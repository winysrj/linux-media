Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from nf-out-0910.google.com ([64.233.182.188])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <timothyparez@gmail.com>) id 1Jauhv-0008Ql-Pq
	for linux-dvb@linuxtv.org; Sun, 16 Mar 2008 16:23:33 +0100
Received: by nf-out-0910.google.com with SMTP id d21so1683031nfb.11
	for <linux-dvb@linuxtv.org>; Sun, 16 Mar 2008 08:23:28 -0700 (PDT)
Message-Id: <91A2658A-A909-489F-8DE5-B074330F1B1B@gmail.com>
From: Timothy Parez <timothyparez@gmail.com>
To: Dominik Kuhlen <dkuhlen@gmx.net>
In-Reply-To: <200803161553.49113.dkuhlen@gmx.net>
Mime-Version: 1.0 (Apple Message framework v919.2)
Date: Sun, 16 Mar 2008 16:23:22 +0100
References: <A33C77E06C9E924F8E6D796CA3D635D102397B@w2k3sbs.glcdomain.local>
	<200803161553.49113.dkuhlen@gmx.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVB-S DVB-S2 and CI cards working on Linux
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1127528114=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--===============1127528114==
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-22--259464004"
Content-Transfer-Encoding: 7bit

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-22--259464004
Content-Type: multipart/alternative; boundary=Apple-Mail-21--259464037


--Apple-Mail-21--259464037
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit

I'm using the same card, having the same problem.
How do you make your tuning application do what you suggested ?

As this has no meaning to me:
>
> dvbfe_delsys delsys = DVBFE_DELSYS_DVBS;
> ioctl(front, DVBFE_SET_DELSYS, &delsys);

(Sorry about that... just have no idea what it means).

I've added a link to the multiproto drivers to the Wiki for this card
as it told the reader to load modules which are only available if you  
compile those sources.


Timothy.




On 16 Mar 2008, at 15:53, Dominik Kuhlen wrote:

> On Sunday 16 March 2008, Michael Curtis wrote:
>> First of all my thanks to all those engaged in developing drivers for
>> the various cards for the Linux OS and my apologies for repeating  
>> this
>> question previously asked by others
>>
>>
>> Are there any DVB-S/S2/CI cards that work at present on Linux? If  
>> so I
>> would really appreciate knowing which ones they are
>>
>>
>> I have had a TT3200 DVB-S2/CI card for more than a year and I have  
>> still
>> not got this to work using the Multiproto drivers on Linux, in fact  
>> it
>> seem that I am going backwards with this card with the latest errors
>> appearing in dmesg:
>>
>> stb0899_search: Unsupported delivery system
> There has been an api update. make sure you're tuning application  
> does a
>
> dvbfe_delsys delsys = DVBFE_DELSYS_DVBS;
> ioctl(front, DVBFE_SET_DELSYS, &delsys);
>
> before other tuning ioctls.
>
>>
>> This is with the latest drivers from "http://jusst.de/hg/multiproto"
>>
>> Changeset 7212:b5a34b6a209d
>>
>> I will gladly offer up the log/dmesg/lsmod information if someone can
>> help
>>
>> At the moment, I feel frustrated and lack the confidence that working
>> drivers are are going to be available for this card
>>
>> Kind Regards
>>
>> Mike Curtis
>>
>>
>>
>> _______________________________________________
>> linux-dvb mailing list
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>
>
>
>
> Dominik
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


--Apple-Mail-21--259464037
Content-Type: text/html;
	charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

