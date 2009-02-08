Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wa-out-1112.google.com ([209.85.146.180])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nandviv@gmail.com>) id 1LWBXK-0007PS-5z
	for linux-dvb@linuxtv.org; Sun, 08 Feb 2009 16:25:34 +0100
Received: by wa-out-1112.google.com with SMTP id k17so1239538waf.1
	for <linux-dvb@linuxtv.org>; Sun, 08 Feb 2009 07:25:28 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 8 Feb 2009 20:55:28 +0530
Message-ID: <6b0fc64b0902080725u6897462eg5a98a1eff2390b68@mail.gmail.com>
From: vivekanand kumar <nandviv@gmail.com>
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Problem in accessing EN50221 card registers
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2098766672=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============2098766672==
Content-Type: multipart/alternative; boundary=001636418009297f70046269ddaf

--001636418009297f70046269ddaf
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Good hello,
   I have a PCMCIA CAM card on EN50221 standard.
   The card is interfaced to BCM7324 on EBI lines.
    Board detects the card,and it has to get initialised through proper
sequence .The sequence follows :set Reset bit and Poll for Ready bit in
command Register
The offset of Command Register is 0x1
   the processor address pins and    CAM address pins  are interfaced as
follows
  Processor                 CAM Card
   A3<------------------------>A2_CAM
   A2<-------------------------->A1_CAM
   A1<-------------------------->A0_CAM
   ........
  processor does not show A0 .I suppose this is for even address alignement.
CAM memory map for command Register is
A0_CAM=1
A1_CAM=0

   Hence to configure 0x1 offset(Command Register) i do
  CHIP_SELECT=0x1A000000
   *(ioremap(CHIP_SELECT+2,0x4) =value.

  I think CHIP_SELECT+2 should select A0_CAM=1 ;
  Am I right on this?

  But when i read the command register value i don,t get correct value.

  Can someone please tell me if i select the registers properly as
  written above ? Or please suggest me something else to be done .

Warm Regards,
 Vivian

--001636418009297f70046269ddaf
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Good hello,<br>&nbsp;&nbsp; I have a PCMCIA CAM card on EN50221 standard.<b=
r>&nbsp;&nbsp; The card is interfaced to BCM7324 on EBI lines.<br>&nbsp; &n=
bsp; Board detects the card,and it has to get initialised through proper se=
quence .The sequence follows :set Reset bit and Poll for Ready bit in comma=
nd Register <br>
The offset of Command Register is 0x1<br>&nbsp;&nbsp; the processor address=
 pins and&nbsp;&nbsp;&nbsp; CAM address pins&nbsp; are interfaced as follow=
s<br>&nbsp; Processor&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; CAM Card<br>&nbsp;&nbsp; A3&lt;-=
-----------------------&gt;A2_CAM<br>&nbsp;&nbsp; A2&lt;-------------------=
-------&gt;A1_CAM<br>
&nbsp;&nbsp; A1&lt;--------------------------&gt;A0_CAM<br>&nbsp;&nbsp; ...=
.....<br>&nbsp; processor does not show A0 .I suppose this is for even addr=
ess alignement.<br>CAM memory map for command Register is <br>A0_CAM=3D1<br=
>A1_CAM=3D0<br><br>&nbsp;&nbsp; Hence to configure 0x1 offset(Command Regis=
ter) i do<br>
&nbsp; CHIP_SELECT=3D0x1A000000<br>&nbsp;&nbsp; *(ioremap(CHIP_SELECT+2,0x4=
) =3Dvalue.<br><br>&nbsp; I think CHIP_SELECT+2 should select A0_CAM=3D1 ;<=
br>&nbsp; Am I right on this?<br><br>&nbsp; But when i read the command reg=
ister value i don,t get correct value.<br>
<br>&nbsp; Can someone please tell me if i select the registers properly as=
 <br>&nbsp; written above ? Or please suggest me something else to be done =
.<br><br>Warm Regards,<br>&nbsp;Vivian<br><br><br>&nbsp;&nbsp; <br>&nbsp; <=
br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <br>
&nbsp;&nbsp; <br><br>&nbsp;&nbsp; <br>&nbsp;&nbsp;&nbsp; <br>&nbsp;<br>&nbs=
p;&nbsp; <br>

--001636418009297f70046269ddaf--


--===============2098766672==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============2098766672==--
