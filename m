Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp2.aster.pl ([212.76.33.47])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Daniel.Perzynski@aster.pl>) id 1LCLtX-0002sA-CX
	for linux-dvb@linuxtv.org; Mon, 15 Dec 2008 23:26:40 +0100
From: "Daniel Perzynski" <Daniel.Perzynski@aster.pl>
To: <linux-dvb@linuxtv.org>
Date: Mon, 15 Dec 2008 23:25:43 +0100
Message-ID: <000901c95f04$11bda940$3538fbc0$@Perzynski@aster.pl>
MIME-Version: 1.0
Content-Language: en-us
Subject: Re: [linux-dvb] Avermedia A312 - patch for review
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1946524532=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multipart message in MIME format.

--===============1946524532==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_000A_01C95F0C.73821140"
Content-Language: en-us

This is a multipart message in MIME format.

------=_NextPart_000_000A_01C95F0C.73821140
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

 

According to the suggestions I've modified dvb-usb-ids.h and cxusb.c to add
a support for that card.

 

I would appreciate someone to look at the code below and compare it with
spec on the wiki for that card.

 

--- ala/v4l-dvb/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h
2008-12-14 23:11:28.000000000 +0100

+++ v4l-dvb/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h   2008-12-14
22:08:17.000000000 +0100

@@ -234,5 +234,5 @@

 #define USB_PID_XTENSIONS_XD_380
0x0381

 #define USB_PID_TELESTAR_STARSTICK_2
0x8000

 #define USB_PID_MSI_DIGI_VOX_MINI_III                   0x8807

-

+#define USB_PID_AVERMEDIA_A312                          0xa312

 #endif

--- ala/v4l-dvb/linux/drivers/media/dvb/dvb-usb/cxusb.c
2008-12-14 23:11:28.000000000 +0100

+++ v4l-dvb/linux/drivers/media/dvb/dvb-usb/cxusb.c
2008-12-14 22:43:33.000000000 +0100

@@ -1224,6 +1224,8 @@

 static struct dvb_usb_device_properties cxusb_bluebird_nano2_properties;

 static struct dvb_usb_device_properties
cxusb_bluebird_nano2_needsfirmware_properties;

 static struct dvb_usb_device_properties cxusb_aver_a868r_properties;

+static struct dvb_usb_device_properties cxusb_aver_a312_properties;

+

 static struct dvb_usb_device_properties cxusb_d680_dmb_properties;

 

 static int cxusb_probe(struct usb_interface *intf,

@@ -1248,6 +1250,8 @@

 
THIS_MODULE, NULL, adapter_nr) ||

                    0 == dvb_usb_device_init(intf,
&cxusb_aver_a868r_properties,

 
THIS_MODULE, NULL, adapter_nr) ||

+                 0 == dvb_usb_device_init(intf,
&cxusb_aver_a312_properties,

+
THIS_MODULE, NULL, adapter_nr) ||

                    0 == dvb_usb_device_init(intf,

 
&cxusb_bluebird_dualdig4_rev2_properties,

 
THIS_MODULE, NULL, adapter_nr) ||

@@ -1277,6 +1281,7 @@

                { USB_DEVICE(USB_VID_DVICO,
USB_PID_DVICO_BLUEBIRD_DVB_T_NANO_2) },

                { USB_DEVICE(USB_VID_DVICO,
USB_PID_DVICO_BLUEBIRD_DVB_T_NANO_2_NFW_WARM) },

                { USB_DEVICE(USB_VID_AVERMEDIA,
USB_PID_AVERMEDIA_VOLAR_A868R) },

+             { USB_DEVICE(USB_VID_AVERMEDIA, USB_PID_AVERMEDIA_A312) },

                { USB_DEVICE(USB_VID_DVICO,
USB_PID_DVICO_BLUEBIRD_DUAL_4_REV_2) },

                { USB_DEVICE(USB_VID_CONEXANT, USB_PID_CONEXANT_D680_DMB) },

                {}                             /* Terminating entry */

@@ -1724,6 +1729,48 @@

                }

 };

 

