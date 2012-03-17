<%!
	section = "index"
%>
<%inherit file="_templates/all-knowing-dns.mako" />

<div class="row-fluid">
<div class="span6">

<h3>Introduction</h3>

<p style="text-align: justify">
AllKnowingDNS provides reverse DNS for IPv6 networks which use SLAAC
(autoconf), e.g. for a /64 network.
</p>

<p style="text-align: justify">
The problem with IPv6 reverse DNS and traditional nameservers is that the
nameserver requires you to provide a zone file. Assuming you want to provide
RDNS for a /64 network, you have 2<sup>64</sup> = 18446744073709551616 different usable
IP addresses (a little less if you are using SLAAC). Providing a zone file for
that, even in a very terse notation, would consume a huge amount of disk space
and could not possibly be held in the memory of the computers we have nowadays.
</p>

<p style="text-align: justify">
AllKnowingDNS instead generates <code>PTR</code> and <code>AAAA</code> records
on the fly. You only configure which network you want to serve and what your
entries should look like.
</p>

<h3>Features</h3>

<ul>
<li>Answers <code>PTR</code> and <code>AAAA</code> queries with configurable format.</li>
<li>Can ask an upstream DNS server first and only be a fallback.</li>
<li>Works for different network sizes.</li>
<li>Beautifully simple configuration file.</li>
</ul>

<h3>Documentation</h3>

<p>
You can find full documentation for AllKnowingDNS and its configuration file in
the <a href="https://metacpan.org/module/all-knowing-dns">manpage
all-knowing-dns(1)</a>.
</p>

<p>
In case you understand German, you can also <a
href="http://www.youtube.com/watch?v=PG_0gXp5Z4k">watch a presentation</a>
about AllKnowingDNS.
</p>

<h3>Download</h3>

<p style="text-align: justify">
Ideally, your Linux distribution provides a package for AllKnowingDNS already.
Please use that package. If you insist on downloading and installing
AllKnowingDNS manually, here you go:
</p>

<p>
<a href="https://metacpan.org/release/AllKnowingDNS"><i class="icon-download"></i> latest AllKnowingDNS on metacpan.org</a>
</p>

</div>

<div class="span1">
&nbsp;
</div>

<div class="span5">
<h3>Installation Guide</h3>
<p>
Dou you have an IPv6 network with autoconf and want to provide reverse DNS for
it? Got five minutes? We can do that! Let’s assume your network is <i>2001:4d88:100e:ccc0::/64</i>.
</p>
<h4>Install AllKnowingDNS</h4>
<pre>
apt-get install all-knowing-dns
</pre>
<p>
Edit <b>/etc/all-knowing-dns.conf</b>:
</p>
<pre>
network 2001:4d88:100e:ccc0::/64
  resolves to ipv6-%DIGITS%.users.rzl.so
</pre>
<p>
(Re-)start AllKnowingDNS:
</p>
<pre>
/etc/init.d/all-knowing-dns restart
</pre>

<h4>Delegate the .ip6.arpa zone</h4>
<pre>
$TTL 7d     ; 1 week
e.0.0.1.8.8.d.4.1.0.0.2.ip6.arpa. IN SOA
    ns1.rzl.so. hostmaster.rzl.so. (
        ; serial  refresh  retry  expire  minimum
        42        7d       1d     30d     7d )
                    NS      ns1.rzl.so.
                    NS      ns2.rzl.so.

0.c.c.c.e.0.0.1.8.8.d.4.1.0.0.2.ip6.arpa. IN  NS        ipv6-rdns.rzl.so.
</pre>

<h4>Delegate the (sub)domain</h4>
<pre>
$TTL    6h
rzl.so. IN  SOA ns1.rzl.so. hostmaster.rzl.so. (
        ; serial   refresh  retry  expire  minimum
        2012030701 3h       30m    7d      1d )
        NS  ns1.rzl.so.
        NS  ns2.rzl.so.

users.rzl.so. IN NS ipv6-rdns.rzl.so.
</pre>

<h4>Done!</h4>

<p>
Verify that everything works by resolving a host both ways:
</p>

<pre>
host 2001:4d88:100e:ccc0:216:eaff:fecb:826
host -t AAAA ipv6-0216eafffecb0826.users.rzl.so
</pre>

</div>

</div>
