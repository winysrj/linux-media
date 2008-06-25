Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1KBdbm-0000De-6M
	for linux-dvb@linuxtv.org; Thu, 26 Jun 2008 00:37:05 +0200
Received: from wfilter3.us4.outblaze.com.int (wfilter3.us4.outblaze.com.int
	[192.168.8.242])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	E489518007F3
	for <linux-dvb@linuxtv.org>; Wed, 25 Jun 2008 22:32:50 +0000 (GMT)
MIME-Version: 1.0
From: stev391@email.com
To: "Steven Toth" <stoth@linuxtv.org>
Date: Thu, 26 Jun 2008 08:32:07 +1000
Message-Id: <20080625223207.289C832675A@ws1-8.us4.outblaze.com>
Cc: linux dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] cx23885 driver and DMA timeouts
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1902707755=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

--===============1902707755==
Content-Transfer-Encoding: 7bit
Content-Type: multipart/alternative; boundary="_----------=_121443312757800"

This is a multi-part message in MIME format.

--_----------=_121443312757800
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

 Steve,

I have found the cause of my DMA timeouts, as per your suggestion I
checked the sram settings.
The cause of the issue was in SRAM_CH06 cdt, this was originally set to
0x10480 and is currently set to 0x108d0.  In changeset 7005:a6d2028a4aab
you introduced this as an alternative set of values and then in changeset
7464:20a1412b4f1a it was all converted to these values.  I was wondering
why this value was required to change?

I have not yet had the time to analyse these values in detail, but the
following are possible options that I/we can persue:

1) Set the value back to 0x10480 (diff attached), the following supported
cards will use this value (from a quick glance):
CX23885_BOARD_HAUPPAUGE_HVR1800lp
CX23885_BOARD_HAUPPAUGE_HVR1800
CX23885_BOARD_HAUPPAUGE_HVR1250
CX23885_BOARD_HAUPPAUGE_HVR1500Q
CX23885_BOARD_HAUPPAUGE_HVR1500
CX23885_BOARD_HAUPPAUGE_HVR1200
CX23885_BOARD_HAUPPAUGE_HVR1700
CX23885_BOARD_HAUPPAUGE_HVR1400
CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP

2) Introduce another variable in struct cx23885_board to allow board
specific srams.  The sram would not be duplicated in this struct, a
second version would be included in cx23885-core.c (similar to the 7005
changeset except it is now manual configurable and not switching on PCI
id). The down side of this is the cx23885-core.c will be slightly larger,
with a larger memory footprint.

3) Reallocate entire sram, this would require a detailed look on my
behalf to see how much space each variable requires and reallocate it.=20
This will potentially break the cards mentioned in option 1 and will take
more time to implement and test. This is highly undesirable my viewpoint.

4) Something else? Please suggest a solution...

Regards,

Stephen

diff -Naur v4l-dvb/linux/drivers/media/video/cx23885/cx23885-core.c
v4l-dvb1/linux/drivers/media/video/cx23885/cx23885-core.c
--- v4l-dvb/linux/drivers/media/video/cx23885/cx23885-core.c=20=20=20
2008-06-06 14:57:55.000000000 +1000
+++ v4l-dvb1/linux/drivers/media/video/cx23885/cx23885-core.c=20=20
2008-06-26 08:26:42.000000000 +1000
@@ -142,7 +142,7 @@
.name           =3D "TS2 C",
.cmds_start     =3D 0x10140,
.ctrl_start     =3D 0x10680,
-               .cdt            =3D 0x108d0,
+               .cdt            =3D 0x10480,
.fifo_start     =3D 0x6000,
.fifo_size      =3D 0x1000,
.ptr1_reg       =3D DMA5_PTR1,

  ----- Original Message -----
  From: "Steven Toth"
  To: stev391@email.com
  Subject: Re: [linux-dvb] cx23885 driver and DMA timeouts
  Date: Mon, 23 Jun 2008 08:51:10 -0400

  No need to try windows, if you have the driver already running
  (pascoe's patches) then your chipset and hardware are fine.

  Sounds like you have a simple merge issue.

  Try to figure out which parts of the merge actually create the
  problem then bring that issue back to this list for discussion.

  Regards,

  - Steve

--=20
Be Yourself @ mail.com!
Choose From 200+ Email Addresses
Get a Free Account at www.mail.com


--_----------=_121443312757800
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html; charset="iso-8859-1"


<div>
Steve,<br><br>I have found the cause of my DMA timeouts, as per your sugges=
tion I checked the sram settings.<br>The cause of the issue was in SRAM_CH0=
6 cdt, this was originally set to 0x10480 and is currently set to 0x108d0.&=
nbsp; In changeset 7005:a6d2028a4aab you introduced this as an alternative =
set of values and then in changeset 7464:20a1412b4f1a it was all converted =
to these values.&nbsp; I was wondering why this value was required to chang=
e?<br><br>I have not yet had the time to analyse these values in detail, bu=
t the following are possible options that I/we can persue:<br><br>1) Set th=
e value back to 0x10480 (diff attached), the following supported cards will=
 use this value (from a quick glance):<br>&nbsp;&nbsp;&nbsp; CX23885_BOARD_=