+static struct dvb_usb_device_properties cxusb_aver_a312_properties = {

+             .caps = DVB_USB_IS_AN_I2C_ADAPTER,

+

+             .usb_ctrl         = CYPRESS_FX2,

+

+             .size_of_priv     = sizeof(struct cxusb_state),

+

+             .num_adapters = 1,

+             .adapter = {

+                             {

+                                             .streaming_ctrl   =
cxusb_aver_streaming_ctrl,

+                                             .frontend_attach  =
cxusb_aver_lgdt3303_frontend_attach,

+                                             .tuner_attach     =
cxusb_dvico_xc3028_tuner_attach,

+                                             /* parameter for the
MPEG2-data transfer */

+                                             .stream = {

+                                                             .type =
USB_BULK,

+                                                             .count = 5,

+                                                             .endpoint =
0x04,

+                                                             .u = {

+
.bulk = {

+
.buffersize = 8192,

+
}

+                                                             }

+                                             },

+

+                             },

+             },

+             .power_ctrl       = cxusb_aver_power_ctrl,

+

+             .i2c_algo         = &cxusb_i2c_algo,

+

+             .generic_bulk_ctrl_endpoint = 0x01,

+

+             .num_device_descs = 1,

+             .devices = {

+                             {   "AVerMedia AVerTVHD (A312)",

+                                             { NULL },

+                                             { &cxusb_table[17], NULL },

+                             },

+             }

+};

+

 static

 struct dvb_usb_device_properties cxusb_bluebird_dualdig4_rev2_properties =
{

