Return-path: <mchehab@pedra>
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:44127 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942Ab1B1RxP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Feb 2011 12:53:15 -0500
Received: from relay2-v.mail.gandi.net (relay2-v.mail.gandi.net [217.70.178.76])
	by slow3-v.mail.gandi.net (Postfix) with ESMTP id 61C2885E49
	for <linux-media@vger.kernel.org>; Mon, 28 Feb 2011 18:53:13 +0100 (CET)
Received: from mfilter8-d.gandi.net (mfilter8-d.gandi.net [217.70.178.34])
	by relay2-v.mail.gandi.net (Postfix) with ESMTP id 346C1135D6
	for <linux-media@vger.kernel.org>; Mon, 28 Feb 2011 18:52:49 +0100 (CET)
Received: from relay2-v.mail.gandi.net ([217.70.178.76])
	by mfilter8-d.gandi.net (mfilter8-d.gandi.net [217.70.178.34]) (amavisd-new, port 10024)
	with ESMTP id GIXqUH91-apQ for <linux-media@vger.kernel.org>;
	Mon, 28 Feb 2011 18:52:48 +0100 (CET)
Received: from WIN7PC (ALyon-157-1-160-78.w109-213.abo.wanadoo.fr [109.213.151.78])
	(Authenticated sender: sr@coexsi.fr)
	by relay2-v.mail.gandi.net (Postfix) with ESMTPSA id 7A282135D9
	for <linux-media@vger.kernel.org>; Mon, 28 Feb 2011 18:52:46 +0100 (CET)
From: =?iso-8859-1?Q?S=E9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>
To: "Linux Media Mailing List" <linux-media@vger.kernel.org>
Subject: [PATCH] DVB : add option to dump PDU exchanged with CAM in dvb_core
Date: Mon, 28 Feb 2011 18:52:46 +0100
Message-ID: <009f01cbd770$50208a90$f0619fb0$@coexsi.fr>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_00A0_01CBD778.B1E567C0"
Content-Language: fr
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multipart message in MIME format.

------=_NextPart_000_00A0_01CBD778.B1E567C0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

Dear all,

Here is a patch for the dvb_core module, you'll find it attached to this
message.

It's adding a new module integer parameter called "cam_dump_pdu" that can
have the following values:
- 0 (by default): don't dump PDU (do nothing)
- 1: Dump all PDU written and read on device through the syscall functions.
The PDU are dumped in segments of 16 bytes maximum written in hexadecimal.
- 2: like value 1 but remove the commonly used PDU for polling (generating a
lot of "noise" in the logs)

The goal of dumping PDU exchanged with CAM is to help debugging userland
applications and libraries.

This is my first patch submission, so I may have made some errors regarding
the submission rules.

Best regards,
Sebastien.

------=_NextPart_000_00A0_01CBD778.B1E567C0
Content-Type: application/octet-stream;
	name="dvb_ca_en50221.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dvb_ca_en50221.patch"

diff --git a/linux/drivers/media/dvb/dvb-core/dvb_ca_en50221.c =
b/linux/drivers/media/dvb/dvb-core/dvb_ca_en50221.c=0A=
--- a/linux/drivers/media/dvb/dvb-core/dvb_ca_en50221.c=0A=
+++ b/linux/drivers/media/dvb/dvb-core/dvb_ca_en50221.c=0A=
@@ -43,10 +43,14 @@=0A=
 #include "dvb_ringbuffer.h"=0A=
 =0A=
 static int dvb_ca_en50221_debug;=0A=
+static int dvb_ca_en50221_dump_pdu;=0A=
 =0A=
 module_param_named(cam_debug, dvb_ca_en50221_debug, int, 0644);=0A=
 MODULE_PARM_DESC(cam_debug, "enable verbose debug messages");=0A=
 =0A=
