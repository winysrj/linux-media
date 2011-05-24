Return-path: <mchehab@pedra>
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:43942 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab1EXVqV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2011 17:46:21 -0400
Received: from mfilter8-d.gandi.net (mfilter8-d.gandi.net [217.70.178.137])
	by relay4-d.mail.gandi.net (Postfix) with ESMTP id 0519C172080
	for <linux-media@vger.kernel.org>; Tue, 24 May 2011 23:46:20 +0200 (CEST)
Received: from relay4-d.mail.gandi.net ([217.70.183.196])
	by mfilter8-d.gandi.net (mfilter8-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id PNN5iYOzVfo8 for <linux-media@vger.kernel.org>;
	Tue, 24 May 2011 23:46:18 +0200 (CEST)
Received: from WIN7PC (ALyon-157-1-201-218.w109-213.abo.wanadoo.fr [109.213.176.218])
	(Authenticated sender: sr@coexsi.fr)
	by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 984A0172077
	for <linux-media@vger.kernel.org>; Tue, 24 May 2011 23:46:17 +0200 (CEST)
From: =?iso-8859-1?Q?S=E9bastien_RAILLARD_=28COEXSI=29?= <sr@coexsi.fr>
To: "'Linux Media Mailing List'" <linux-media@vger.kernel.org>
References: <008f01cbd9c3$55b81a90$01284fb0$@coexsi.fr>
In-Reply-To: <008f01cbd9c3$55b81a90$01284fb0$@coexsi.fr>
Subject: RE: [PATCH] DVB-APPS : correct some issues in libdvben50221
Date: Tue, 24 May 2011 23:46:31 +0200
Message-ID: <007801cc1a5c$0c13f650$243be2f0$@coexsi.fr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Language: fr
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>



> -----Original Message-----
> From: linux-media-owner@vger.kernel.org [mailto:linux-media-
> owner@vger.kernel.org] On Behalf Of Sébastien RAILLARD (COEXSI)
> Sent: jeudi 3 mars 2011 17:52
> To: Linux Media Mailing List
> Subject: [PATCH] DVB-APPS : correct some issues in libdvben50221
> 
> Dear all,
> 
> Here are two patches against the latest version of libdvben50221 in the
> hg repository.
> 
> Details of corrections:
> -----------------------
> 
> * In "en50221_sl_handle_close_session_response", the expected data
> length wasn't good, the "close_session_response" object is 3 bytes long,
> not 4 bytes long (see the specification)
> 
> * The "LLCI_RESPONSE_TIMEOUT_MS" has been increased from 1000ms to
> 10000ms in order to wait for long/complex MMI operations. The timeout
> work at TPDU 2nd level and not at LPDU 1st level of communication stack.
> 
> * In "en50221_stdcam_llci_destroy", all data from the CA device are read
> before closing the device. This prevent from keeping the last poll reply
> in the dvb_core module ringbuffer. The polling function used to keep
> contact with the CAM is first reading data then writing data, so there
> is always a reply left in the buffer.
> 
> * In "llci_lookup_callback", some tests permitting resource usage limit
> are disabled as they are not working correctly. When a new session is
> created, it is declared. But when a session is closed, this isn't
> declared so a new session can't be opened a second time.
> 
> * In "llci_session_callback", a test was removed as it was duplicated.
> 
> * In "en50221_stdcam_llci_poll" and "llci_datetime_enquiry_callback", if
> the function "en50221_stdcam_llci_dvbtime" isn't called regularly, a
> wrong date/time is send to the CAM. So, if the time wasn't supplied, we
> send the UTC time from the system. Also, the "time_offset" parameter of
> the called function "en50221_app_datetime_send" has been set to -1 as we
> don't have the "local_offset" information and as this information is
> optional (see the specification).
> 
> Best regards,
> Sebastien RAILLARD.

This is a patch re-submission with the correct format in order to get catch
in patchwork:

Signed-off-by: Sebastien RAILLARD <sr@coexsi.fr>

diff -r 1f246cbf8104 -r abf3b2af3520 lib/libdvben50221/en50221_session.c
--- a/lib/libdvben50221/en50221_session.c       Mon Jan 31 14:47:32 2011
+0100
+++ b/lib/libdvben50221/en50221_session.c       Tue May 24 23:28:53 2011
+0200
@@ -715,13 +715,13 @@
                                                     uint8_t connection_id)
 {
        // check
-       if (data_length < 5) {
+       if (data_length < 4) {
                print(LOG_LEVEL, ERROR, 1,
                      "Received data with invalid length from module on slot
%02x\n",
                      slot_id);
                return;
        }
-       if (data[0] != 4) {
+       if (data[0] != 3) {
                print(LOG_LEVEL, ERROR, 1,
                      "Received data with invalid length from module on slot
%02x\n",
                      slot_id);
diff -r 1f246cbf8104 -r abf3b2af3520 lib/libdvben50221/en50221_stdcam_llci.c
--- a/lib/libdvben50221/en50221_stdcam_llci.c   Mon Jan 31 14:47:32 2011
+0100
+++ b/lib/libdvben50221/en50221_stdcam_llci.c   Tue May 24 23:28:53 2011
+0200
@@ -32,7 +32,7 @@
 #include "en50221_app_tags.h"
 #include "en50221_stdcam.h"

-#define LLCI_RESPONSE_TIMEOUT_MS 1000
+#define LLCI_RESPONSE_TIMEOUT_MS 10*1000
 #define LLCI_POLL_DELAY_MS 100

 /* resource IDs we support */
@@ -207,7 +207,16 @@
                en50221_app_mmi_destroy(llci->stdcam.mmi_resource);

        if (closefd)
+       {
+               // Read the buffer before closing the device to remove the
last polling answer
+               uint8_t r_slot_id;
+               uint8_t connection_id;
+               uint8_t data[4096];
+               dvbca_link_read(llci->cafd, &r_slot_id,
+                       &connection_id,
+                       data, sizeof(data));
                close(llci->cafd);
+       }

        free(llci);
 }
@@ -243,9 +252,14 @@
        if (llci->datetime_session_number != -1) {
                time_t cur_time = time(NULL);
                if (llci->datetime_response_interval && (cur_time >
llci->datetime_next_send)) {
-                       en50221_app_datetime_send(llci->datetime_resource,
-
llci->datetime_session_number,
-                                               llci->datetime_dvbtime, 0);
+                       if (llci->datetime_dvbtime>0)
+
en50221_app_datetime_send(llci->datetime_resource,
+
llci->datetime_session_number,
+
llci->datetime_dvbtime, -1);
+                       else
+
en50221_app_datetime_send(llci->datetime_resource,
+
llci->datetime_session_number,
+                                                       time(NULL), -1);
                        llci->datetime_next_send = cur_time +
llci->datetime_response_interval;
                }
        }
@@ -334,12 +348,14 @@
                                        return -3;
                                break;
                        case EN50221_APP_CA_RESOURCEID:
-                               if (llci->stdcam.ca_session_number != -1)
-                                       return -3;
+                               // As ressources are declared when used but
not when released, limiting session is buggy...
+                               // if (llci->stdcam.ca_session_number != -1)
+                               //      return -3;
                                break;
                        case EN50221_APP_MMI_RESOURCEID:
-                               if (llci->stdcam.mmi_session_number != -1)
-                                       return -3;
+                               // As ressources are declared when used but
not when released, limiting session is buggy...
+                               // if (llci->stdcam.mmi_session_number !=
-1)
+                               //      return -3;
                                break;
                        }

@@ -377,9 +393,7 @@
                break;

        case S_SCALLBACK_REASON_CLOSE:
-               if (resource_id == EN50221_APP_MMI_RESOURCEID) {
-                       llci->stdcam.mmi_session_number = -1;
-               } else if (resource_id == EN50221_APP_DATETIME_RESOURCEID) {
+               if (resource_id == EN50221_APP_DATETIME_RESOURCEID) {
                        llci->datetime_session_number = -1;
                } else if (resource_id == EN50221_APP_AI_RESOURCEID) {
                        llci->stdcam.ai_session_number = -1;
@@ -438,7 +452,10 @@
        if (response_interval) {
                llci->datetime_next_send = time(NULL) + response_interval;
        }
-       en50221_app_datetime_send(llci->datetime_resource, session_number,
llci->datetime_dvbtime, 0);
+       if (llci->datetime_dvbtime>0)
+               en50221_app_datetime_send(llci->datetime_resource,
session_number, llci->datetime_dvbtime, -1);
+       else
+               en50221_app_datetime_send(llci->datetime_resource,
session_number, time(NULL), -1);

        return 0;
 }
root@video-showroom-1:/usr/src-coexsi/dvb-apps.20110303# man hg
root@video-showroom-1:/usr/src-coexsi/dvb-apps.20110303# hg export
1415:abf3b2af3520 --git
# HG changeset patch
# User Sebastien RAILLARD <sr@coexsi.fr>
# Date 1306272533 -7200
# Node ID abf3b2af35200cd2f1e50a2746a7bab7eac4027e
# Parent  1f246cbf810416eab545824b7f9448b693e19dcc
correct some issues in libdvben50221

diff --git a/lib/libdvben50221/en50221_session.c
b/lib/libdvben50221/en50221_session.c
--- a/lib/libdvben50221/en50221_session.c
+++ b/lib/libdvben50221/en50221_session.c
@@ -715,13 +715,13 @@
                                                     uint8_t connection_id)
 {
        // check
-       if (data_length < 5) {
+       if (data_length < 4) {
                print(LOG_LEVEL, ERROR, 1,
                      "Received data with invalid length from module on slot
%02x\n",
                      slot_id);
                return;
        }
-       if (data[0] != 4) {
+       if (data[0] != 3) {
                print(LOG_LEVEL, ERROR, 1,
                      "Received data with invalid length from module on slot
%02x\n",
                      slot_id);
diff --git a/lib/libdvben50221/en50221_stdcam_llci.c
b/lib/libdvben50221/en50221_stdcam_llci.c
--- a/lib/libdvben50221/en50221_stdcam_llci.c
+++ b/lib/libdvben50221/en50221_stdcam_llci.c
@@ -32,7 +32,7 @@
 #include "en50221_app_tags.h"
 #include "en50221_stdcam.h"

-#define LLCI_RESPONSE_TIMEOUT_MS 1000
+#define LLCI_RESPONSE_TIMEOUT_MS 10*1000
 #define LLCI_POLL_DELAY_MS 100

 /* resource IDs we support */
@@ -207,7 +207,16 @@
                en50221_app_mmi_destroy(llci->stdcam.mmi_resource);

        if (closefd)
+       {
+               // Read the buffer before closing the device to remove the
last polling answer
+               uint8_t r_slot_id;
+               uint8_t connection_id;
+               uint8_t data[4096];
+               dvbca_link_read(llci->cafd, &r_slot_id,
+                       &connection_id,
+                       data, sizeof(data));
                close(llci->cafd);
+       }

        free(llci);
 }
@@ -243,9 +252,14 @@
        if (llci->datetime_session_number != -1) {
                time_t cur_time = time(NULL);
                if (llci->datetime_response_interval && (cur_time >
llci->datetime_next_send)) {
-                       en50221_app_datetime_send(llci->datetime_resource,
-
llci->datetime_session_number,
-                                               llci->datetime_dvbtime, 0);
+                       if (llci->datetime_dvbtime>0)
+
en50221_app_datetime_send(llci->datetime_resource,
+
llci->datetime_session_number,
+
llci->datetime_dvbtime, -1);
+                       else
+
en50221_app_datetime_send(llci->datetime_resource,
+
llci->datetime_session_number,
+                                                       time(NULL), -1);
                        llci->datetime_next_send = cur_time +
llci->datetime_response_interval;
                }
        }
@@ -334,12 +348,14 @@
                                        return -3;
                                break;
                        case EN50221_APP_CA_RESOURCEID:
-                               if (llci->stdcam.ca_session_number != -1)
-                                       return -3;
+                               // As ressources are declared when used but
not when released, limiting session is buggy...
+                               // if (llci->stdcam.ca_session_number != -1)
+                               //      return -3;
                                break;
                        case EN50221_APP_MMI_RESOURCEID:
-                               if (llci->stdcam.mmi_session_number != -1)
-                                       return -3;
+                               // As ressources are declared when used but
not when released, limiting session is buggy...
+                               // if (llci->stdcam.mmi_session_number !=
-1)
+                               //      return -3;
                                break;
                        }

@@ -377,9 +393,7 @@
                break;

        case S_SCALLBACK_REASON_CLOSE:
-               if (resource_id == EN50221_APP_MMI_RESOURCEID) {
-                       llci->stdcam.mmi_session_number = -1;
-               } else if (resource_id == EN50221_APP_DATETIME_RESOURCEID) {
+               if (resource_id == EN50221_APP_DATETIME_RESOURCEID) {
                        llci->datetime_session_number = -1;
                } else if (resource_id == EN50221_APP_AI_RESOURCEID) {
                        llci->stdcam.ai_session_number = -1;
@@ -438,7 +452,10 @@
        if (response_interval) {
                llci->datetime_next_send = time(NULL) + response_interval;
        }
-       en50221_app_datetime_send(llci->datetime_resource, session_number,
llci->datetime_dvbtime, 0);
+       if (llci->datetime_dvbtime>0)
+               en50221_app_datetime_send(llci->datetime_resource,
session_number, llci->datetime_dvbtime, -1);
+       else
+               en50221_app_datetime_send(llci->datetime_resource,
session_number, time(NULL), -1);

        return 0;
 }
root@video-showroom-1:/usr/src-coexsi/dvb-apps.20110303#
root@video-showroom-1:/usr/src-coexsi/dvb-apps.20110303# hg export --git
1415:abf3b2af3520
# HG changeset patch
# User Sebastien RAILLARD <sr@coexsi.fr>
# Date 1306272533 -7200
# Node ID abf3b2af35200cd2f1e50a2746a7bab7eac4027e
# Parent  1f246cbf810416eab545824b7f9448b693e19dcc
correct some issues in libdvben50221

diff --git a/lib/libdvben50221/en50221_session.c
b/lib/libdvben50221/en50221_session.c
--- a/lib/libdvben50221/en50221_session.c
+++ b/lib/libdvben50221/en50221_session.c
@@ -715,13 +715,13 @@
                                                     uint8_t connection_id)
 {
        // check
-       if (data_length < 5) {
+       if (data_length < 4) {
                print(LOG_LEVEL, ERROR, 1,
                      "Received data with invalid length from module on slot
%02x\n",
                      slot_id);
                return;
        }
-       if (data[0] != 4) {
+       if (data[0] != 3) {
                print(LOG_LEVEL, ERROR, 1,
                      "Received data with invalid length from module on slot
%02x\n",
                      slot_id);
diff --git a/lib/libdvben50221/en50221_stdcam_llci.c
b/lib/libdvben50221/en50221_stdcam_llci.c
--- a/lib/libdvben50221/en50221_stdcam_llci.c
+++ b/lib/libdvben50221/en50221_stdcam_llci.c
@@ -32,7 +32,7 @@
 #include "en50221_app_tags.h"
 #include "en50221_stdcam.h"

-#define LLCI_RESPONSE_TIMEOUT_MS 1000
+#define LLCI_RESPONSE_TIMEOUT_MS 10*1000
 #define LLCI_POLL_DELAY_MS 100

 /* resource IDs we support */
@@ -207,7 +207,16 @@
                en50221_app_mmi_destroy(llci->stdcam.mmi_resource);

        if (closefd)
+       {
+               // Read the buffer before closing the device to remove the
last polling answer
+               uint8_t r_slot_id;
+               uint8_t connection_id;
+               uint8_t data[4096];
+               dvbca_link_read(llci->cafd, &r_slot_id,
+                       &connection_id,
+                       data, sizeof(data));
                close(llci->cafd);
+       }

        free(llci);
 }
@@ -243,9 +252,14 @@
        if (llci->datetime_session_number != -1) {
                time_t cur_time = time(NULL);
                if (llci->datetime_response_interval && (cur_time >
llci->datetime_next_send)) {
-                       en50221_app_datetime_send(llci->datetime_resource,
-
llci->datetime_session_number,
-                                               llci->datetime_dvbtime, 0);
+                       if (llci->datetime_dvbtime>0)
+
en50221_app_datetime_send(llci->datetime_resource,
+
llci->datetime_session_number,
+
llci->datetime_dvbtime, -1);
+                       else
+
en50221_app_datetime_send(llci->datetime_resource,
+
llci->datetime_session_number,
+                                                       time(NULL), -1);
                        llci->datetime_next_send = cur_time +
llci->datetime_response_interval;
                }
        }
@@ -334,12 +348,14 @@
                                        return -3;
                                break;
                        case EN50221_APP_CA_RESOURCEID:
-                               if (llci->stdcam.ca_session_number != -1)
-                                       return -3;
+                               // As ressources are declared when used but
not when released, limiting session is buggy...
+                               // if (llci->stdcam.ca_session_number != -1)
+                               //      return -3;
                                break;
                        case EN50221_APP_MMI_RESOURCEID:
-                               if (llci->stdcam.mmi_session_number != -1)
-                                       return -3;
+                               // As ressources are declared when used but
not when released, limiting session is buggy...
+                               // if (llci->stdcam.mmi_session_number !=
-1)
+                               //      return -3;
                                break;
                        }

@@ -377,9 +393,7 @@
                break;

        case S_SCALLBACK_REASON_CLOSE:
-               if (resource_id == EN50221_APP_MMI_RESOURCEID) {
-                       llci->stdcam.mmi_session_number = -1;
-               } else if (resource_id == EN50221_APP_DATETIME_RESOURCEID) {
+               if (resource_id == EN50221_APP_DATETIME_RESOURCEID) {
                        llci->datetime_session_number = -1;
                } else if (resource_id == EN50221_APP_AI_RESOURCEID) {
                        llci->stdcam.ai_session_number = -1;
@@ -438,7 +452,10 @@
        if (response_interval) {
                llci->datetime_next_send = time(NULL) + response_interval;
        }
-       en50221_app_datetime_send(llci->datetime_resource, session_number,
llci->datetime_dvbtime, 0);
+       if (llci->datetime_dvbtime>0)
+               en50221_app_datetime_send(llci->datetime_resource,
session_number, llci->datetime_dvbtime, -1);
+       else
+               en50221_app_datetime_send(llci->datetime_resource,
session_number, time(NULL), -1);

        return 0;
 }
--




