Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.159])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <timothyparez@gmail.com>) id 1JgoZY-0006de-BS
	for linux-dvb@linuxtv.org; Wed, 02 Apr 2008 00:03:17 +0200
Received: by fg-out-1718.google.com with SMTP id 22so2079167fge.25
	for <linux-dvb@linuxtv.org>; Tue, 01 Apr 2008 15:03:12 -0700 (PDT)
Message-Id: <F8D798DA-89B0-4F6E-9DF4-156A1C155321@gmail.com>
From: Timothy Parez <timothyparez@gmail.com>
To: "Nick Morrott" <knowledgejunkie@gmail.com>
In-Reply-To: <5387cd30804011456h6ef9c46bu99d8c8290a33ca7a@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v919.2)
Date: Wed, 2 Apr 2008 00:00:32 +0200
References: <47EEE49F.4060202@andrei.myip.org>
	<9F2076E5-6941-444E-94D3-B4F174DA31FB@gmail.com>
	<5387cd30804011456h6ef9c46bu99d8c8290a33ca7a@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Hauppauge WinTV Nova-S Plus
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0846137120=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--===============0846137120==
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-4--1000717247"
Content-Transfer-Encoding: 7bit

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-4--1000717247
Content-Type: multipart/alternative; boundary=Apple-Mail-3--1000717290


--Apple-Mail-3--1000717290
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit

Yes, I should,
just a typo in the message, that's actually what I'm doing.

dd if=/dev/dvb/adapter0/dvr0 of=test.mpg

the file remains empty

and mplayer returns an error


Timothy.


On 01 Apr 2008, at 23:56, Nick Morrott wrote:

> On 30/03/2008, Timothy Parez <timothyparez@gmail.com> wrote:
>> Hey,
>>
>> I got it working once.
>> Then I had scanning problems,
>> now I don't have scanning problems
>>
>> but szap -r "BBC THREE"     for example works,
>> but doesn't put any data in /dev/dvb/adapter0
>>
>> So I get a lock, but no data.
>
> Shouldn't you be using /dev/dvb/adapter0/dvr0 ?
>
> If you have mplayer installed, try
>
> $ mplayer /dev/dvb/adapter0/dvr0
>
> whilst szap is running and has a channel lock
>
> --  
> Nick Morrott
>
> MythTV Official wiki:
> http://mythtv.org/wiki/
> MythTV users list archive:
> http://www.gossamer-threads.com/lists/mythtv/users
>
> "An investment in knowledge always pays the best interest." -  
> Benjamin Franklin
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb


--Apple-Mail-3--1000717290
Content-Type: text/html;
	charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

<html><body style=3D"word-wrap: break-word; -webkit-nbsp-mode: space; =
-webkit-line-break: after-white-space; ">Yes, I should,<div>just a typo =
in the message, that's actually what I'm doing.</div><div><br =
class=3D"webkit-block-placeholder"></div><div>dd =
if=3D/dev/dvb/adapter0/dvr0 of=3Dtest.mpg</div><div><br =
class=3D"webkit-block-placeholder"></div><div>the file remains =
empty</div><div><br class=3D"webkit-block-placeholder"></div><div>and =
mplayer returns an error</div><div><br =
class=3D"webkit-block-placeholder"></div><div><br =
class=3D"webkit-block-placeholder"></div><div>Timothy.</div><div><br =
class=3D"webkit-block-placeholder"></div><div><br><div><div>On 01 Apr =
2008, at 23:56, Nick Morrott wrote:</div><br =
class=3D"Apple-interchange-newline"><blockquote type=3D"cite">On =
30/03/2008, Timothy Parez &lt;<a =
href=3D"mailto:timothyparez@gmail.com">timothyparez@gmail.com</a>&gt; =
wrote:<br><blockquote type=3D"cite">Hey,<br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote type=3D"cite">I got it =
working once.<br></blockquote><blockquote type=3D"cite">Then I had =
scanning problems,<br></blockquote><blockquote type=3D"cite">now I don't =
have scanning problems<br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote type=3D"cite">but szap -r =
"BBC THREE" &nbsp;&nbsp;&nbsp;&nbsp;for example =
works,<br></blockquote><blockquote type=3D"cite">but doesn't put any =
data in /dev/dvb/adapter0<br></blockquote><blockquote =
type=3D"cite"><br></blockquote><blockquote type=3D"cite">So I get a =
lock, but no data.<br></blockquote><br>Shouldn't you be using =
/dev/dvb/adapter0/dvr0 ?<br><br>If you have mplayer installed, =
try<br><br>$ mplayer /dev/dvb/adapter0/dvr0<br><br>whilst szap is =
running and has a channel lock<br><br>-- <br>Nick Morrott<br><br>MythTV =
Official wiki:<br><a =
href=3D"http://mythtv.org/wiki/">http://mythtv.org/wiki/</a><br>MythTV =
users list archive:<br><a =
href=3D"http://www.gossamer-threads.com/lists/mythtv/users">http://www.gos=
samer-threads.com/lists/mythtv/users</a><br><br>"An investment in =
knowledge always pays the best interest." - Benjamin =
Franklin<br><br>_______________________________________________<br>linux-d=
vb mailing =
list<br>linux-dvb@linuxtv.org<br>http://www.linuxtv.org/cgi-bin/mailman/li=
stinfo/linux-dvb<br></blockquote></div><br></div></body></html>=

--Apple-Mail-3--1000717290--

--Apple-Mail-4--1000717247
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (Darwin)

iD8DBQFH8rCB+j5y+etesF8RAkVxAJ49zNX0w+J9M629fD+IzOaKFCtwWwCeM2/m
EbliGngAnDb66z/sybpYYSI=
=39UE
-----END PGP SIGNATURE-----

--Apple-Mail-4--1000717247--


--===============0846137120==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0846137120==--