<html><body style=3D"word-wrap: break-word; -webkit-nbsp-mode: space; =
-webkit-line-break: after-white-space; "><div>I'm using the same card, =
having the same problem.</div><div>How do you make your tuning =
application do what you suggested ?</div><div><br =
class=3D"webkit-block-placeholder"></div><div>As this has no meaning to =
me:</div><div><blockquote type=3D"cite"><br>dvbfe_delsys delsys =3D =
DVBFE_DELSYS_DVBS;<br>ioctl(front, DVBFE_SET_DELSYS, =
&amp;delsys);</blockquote><br></div><div>(Sorry about that... just have =
no idea what it means).</div><div><br =
class=3D"webkit-block-placeholder"></div><div>I've added a link to the =
multiproto drivers to the Wiki for this card</div><div>as it told the =
reader to load modules which are only available if you compile those =
sources.</div><div><br class=3D"webkit-block-placeholder"></div><div><br =
class=3D"webkit-block-placeholder"></div><div>Timothy.</div><div><br =
class=3D"webkit-block-placeholder"></div><div><br =
class=3D"webkit-block-placeholder"></div><div><br =
class=3D"webkit-block-placeholder"></div><br><div><div>On 16 Mar 2008, =
at 15:53, Dominik Kuhlen wrote:</div><br =
class=3D"Apple-interchange-newline"><blockquote type=3D"cite">On Sunday =
16 March 2008, Michael Curtis wrote:<br><blockquote type=3D"cite">First =
of all my thanks to all those engaged in developing drivers =
for<br></blockquote><blockquote type=3D"cite">the various cards for the =
Linux OS and my apologies for repeating this<br></blockquote><blockquote =
type=3D"cite">question previously asked by =
others<br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote type=3D"cite">Are there any =
DVB-S/S2/CI cards that work at present on Linux? If so =
I<br></blockquote><blockquote type=3D"cite">would really appreciate =
knowing which ones they are<br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote type=3D"cite">I have had a =
TT3200 DVB-S2/CI card for more than a year and I have =
still<br></blockquote><blockquote type=3D"cite">not got this to work =
using the Multiproto drivers on Linux, in fact =
it<br></blockquote><blockquote type=3D"cite">seem that I am going =
backwards with this card with the latest =
errors<br></blockquote><blockquote type=3D"cite">appearing in =
dmesg:<br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote type=3D"cite">stb0899_search: =
Unsupported delivery system<br></blockquote>There has been an api =
update. make sure you're tuning application does a <br><br>dvbfe_delsys =
delsys =3D DVBFE_DELSYS_DVBS;<br>ioctl(front, DVBFE_SET_DELSYS, =
&amp;delsys);<br><br>before other tuning ioctls.<br><br><blockquote =
type=3D"cite"><br></blockquote><blockquote type=3D"cite">This is with =
the latest drivers from "<a =
href=3D"http://jusst.de/hg/multiproto">http://jusst.de/hg/multiproto</a>"<=
br></blockquote><blockquote type=3D"cite"><br></blockquote><blockquote =
type=3D"cite">Changeset 7212:b5a34b6a209d<br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote type=3D"cite">I will gladly =
offer up the log/dmesg/lsmod information if someone =
can<br></blockquote><blockquote =
type=3D"cite">help<br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote type=3D"cite">At the moment, =
I feel frustrated and lack the confidence that =
working<br></blockquote><blockquote type=3D"cite">drivers are are going =
to be available for this card<br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote type=3D"cite">Kind =
Regards<br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote type=3D"cite">Mike =
Curtis<br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote =
type=3D"cite">_______________________________________________<br></blockqu=
ote><blockquote type=3D"cite">linux-dvb mailing =
list<br></blockquote><blockquote type=3D"cite"><a =
href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br></block=
quote><blockquote type=3D"cite"><a =
href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://=
www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a><br></blockquote><bl=
ockquote =
type=3D"cite"><br></blockquote><br><br><br>Dominik<br>____________________=
___________________________<br>linux-dvb mailing list<br><a =
href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a><br><a =
href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb">http://=
www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a></blockquote></div><=
br></body></html>=

--Apple-Mail-21--259464037--

--Apple-Mail-22--259464004
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)

iD8DBQFH3Ttq+j5y+etesF8RAli/AKDoT3N9J3ro80k+3LQn3t5gzxDFKgCfaRql
A8MTjPwp11mz8mrrbXMF5m8=
=xoaq
-----END PGP SIGNATURE-----

--Apple-Mail-22--259464004--


--===============1127528114==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1127528114==--
