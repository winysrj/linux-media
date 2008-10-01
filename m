Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from blu0-omc1-s17.blu0.hotmail.com ([65.55.116.28])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <db260179@hotmail.com>) id 1KkzQ9-0003RB-Sy
	for linux-dvb@linuxtv.org; Wed, 01 Oct 2008 12:59:08 +0200
Message-ID: <BLU116-W31A8ACFFBED560E0D80D5AC2420@phx.gbl>
From: dabby bentam <db260179@hotmail.com>
To: <darron@kewl.org>, <linux-dvb@linuxtv.org>
Date: Wed, 1 Oct 2008 10:58:32 +0000
MIME-Version: 1.0
Subject: Re: [linux-dvb] Adding remote support to Avermedia Super 007 - more
 info needed!
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0027519201=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0027519201==
Content-Type: multipart/alternative;
	boundary="_caea435d-a4ae-4804-9496-f2da18af060d_"

--_caea435d-a4ae-4804-9496-f2da18af060d_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


-----Original Message-----
From: darron@kewl.org [mailto:darron@kewl.org]
Sent: 01 October 2008 02:08
To: dabby bentam
Subject: Re: [linux-dvb] Adding remote support to Avermedia Super 007 - mor=
e info needed!=20

In message <BLU116-W122752EF5297963897FDE5C2430@phx.gbl>=2C dabby bentam wr=
ote:

hello david

>I'm currently trying to get remote support added to the Avermedia Super=20
>007=3D  card.

I have one of these cards also but I have no good news for you unfortunatel=
y.

I am replying just to confirm that I too saw no activity in the register lo=
gs in XP when pressing remote key presses. Nor=2C from what I can see will =
any additions to the saa7134 code as is=2C aide you in reaching remote cont=
rol nirvana.

It looks as if all remotes on the saa7134 linux driver thus far are trigger=
ed via an interrupt and that no such interrupt is occuring when you press a=
 key on the remote for that board. This may require more absolute confirmat=
ion though as I didn't spend a great deal of time looking.

>I've turned the ir_debug on and gpio tracking on and enabled i2c_scan.=20
>I've=3D  added an entry in the saa7134-cards.c and saa7134-input.c -=20
>copying the se=3D ttings from other avermedia cards.
>
>The polling setting makes the card print out loads of ir_builder=20
>settings=3D =3D2C removing the setting no output! - from this i am assumin=
g=20
>that this car=3D d has no gpio setting? - possible i2c?
>
>I've used regspy (from dscaler) to determine the GPIO STATUS and MASK=20
>value=3D . Turning on/off the remote in windows has no value change? -=20
>does it chang=3D e?
>
>Any guidance on how to determine the ir code? - without the manufacture=20
>cod=3D e book.

I took a photo but didn't identify all the ICs on the board and write them =
down=2C it may be worthwhie doing so and also tracing from where the IR det=
ector comes into the card and where it actually ends up.

If you are determined then you could explore the above but there is still n=
o guarantee of any eventual success of course as just knowing about it more=
 is only the first step in actually getting it to work.

cya!

Hello darron=2C

Thanks for the reply. I've established the cards IR port is not GPIO but I2=
C. Similar to the hvr-1110 card. The I2C readout gives me:-

0x10
0x96

>From the other I2C cards=2C these functions are used to enable/disable the =
IR port.

I'll take a closer look at he pins just incase.

Thanks

David


_________________________________________________________________
Make a mini you and download it into Windows Live Messenger
http://clk.atdmt.com/UKM/go/111354029/direct/01/=

--_caea435d-a4ae-4804-9496-f2da18af060d_
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
FONT-SIZE: 10pt=3B
FONT-FAMILY:Tahoma
}
</style>
</head>
<body class=3D'hmmessage'>
-----Original Message-----<br>From: darron@kewl.org [mailto:darron@kewl.org=
]<br>Sent: 01 October 2008 02:08<br>To: dabby bentam<br>Subject: Re: [linux=
-dvb] Adding remote support to Avermedia Super 007 - more info needed! <br>=
<br>In message &lt=3BBLU116-W122752EF5297963897FDE5C2430@phx.gbl&gt=3B=2C d=
abby bentam wrote:<br><br>hello david<br><br>&gt=3BI'm currently trying to =
get remote support added to the Avermedia Super <br>&gt=3B007=3D&nbsp=3B ca=
rd.<br><br>I have one of these cards also but I have no good news for you u=
nfortunately.<br><br>I am replying just to confirm that I too saw no activi=
ty in the register logs in XP when pressing remote key presses. Nor=2C from=
 what I can see will any additions to the saa7134 code as is=2C aide you in=
 reaching remote control nirvana.<br><br>It looks as if all remotes on the =
saa7134 linux driver thus far are triggered via an interrupt and that no su=
ch interrupt is occuring when you press a key on the remote for that board.=
 This may require more absolute confirmation though as I didn't spend a gre=
at deal of time looking.<br><br>&gt=3BI've turned the ir_debug on and gpio =
tracking on and enabled i2c_scan. <br>&gt=3BI've=3D&nbsp=3B added an entry =
in the saa7134-cards.c and saa7134-input.c - <br>&gt=3Bcopying the se=3D tt=
ings from other avermedia cards.<br>&gt=3B<br>&gt=3BThe polling setting mak=
es the card print out loads of ir_builder <br>&gt=3Bsettings=3D =3D2C remov=
ing the setting no output! - from this i am assuming <br>&gt=3Bthat this ca=
r=3D d has no gpio setting? - possible i2c?<br>&gt=3B<br>&gt=3BI've used re=
gspy (from dscaler) to determine the GPIO STATUS and MASK <br>&gt=3Bvalue=
=3D . Turning on/off the remote in windows has no value change? - <br>&gt=
=3Bdoes it chang=3D e?<br>&gt=3B<br>&gt=3BAny guidance on how to determine =
the ir code? - without the manufacture <br>&gt=3Bcod=3D e book.<br><br>I to=
ok a photo but didn't identify all the ICs on the board and write them down=
=2C it may be worthwhie doing so and also tracing from where the IR detecto=
r comes into the card and where it actually ends up.<br><br>If you are dete=
rmined then you could explore the above but there is still no guarantee of =
any eventual success of course as just knowing about it more is only the fi=
rst step in actually getting it to work.<br><br>cya!<br><br>Hello darron=2C=
<br><br>Thanks for the reply. I've established the cards IR port is not GPI=
O but I2C. Similar to the hvr-1110 card. The I2C readout gives me:-<br><br>=
0x10<br>0x96<br><br>From the other I2C cards=2C these functions are used to=
 enable/disable the IR port.<br><br>I'll take a closer look at he pins just=
 incase.<br><br>Thanks<br><br>David<br><br><br /><hr />Win =A33000 to spend=
 on whatever you want at Uni! <a href=3D'http://clk.atdmt.com/UKM/go/111354=
032/direct/01/' target=3D'_new'>Click here to WIN!</a></body>
</html>=

--_caea435d-a4ae-4804-9496-f2da18af060d_--


--===============0027519201==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0027519201==--
