Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1389 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab2ISHAn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Sep 2012 03:00:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [PATCH TRIVIAL] ivtv-alsa-pcm: remove unnecessary printk.h include
Date: Wed, 19 Sep 2012 09:00:35 +0200
Cc: Andy Walls <awalls@md.metrocast.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201209190900.35230.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just a quick patch removing the printk.h include: this header is already
included by kernel.h, and it breaks the compat build because this header
only appeared in 2.6.37.

Regards,

	Hans

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/pci/ivtv/ivtv-alsa-pcm.c b/drivers/media/pci/ivtv/ivtv-alsa-pcm.c
index 82c708e..f7022bd 100644
--- a/drivers/media/pci/ivtv/ivtv-alsa-pcm.c
+++ b/drivers/media/pci/ivtv/ivtv-alsa-pcm.c
@@ -26,7 +26,6 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/vmalloc.h>
-#include <linux/printk.h>
 
 #include <media/v4l2-device.h>
 
