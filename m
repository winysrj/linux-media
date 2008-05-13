Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4D9LLDw027308
	for <video4linux-list@redhat.com>; Tue, 13 May 2008 05:21:21 -0400
Received: from mgw-mx03.nokia.com (smtp.nokia.com [192.100.122.230])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4D9LDAs013829
	for <video4linux-list@redhat.com>; Tue, 13 May 2008 05:21:13 -0400
Received: from esebh106.NOE.Nokia.com (esebh106.ntc.nokia.com [172.21.138.213])
	by mgw-mx03.nokia.com (Switch-3.2.6/Switch-3.2.6) with ESMTP id
	m4D9KobQ005892
	for <video4linux-list@redhat.com>; Tue, 13 May 2008 12:21:06 +0300
Received: from kaali.localdomain (kaali.localdomain [192.168.239.7])
	by maxwell.research.nokia.com (Postfix) with ESMTP id 214844674E
	for <video4linux-list@redhat.com>;
	Tue, 13 May 2008 12:21:06 +0300 (EEST)
Received: from sailus by kaali.localdomain with local (Exim 4.63)
	(envelope-from <sakari.ailus@nokia.com>) id 1Jvqh0-0006tC-11
	for video4linux-list@redhat.com; Tue, 13 May 2008 12:21:06 +0300
From: Sakari Ailus <sakari.ailus@nokia.com>
To: video4linux-list@redhat.com
Cc: 
Date: Tue, 13 May 2008 12:21:06 +0300
Message-Id: <12106704662247-git-send-email-sakari.ailus@nokia.com>
In-Reply-To: <48295D60.90504@nokia.com>
References: <48295D60.90504@nokia.com>
Subject: [PATCH] TCM825x: Include invertation of image mirroring in
	configuration
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Add invertation of image mirroring register bits to default
configuration.

This is useful when the camera module is e.g. mounted upside down.

Signed-off-by: Sakari Ailus <sakari.ailus@nokia.com>
---
 drivers/media/video/tcm825x.c |    6 ++++++
 drivers/media/video/tcm825x.h |    1 +
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/tcm825x.c b/drivers/media/video/tcm825x.c
index e57a646..216638e 100644
--- a/drivers/media/video/tcm825x.c
+++ b/drivers/media/video/tcm825x.c
@@ -523,6 +523,9 @@ static int ioctl_g_ctrl(struct v4l2_int_device *s,
 	if (val < 0)
 		return val;
 
+	if (vc->id == V4L2_CID_HFLIP || vc->id == V4L2_CID_VFLIP)
+		val ^= sensor->platform_data->is_upside_down();
+
 	vc->value = val;
 	return 0;
 }
@@ -556,6 +559,9 @@ static int ioctl_s_ctrl(struct v4l2_int_device *s,
 	if (lvc == NULL)
 		return -EINVAL;
 
+	if (vc->id == V4L2_CID_HFLIP || vc->id == V4L2_CID_VFLIP)
+		val ^= sensor->platform_data->is_upside_down();
+
 	val = val << lvc->start_bit;
 	if (tcm825x_write_reg_mask(client, lvc->reg, val))
 		return -EIO;
diff --git a/drivers/media/video/tcm825x.h b/drivers/media/video/tcm825x.h
index 966765b..770ebac 100644
--- a/drivers/media/video/tcm825x.h
+++ b/drivers/media/video/tcm825x.h
@@ -182,6 +182,7 @@ struct tcm825x_platform_data {
 	int (*needs_reset)(struct v4l2_int_device *s, void *buf,
 			   struct v4l2_pix_format *fmt);
 	int (*ifparm)(struct v4l2_ifparm *p);
+	int (*is_upside_down)(void);
 };
 
 /* Array of image sizes supported by TCM825X.  These must be ordered from
-- 
1.5.0.6

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
