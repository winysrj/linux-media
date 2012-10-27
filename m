Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17338 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515Ab2J0Ul7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Oct 2012 16:41:59 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9RKfw0x019771
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 27 Oct 2012 16:41:59 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 16/68] [media] mantis: get rid of warning: no previous prototype
Date: Sat, 27 Oct 2012 18:40:34 -0200
Message-Id: <1351370486-29040-17-git-send-email-mchehab@redhat.com>
In-Reply-To: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
References: <1351370486-29040-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

drivers/media/pci/mantis/mantis_input.c:107:5: warning: no previous prototype for 'mantis_input_init' [-Wmissing-prototypes]
drivers/media/pci/mantis/mantis_input.c:153:5: warning: no previous prototype for 'mantis_exit' [-Wmissing-prototypes]
drivers/media/pci/mantis/mantis_uart.c:64:5: warning: no previous prototype for 'mantis_uart_read' [-Wmissing-prototypes]
drivers/media/pci/mantis/mantis_vp1033.c:118:5: warning: no previous prototype for 'lgtdqcs001f_set_symbol_rate' [-Wmissing-prototypes]
drivers/media/pci/mantis/mantis_vp1033.c:86:5: warning: no previous prototype for 'lgtdqcs001f_tuner_set' [-Wmissing-prototypes]

Note: there is already a mantis_exit at the mantis driver. So,
this should be renamed to mantis_input_exit.

The mantis_input code is currently unused, as it doesn't implement the RC API
right.

Patches for it are sent for discussions, but were never
accepted. So, while this is not fixed, the entire code inside
mantis_input can simply be commented.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/pci/mantis/mantis_input.c  | 5 ++++-
 drivers/media/pci/mantis/mantis_uart.c   | 2 +-
 drivers/media/pci/mantis/mantis_vp1033.c | 6 +++---
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/media/pci/mantis/mantis_input.c b/drivers/media/pci/mantis/mantis_input.c
index db6d54d..0e5252e 100644
--- a/drivers/media/pci/mantis/mantis_input.c
+++ b/drivers/media/pci/mantis/mantis_input.c
@@ -18,6 +18,8 @@
 	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
+#if 0 /* Currently unused */
+
 #include <media/rc-core.h>
 #include <linux/pci.h>
 
@@ -150,10 +152,11 @@ out:
 	return err;
 }
 
-int mantis_exit(struct mantis_pci *mantis)
+int mantis_init_exit(struct mantis_pci *mantis)
 {
 	rc_unregister_device(mantis->rc);
 	rc_map_unregister(&ir_mantis_map);
 	return 0;
 }
 
+#endif
diff --git a/drivers/media/pci/mantis/mantis_uart.c b/drivers/media/pci/mantis/mantis_uart.c
index 85e9778..a707192 100644
--- a/drivers/media/pci/mantis/mantis_uart.c
+++ b/drivers/media/pci/mantis/mantis_uart.c
@@ -61,7 +61,7 @@ static struct {
 
 #define UART_MAX_BUF			16
 
-int mantis_uart_read(struct mantis_pci *mantis, u8 *data)
+static int mantis_uart_read(struct mantis_pci *mantis, u8 *data)
 {
 	struct mantis_hwconfig *config = mantis->hwconfig;
 	u32 stat = 0, i;
diff --git a/drivers/media/pci/mantis/mantis_vp1033.c b/drivers/media/pci/mantis/mantis_vp1033.c
index ad013e9..115003e 100644
--- a/drivers/media/pci/mantis/mantis_vp1033.c
+++ b/drivers/media/pci/mantis/mantis_vp1033.c
@@ -83,7 +83,7 @@ u8 lgtdqcs001f_inittab[] = {
 #define MANTIS_MODEL_NAME	"VP-1033"
 #define MANTIS_DEV_TYPE		"DVB-S/DSS"
 
-int lgtdqcs001f_tuner_set(struct dvb_frontend *fe)
+static int lgtdqcs001f_tuner_set(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
 	struct mantis_pci *mantis	= fe->dvb->priv;
@@ -115,8 +115,8 @@ int lgtdqcs001f_tuner_set(struct dvb_frontend *fe)
 	return 0;
 }
 
-int lgtdqcs001f_set_symbol_rate(struct dvb_frontend *fe,
-				u32 srate, u32 ratio)
+static int lgtdqcs001f_set_symbol_rate(struct dvb_frontend *fe,
+				       u32 srate, u32 ratio)
 {
 	u8 aclk = 0;
 	u8 bclk = 0;
-- 
1.7.11.7

