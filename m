Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310Ab0HAUU5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Aug 2010 16:20:57 -0400
Date: Sun, 1 Aug 2010 17:21:22 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Udi Atar <udia@siano-ms.com>
Subject: [PATCH 5/6] V4L/DVB: sms: properly initialize IR phys and IR name
Message-ID: <20100801172122.01dfc9ec@pedra>
In-Reply-To: <cover.1280693675.git.mchehab@redhat.com>
References: <cover.1280693675.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

sms were using a non-compliant nomenclature for the USB devices. Fix it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/dvb/siano/smsir.c b/drivers/media/dvb/siano/smsir.c
index a56eac7..f8a4fd6 100644
--- a/drivers/media/dvb/siano/smsir.c
+++ b/drivers/media/dvb/siano/smsir.c
@@ -22,6 +22,7 @@
 
 #include <linux/types.h>
 #include <linux/input.h>
+#include <media/ir-core.h>
 
 #include "smscoreapi.h"
 #include "smsir.h"
@@ -247,6 +248,7 @@ void sms_ir_event(struct smscore_device_t *coredev, const char *buf, int len)
 int sms_ir_init(struct smscore_device_t *coredev)
 {
 	struct input_dev *input_dev;
+	int board_id = smscore_get_board_id(coredev);
 
 	sms_log("Allocating input device");
 	input_dev = input_allocate_device();
@@ -256,8 +258,7 @@ int sms_ir_init(struct smscore_device_t *coredev)
 	}
 
 	coredev->ir.input_dev = input_dev;
-	coredev->ir.ir_kb_type =
-		sms_get_board(smscore_get_board_id(coredev))->ir_kb_type;
+	coredev->ir.ir_kb_type = sms_get_board(board_id)->ir_kb_type;
 	coredev->ir.keyboard_layout_map =
 		keyboard_layout_maps[coredev->ir.ir_kb_type].
 				keyboard_layout_map;
@@ -269,11 +270,15 @@ int sms_ir_init(struct smscore_device_t *coredev)
 			coredev->ir.controller, coredev->ir.timeout);
 
 	snprintf(coredev->ir.name,
-				IR_DEV_NAME_MAX_LEN,
-				"SMS IR w/kbd type %d",
-				coredev->ir.ir_kb_type);
+				sizeof(coredev->ir.name),
+				"SMS IR (%s)",
+				sms_get_board(board_id)->name);
+
+	strlcpy(coredev->ir.phys, coredev->devpath, sizeof(coredev->ir.phys));
+	strlcat(coredev->ir.phys, "/ir0", sizeof(coredev->ir.phys));
+
 	input_dev->name = coredev->ir.name;
-	input_dev->phys = coredev->ir.name;
+	input_dev->phys = coredev->ir.phys;
 	input_dev->dev.parent = coredev->device;
 
 	/* Key press events only */
diff --git a/drivers/media/dvb/siano/smsir.h b/drivers/media/dvb/siano/smsir.h
index b7d703e..77e6505 100644
--- a/drivers/media/dvb/siano/smsir.h
+++ b/drivers/media/dvb/siano/smsir.h
@@ -24,7 +24,7 @@ along with this program.  If not, see <http://www.gnu.org/licenses/>.
 
 #include <linux/input.h>
 
-#define IR_DEV_NAME_MAX_LEN		23 /* "SMS IR kbd type nn\0" */
+#define IR_DEV_NAME_MAX_LEN		40
 #define IR_KEYBOARD_LAYOUT_SIZE	64
 #define IR_DEFAULT_TIMEOUT		100
 
@@ -78,7 +78,8 @@ struct smscore_device_t;
 struct ir_t {
 	struct input_dev *input_dev;
 	enum ir_kb_type ir_kb_type;
-	char name[IR_DEV_NAME_MAX_LEN+1];
+	char name[IR_DEV_NAME_MAX_LEN + 1];
+	char phys[32];
 	u16 *keyboard_layout_map;
 	u32 timeout;
 	u32 controller;
diff --git a/drivers/media/dvb/siano/smsusb.c b/drivers/media/dvb/siano/smsusb.c
index a9c27fb..50d4338 100644
--- a/drivers/media/dvb/siano/smsusb.c
+++ b/drivers/media/dvb/siano/smsusb.c
@@ -352,8 +352,7 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
 	params.num_buffers = MAX_BUFFERS;
 	params.sendrequest_handler = smsusb_sendrequest;
 	params.context = dev;
-	snprintf(params.devpath, sizeof(params.devpath),
-		 "usb\\%d-%s", dev->udev->bus->busnum, dev->udev->devpath);
+	usb_make_path(dev->udev, params.devpath, sizeof(params.devpath));
 
 	/* register in smscore */
 	rc = smscore_register_device(&params, &dev->coredev);
-- 
1.7.1