+module_param_named(cam_dump_pdu, dvb_ca_en50221_dump_pdu, int, 0644);=0A=
+MODULE_PARM_DESC(cam_dump_pdu, "1 =3D enable dumping of all PDU; 2 =3D =
filter out commonly used PDU for polling");=0A=
+=0A=
 #define dprintk if (dvb_ca_en50221_debug) printk=0A=
 =0A=
 #define INIT_TIMEOUT_SECS 10=0A=
@@ -1346,6 +1350,32 @@ static ssize_t dvb_ca_en50221_io_write(s=0A=
 	status =3D count + 2;=0A=
 =0A=
 exit:=0A=
+=0A=
+	// Check if the dump PDU option is enabled=0A=
+	if (dvb_ca_en50221_dump_pdu>0) {=0A=
+		 if (status<2) {=0A=
+			printk(KERN_INFO "dvb%d.ca%d PDU_write: ERROR, status=3D%d\n", =
ca->dvbdev->adapter->num, ca->dvbdev->id, status);=0A=
+		} else {=0A=
+			// Check if we need to filter the [A00101] PDU used for polling =
(empty T_data_last transport tag for for t_c_id=3D1)=0A=
+			if (!(dvb_ca_en50221_dump_pdu=3D=3D2 && (status-2)=3D=3D3 && =
(unsigned char)(buf[0])=3D=3D0xa0 && (unsigned char)(buf[1])=3D=3D0x01 =
&& (unsigned char)(buf[2])=3D=3D0x01)) {=0A=
+				char dumped_string[33];=0A=
+				int total_bytes, segment, dumped_bytes, to_be_written, i;=0A=
+				total_bytes=3Dstatus-2;=0A=
+				segment=3D0;=0A=
+				dumped_bytes=3D0;=0A=
+				while (dumped_bytes<total_bytes) {=0A=
+					=
to_be_written=3D((total_bytes-dumped_bytes)<16)?(total_bytes-dumped_bytes=
):16;=0A=
+					for (i=3D0;i<to_be_written;i++) =0A=
+						sprintf(dumped_string+i*2,"%02X",(unsigned =
char)(buf[dumped_bytes+i]));=0A=
+					dumped_string[to_be_written*2]=3D0;=0A=
+					printk(KERN_INFO "dvb%d.ca%d PDU_write: length=3D%03d, =
segment=3D%02d, dump=3D[%s]\n", ca->dvbdev->adapter->num, =
ca->dvbdev->id, total_bytes, segment, dumped_string);=0A=
+					segment++;=0A=
+					dumped_bytes+=3Dto_be_written;=0A=
+				}=0A=
+			}=0A=
+		}=0A=
+	}=0A=
+=0A=
 	return status;=0A=
 }=0A=
 =0A=
@@ -1493,6 +1523,32 @@ static ssize_t dvb_ca_en50221_io_read(st=0A=
 	status =3D pktlen;=0A=
 =0A=
 exit:=0A=
+=0A=
+	// Check if the dump PDU option is enabled=0A=
+	if (dvb_ca_en50221_dump_pdu>0) {=0A=
+		 if (status<2) {=0A=
+			printk(KERN_INFO "dvb%d.ca%d PDU_read:  ERROR, status=3D%d\n", =
ca->dvbdev->adapter->num, ca->dvbdev->id, status);=0A=
+		} else {=0A=
+			// Check if we need to filter the [80020100] PDU used for polling =
(T_SB transport tag for t_c_id=3D1 saying no data avaliable)=0A=
+			if (!(dvb_ca_en50221_dump_pdu=3D=3D2 && (status-2)=3D=3D4 && =
(unsigned char)(buf[0+2])=3D=3D0x80 && (unsigned =
char)(buf[1+2])=3D=3D0x02 && (unsigned char)(buf[2+2])=3D=3D0x01 && =
(unsigned char)(buf[3+2])=3D=3D0x00)) {=0A=
+				char dumped_string[33];=0A=
+				int total_bytes, segment, dumped_bytes, to_be_written, i;=0A=
+				total_bytes=3Dstatus-2;=0A=
+				segment=3D0;=0A=
+				dumped_bytes=3D0;=0A=
+				while (dumped_bytes<total_bytes) {=0A=
+					=
to_be_written=3D((total_bytes-dumped_bytes)<16)?(total_bytes-dumped_bytes=
):16;=0A=
+					for (i=3D0;i<to_be_written;i++) =0A=
+						sprintf(dumped_string+i*2,"%02X",(unsigned =
char)(buf[dumped_bytes+i+2]));=0A=
+					dumped_string[to_be_written*2]=3D0;=0A=
+					printk(KERN_INFO "dvb%d.ca%d PDU_read:  length=3D%03d, =
segment=3D%02d, dump=3D[%s]\n", ca->dvbdev->adapter->num, =
ca->dvbdev->id, total_bytes, segment, dumped_string);=0A=
+					segment++;=0A=
+					dumped_bytes+=3Dto_be_written;=0A=
+				}=0A=
+			}=0A=
+		}=0A=
+	}=0A=
+=0A=
 	return status;=0A=
 }=0A=
 =0A=

------=_NextPart_000_00A0_01CBD778.B1E567C0--

