Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:61605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880Ab0L0OSA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Dec 2010 09:18:00 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oBREHxNQ015634
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Mon, 27 Dec 2010 09:17:59 -0500
Received: from [10.11.11.201] (vpn-11-201.rdu.redhat.com [10.11.11.201])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id oBREHu66002719
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 27 Dec 2010 09:17:58 -0500
Message-ID: <4D18A00C.50509@redhat.com>
Date: Mon, 27 Dec 2010 12:17:48 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] feature_removal_schedule.txt: mark VIDIOC_*_OLD ioctls to
 die
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

There are some old broken definitions of ioctl's, where the
read/write arguments were marked wrong. The last one were added
on 2.6.6 kernel. Remove them, in order to cleanup some
copy_from_user/copy_to_user logic done inside V4L core.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index e348b7e..f2742e1 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -112,6 +112,27 @@ Who:	Mauro Carvalho Chehab <mchehab@infradead.org>
 
 ---------------------------
 
+What:	Video4Linux: Remove obsolete ioctl's
+When:	kernel 2.6.39
+Files:	include/media/videodev2.h
+Why:	Some ioctl's were defined wrong on 2.6.2 and 2.6.6, using the wrong
+	type of R/W arguments. They were fixed, but the old ioctl names are
+	still there, maintained to avoid breaking binary compatibility:
+	  #define VIDIOC_OVERLAY_OLD   	_IOWR('V', 14, int)
+	  #define VIDIOC_S_PARM_OLD	_IOW('V', 22, struct v4l2_streamparm)
+	  #define VIDIOC_S_CTRL_OLD	_IOW('V', 28, struct v4l2_control)
+	  #define VIDIOC_G_AUDIO_OLD	_IOWR('V', 33, struct v4l2_audio)
+	  #define VIDIOC_G_AUDOUT_OLD	_IOWR('V', 49, struct v4l2_audioout)
+	  #define VIDIOC_CROPCAP_OLD	_IOR('V', 58, struct v4l2_cropcap)
+	There's no sense on preserving those forever, as it is very doubtful
+	that someone would try to use a such old binary with a modern kernel.
+	Removing them will allow us to remove some magic done at the V4L ioctl
+	handler.
+
+Who:	Mauro Carvalho Chehab <mchehab@infradead.org>
+
+---------------------------
+
 What:	sys_sysctl
 When:	September 2010
 Option: CONFIG_SYSCTL_SYSCALL