                .caps = DVB_USB_IS_AN_I2C_ADAPTER,

 

After modprobing cxusb driver I have:

 

vb-usb: found a 'AVerMedia AVerTVHD (A312)' in warm state.

dvb-usb: will pass the complete MPEG2 transport stream to the software
demuxer.

DVB: registering new adapter (AVerMedia AVerTVHD (A312))

DVB: registering adapter 0 frontend 0 (LG Electronics LGDT3303 VSB/QAM
Frontend)...

xc2028 4-0061: creating new instance

xc2028 4-0061: type set to XCeive xc2028/xc3028 tuner

dvb-usb: AVerMedia AVerTVHD (A312) successfully initialized and connected.

usbcore: registered new interface driver dvb_usb_cxusb

 

h3xu5 v4l-dvb # ls -laR /dev/dvb/

/dev/dvb/:

total 0

drwxr-xr-x  3 root root   60 Dec 14 23:06 .

drwxr-xr-x 15 root root 4640 Dec 14 23:06 ..

drwxr-xr-x  2 root root  120 Dec 14 23:06 adapter0

 

/dev/dvb/adapter0:

total 0

drwxr-xr-x 2 root root     120 Dec 14 23:06 .

drwxr-xr-x 3 root root      60 Dec 14 23:06 ..

crw-rw---- 1 root video 212, 0 Dec 14 23:06 demux0

crw-rw---- 1 root video 212, 1 Dec 14 23:06 dvr0

crw-rw---- 1 root video 212, 3 Dec 14 23:06 frontend0

crw-rw---- 1 root video 212, 2 Dec 14 23:06 net0

 

The question is if it is ok or maybe something is missing here and what
should be next steps.

 

Regards,

 


------=_NextPart_000_000A_01C95F0C.73821140
Content-Type: text/html;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html xmlns:v=3D"urn:schemas-microsoft-com:vml" =
xmlns:o=3D"urn:schemas-microsoft-com:office:office" =
xmlns:w=3D"urn:schemas-microsoft-com:office:word" =
xmlns:m=3D"http://schemas.microsoft.com/office/2004/12/omml" =
xmlns=3D"http://www.w3.org/TR/REC-html40">

<head>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Dus-ascii">
<meta name=3DGenerator content=3D"Microsoft Word 12 (filtered medium)">
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0in;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
a:link, span.MsoHyperlink
	{mso-style-priority:99;
	color:blue;
	text-decoration:underline;}
a:visited, span.MsoHyperlinkFollowed
	{mso-style-priority:99;
	color:purple;
	text-decoration:underline;}
span.EmailStyle17
	{mso-style-type:personal-compose;
	font-family:"Calibri","sans-serif";
	color:windowtext;}
.MsoChpDefault
	{mso-style-type:export-only;}
@page Section1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.Section1
	{page:Section1;}
-->
</style>
<!--[if gte mso 9]><xml>
 <o:shapedefaults v:ext=3D"edit" spidmax=3D"1026" />
</xml><![endif]--><!--[if gte mso 9]><xml>
 <o:shapelayout v:ext=3D"edit">
  <o:idmap v:ext=3D"edit" data=3D"1" />
 </o:shapelayout></xml><![endif]-->
</head>

<body lang=3DEN-US link=3Dblue vlink=3Dpurple>

<div class=3DSection1>

<p class=3DMsoNormal>Hi,<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>According to the suggestions I&#8217;ve modified =
dvb-usb-ids.h
and cxusb.c to add a support for that card.<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>I would appreciate someone to look at the code =
below and
compare it with spec on the wiki for that card.<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>---
ala/v4l-dvb/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
2008-12-14
23:11:28.000000000 +0100<o:p></o:p></p>

<p class=3DMsoNormal>+++ =
v4l-dvb/linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h&nbsp;&nbsp; =
2008-12-14
22:08:17.000000000 +0100<o:p></o:p></p>

<p class=3DMsoNormal>@@ -234,5 +234,5 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;#define =
USB_PID_XTENSIONS_XD_380&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; 0x0381<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;#define =
USB_PID_TELESTAR_STARSTICK_2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 0x8000<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;#define =
USB_PID_MSI_DIGI_VOX_MINI_III&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
0x8807<o:p></o:p></p>

<p class=3DMsoNormal>-<o:p></o:p></p>

<p class=3DMsoNormal>+#define =
USB_PID_AVERMEDIA_A312&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;
0xa312<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;#endif<o:p></o:p></p>

<p class=3DMsoNormal>--- =
ala/v4l-dvb/linux/drivers/media/dvb/dvb-usb/cxusb.c&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2008-12-14
23:11:28.000000000 +0100<o:p></o:p></p>

<p class=3DMsoNormal>+++ =
v4l-dvb/linux/drivers/media/dvb/dvb-usb/cxusb.c&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
2008-12-14
22:43:33.000000000 +0100<o:p></o:p></p>

<p class=3DMsoNormal>@@ -1224,6 +1224,8 @@<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;static struct dvb_usb_device_properties
cxusb_bluebird_nano2_properties;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;static struct dvb_usb_device_properties
cxusb_bluebird_nano2_needsfirmware_properties;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;static struct dvb_usb_device_properties
cxusb_aver_a868r_properties;<o:p></o:p></p>

<p class=3DMsoNormal>+static struct dvb_usb_device_properties
cxusb_aver_a312_properties;<o:p></o:p></p>

<p class=3DMsoNormal>+<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;static struct dvb_usb_device_properties
cxusb_d680_dmb_properties;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;static int cxusb_probe(struct usb_interface =
*intf,<o:p></o:p></p>

<p class=3DMsoNormal>@@ -1248,6 +1250,8 @@<o:p></o:p></p>

<p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;
THIS_MODULE, NULL, adapter_nr) ||<o:p></o:p></p>

<p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; 0 =3D=3D =
dvb_usb_device_init(intf,
&amp;cxusb_aver_a868r_properties,<o:p></o:p></p>

<p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;
THIS_MODULE, NULL, adapter_nr) ||<o:p></o:p></p>

<p =
class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; 0 =3D=3D dvb_usb_device_init(intf,
&amp;cxusb_aver_a312_properties,<o:p></o:p></p>

<p =
class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;
THIS_MODULE, NULL, adapter_nr) ||<o:p></o:p></p>

<p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; 0 =3D=3D =
dvb_usb_device_init(intf,<o:p></o:p></p>

<p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;
&amp;cxusb_bluebird_dualdig4_rev2_properties,<o:p></o:p></p>

<p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;
THIS_MODULE, NULL, adapter_nr) ||<o:p></o:p></p>

<p class=3DMsoNormal>@@ -1277,6 +1281,7 @@<o:p></o:p></p>

<p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; { USB_DEVICE(USB_VID_DVICO,
USB_PID_DVICO_BLUEBIRD_DVB_T_NANO_2) },<o:p></o:p></p>

<p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; { USB_DEVICE(USB_VID_DVICO,
USB_PID_DVICO_BLUEBIRD_DVB_T_NANO_2_NFW_WARM) },<o:p></o:p></p>

<p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; { USB_DEVICE(USB_VID_AVERMEDIA,
USB_PID_AVERMEDIA_VOLAR_A868R) },<o:p></o:p></p>

<p =
class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; { USB_DEVICE(USB_VID_AVERMEDIA,
USB_PID_AVERMEDIA_A312) },<o:p></o:p></p>

<p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; { USB_DEVICE(USB_VID_DVICO,
USB_PID_DVICO_BLUEBIRD_DUAL_4_REV_2) },<o:p></o:p></p>

<p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; { USB_DEVICE(USB_VID_CONEXANT,
USB_PID_CONEXANT_D680_DMB) },<o:p></o:p></p>

<p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
{}&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp; /*
Terminating entry */<o:p></o:p></p>

<p class=3DMsoNormal>@@ -1724,6 +1729,48 @@<o:p></o:p></p>

<p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;};<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;<o:p></o:p></p>

