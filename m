Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1KNF9s-0001cf-IN
	for linux-dvb@linuxtv.org; Mon, 28 Jul 2008 00:56:10 +0200
Received: from wfilter3.us4.outblaze.com.int (wfilter3.us4.outblaze.com.int
	[192.168.8.242])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	7476D1802356
	for <linux-dvb@linuxtv.org>; Sun, 27 Jul 2008 22:55:31 +0000 (GMT)
MIME-Version: 1.0
From: stev391@email.com
To: "Jonathan Hummel" <jhhummel@bigpond.com>
Date: Mon, 28 Jul 2008 08:55:31 +1000
Message-Id: <20080727225531.638A0164293@ws1-4.us4.outblaze.com>
Cc: linux dvb mailing list <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Leadtek Winfast PxDVR 3200 H
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1079887941=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============1079887941==
Content-Transfer-Encoding: 7bit
Content-Type: multipart/alternative; boundary="_----------=_1217199331271822"

This is a multi-part message in MIME format.

--_----------=_1217199331271822
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-15"

Jon,

It appears that this card uses the CX23885 PCIe controller.

>From initial research on the Leadtek site it appears that this card
utilises the following main chips:
Conexant CX23885 - PCIe Interface
Conexant CX23417 - Analog Video to MPEG2 Encoder
Intel CE6353 - Digital TV Demodulator (Formerly known as Zarlink 10353)
Xceive ????? - Digital TV Tuner,

All of the above that I have identified have drivers in linux in various
stages of development.

Can you take a high res photo of the card showing all chip IDs?
Can you identify which tuner from Xceive it is?
Do you have a partition set up with windows and the card working?
If so can you use regspy (Google "Dscaler Regspy" to find the correct
program), and record what the values are for:
- Card sitting idle straight after bootup
- Watching Digital TV
- Watching Analog TV
- Sitting idle after watching TV

What is the output of `lspci -vnn` when in linux regarding this card?

What does `dmesg | grep cx23885` give you?

It might also be useful for others who have this card if you make an
entry the linuxtv wiki for this card, with all of the information that I
have requested linked to or included.

I may be able to knock up a driver that you can use for the digital TV
side as this seems similar to other existing cards, I'm not familiar with
the Analog side though.
(No gurantees, but it should be relatively simple to achieve).

Regards,

Stephen.


--- Original Message ---

         Hi,

         I was wondering if anyone could help me get this card up and
         working in
         kubuntu 8.04. I've tried setting it up much like a Leadtek
         DTV2000H,
         version J, as per instructions here:
         http://wiki.linuxmce.org/index.php/Leadtek_DTV2000H
         (I've been using that card for a while in another box)

         System:
         Gibagyte moher board (all in one) GA-MA78GM-S2H
         AMD Athlon X2 6000 (2 core, 3GHz)
         4G ram, heaps of hard disk
         64bit KDE 4 kubuntu, kernel: 2.6.24-20 generic

         http://www.linuxtv.org/wiki/index.php/DVB-T_PCIe_Cards
         suggested I email this address.


         cheers

         Jon

--=20
Be Yourself @ mail.com!
Choose From 200+ Email Addresses
Get a Free Account at www.mail.com


--_----------=_1217199331271822
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="iso-8859-15"

Jon,<br><br>It appears that this card uses the CX23885 PCIe controller.<br>=
<br>From initial research on the Leadtek site it appears that this card uti=
lises the following main chips:<br>Conexant CX23885 - PCIe Interface<br>Con=
exant CX23417 - Analog Video to MPEG2 Encoder<br>Intel CE6353 - Digital TV =
Demodulator (Formerly known as Zarlink 10353)<br>Xceive ????? - Digital TV =
Tuner,<br><br>All of the above that I have identified have drivers in linux=
 in various stages of development.<br><br>Can you take a high res photo of =
the card showing all chip IDs?<br>Can you identify which tuner from Xceive =
it is?<br>Do you have a partition set up with windows and the card working?=
<br>&nbsp;&nbsp; If so can you use regspy (Google "Dscaler Regspy" to find =
the correct program), and record what the values are for:<br>&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp; - Card sitting idle straight after bootup<br>&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp; - Watching Digital TV<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -=
 Watching Analog TV<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; - Sitting idle after =
watching TV<br><br>What is the output of `lspci -vnn` when in linux regardi=
ng this card?<br><br>What does `dmesg | grep cx23885` give you?<br><br>It m=
ight also be useful for others who have this card if you make an entry the =
linuxtv wiki for this card, with all of the information that I have request=
ed linked to or included.<br><br>I may be able to knock up a driver that yo=
u can use for the digital TV side as this seems similar to other existing c=
ards, I'm not familiar with the Analog side though. <br>(No gurantees, but =
it should be relatively simple to achieve).<br><br>Regards,<br><br>Stephen.=
<br><br><br>--- Original Message ---<br><span id=3D"obmessage"><pre>       =
  Hi,<br><br>         I was wondering if anyone could help me get this card=
 up and<br>         working in<br>         kubuntu 8.04. I've tried setting=
 it up much like a Leadtek<br>         DTV2000H,<br>         version J, as =
per instructions here:<br>         <a href=3D"http://wiki.linuxmce.org/inde=
x.php/Leadtek_DTV2000H" target=3D"_blank"><font color=3D"BLUE">http://wiki.=
linuxmce.org/index.php/Leadtek_DTV2000H</font></a><br>         (I've been u=
sing that card for a while in another box)<br><br>         System:<br>     =
    Gibagyte moher board (all in one) GA-MA78GM-S2H<br>         AMD Athlon =
X2 6000 (2 core, 3GHz)<br>         4G ram, heaps of hard disk<br>         6=
4bit KDE 4 kubuntu, kernel: 2.6.24-20 generic<br><br>         <a href=3D"ht=
tp://www.linuxtv.org/wiki/index.php/DVB-T_PCIe_Cards" target=3D"_blank"><fo=
nt color=3D"BLUE">http://www.linuxtv.org/wiki/index.php/DVB-T_PCIe_Cards</f=
ont></a><br>         suggested I email this address.<br><br><br>         ch=
eers<br><br>         Jon<br></pre></span><br>
<div>

</div>
<br><BR>

--=20
<div> Be Yourself @ mail.com!<br>
Choose From 200+ Email Addresses<br>
Get a <b>Free</b> Account at <a href=3D"http://www.mail.com/Product.aspx" t=
arget=3D"_blank">www.mail.com</a>!</div>

--_----------=_1217199331271822--



--===============1079887941==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1079887941==--
