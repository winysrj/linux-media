Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bay0-omc2-s18.bay0.hotmail.com ([65.54.246.154])
	by mail.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <richy_lane@hotmail.com>) id 1M48f3-0002d4-8B
	for linux-dvb@linuxtv.org; Wed, 13 May 2009 09:13:53 +0200
Message-ID: <BAY106-W2068AC6BD55AAC82AA765CFF610@phx.gbl>
From: Rick Lane <richy_lane@hotmail.com>
To: <linux-dvb@linuxtv.org>
Date: Wed, 13 May 2009 08:13:16 +0100
MIME-Version: 1.0
Subject: Re: [linux-dvb] GDI Black Gold [14c7:0108] cx88 card
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1543302089=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1543302089==
Content-Type: multipart/alternative;
	boundary="_2a69d6f6-4496-4d54-b14f-5dfc3fbd8824_"

--_2a69d6f6-4496-4d54-b14f-5dfc3fbd8824_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


IN REPLY TO:

> Hello=2C
>=20
> I'm interested in getting this card working under Linux as well=2C it's=20
> labelled GDI2500PCTV on the back=2C and has a Conexant CX23881 visible on=
=20
> the front=2C with a Philips "TU1216/1 H P" RF box...  Looks like there ma=
y=20
> be some more ICs under the metal box=2C but I'd have to desolder it to=20
> check what they were (which I can do if necessary).
>=20
> There seems to be TU1216 support in both v4l/saa7134-dvb.c and=20
> v4l/budget-av.c (code cut-n-paste by the look of it)=2C but I can't see a=
=20
> way to select this tuner with the cx88xx module (e.g. CARDLIST.tuner).
>=20
> So... I'm game for trying to get this working=2C and have a bit of kernel=
=20
> programming experience=2C but is there anything else I'm likely to need t=
o=20
> know before I set out on this?
> Cheers!
>=20
> Tim.
Hi Tim=2C

I've got two of these cards=2C and they give a really good picture in windo=
ws so I'd love to be able to use them on my Myth box rather than ebay them =
and get alternatives. I don't have any kernel programming experience but I'=
m ready to roll my sleeves up and see what happens if you want a guinea pig=
. My programming experience in the linux world goes as far as tweaking php =
files and things like that. Currently have the full set of latest v4l-dvb d=
rivers on my backend and plenty of opportunity to fiddle with the config et=
c.=20

Let me know if you wanna bang heads on this...
Rick

--_2a69d6f6-4496-4d54-b14f-5dfc3fbd8824_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<style>
.hmmessage P
{
margin:0px=3B
padding:0px
}
body.hmmessage
{
font-size: 10pt=3B
font-family:Verdana
}
</style>
</head>
<body class=3D'hmmessage'>
IN REPLY TO:<br><br><pre>&gt=3B Hello=2C<br>&gt=3B <br>&gt=3B I'm intereste=
d in getting this card working under Linux as well=2C it's <br>&gt=3B label=
led GDI2500PCTV on the back=2C and has a Conexant CX23881 visible on <br>&g=
t=3B the front=2C with a Philips "TU1216/1 H P" RF box...  Looks like there=
 may <br>&gt=3B be some more ICs under the metal box=2C but I'd have to des=
older it to <br>&gt=3B check what they were (which I can do if necessary).<=
br>&gt=3B <br>&gt=3B There seems to be TU1216 support in both v4l/saa7134-d=
vb.c and <br>&gt=3B v4l/budget-av.c (code cut-n-paste by the look of it)=2C=
 but I can't see a <br>&gt=3B way to select this tuner with the cx88xx modu=
le (e.g. CARDLIST.tuner).<br>&gt=3B <br>&gt=3B So... I'm game for trying to=
 get this working=2C and have a bit of kernel <br>&gt=3B programming experi=
ence=2C but is there anything else I'm likely to need to <br>&gt=3B know be=
fore I set out on this?<br>&gt=3B Cheers!<br>&gt=3B <br>&gt=3B Tim.<br></pr=
e>Hi Tim=2C<br><br>I've got two of these cards=2C and they give a really go=
od picture in windows so I'd love to be able to use them on my Myth box rat=
her than ebay them and get alternatives. I don't have any kernel programmin=
g experience but I'm ready to roll my sleeves up and see what happens if yo=
u want a guinea pig. My programming experience in the linux world goes as f=
ar as tweaking php files and things like that. Currently have the full set =
of latest v4l-dvb drivers on my backend and plenty of opportunity to fiddle=
 with the config etc. <br><br>Let me know if you wanna bang heads on this..=
.<br>Rick<br></body>
</html>=

--_2a69d6f6-4496-4d54-b14f-5dfc3fbd8824_--


--===============1543302089==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1543302089==--