<p class=3DMsoNormal>+static struct dvb_usb_device_properties
cxusb_aver_a312_properties =3D {<o:p></o:p></p>

<p =
class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; .caps =3D DVB_USB_IS_AN_I2C_ADAPTER,<o:p></o:p></p>

<p class=3DMsoNormal>+<o:p></o:p></p>

<p =
class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; =
.usb_ctrl&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D =
CYPRESS_FX2,<o:p></o:p></p>

<p class=3DMsoNormal>+<o:p></o:p></p>

<p =
class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; .size_of_priv&nbsp;&nbsp;&nbsp;&nbsp; =3D =
sizeof(struct
cxusb_state),<o:p></o:p></p>

<p class=3DMsoNormal>+<o:p></o:p></p>

<p =
class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; .num_adapters =3D 1,<o:p></o:p></p>

<p =
class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; .adapter =3D {<o:p></o:p></p>

<p =
class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {<o:p></o:p></p>

<p =
class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
.streaming_ctrl&nbsp;&nbsp;
=3D cxusb_aver_streaming_ctrl,<o:p></o:p></p>

<p =
class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
.frontend_attach&nbsp;
=3D cxusb_aver_lgdt3303_frontend_attach,<o:p></o:p></p>

<p =
class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
.tuner_attach&nbsp;&nbsp;&nbsp;&nbsp;
=3D cxusb_dvico_xc3028_tuner_attach,<o:p></o:p></p>

<p =
class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /* =
parameter
for the MPEG2-data transfer */<o:p></o:p></p>

<p =
class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .stream =
=3D {<o:p></o:p></p>

<p =
class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; .type
=3D USB_BULK,<o:p></o:p></p>

<p =
class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; .count
=3D 5,<o:p></o:p></p>

<p =
class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; .endpoint
=3D 0x04,<o:p></o:p></p>

<p =
class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; .u
=3D {<o:p></o:p></p>

<p =
class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .bulk
=3D {<o:p></o:p></p>

<p =
class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .buffersize
=3D 8192,<o:p></o:p></p>

<p =
class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; }<o:p></o:p></p>

<p =
class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp; }<o:p></o:p></p>

<p =
class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
},<o:p></o:p></p>

<p class=3DMsoNormal>+<o:p></o:p></p>

<p =
class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; },<o:p></o:p></p>

<p =
class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; },<o:p></o:p></p>

<p =
class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; .power_ctrl&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D =
cxusb_aver_power_ctrl,<o:p></o:p></p>

<p class=3DMsoNormal><span lang=3DPL>+<o:p></o:p></span></p>

<p class=3DMsoNormal><span =
lang=3DPL>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp; .i2c_algo&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =3D
&amp;cxusb_i2c_algo,<o:p></o:p></span></p>

<p class=3DMsoNormal>+<o:p></o:p></p>

<p =
class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; .generic_bulk_ctrl_endpoint =3D 0x01,<o:p></o:p></p>

<p class=3DMsoNormal>+<o:p></o:p></p>

<p =
class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; .num_device_descs =3D 1,<o:p></o:p></p>

<p =
class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; .devices =3D {<o:p></o:p></p>

<p =
class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {&nbsp;&nbsp; &quot;AVerMedia =
AVerTVHD
(A312)&quot;,<o:p></o:p></p>

<p =
class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; { NULL =
},<o:p></o:p></p>

<p =
class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; {
&amp;cxusb_table[17], NULL },<o:p></o:p></p>

<p =
class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; },<o:p></o:p></p>

<p =
class=3DMsoNormal>+&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp; }<o:p></o:p></p>

<p class=3DMsoNormal>+};<o:p></o:p></p>

