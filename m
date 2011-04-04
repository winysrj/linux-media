Return-path: <mchehab@pedra>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <stev391@email.com>) id 1Q6t3B-0006eF-FJ
	for linux-dvb@linuxtv.org; Tue, 05 Apr 2011 01:19:38 +0200
Received: from imr-da02.mx.aol.com ([205.188.105.144])
	by mail.tu-berlin.de (exim-4.75/mailfrontend-3) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1Q6t3A-0004WB-G6; Tue, 05 Apr 2011 01:19:13 +0200
References: <mailman.1.1301911201.19445.linux-dvb@linuxtv.org>
To: linux-dvb@linuxtv.org
Date: Mon, 04 Apr 2011 19:13:41 -0400
In-Reply-To: <mailman.1.1301911201.19445.linux-dvb@linuxtv.org>
MIME-Version: 1.0
From: stev391@email.com
Message-Id: <8CDC1351244FD0C-16B8-53A3@web-mmc-d04.sysops.aol.com>
Subject: Re: [linux-dvb] linux-dvb Digest, Vol 75, Issue 3
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2021900270=="
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
Sender: <mchehab@pedra>
List-ID: <linux-dvb@linuxtv.org>


--===============2021900270==
Content-Type: multipart/alternative;
 boundary="--------MB_8CDC1351250E3EC_16B8_AB38_web-mmc-d04.sysops.aol.com"


----------MB_8CDC1351250E3EC_16B8_AB38_web-mmc-d04.sysops.aol.com
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"


 Nick,