HAUPPAUGE_HVR1800lp<br>&nbsp;&nbsp;&nbsp; CX23885_BOARD_HAUPPAUGE_HVR1800<b=
r>&nbsp;&nbsp;&nbsp; CX23885_BOARD_HAUPPAUGE_HVR1250<br>&nbsp;&nbsp;&nbsp; =
CX23885_BOARD_HAUPPAUGE_HVR1500Q<br>&nbsp;&nbsp;&nbsp; CX23885_BOARD_HAUPPA=
UGE_HVR1500<br>&nbsp;&nbsp;&nbsp; CX23885_BOARD_HAUPPAUGE_HVR1200<br>&nbsp;=
&nbsp;&nbsp; CX23885_BOARD_HAUPPAUGE_HVR1700<br>&nbsp;&nbsp;&nbsp; CX23885_=
BOARD_HAUPPAUGE_HVR1400<br>&nbsp;&nbsp;&nbsp; CX23885_BOARD_DVICO_FUSIONHDT=
V_7_DUAL_EXP<br><br>2) Introduce another variable in struct cx23885_board t=
o allow board specific srams.&nbsp; The sram would not be duplicated in thi=
s struct, a second version would be included in cx23885-core.c (similar to =
the 7005 changeset except it is now manual configurable and not switching o=
n PCI id). The down side of this is the cx23885-core.c will be slightly lar=
ger, with a larger memory footprint.<br><br>3) Reallocate entire sram, this=
 would require a detailed look on my behalf to see how much space each vari=
able requires and reallocate it.&nbsp; This will potentially break the card=
s mentioned in option 1 and will take more time to implement and test. This=
 is highly undesirable my viewpoint.<br><br>4) Something else? Please sugge=
st a solution...<br><br>Regards,<br><br>Stephen<br><br>diff -Naur v4l-dvb/l=
inux/drivers/media/video/cx23885/cx23885-core.c v4l-dvb1/linux/drivers/medi=
a/video/cx23885/cx23885-core.c<br>--- v4l-dvb/linux/drivers/media/video/cx2=
3885/cx23885-core.c&nbsp;&nbsp;&nbsp; 2008-06-06 14:57:55.000000000 +1000<b=
r>+++ v4l-dvb1/linux/drivers/media/video/cx23885/cx23885-core.c&nbsp;&nbsp;=
 2008-06-26 08:26:42.000000000 +1000<br>@@ -142,7 +142,7 @@<br>&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; .name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D "=
TS2 C",<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp; .cmds_start&nbsp;&nbsp;&nbsp;&nbsp; =3D 0x10140,=
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp; .ctrl_start&nbsp;&nbsp;&nbsp;&nbsp; =3D 0x10680,<br>-&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp; .cdt&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp; =3D 0x108d0,<br>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .cdt&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp; =3D 0x10480,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .fifo_start&nbsp=
;&nbsp;&nbsp;&nbsp; =3D 0x6000,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .fifo_size&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp; =3D 0x1000,<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .ptr1_reg&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; =3D DMA5_PTR1,<br>
<br>
<blockquote style=3D"border-left: 2px solid rgb(16, 16, 255); margin-left: =
5px; padding-left: 5px;">----- Original Message -----<br>
From: "Steven Toth" <stoth@linuxtv.org><br>
To: stev391@email.com<br>
Subject: Re: [linux-dvb] cx23885 driver and DMA timeouts<br>
Date: Mon, 23 Jun 2008 08:51:10 -0400<br>
<br>

No need to try windows, if you have the driver already running <br>
(pascoe's patches) then your chipset and hardware are fine.<br>
<br>
Sounds like you have a simple merge issue.<br>
<br>
Try to figure out which parts of the merge actually create the <br>
problem then bring that issue back to this list for discussion.<br>
<br>
Regards,<br>
<br>
- Steve<br>
</stoth@linuxtv.org></blockquote>
</div>
<BR>

--=20
<div> Be Yourself @ mail.com!<br>
Choose From 200+ Email Addresses<br>
Get a <b>Free</b> Account at <a href=3D"http://www.mail.com/Product.aspx" t=
arget=3D"_blank">www.mail.com</a>!</div>

--_----------=_121443312757800--



--===============1902707755==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1902707755==--