<p class=3DMsoNormal>+<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;static<o:p></o:p></p>

<p class=3DMsoNormal>&nbsp;struct dvb_usb_device_properties
cxusb_bluebird_dualdig4_rev2_properties =3D {<o:p></o:p></p>

<p =
class=3DMsoNormal>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .caps =3D =
DVB_USB_IS_AN_I2C_ADAPTER,<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>After modprobing cxusb driver I =
have:<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>vb-usb: found a 'AVerMedia AVerTVHD (A312)' in warm =
state.<o:p></o:p></p>

<p class=3DMsoNormal>dvb-usb: will pass the complete MPEG2 transport =
stream to
the software demuxer.<o:p></o:p></p>

<p class=3DMsoNormal>DVB: registering new adapter (AVerMedia AVerTVHD =
(A312))<o:p></o:p></p>

<p class=3DMsoNormal>DVB: registering adapter 0 frontend 0 (LG =
Electronics
LGDT3303 VSB/QAM Frontend)...<o:p></o:p></p>

<p class=3DMsoNormal>xc2028 4-0061: creating new instance<o:p></o:p></p>

<p class=3DMsoNormal>xc2028 4-0061: type set to XCeive xc2028/xc3028 =
tuner<o:p></o:p></p>

<p class=3DMsoNormal>dvb-usb: AVerMedia AVerTVHD (A312) successfully =
initialized
and connected.<o:p></o:p></p>

<p class=3DMsoNormal>usbcore: registered new interface driver =
dvb_usb_cxusb<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>h3xu5 v4l-dvb # ls -laR /dev/dvb/<o:p></o:p></p>

<p class=3DMsoNormal>/dev/dvb/:<o:p></o:p></p>

<p class=3DMsoNormal>total 0<o:p></o:p></p>

<p class=3DMsoNormal>drwxr-xr-x&nbsp; 3 root root&nbsp;&nbsp; 60 Dec 14 =
23:06 .<o:p></o:p></p>

<p class=3DMsoNormal>drwxr-xr-x 15 root root 4640 Dec 14 23:06 =
..<o:p></o:p></p>

<p class=3DMsoNormal>drwxr-xr-x&nbsp; 2 root root&nbsp; 120 Dec 14 23:06 =
adapter0<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>/dev/dvb/adapter0:<o:p></o:p></p>

<p class=3DMsoNormal>total 0<o:p></o:p></p>

<p class=3DMsoNormal>drwxr-xr-x 2 root root&nbsp;&nbsp;&nbsp;&nbsp; 120 =
Dec 14 23:06 .<o:p></o:p></p>

<p class=3DMsoNormal>drwxr-xr-x 3 root =
root&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 60 Dec 14 23:06 ..<o:p></o:p></p>

<p class=3DMsoNormal>crw-rw---- 1 root video 212, 0 Dec 14 23:06 =
demux0<o:p></o:p></p>

<p class=3DMsoNormal>crw-rw---- 1 root video 212, 1 Dec 14 23:06 =
dvr0<o:p></o:p></p>

<p class=3DMsoNormal>crw-rw---- 1 root video 212, 3 Dec 14 23:06 =
frontend0<o:p></o:p></p>

<p class=3DMsoNormal>crw-rw---- 1 root video 212, 2 Dec 14 23:06 =
net0<o:p></o:p></p>

<p class=3DMsoNormal><b><o:p>&nbsp;</o:p></b></p>

<p class=3DMsoNormal>The question is if it is ok or maybe something is =
missing
here and what should be next steps.<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

<p class=3DMsoNormal>Regards,<o:p></o:p></p>

<p class=3DMsoNormal><o:p>&nbsp;</o:p></p>

</div>

</body>

</html>

------=_NextPart_000_000A_01C95F0C.73821140--



--===============1946524532==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1946524532==--