To get some hints on what configuration settings are required check out th=
e windows driver inf (zl885avs.inf, which is in the FusionHDTV software pa=
ckage available on DViCo's website).
In particular these settings:

 [DvbtDual2.AddReg]
HKR,"DriverData","TunerType",       0x00010001, 0x20, 0x01, 0x00, 0x00
HKR,"DriverData","TunerI2CAddress", 0x00010001, 0x12, 0x00, 0x00, 0x00
HKR,"DriverData","TunerCountryCode",0x00010001, 0x3d, 0x00, 0x00, 0x00  ;=
 61=3DAustralia =20
HKR,"DriverData","HasDualTuner",    0x00010001, 0x01, 0x00, 0x00, 0x00
HKR,"DriverData","Tuner2Type",      0x00010001, 0x20, 0x01, 0x00, 0x00
HKR,"DriverData","Tuner1ResetMask", 0x00010001, 0x01, 0x00, 0x00, 0x00
HKR,"DriverData","Demod1ResetMask", 0x00010001, 0x00, 0x00, 0x00, 0x00
HKR,"DriverData","Tuner2ResetMask", 0x00010001, 0x04, 0x00, 0x00, 0x00
HKR,"DriverData","Demod2ResetMask", 0x00010001, 0x00, 0x00, 0x00, 0x00

To get the previous Dual Pro card working I used this information and comp=
ared it to the existing configuration options. =20

You shouldn't have to modprobe the tuners, if you do the configuration cor=
rect (cx23885-cards.c) it should load the tuner modules automatically.  Ho=
wever I'm not sure if the tuner in this card has been used with this PCIe=
 bridge (it might have, just don't have time to pull apart the code lookin=
g for the correct TUNER define). Apart from the correct tuner define the=
 other key is the Tuner I2CAddress (0x12) and the reset masks for the tune=
r...

I hope this helps you,

Stephen.



=20

=20

-----Original Message-----
From: linux-dvb-request@linuxtv.org
To: linux-dvb@linuxtv.org
Sent: Mon, Apr 4, 2011 8:00 pm
Subject: linux-dvb Digest, Vol 75, Issue 3


Send linux-dvb mailing list submissions to
    linux-dvb@linuxtv.org

To subscribe or unsubscribe via the World Wide Web, visit
    http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
or, via email, send a message with subject or body 'help' to
    linux-dvb-request@linuxtv.org

You can reach the person managing the list at
    linux-dvb-owner@linuxtv.org

When replying, please edit your Subject line so it is more specific
than "Re: Contents of linux-dvb digest..."


Today's Topics:

   1. Re: DVICO HDTV Dual Express2 (Nicholas Leahy)


----------------------------------------------------------------------

Message: 1
Date: Mon, 4 Apr 2011 14:43:34 +1000
From: Nicholas Leahy <silvercordiagsr@hotmail.com>
Subject: Re: [linux-dvb] DVICO HDTV Dual Express2
To: <linux-dvb@linuxtv.org>
Message-ID: <SNT124-W658C9CDE54575A79B73D6FACA30@phx.gbl>
Content-Type: text/plain; charset=3D"iso-8859-1"


Hi

I purchased a DVICO HDTV Dual Express2 http://www.linuxtv.org/wiki/index.p=
hp/DViCO_FusionHDTV_DVB-T_Dual_Express2


The card has a CONEXANT CX23885-152 & DiBcom 7070PB1-AXGXba-G-b Tuners


I have been modifying the V4l-DVB code (cx23885-dvb.c, cx23885-cards.c=20
&cx23885.h) based on the DVICO HDTV Dual Express to try and get the card=
 to=20
work.
But I am having trouble with the 7070PB1-AXGXba-G-b tuners that I am tryin=
g to=20
base on the FusionHDTV Dual Digital 4 (cxusb.c).


I can get Modprobe to load the 2 tuners, but DVBSCAN says the frontend is=
 not=20
loaded


Any help would be appreciated


Cheers Nick
=20






                     =20
-------------- next part --------------
An HTML attachment was scrubbed...
URL: <http://www.linuxtv.org/pipermail/linux-dvb/attachments/20110404/79aa=
6670/attachment.html>

------------------------------

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb

End of linux-dvb Digest, Vol 75, Issue 3
****************************************

=20

----------MB_8CDC1351250E3EC_16B8_AB38_web-mmc-d04.sysops.aol.com
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="us-ascii"

<font color=3D'black' size=3D'2' face=3D'arial'><font color=3D"black" face=
=3D"arial" size=3D"2">

<div> Nick,<br>
<br>
To get some hints on what configuration settings are required check out th=
e windows driver inf (zl885avs.inf, which is in the FusionHDTV software pa=
ckage available on DViCo's website).<br>
In particular these settings:<br>

</div>



<div> [DvbtDual2.AddReg]<br>
HKR,"DriverData","TunerType",&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0x000100=
01, 0x20, 0x01, 0x00, 0x00<br>
HKR,"DriverData","TunerI2CAddress", 0x00010001, 0x12, 0x00, 0x00, 0x00<br>
HKR,"DriverData","TunerCountryCode",0x00010001, 0x3d, 0x00, 0x00, 0x00&nbs=
p; ; 61=3DAustralia&nbsp; <br>
HKR,"DriverData","HasDualTuner",&nbsp;&nbsp;&nbsp; 0x00010001, 0x01, 0x00,=
 0x00, 0x00<br>
HKR,"DriverData","Tuner2Type",&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0x00010001,=
 0x20, 0x01, 0x00, 0x00<br>
HKR,"DriverData","Tuner1ResetMask", 0x00010001, 0x01, 0x00, 0x00, 0x00<br>
HKR,"DriverData","Demod1ResetMask", 0x00010001, 0x00, 0x00, 0x00, 0x00<br>
HKR,"DriverData","Tuner2ResetMask", 0x00010001, 0x04, 0x00, 0x00, 0x00<br>
HKR,"DriverData","Demod2ResetMask", 0x00010001, 0x00, 0x00, 0x00, 0x00<br>
<br>
To get the previous Dual Pro card working I used this information and comp=
ared it to the existing configuration options.&nbsp; <br>
<br>
You shouldn't have to modprobe the tuners, if you do the configuration cor=
rect (cx23885-cards.c) it should load the tuner modules automatically.&nbs=
p; However I'm not sure if the tuner in this card has been used with this=
 PCIe bridge (it might have, just don't have time to pull apart the code=
 looking for the correct TUNER define). Apart from the correct tuner defin=
e the other key is the Tuner I2CAddress (0x12) and the reset masks for the=
 tuner...<br>
<br>
I hope this helps you,<br>
<br>
Stephen.<br>
<br>

</div>



<div style=3D"clear:both"></div>



<div> <br>

</div>



<div> <br>

</div>



<div style=3D"font-family:arial,helvetica;font-size:10pt;color:black">----=
-Original Message-----<br>

From: linux-dvb-request@linuxtv.org<br>

To: linux-dvb@linuxtv.org<br>

Sent: Mon, Apr 4, 2011 8:00 pm<br>

Subject: linux-dvb Digest, Vol 75, Issue 3<br>

<br>









<div id=3D"AOLMsgPart_0_4ab4349e-a7be-406c-9718-62ca9eaf5b84" style=3D"mar=
gin: 0px;font-family: Tahoma, Verdana, Arial, Sans-Serif;font-size: 12px;c=
olor: #000;background-color: #fff;">

<pre style=3D"font-size: 9pt;"><tt>Send linux-dvb mailing list submissions=
 to
    <a href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a>

To subscribe or unsubscribe via the World Wide Web, visit
    <a href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb"=
 target=3D"_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-d=
vb</a>
or, via email, send a message with subject or body 'help' to
    <a href=3D"mailto:linux-dvb-request@linuxtv.org">linux-dvb-request@lin=
uxtv.org</a>

You can reach the person managing the list at
    <a href=3D"mailto:linux-dvb-owner@linuxtv.org">linux-dvb-owner@linuxtv=
.org</a>

When replying, please edit your Subject line so it is more specific
than "Re: Contents of linux-dvb digest..."


Today's Topics:

   1. Re: DVICO HDTV Dual Express2 (Nicholas Leahy)


----------------------------------------------------------------------

Message: 1
Date: Mon, 4 Apr 2011 14:43:34 +1000
From: Nicholas Leahy &lt;<a href=3D"mailto:silvercordiagsr@hotmail.com">si=
lvercordiagsr@hotmail.com</a>&gt;
Subject: Re: [linux-dvb] DVICO HDTV Dual Express2
To: &lt;<a href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a>=
&gt;
Message-ID: &lt;<a href=3D"mailto:SNT124-W658C9CDE54575A79B73D6FACA30@phx.=
gbl">SNT124-W658C9CDE54575A79B73D6FACA30@phx.gbl</a>&gt;
Content-Type: text/plain; charset=3D"iso-8859-1"


Hi

I purchased a DVICO HDTV Dual Express2 <a href=3D"http://www.linuxtv.org/w=
iki/index.php/DViCO_FusionHDTV_DVB-T_Dual_Express2" target=3D"_blank">http=
://www.linuxtv.org/wiki/index.php/DViCO_FusionHDTV_DVB-T_Dual_Express2</a>


The card has a CONEXANT CX23885-152 &amp; DiBcom 7070PB1-AXGXba-G-b Tuners


I have been modifying the V4l-DVB code (cx23885-dvb.c, cx23885-cards.c=20
&amp;cx23885.h) based on the DVICO HDTV Dual Express to try and get the ca=
rd to=20
work.
But I am having trouble with the 7070PB1-AXGXba-G-b tuners that I am tryin=
g to=20
base on the FusionHDTV Dual Digital 4 (cxusb.c).


I can get Modprobe to load the 2 tuners, but DVBSCAN says the frontend is=
 not=20
loaded


Any help would be appreciated


Cheers Nick
=20






                     =20
-------------- next part --------------
An HTML attachment was scrubbed...
URL: &lt;<a href=3D"http://www.linuxtv.org/pipermail/linux-dvb/attachments=
/20110404/79aa6670/attachment.html" target=3D"_blank">http://www.linuxtv.o=
rg/pipermail/linux-dvb/attachments/20110404/79aa6670/attachment.html</a>&g=
t;

------------------------------

_______________________________________________
linux-dvb mailing list
<a href=3D"mailto:linux-dvb@linuxtv.org">linux-dvb@linuxtv.org</a>
<a href=3D"http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb" targ=
et=3D"_blank">http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb</a=
>

End of linux-dvb Digest, Vol 75, Issue 3
****************************************
</tt></pre>
</div>

 <!-- end of AOLMsgPart_0_4ab4349e-a7be-406c-9718-62ca9eaf5b84 -->



</div>

</font></font>

----------MB_8CDC1351250E3EC_16B8_AB38_web-mmc-d04.sysops.aol.com--


--===============2021900270==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2021900270==--
