Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:57570
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751386AbdIELE1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 5 Sep 2017 07:04:27 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 2/2] media: dvb headers: make checkpatch happier
Date: Tue,  5 Sep 2017 08:04:21 -0300
Message-Id: <f406ad5579dd00b0d28fd4dcd149865f1cdb0282.1504609455.git.mchehab@s-opensource.com>
In-Reply-To: <ebc93052aeadd7b931371c293f62074b1dba7265.1504609454.git.mchehab@s-opensource.com>
References: <ebc93052aeadd7b931371c293f62074b1dba7265.1504609454.git.mchehab@s-opensource.com>
In-Reply-To: <ebc93052aeadd7b931371c293f62074b1dba7265.1504609454.git.mchehab@s-opensource.com>
References: <ebc93052aeadd7b931371c293f62074b1dba7265.1504609454.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adjust dvb ca.h, dmx.h and frontend.h in order to make
checkpatch happier. Now, it only complains about the typedefs,
and those are there just to provide backward userspace
compatibility.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 include/uapi/linux/dvb/ca.h       | 2 +-
 include/uapi/linux/dvb/dmx.h      | 5 ++---
 include/uapi/linux/dvb/frontend.h | 6 +++---
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/dvb/ca.h b/include/uapi/linux/dvb/ca.h
index 24fc38efbc2b..cb150029fdff 100644
--- a/include/uapi/linux/dvb/ca.h
+++ b/include/uapi/linux/dvb/ca.h
@@ -139,7 +139,7 @@ struct ca_descr {
 #define CA_SEND_MSG       _IOW('o', 133, struct ca_msg)
 #define CA_SET_DESCR      _IOW('o', 134, struct ca_descr)
 
-#if !defined (__KERNEL__)
+#if !defined(__KERNEL__)
 
 /* This is needed for legacy userspace support */
 typedef struct ca_slot_info ca_slot_info_t;
diff --git a/include/uapi/linux/dvb/dmx.h b/include/uapi/linux/dvb/dmx.h
index 4e3f3a2fe83f..4aa5f6a1815a 100644
--- a/include/uapi/linux/dvb/dmx.h
+++ b/include/uapi/linux/dvb/dmx.h
@@ -189,8 +189,7 @@ struct dmx_sct_filter_params {
  * @pes_type:	Type of the pes filter, as specified by &enum dmx_pes_type.
  * @flags:	Demux PES flags.
  */
-struct dmx_pes_filter_params
-{
+struct dmx_pes_filter_params {
 	__u16           pid;
 	enum dmx_input  input;
 	enum dmx_output output;
@@ -221,7 +220,7 @@ struct dmx_stc {
 #define DMX_ADD_PID              _IOW('o', 51, __u16)
 #define DMX_REMOVE_PID           _IOW('o', 52, __u16)
 
-#if !defined (__KERNEL__)
+#if !defined(__KERNEL__)
 
 /* This is needed for legacy userspace support */
 typedef enum dmx_output dmx_output_t;
diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index fc2edb6014fe..861cacd5711f 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -907,7 +907,7 @@ struct dtv_properties {
 #define FE_SET_PROPERTY		   _IOW('o', 82, struct dtv_properties)
 #define FE_GET_PROPERTY		   _IOR('o', 83, struct dtv_properties)
 
-#if defined(__DVB_CORE__) || !defined (__KERNEL__)
+#if defined(__DVB_CORE__) || !defined(__KERNEL__)
 
 /*
  * DEPRECATED: Everything below is deprecated in favor of DVBv5 API
@@ -982,8 +982,8 @@ struct dvb_ofdm_parameters {
 };
 
 struct dvb_frontend_parameters {
-	__u32 frequency;     /* (absolute) frequency in Hz for DVB-C/DVB-T/ATSC */
-			     /* intermediate frequency in kHz for DVB-S */
+	__u32 frequency;  /* (absolute) frequency in Hz for DVB-C/DVB-T/ATSC */
+			  /* intermediate frequency in kHz for DVB-S */
 	fe_spectral_inversion_t inversion;
 	union {
 		struct dvb_qpsk_parameters qpsk;	/* DVB-S */
-- 
2.13.5
