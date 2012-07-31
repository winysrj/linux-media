Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.linuxtv.org ([130.149.80.248]:43711 "EHLO www.linuxtv.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745Ab2GaEAD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 00:00:03 -0400
Message-Id: <E1Sw3Hp-0006sM-TG@www.linuxtv.org>
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Tue, 31 Jul 2012 04:21:56 +0200
Subject: [git:v4l-dvb/for_v3.6] [media] s2255drv: Add MODULE_FIRMWARE statement
To: linuxtv-commits@linuxtv.org
Cc: linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Tim Gardner <tim.gardner@canonical.com>,
	Dean Anderson <linux-dev@sensoray.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Dan Carpenter <dan.carpenter@oracle.com>
Reply-to: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an automatic generated email to let you know that the following patch were queued at the 
http://git.linuxtv.org/media_tree.git tree:

Subject: [media] s2255drv: Add MODULE_FIRMWARE statement
Author:  Tim Gardner <tim.gardner@canonical.com>
Date:    Tue Jul 24 16:52:27 2012 -0300

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Dean Anderson <linux-dev@sensoray.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 drivers/media/video/s2255drv.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

---

http://git.linuxtv.org/media_tree.git?a=commitdiff;h=1bec982dd432a187459d59900a16cd79d5eea7fc

diff --git a/drivers/media/video/s2255drv.c b/drivers/media/video/s2255drv.c
index 01c2179..95007dd 100644
--- a/drivers/media/video/s2255drv.c
+++ b/drivers/media/video/s2255drv.c
@@ -2686,3 +2686,4 @@ MODULE_DESCRIPTION("Sensoray 2255 Video for Linux driver");
 MODULE_AUTHOR("Dean Anderson (Sensoray Company Inc.)");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(S2255_VERSION);
+MODULE_FIRMWARE(FIRMWARE_FILE_NAME);
