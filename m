Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:39194 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbbJJNgQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 10 Oct 2015 09:36:16 -0400
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 10/26] [media] dvb_ca_en50221.h: Make checkpatch.pl happy
Date: Sat, 10 Oct 2015 10:35:53 -0300
Message-Id: <bdbbf13e0434ab82d700693ff19182013aaa09dd.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
In-Reply-To: <cover.1444483819.git.mchehab@osg.samsung.com>
References: <cover.1444483819.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several CodingStyle violations at the DVB code. While
we won't be fixing them as a hole, let's fix at least the
headers, as we're touching on them already in order to properly
document them.

No functional changes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.h b/drivers/media/dvb-core/dvb_ca_en50221.h
index 9ec2adc3ea11..1e4bbbd34d91 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.h
+++ b/drivers/media/dvb-core/dvb_ca_en50221.h
@@ -12,10 +12,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	 See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU Lesser General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
  */
 
 #ifndef _DVB_CA_EN50221_H_
@@ -37,8 +33,6 @@
 #define DVB_CA_EN50221_CAMCHANGE_REMOVED		0
 #define DVB_CA_EN50221_CAMCHANGE_INSERTED		1
 
-
-
 /**
  * struct dvb_ca_en50221- Structure describing a CA interface
  *
@@ -60,30 +54,32 @@
  * and if appropriate. There will be no concurrent access to one slot.
  */
 struct dvb_ca_en50221 {
+	struct module *owner;
 
+	int (*read_attribute_mem)(struct dvb_ca_en50221 *ca,
+				  int slot, int address);
+	int (*write_attribute_mem)(struct dvb_ca_en50221 *ca,
+				   int slot, int address, u8 value);
 
+	int (*read_cam_control)(struct dvb_ca_en50221 *ca,
+				int slot, u8 address);
+	int (*write_cam_control)(struct dvb_ca_en50221 *ca,
+				 int slot, u8 address, u8 value);
 
-	int (*write_attribute_mem)(struct dvb_ca_en50221* ca, int slot, int address, u8 value);
+	int (*slot_reset)(struct dvb_ca_en50221 *ca, int slot);
+	int (*slot_shutdown)(struct dvb_ca_en50221 *ca, int slot);
+	int (*slot_ts_enable)(struct dvb_ca_en50221 *ca, int slot);
 
-	int (*read_cam_control)(struct dvb_ca_en50221* ca, int slot, u8 address);
-	int (*write_cam_control)(struct dvb_ca_en50221* ca, int slot, u8 address, u8 value);
+	int (*poll_slot_status)(struct dvb_ca_en50221 *ca, int slot, int open);
 
-	int (*slot_reset)(struct dvb_ca_en50221* ca, int slot);
-	int (*slot_shutdown)(struct dvb_ca_en50221* ca, int slot);
-	int (*slot_ts_enable)(struct dvb_ca_en50221* ca, int slot);
+	void *data;
 
-	int (*poll_slot_status)(struct dvb_ca_en50221* ca, int slot, int open);
-
-	void* data;
-
-	void* private;
+	void *private;
 };
 
-
-
-
-/* ******************************************************************************** */
-/* Functions for reporting IRQ events */
+/*
+ * Functions for reporting IRQ events
+ */
 
 /**
  * dvb_ca_en50221_camchange_irq - A CAMCHANGE IRQ has occurred.
@@ -92,7 +88,8 @@ struct dvb_ca_en50221 {
  * @slot: Slot concerned.
  * @change_type: One of the DVB_CA_CAMCHANGE_* values
  */
-void dvb_ca_en50221_camchange_irq(struct dvb_ca_en50221* pubca, int slot, int change_type);
+void dvb_ca_en50221_camchange_irq(struct dvb_ca_en50221 *pubca, int slot,
+				  int change_type);
 
 /**
  * dvb_ca_en50221_camready_irq - A CAMREADY IRQ has occurred.
@@ -100,7 +97,7 @@ void dvb_ca_en50221_camchange_irq(struct dvb_ca_en50221* pubca, int slot, int ch
  * @pubca: CA instance.
  * @slot: Slot concerned.
  */
-void dvb_ca_en50221_camready_irq(struct dvb_ca_en50221* pubca, int slot);
+void dvb_ca_en50221_camready_irq(struct dvb_ca_en50221 *pubca, int slot);
 
 /**
  * dvb_ca_en50221_frda_irq - An FR or a DA IRQ has occurred.
@@ -108,12 +105,11 @@ void dvb_ca_en50221_camready_irq(struct dvb_ca_en50221* pubca, int slot);
  * @ca: CA instance.
  * @slot: Slot concerned.
  */
-void dvb_ca_en50221_frda_irq(struct dvb_ca_en50221* ca, int slot);
+void dvb_ca_en50221_frda_irq(struct dvb_ca_en50221 *ca, int slot);
 
-
-
-/* ******************************************************************************** */
-/* Initialisation/shutdown functions */
+/*
+ * Initialisation/shutdown functions
+ */
 
 /**
  * dvb_ca_en50221_init - Initialise a new DVB CA device.
@@ -125,15 +121,15 @@ void dvb_ca_en50221_frda_irq(struct dvb_ca_en50221* ca, int slot);
  *
  * @return 0 on success, nonzero on failure
  */
-extern int dvb_ca_en50221_init(struct dvb_adapter *dvb_adapter, struct dvb_ca_en50221* ca, int flags, int slot_count);
+extern int dvb_ca_en50221_init(struct dvb_adapter *dvb_adapter,
+			       struct dvb_ca_en50221 *ca, int flags,
+			       int slot_count);
 
 /**
  * dvb_ca_en50221_release - Release a DVB CA device.
  *
  * @ca: The associated dvb_ca instance.
  */
-extern void dvb_ca_en50221_release(struct dvb_ca_en50221* ca);
-
-
+extern void dvb_ca_en50221_release(struct dvb_ca_en50221 *ca);
 
 #endif
-- 
2.4.3


