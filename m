Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9FAJkod006264
	for <video4linux-list@redhat.com>; Wed, 15 Oct 2008 06:19:46 -0400
Received: from rn-out-0910.google.com (rn-out-0910.google.com [64.233.170.186])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9FAJYK3003883
	for <video4linux-list@redhat.com>; Wed, 15 Oct 2008 06:19:34 -0400
Received: by rn-out-0910.google.com with SMTP id k32so1273804rnd.7
	for <video4linux-list@redhat.com>; Wed, 15 Oct 2008 03:19:34 -0700 (PDT)
From: Magnus Damm <magnus.damm@gmail.com>
To: video4linux-list@redhat.com
Date: Wed, 15 Oct 2008 19:18:24 +0900
Message-Id: <20081015101824.23072.11963.sendpatchset@rx1.opensource.se>
Cc: v4l-dvb-maintainer@linuxtv.org, g.liakhovetski@gmx.de,
	mchehab@infradead.org
Subject: [PATCH] video: add header to soc_camera_platform include file
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

From: Magnus Damm <damm@igel.co.jp>

Update the soc_camera_platform header with licensing information.

Signed-off-by: Magnus Damm <damm@igel.co.jp>
---

 include/media/soc_camera_platform.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- 0002/include/media/soc_camera_platform.h
+++ work/include/media/soc_camera_platform.h	2008-10-15 18:35:33.000000000 +0900
@@ -1,3 +1,13 @@
+/*
+ * Generic Platform Camera Driver Header
+ *
+ * Copyright (C) 2008 Magnus Damm
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #ifndef __SOC_CAMERA_H__
 #define __SOC_CAMERA_H__
 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
