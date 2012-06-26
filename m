Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20226 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910Ab2FZTeh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jun 2012 15:34:37 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Antti Palosaari <crope@iki.fi>, Kay Sievers <kay@redhat.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH RFC 3/4] em28xx: Workaround for new udev versions
Date: Tue, 26 Jun 2012 16:34:21 -0300
Message-Id: <1340739262-13747-4-git-send-email-mchehab@redhat.com>
In-Reply-To: <1340739262-13747-1-git-send-email-mchehab@redhat.com>
References: <4FE9169D.5020300@redhat.com>
 <1340739262-13747-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

New udev-182 seems to be buggy: even when usermode is enabled, it
insists on needing that probe would defer any firmware requests.
So, drivers with firmware need to defer probe for the first
driver's core request, otherwise an useless penalty of 30 seconds
happens, as udev will refuse to load any firmware.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---

Note: this patch adds an ugly printk there, in order to allow testing it better.
This will be removed at the final version.

 drivers/media/video/em28xx/em28xx-cards.c |   39 +++++++++++++++++++++++++----
 1 file changed, 34 insertions(+), 5 deletions(-)

diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
index 9229cd2..9a1c16c 100644
--- a/drivers/media/video/em28xx/em28xx-cards.c
+++ b/drivers/media/video/em28xx/em28xx-cards.c
@@ -60,6 +60,8 @@ static unsigned int card[]     = {[0 ... (EM28XX_MAXBOARDS - 1)] = UNSET };
 module_param_array(card,  int, NULL, 0444);
 MODULE_PARM_DESC(card,     "card type");
 
+static bool is_em28xx_initialized;
+
 /* Bitmask marking allocated devices from 0 to EM28XX_MAXBOARDS - 1 */
 static unsigned long em28xx_devused;
 
@@ -3167,11 +3169,14 @@ static int em28xx_usb_probe(struct usb_interface *interface,
 	 * postponed, as udev may not be ready yet to honour firmware
 	 * load requests.
 	 */
+printk("em28xx: init = %d, userspace_is_disabled = %d, needs firmware = %d\n",
+	is_em28xx_initialized,
+	is_usermodehelp_disabled(), em28xx_boards[id->driver_info].needs_firmware);
 	if (em28xx_boards[id->driver_info].needs_firmware &&
-	    is_usermodehelp_disabled()) {
-		printk_once(KERN_DEBUG DRIVER_NAME
-		            ": probe deferred for board %d.\n",
-		            (unsigned)id->driver_info);
+	    (!is_em28xx_initialized || is_usermodehelp_disabled())) {
+		printk(KERN_DEBUG DRIVER_NAME
+		       ": probe deferred for board %d.\n",
+		       (unsigned)id->driver_info);
 		return -EPROBE_DEFER;
 	}
 
@@ -3456,4 +3461,28 @@ static struct usb_driver em28xx_usb_driver = {
 	.id_table = em28xx_id_table,
 };
 
-module_usb_driver(em28xx_usb_driver);
+static int __init em28xx_module_init(void)
+{
+	int result;
+
+	/* register this driver with the USB subsystem */
+	result = usb_register(&em28xx_usb_driver);
+	if (result)
+		em28xx_err(DRIVER_NAME
+			   " usb_register failed. Error number %d.\n", result);
+
+	printk(KERN_INFO DRIVER_NAME " driver loaded\n");
+
+	is_em28xx_initialized = true;
+
+	return result;
+}
+
+static void __exit em28xx_module_exit(void)
+{
+	/* deregister this driver with the USB subsystem */
+	usb_deregister(&em28xx_usb_driver);
+}
+
+module_init(em28xx_module_init);
+module_exit(em28xx_module_exit);
-- 
1.7.10.2

