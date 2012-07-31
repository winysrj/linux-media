Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.linuxtv.org ([130.149.80.248]:43714 "EHLO www.linuxtv.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008Ab2GaEAI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 00:00:08 -0400
Message-Id: <E1Sw3Ho-0006rL-E9@www.linuxtv.org>
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Date: Tue, 31 Jul 2012 04:46:53 +0200
Subject: [git:v4l-dvb/for_v3.6] [media] tlg2300: Declare MODULE_FIRMWARE usage
To: linuxtv-commits@linuxtv.org
Cc: Kang Yong <kangyong@telegent.com>,
	Huang Shijie <shijie8@gmail.com>, linux-media@vger.kernel.org,
	Tim Gardner <tim.gardner@canonical.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Zhang Xiaobing <xbzhang@telegent.com>
Reply-to: linux-media@vger.kernel.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is an automatic generated email to let you know that the following patch were queued at the 
http://git.linuxtv.org/media_tree.git tree:

Subject: [media] tlg2300: Declare MODULE_FIRMWARE usage
Author:  Tim Gardner <tim.gardner@canonical.com>
Date:    Wed Jul 25 15:41:04 2012 -0300

Cc: Huang Shijie <shijie8@gmail.com>
Cc: Kang Yong <kangyong@telegent.com>
Cc: Zhang Xiaobing <xbzhang@telegent.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Acked-by: Huang Shijie <shijie8@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 drivers/media/video/tlg2300/pd-main.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

---

http://git.linuxtv.org/media_tree.git?a=commitdiff;h=4d98015eef6fa97b0cbba7310041ab75b223524b

diff --git a/drivers/media/video/tlg2300/pd-main.c b/drivers/media/video/tlg2300/pd-main.c
index c096b3f..7b1f6eb 100644
--- a/drivers/media/video/tlg2300/pd-main.c
+++ b/drivers/media/video/tlg2300/pd-main.c
@@ -53,7 +53,8 @@ int debug_mode;
 module_param(debug_mode, int, 0644);
 MODULE_PARM_DESC(debug_mode, "0 = disable, 1 = enable, 2 = verbose");
 
-static const char *firmware_name = "tlg2300_firmware.bin";
+#define TLG2300_FIRMWARE "tlg2300_firmware.bin"
+static const char *firmware_name = TLG2300_FIRMWARE;
 static struct usb_driver poseidon_driver;
 static LIST_HEAD(pd_device_list);
 
@@ -532,3 +533,4 @@ MODULE_AUTHOR("Telegent Systems");
 MODULE_DESCRIPTION("For tlg2300-based USB device ");
 MODULE_LICENSE("GPL");
 MODULE_VERSION("0.0.2");
+MODULE_FIRMWARE(TLG2300_FIRMWARE);
