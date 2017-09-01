Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:47019
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752159AbdIANZI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 09:25:08 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH v2 01/27] media: ca.h: split typedefs from structs
Date: Fri,  1 Sep 2017 10:24:23 -0300
Message-Id: <d6e55961dd31efb29e38f2a7846f11ca378e9b27.1504272067.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504272067.git.mchehab@s-opensource.com>
References: <cover.1504272067.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1504272067.git.mchehab@s-opensource.com>
References: <cover.1504272067.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using typedefs inside the Kernel is against CodingStyle, and
there's no good usage here.

Just like we did at frontend.h, at changeset 0df289a209e0
("[media] dvb: Get rid of typedev usage for enums"), let's keep
those typedefs only to provide userspace backward compatibility.

No functional changes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/ttpci/av7110.h    |  2 +-
 drivers/media/pci/ttpci/av7110_ca.c | 12 ++++-----
 include/uapi/linux/dvb/ca.h         | 51 +++++++++++++++++++++++--------------
 3 files changed, 39 insertions(+), 26 deletions(-)

diff --git a/drivers/media/pci/ttpci/av7110.h b/drivers/media/pci/ttpci/av7110.h
index 824c1e262fbb..347827925c14 100644
--- a/drivers/media/pci/ttpci/av7110.h
+++ b/drivers/media/pci/ttpci/av7110.h
@@ -177,7 +177,7 @@ struct av7110 {
 
 	/* CA */
 
-	ca_slot_info_t		ci_slot[2];
+	struct ca_slot_info	ci_slot[2];
 
 	enum av7110_video_mode	vidmode;
 	struct dmxdev		dmxdev;
diff --git a/drivers/media/pci/ttpci/av7110_ca.c b/drivers/media/pci/ttpci/av7110_ca.c
index f64723aea56b..1fe49171d823 100644
--- a/drivers/media/pci/ttpci/av7110_ca.c
+++ b/drivers/media/pci/ttpci/av7110_ca.c
@@ -119,7 +119,7 @@ static void ci_ll_release(struct dvb_ringbuffer *cirbuf, struct dvb_ringbuffer *
 }
 
 static int ci_ll_reset(struct dvb_ringbuffer *cibuf, struct file *file,
-		       int slots, ca_slot_info_t *slot)
+		       int slots, struct ca_slot_info *slot)
 {
 	int i;
 	int len = 0;
@@ -264,7 +264,7 @@ static int dvb_ca_ioctl(struct file *file, unsigned int cmd, void *parg)
 		break;
 	case CA_GET_CAP:
 	{
-		ca_caps_t cap;
+		struct ca_caps cap;
 
 		cap.slot_num = 2;
 		cap.slot_type = (FW_CI_LL_SUPPORT(av7110->arm_app) ?
@@ -277,7 +277,7 @@ static int dvb_ca_ioctl(struct file *file, unsigned int cmd, void *parg)
 
 	case CA_GET_SLOT_INFO:
 	{
-		ca_slot_info_t *info=(ca_slot_info_t *)parg;
+		struct ca_slot_info *info=(struct ca_slot_info *)parg;
 
 		if (info->num < 0 || info->num > 1) {
 			mutex_unlock(&av7110->ioctl_mutex);
@@ -286,7 +286,7 @@ static int dvb_ca_ioctl(struct file *file, unsigned int cmd, void *parg)
 		av7110->ci_slot[info->num].num = info->num;
 		av7110->ci_slot[info->num].type = FW_CI_LL_SUPPORT(av7110->arm_app) ?
 							CA_CI_LINK : CA_CI;
-		memcpy(info, &av7110->ci_slot[info->num], sizeof(ca_slot_info_t));
+		memcpy(info, &av7110->ci_slot[info->num], sizeof(struct ca_slot_info));
 		break;
 	}
 
@@ -298,7 +298,7 @@ static int dvb_ca_ioctl(struct file *file, unsigned int cmd, void *parg)
 
 	case CA_GET_DESCR_INFO:
 	{
-		ca_descr_info_t info;
+		struct ca_descr_info info;
 
 		info.num = 16;
 		info.type = CA_ECD;
@@ -308,7 +308,7 @@ static int dvb_ca_ioctl(struct file *file, unsigned int cmd, void *parg)
 
 	case CA_SET_DESCR:
 	{
-		ca_descr_t *descr = (ca_descr_t*) parg;
+		struct ca_descr *descr = (struct ca_descr*) parg;
 
 		if (descr->index >= 16 || descr->parity > 1) {
 			mutex_unlock(&av7110->ioctl_mutex);
diff --git a/include/uapi/linux/dvb/ca.h b/include/uapi/linux/dvb/ca.h
index c18537f3e449..00cf24587bea 100644
--- a/include/uapi/linux/dvb/ca.h
+++ b/include/uapi/linux/dvb/ca.h
@@ -26,7 +26,7 @@
 
 /* slot interface types and info */
 
-typedef struct ca_slot_info {
+struct ca_slot_info {
 	int num;               /* slot number */
 
 	int type;              /* CA interface this slot supports */
@@ -39,52 +39,65 @@ typedef struct ca_slot_info {
 	unsigned int flags;
 #define CA_CI_MODULE_PRESENT 1 /* module (or card) inserted */
 #define CA_CI_MODULE_READY   2
-} ca_slot_info_t;
+};
 
 
 /* descrambler types and info */
 
-typedef struct ca_descr_info {
+struct ca_descr_info {
 	unsigned int num;          /* number of available descramblers (keys) */
 	unsigned int type;         /* type of supported scrambling system */
 #define CA_ECD           1
 #define CA_NDS           2
 #define CA_DSS           4
-} ca_descr_info_t;
+};
 
-typedef struct ca_caps {
+struct ca_caps {
 	unsigned int slot_num;     /* total number of CA card and module slots */
 	unsigned int slot_type;    /* OR of all supported types */
 	unsigned int descr_num;    /* total number of descrambler slots (keys) */
 	unsigned int descr_type;   /* OR of all supported types */
-} ca_caps_t;
+};
 
 /* a message to/from a CI-CAM */
-typedef struct ca_msg {
+struct ca_msg {
 	unsigned int index;
 	unsigned int type;
 	unsigned int length;
 	unsigned char msg[256];
-} ca_msg_t;
+};
 
-typedef struct ca_descr {
+struct ca_descr {
 	unsigned int index;
 	unsigned int parity;	/* 0 == even, 1 == odd */
 	unsigned char cw[8];
-} ca_descr_t;
+};
 
-typedef struct ca_pid {
+struct ca_pid {
 	unsigned int pid;
 	int index;		/* -1 == disable*/
-} ca_pid_t;
+};
 
 #define CA_RESET          _IO('o', 128)
-#define CA_GET_CAP        _IOR('o', 129, ca_caps_t)
-#define CA_GET_SLOT_INFO  _IOR('o', 130, ca_slot_info_t)
-#define CA_GET_DESCR_INFO _IOR('o', 131, ca_descr_info_t)
-#define CA_GET_MSG        _IOR('o', 132, ca_msg_t)
-#define CA_SEND_MSG       _IOW('o', 133, ca_msg_t)
-#define CA_SET_DESCR      _IOW('o', 134, ca_descr_t)
-#define CA_SET_PID        _IOW('o', 135, ca_pid_t)
+#define CA_GET_CAP        _IOR('o', 129, struct ca_caps)
+#define CA_GET_SLOT_INFO  _IOR('o', 130, struct ca_slot_info)
+#define CA_GET_DESCR_INFO _IOR('o', 131, struct ca_descr_info)
+#define CA_GET_MSG        _IOR('o', 132, struct ca_msg)
+#define CA_SEND_MSG       _IOW('o', 133, struct ca_msg)
+#define CA_SET_DESCR      _IOW('o', 134, struct ca_descr)
+#define CA_SET_PID        _IOW('o', 135, struct ca_pid)
+
+#if !defined (__KERNEL__)
+
+/* This is needed for legacy userspace support */
+typedef struct ca_slot_info ca_slot_info_t;
+typedef struct ca_descr_info  ca_descr_info_t;
+typedef struct ca_caps  ca_caps_t;
+typedef struct ca_msg ca_msg_t;
+typedef struct ca_descr ca_descr_t;
+typedef struct ca_pid ca_pid_t;
+
+#endif
+
 
 #endif
-- 
2.13.5
