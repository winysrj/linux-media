Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m89HHlTl012705
	for <video4linux-list@redhat.com>; Tue, 9 Sep 2008 13:17:48 -0400
Received: from mail11a.verio-web.com (mail11a.verio-web.com [204.202.242.23])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m89HGcE5003571
	for <video4linux-list@redhat.com>; Tue, 9 Sep 2008 13:16:38 -0400
Received: from mx22.stngva01.us.mxservers.net (204.202.242.39)
	by mail11a.verio-web.com (RS ver 1.0.95vs) with SMTP id 3-0725814198
	for <video4linux-list@redhat.com>; Tue,  9 Sep 2008 11:29:58 -0400 (EDT)
Date: Tue, 9 Sep 2008 08:29:56 -0700 (PDT)
From: "Dean A." <dean@sensoray.com>
To: mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org,
	video4linux-list@redhat.com
Message-ID: <tkrat.c89a311b7d53c0ac@sensoray.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Cc: dean@sensoray.com
Subject: [PATCH] s2255drv field count fix
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

From: Dean Anderson <dean@sensoray.com>

Fixes videobuf field_count

Signed-off-by: Dean Anderson <dean@sensoray.com>
---
Note: Please review the vivi driver. Using buf->vb.field_count++ in vivi
may be incorrect if there are multiple buffers.


--- /usr/src/v4l-dvb-ff052010c4cb/linux/drivers/media/video/s2255drv.c.orig	2008-09-09 08:08:01.000000000 -0700
+++ /usr/src/v4l-dvb-ff052010c4cb/linux/drivers/media/video/s2255drv.c	2008-09-09 08:08:50.000000000 -0700
@@ -687,7 +687,7 @@ static void s2255_fillbuff(struct s2255_
 		(unsigned long)vbuf, pos);
 	/* tell v4l buffer was filled */
 
-	buf->vb.field_count++;
+	buf->vb.field_count = dev->frame_count[chn] * 2;
 	do_gettimeofday(&ts);
 	buf->vb.ts = ts;
 	buf->vb.state = VIDEOBUF_DONE;
@@ -1304,6 +1304,7 @@ static int vidioc_streamon(struct file *
 	dev->last_frame[chn] = -1;
 	dev->bad_payload[chn] = 0;
 	dev->cur_frame[chn] = 0;
+	dev->frame_count[chn] = 0;
 	for (j = 0; j < SYS_FRAMES; j++) {
 		dev->buffer[chn].frame[j].ulState = S2255_READ_IDLE;
 		dev->buffer[chn].frame[j].cur_size = 0;

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
