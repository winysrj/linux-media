Return-path: <linux-media-owner@vger.kernel.org>
Received: from cinke.fazekas.hu ([195.199.244.225]:41516 "EHLO
	cinke.fazekas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757274Ab0BXQcv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2010 11:32:51 -0500
Received: from localhost (localhost [127.0.0.1])
	by cinke.fazekas.hu (Postfix) with ESMTP id 5F6D42C215
	for <linux-media@vger.kernel.org>; Wed, 24 Feb 2010 17:24:28 +0100 (CET)
Received: from cinke.fazekas.hu ([127.0.0.1])
	by localhost (cinke.fazekas.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HrP7qAuVWAfs for <linux-media@vger.kernel.org>;
	Wed, 24 Feb 2010 17:24:28 +0100 (CET)
Received: from roadrunner.athome (cinke.fazekas.hu [195.199.244.225])
	by cinke.fazekas.hu (Postfix) with ESMTP id 456C32C0B5
	for <linux-media@vger.kernel.org>; Wed, 24 Feb 2010 17:24:28 +0100 (CET)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH] cx88: increase BUFFER_TIMEOUT to 2 seconds
Message-Id: <5013801372b14e3d1439.1267028616@roadrunner.athome>
Date: Wed, 24 Feb 2010 16:23:36 -0000
From: Marton Balint <cus@fazekas.hu>
To: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

# HG changeset patch
# User Marton Balint <cus@fazekas.hu>
# Date 1267027831 -3600
# Node ID 5013801372b14e3d143955c04108d450323eb2de
# Parent  2e0444bf93a4a93e5e9363d43e6f6e9d451fa9bc
cx88: increase BUFFER_TIMEOUT to 2 seconds

From: Marton Balint <cus@fazekas.hu>

When temporarily there is no video signal, sometimes it takes more than 0.5
secs for the cx88 chip to generate a single frame. If a dma timeout occurs
during recording, it confuses the recording application (at least mencoder) and
the recording stops. Since there is already an ifdefed-out 2 second buffer
timeout in the code, re-enabling that seemed the most simple solution.

Priority: normal

Signed-off-by: Marton Balint <cus@fazekas.hu>

diff -r 2e0444bf93a4 -r 5013801372b1 linux/drivers/media/video/cx88/cx88.h
--- a/linux/drivers/media/video/cx88/cx88.h	Mon Feb 22 10:58:43 2010 -0300
+++ b/linux/drivers/media/video/cx88/cx88.h	Wed Feb 24 17:10:31 2010 +0100
@@ -290,10 +290,7 @@
 #define RESOURCE_VIDEO         2
 #define RESOURCE_VBI           4
 
-#define BUFFER_TIMEOUT     msecs_to_jiffies(500)  /* 0.5 seconds */
-#if 0
 #define BUFFER_TIMEOUT     msecs_to_jiffies(2000)
-#endif
 
 /* buffer for one video frame */
 struct cx88_buffer {
