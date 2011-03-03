Return-path: <mchehab@pedra>
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:57078 "EHLO
	relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758051Ab1CCQwH (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Mar 2011 11:52:07 -0500
Received: from mfilter8-d.gandi.net (mfilter8-d.gandi.net [217.70.178.34])
	by relay2-d.mail.gandi.net (Postfix) with ESMTP id 9394622519F
	for <linux-media@vger.kernel.org>; Thu,  3 Mar 2011 17:52:05 +0100 (CET)
Received: from relay2-d.mail.gandi.net ([217.70.183.194])
	by mfilter8-d.gandi.net (mfilter8-d.gandi.net [217.70.178.34]) (amavisd-new, port 10024)
	with ESMTP id AISxUwOwah9c for <linux-media@vger.kernel.org>;
	Thu,  3 Mar 2011 17:52:04 +0100 (CET)
Received: from WIN7PC (ALyon-157-1-213-100.w109-213.abo.wanadoo.fr [109.213.188.100])
	(Authenticated sender: sr@coexsi.fr)
	by relay2-d.mail.gandi.net (Postfix) with ESMTPSA id 03CD8225149
	for <linux-media@vger.kernel.org>; Thu,  3 Mar 2011 17:52:03 +0100 (CET)
From: =?iso-8859-1?Q?S=E9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>
To: "Linux Media Mailing List" <linux-media@vger.kernel.org>
Subject: [PATCH] DVB-APPS : correct some issues in libdvben50221
Date: Thu, 3 Mar 2011 17:52:04 +0100
Message-ID: <008f01cbd9c3$55b81a90$01284fb0$@coexsi.fr>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0090_01CBD9CB.B77D1ED0"
Content-Language: fr
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is a multipart message in MIME format.

------=_NextPart_000_0090_01CBD9CB.B77D1ED0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

Dear all,

Here are two patches against the latest version of libdvben50221 in the hg
repository.

Details of corrections:
-----------------------

* In "en50221_sl_handle_close_session_response", the expected data length
wasn't good, the "close_session_response" object is 3 bytes long, not 4
bytes long (see the specification)

* The "LLCI_RESPONSE_TIMEOUT_MS" has been increased from 1000ms to 10000ms
in order to wait for long/complex MMI operations. The timeout work at TPDU
2nd level and not at LPDU 1st level of communication stack. 

* In "en50221_stdcam_llci_destroy", all data from the CA device are read
before closing the device. This prevent from keeping the last poll reply in
the dvb_core module ringbuffer. The polling function used to keep contact
with the CAM is first reading data then writing data, so there is always a
reply left in the buffer.

* In "llci_lookup_callback", some tests permitting resource usage limit are
disabled as they are not working correctly. When a new session is created,
it is declared. But when a session is closed, this isn't declared so a new
session can't be opened a second time.

* In "llci_session_callback", a test was removed as it was duplicated.

* In "en50221_stdcam_llci_poll" and "llci_datetime_enquiry_callback", if the
function "en50221_stdcam_llci_dvbtime" isn't called regularly, a wrong
date/time is send to the CAM. So, if the time wasn't supplied, we send the
UTC time from the system. Also, the "time_offset" parameter of the called
function "en50221_app_datetime_send" has been set to -1 as we don't have the
"local_offset" information and as this information is optional (see the
specification).

Best regards,
Sebastien RAILLARD.

------=_NextPart_000_0090_01CBD9CB.B77D1ED0
Content-Type: application/octet-stream;
	name="en50221_session.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="en50221_session.patch"

diff --git a/lib/libdvben50221/en50221_session.c =
b/lib/libdvben50221/en50221_session.c=0A=
--- a/lib/libdvben50221/en50221_session.c=0A=
+++ b/lib/libdvben50221/en50221_session.c=0A=
@@ -715,13 +715,13 @@ static void en50221_sl_handle_close_sess=0A=
 						     uint8_t connection_id)=0A=
 {=0A=
 	// check=0A=
-	if (data_length < 5) {=0A=
+	if (data_length < 4) {=0A=
 		print(LOG_LEVEL, ERROR, 1,=0A=
 		      "Received data with invalid length from module on slot %02x\n",=0A=
 		      slot_id);=0A=
 		return;=0A=
 	}=0A=
-	if (data[0] !=3D 4) {=0A=
+	if (data[0] !=3D 3) {=0A=
 		print(LOG_LEVEL, ERROR, 1,=0A=
 		      "Received data with invalid length from module on slot %02x\n",=0A=
 		      slot_id);=0A=

------=_NextPart_000_0090_01CBD9CB.B77D1ED0
Content-Type: application/octet-stream;
	name="en50221_stdcam_llci.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="en50221_stdcam_llci.patch"

diff --git a/lib/libdvben50221/en50221_stdcam_llci.c =
b/lib/libdvben50221/en50221_stdcam_llci.c=0A=
--- a/lib/libdvben50221/en50221_stdcam_llci.c=0A=
+++ b/lib/libdvben50221/en50221_stdcam_llci.c=0A=
@@ -32,7 +32,7 @@=0A=
 #include "en50221_app_tags.h"=0A=
 #include "en50221_stdcam.h"=0A=
 =0A=
-#define LLCI_RESPONSE_TIMEOUT_MS 1000=0A=
+#define LLCI_RESPONSE_TIMEOUT_MS 10*1000=0A=
 #define LLCI_POLL_DELAY_MS 100=0A=
 =0A=
 /* resource IDs we support */=0A=
@@ -207,7 +207,16 @@ static void en50221_stdcam_llci_destroy(=0A=
 		en50221_app_mmi_destroy(llci->stdcam.mmi_resource);=0A=
 =0A=
 	if (closefd)=0A=
+	{=0A=
+		// Read the buffer before closing the device to remove the last =
polling answer=0A=
+		uint8_t r_slot_id;=0A=
+		uint8_t connection_id;=0A=
+		uint8_t data[4096];=0A=
+		dvbca_link_read(llci->cafd, &r_slot_id,=0A=
+			&connection_id,=0A=
+			data, sizeof(data));=0A=
 		close(llci->cafd);=0A=
+	}=0A=
 =0A=
 	free(llci);=0A=
 }=0A=
@@ -243,9 +252,14 @@ static enum en50221_stdcam_status en5022=0A=
 	if (llci->datetime_session_number !=3D -1) {=0A=
 		time_t cur_time =3D time(NULL);=0A=
 		if (llci->datetime_response_interval && (cur_time > =
llci->datetime_next_send)) {=0A=
-			en50221_app_datetime_send(llci->datetime_resource,=0A=
-						llci->datetime_session_number,=0A=
-						llci->datetime_dvbtime, 0);=0A=
+			if (llci->datetime_dvbtime>0)=0A=
+				en50221_app_datetime_send(llci->datetime_resource,=0A=
+							llci->datetime_session_number,=0A=
+							llci->datetime_dvbtime, -1);=0A=
+			else=0A=
+				en50221_app_datetime_send(llci->datetime_resource,=0A=
+							llci->datetime_session_number,=0A=
+							time(NULL), -1);=0A=
 			llci->datetime_next_send =3D cur_time + =
llci->datetime_response_interval;=0A=
 		}=0A=
 	}=0A=
@@ -334,12 +348,14 @@ static int llci_lookup_callback(void *ar=0A=
 					return -3;=0A=
 				break;=0A=
 			case EN50221_APP_CA_RESOURCEID:=0A=
-				if (llci->stdcam.ca_session_number !=3D -1)=0A=
-					return -3;=0A=
+				// As ressources are declared when used but not when released, =
limiting session is buggy...=0A=
+				// if (llci->stdcam.ca_session_number !=3D -1)=0A=
+				//	return -3;=0A=
 				break;=0A=
 			case EN50221_APP_MMI_RESOURCEID:=0A=
-				if (llci->stdcam.mmi_session_number !=3D -1)=0A=
-					return -3;=0A=
+				// As ressources are declared when used but not when released, =
limiting session is buggy...=0A=
+				// if (llci->stdcam.mmi_session_number !=3D -1)=0A=
+				//	return -3;=0A=
 				break;=0A=
 			}=0A=
 =0A=
@@ -377,9 +393,7 @@ static int llci_session_callback(void *a=0A=
 		break;=0A=
 =0A=
 	case S_SCALLBACK_REASON_CLOSE:=0A=
-		if (resource_id =3D=3D EN50221_APP_MMI_RESOURCEID) {=0A=
-			llci->stdcam.mmi_session_number =3D -1;=0A=
-		} else if (resource_id =3D=3D EN50221_APP_DATETIME_RESOURCEID) {=0A=
+		if (resource_id =3D=3D EN50221_APP_DATETIME_RESOURCEID) {=0A=
 			llci->datetime_session_number =3D -1;=0A=
 		} else if (resource_id =3D=3D EN50221_APP_AI_RESOURCEID) {=0A=
 			llci->stdcam.ai_session_number =3D -1;=0A=
@@ -438,7 +452,10 @@ static int llci_datetime_enquiry_callbac=0A=
 	if (response_interval) {=0A=
 		llci->datetime_next_send =3D time(NULL) + response_interval;=0A=
 	}=0A=
-	en50221_app_datetime_send(llci->datetime_resource, session_number, =
llci->datetime_dvbtime, 0);=0A=
+	if (llci->datetime_dvbtime>0)=0A=
+		en50221_app_datetime_send(llci->datetime_resource, session_number, =
llci->datetime_dvbtime, -1);=0A=
+	else=0A=
+		en50221_app_datetime_send(llci->datetime_resource, session_number, =
time(NULL), -1);=0A=
 =0A=
 	return 0;=0A=
 }=0A=

------=_NextPart_000_0090_01CBD9CB.B77D1ED0--

