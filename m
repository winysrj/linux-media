Return-path: <linux-media-owner@vger.kernel.org>
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:58937 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756200AbZINWN1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2009 18:13:27 -0400
Date: Tue, 15 Sep 2009 00:13:29 +0200
From: Andreas Mohr <andi@lisas.de>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Luca Risolia <luca.risolia@studio.unibo.it>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: V4L2 drivers: potentially dangerous and inefficient
	msecs_to_jiffies() calculation
Message-ID: <20090914221328.GA18867@rhlx01.hs-esslingen.de>
References: <20090914210741.GA16799@rhlx01.hs-esslingen.de> <4AAEB6F0.4080706@gmail.com> <20090914213933.GA5468@rhlx01.hs-esslingen.de> <4AAEBABA.9060108@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AAEBABA.9060108@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 14, 2009 at 11:50:50PM +0200, Jiri Slaby wrote:
> A potential problem here is rather that it may wait longer due to
> returning 1 jiffie. It's then timeout * 1000 * 1. On 250HZ system it
> makes a difference of multiple of 4. Don't think it's a real issue in
> those drivers at all, but it's worth fixing. Care to post a patch?

*sigh*. :) OK, last thing to be done this day.

Generated via precise copy&paste of the change between drivers
(which is a flashing warning that they likely contain too much c&p anyway),
plus:
for file in sn9c102/sn9c102_core.c et61x251/et61x251_core.c zc0301/zc0301_core.c; do diff -upN
linux-2.6.31/drivers/media/video/"$file" linux-2.6.31.patched/drivers/media/video/"$file" >>
/tmp/v4l2_drivers.diff; done

Disclaimer: FULLY UNTESTED, make sure to guard your hen house, use as dog food.

ChangeLog:
Correct dangerous and inefficient msecs_to_jiffies() calculation in some V4L2 drivers

Signed-off-by: Andreas Mohr <andi@lisas.de>

--- linux-2.6.31/drivers/media/video/sn9c102/sn9c102_core.c	2009-09-10 00:13:59.000000000 +0200
+++ linux-2.6.31.patched/drivers/media/video/sn9c102/sn9c102_core.c	2009-09-14 23:58:27.000000000 +0200
@@ -1954,8 +1954,10 @@ sn9c102_read(struct file* filp, char __u
 				    (!list_empty(&cam->outqueue)) ||
 				    (cam->state & DEV_DISCONNECTED) ||
 				    (cam->state & DEV_MISCONFIGURED),
-				    cam->module_param.frame_timeout *
-				    1000 * msecs_to_jiffies(1) );
+				    msecs_to_jiffies(
+					cam->module_param.frame_timeout * 1000
+				    )
+				  );
 			if (timeout < 0) {
 				mutex_unlock(&cam->fileop_mutex);
 				return timeout;
--- linux-2.6.31/drivers/media/video/et61x251/et61x251_core.c	2009-09-10 00:13:59.000000000 +0200
+++ linux-2.6.31.patched/drivers/media/video/et61x251/et61x251_core.c	2009-09-14 23:58:54.000000000 +0200
@@ -1379,8 +1379,10 @@ et61x251_read(struct file* filp, char __
 			    (!list_empty(&cam->outqueue)) ||
 			    (cam->state & DEV_DISCONNECTED) ||
 			    (cam->state & DEV_MISCONFIGURED),
-			    cam->module_param.frame_timeout *
-			    1000 * msecs_to_jiffies(1) );
+			    msecs_to_jiffies(
+				cam->module_param.frame_timeout * 1000
+			    )
+			  );
 		if (timeout < 0) {
 			mutex_unlock(&cam->fileop_mutex);
 			return timeout;
--- linux-2.6.31/drivers/media/video/zc0301/zc0301_core.c	2009-09-10 00:13:59.000000000 +0200
+++ linux-2.6.31.patched/drivers/media/video/zc0301/zc0301_core.c	2009-09-15 00:00:14.000000000 +0200
@@ -819,8 +819,10 @@ zc0301_read(struct file* filp, char __us
 			    (!list_empty(&cam->outqueue)) ||
 			    (cam->state & DEV_DISCONNECTED) ||
 			    (cam->state & DEV_MISCONFIGURED),
-			    cam->module_param.frame_timeout *
-			    1000 * msecs_to_jiffies(1) );
+			    msecs_to_jiffies(
+				cam->module_param.frame_timeout * 1000
+			    )
+			  );
 		if (timeout < 0) {
 			mutex_unlock(&cam->fileop_mutex);
 			return timeout;
