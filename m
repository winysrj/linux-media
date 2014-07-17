Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2584 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758651AbaGQXkv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jul 2014 19:40:51 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	pete@sensoray.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH for v3.17 3/4] solo6x10: a few checkpatch fixes
Date: Fri, 18 Jul 2014 01:40:22 +0200
Message-Id: <1405640423-1037-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1405640423-1037-1-git-send-email-hverkuil@xs4all.nl>
References: <1405640423-1037-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Added a blank line after variable declarations where checkpatch
requested that, and removed the 'write to the FSF' paragraph,
again as requested.

This is in preparation of the move out of staging into drivers/media.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/solo6x10/solo6x10-core.c     | 6 +-----
 drivers/staging/media/solo6x10/solo6x10-disp.c     | 4 ----
 drivers/staging/media/solo6x10/solo6x10-eeprom.c   | 4 ----
 drivers/staging/media/solo6x10/solo6x10-enc.c      | 4 ----
 drivers/staging/media/solo6x10/solo6x10-g723.c     | 4 ----
 drivers/staging/media/solo6x10/solo6x10-gpio.c     | 4 ----
 drivers/staging/media/solo6x10/solo6x10-i2c.c      | 4 ----
 drivers/staging/media/solo6x10/solo6x10-jpeg.h     | 4 ----
 drivers/staging/media/solo6x10/solo6x10-offsets.h  | 4 ----
 drivers/staging/media/solo6x10/solo6x10-p2m.c      | 4 ----
 drivers/staging/media/solo6x10/solo6x10-regs.h     | 4 ----
 drivers/staging/media/solo6x10/solo6x10-tw28.c     | 5 +----
 drivers/staging/media/solo6x10/solo6x10-tw28.h     | 4 ----
 drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c | 7 +++----
 drivers/staging/media/solo6x10/solo6x10-v4l2.c     | 8 ++++----
 drivers/staging/media/solo6x10/solo6x10.h          | 4 ----
 16 files changed, 9 insertions(+), 65 deletions(-)

diff --git a/drivers/staging/media/solo6x10/solo6x10-core.c b/drivers/staging/media/solo6x10/solo6x10-core.c
index f670469..172583d 100644
--- a/drivers/staging/media/solo6x10/solo6x10-core.c
+++ b/drivers/staging/media/solo6x10/solo6x10-core.c
@@ -16,10 +16,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
 #include <linux/kernel.h>
@@ -307,8 +303,8 @@ static ssize_t p2m_timeout_store(struct device *dev,
 	struct solo_dev *solo_dev =
 		container_of(dev, struct solo_dev, dev);
 	unsigned long ms;
-
 	int ret = kstrtoul(buf, 10, &ms);
+
 	if (ret < 0 || ms > 200)
 		return -EINVAL;
 	solo_dev->p2m_jiffies = msecs_to_jiffies(ms);
diff --git a/drivers/staging/media/solo6x10/solo6x10-disp.c b/drivers/staging/media/solo6x10/solo6x10-disp.c
index b529a96..ed88ab4 100644
--- a/drivers/staging/media/solo6x10/solo6x10-disp.c
+++ b/drivers/staging/media/solo6x10/solo6x10-disp.c
@@ -16,10 +16,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/staging/media/solo6x10/solo6x10-eeprom.c b/drivers/staging/media/solo6x10/solo6x10-eeprom.c
index 9d1c9bb..af40b3a 100644
--- a/drivers/staging/media/solo6x10/solo6x10-eeprom.c
+++ b/drivers/staging/media/solo6x10/solo6x10-eeprom.c
@@ -16,10 +16,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/staging/media/solo6x10/solo6x10-enc.c b/drivers/staging/media/solo6x10/solo6x10-enc.c
index 2db53b6..d19c0ae 100644
--- a/drivers/staging/media/solo6x10/solo6x10-enc.c
+++ b/drivers/staging/media/solo6x10/solo6x10-enc.c
@@ -16,10 +16,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/staging/media/solo6x10/solo6x10-g723.c b/drivers/staging/media/solo6x10/solo6x10-g723.c
index 74f037b..c7141f2 100644
--- a/drivers/staging/media/solo6x10/solo6x10-g723.c
+++ b/drivers/staging/media/solo6x10/solo6x10-g723.c
@@ -16,10 +16,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/staging/media/solo6x10/solo6x10-gpio.c b/drivers/staging/media/solo6x10/solo6x10-gpio.c
index 73276dc..6d3b4a3 100644
--- a/drivers/staging/media/solo6x10/solo6x10-gpio.c
+++ b/drivers/staging/media/solo6x10/solo6x10-gpio.c
@@ -16,10 +16,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/staging/media/solo6x10/solo6x10-i2c.c b/drivers/staging/media/solo6x10/solo6x10-i2c.c
index 01aa417..c908672 100644
--- a/drivers/staging/media/solo6x10/solo6x10-i2c.c
+++ b/drivers/staging/media/solo6x10/solo6x10-i2c.c
@@ -16,10 +16,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
 /* XXX: The SOLO6x10 i2c does not have separate interrupts for each i2c
diff --git a/drivers/staging/media/solo6x10/solo6x10-jpeg.h b/drivers/staging/media/solo6x10/solo6x10-jpeg.h
index 9e41185..1c66a46 100644
--- a/drivers/staging/media/solo6x10/solo6x10-jpeg.h
+++ b/drivers/staging/media/solo6x10/solo6x10-jpeg.h
@@ -16,10 +16,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
 #ifndef __SOLO6X10_JPEG_H
diff --git a/drivers/staging/media/solo6x10/solo6x10-offsets.h b/drivers/staging/media/solo6x10/solo6x10-offsets.h
index 13eeb44..d6aea7c 100644
--- a/drivers/staging/media/solo6x10/solo6x10-offsets.h
+++ b/drivers/staging/media/solo6x10/solo6x10-offsets.h
@@ -16,10 +16,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
 #ifndef __SOLO6X10_OFFSETS_H
diff --git a/drivers/staging/media/solo6x10/solo6x10-p2m.c b/drivers/staging/media/solo6x10/solo6x10-p2m.c
index 7f2f247..8c84846 100644
--- a/drivers/staging/media/solo6x10/solo6x10-p2m.c
+++ b/drivers/staging/media/solo6x10/solo6x10-p2m.c
@@ -16,10 +16,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/staging/media/solo6x10/solo6x10-regs.h b/drivers/staging/media/solo6x10/solo6x10-regs.h
index 428f6c9..e34ac56 100644
--- a/drivers/staging/media/solo6x10/solo6x10-regs.h
+++ b/drivers/staging/media/solo6x10/solo6x10-regs.h
@@ -16,10 +16,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
 #ifndef __SOLO6X10_REGISTERS_H
diff --git a/drivers/staging/media/solo6x10/solo6x10-tw28.c b/drivers/staging/media/solo6x10/solo6x10-tw28.c
index 36daa17..edd0781 100644
--- a/drivers/staging/media/solo6x10/solo6x10-tw28.c
+++ b/drivers/staging/media/solo6x10/solo6x10-tw28.c
@@ -16,10 +16,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
 #include <linux/kernel.h>
@@ -214,6 +210,7 @@ static void tw_write_and_verify(struct solo_dev *solo_dev, u8 addr, u8 off,
 
 	for (i = 0; i < 5; i++) {
 		u8 rval = solo_i2c_readbyte(solo_dev, SOLO_I2C_TW, addr, off);
+
 		if (rval == val)
 			return;
 
diff --git a/drivers/staging/media/solo6x10/solo6x10-tw28.h b/drivers/staging/media/solo6x10/solo6x10-tw28.h
index 1a02c87..0966b45 100644
--- a/drivers/staging/media/solo6x10/solo6x10-tw28.h
+++ b/drivers/staging/media/solo6x10/solo6x10-tw28.h
@@ -16,10 +16,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
 #ifndef __SOLO6X10_TW28_H
diff --git a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
index 1fd6bec..2e07b49 100644
--- a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
@@ -16,10 +16,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
 #include <linux/kernel.h>
@@ -704,6 +700,7 @@ static int solo_ring_thread(void *data)
 
 	for (;;) {
 		long timeout = schedule_timeout_interruptible(HZ);
+
 		if (timeout == -ERESTARTSYS || kthread_should_stop())
 			break;
 		solo_irq_off(solo_dev, SOLO_IRQ_ENCODER);
@@ -750,6 +747,7 @@ static int solo_ring_start(struct solo_dev *solo_dev)
 					    SOLO6X10_NAME "_ring");
 	if (IS_ERR(solo_dev->ring_thread)) {
 		int err = PTR_ERR(solo_dev->ring_thread);
+
 		solo_dev->ring_thread = NULL;
 		return err;
 	}
@@ -1402,6 +1400,7 @@ int solo_enc_v4l2_init(struct solo_dev *solo_dev, unsigned nr)
 
 	if (i != solo_dev->nr_chans) {
 		int ret = PTR_ERR(solo_dev->v4l2_enc[i]);
+
 		while (i--)
 			solo_enc_free(solo_dev->v4l2_enc[i]);
 		pci_free_consistent(solo_dev->pdev, solo_dev->vh_size,
diff --git a/drivers/staging/media/solo6x10/solo6x10-v4l2.c b/drivers/staging/media/solo6x10/solo6x10-v4l2.c
index ba2526c..63ae8a6 100644
--- a/drivers/staging/media/solo6x10/solo6x10-v4l2.c
+++ b/drivers/staging/media/solo6x10/solo6x10-v4l2.c
@@ -16,10 +16,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
 #include <linux/kernel.h>
@@ -98,6 +94,7 @@ static int solo_v4l2_ch_ext_4up(struct solo_dev *solo_dev, u8 idx, int on)
 
 	if (!on) {
 		u8 i;
+
 		for (i = ch; i < ch + 4; i++)
 			solo_win_setup(solo_dev, i, solo_dev->video_hsize,
 				       solo_vlines(solo_dev),
@@ -206,6 +203,7 @@ static void solo_fillbuf(struct solo_dev *solo_dev,
 	if (erase_off(solo_dev)) {
 		void *p = vb2_plane_vaddr(vb, 0);
 		int image_size = solo_image_size(solo_dev);
+
 		for (i = 0; i < image_size; i += 2) {
 			((u8 *)p)[i] = 0x80;
 			((u8 *)p)[i + 1] = 0x00;
@@ -275,6 +273,7 @@ static int solo_thread(void *data)
 
 	for (;;) {
 		long timeout = schedule_timeout_interruptible(HZ);
+
 		if (timeout == -ERESTARTSYS || kthread_should_stop())
 			break;
 		solo_thread_try(solo_dev);
@@ -414,6 +413,7 @@ static int solo_enum_input(struct file *file, void *priv,
 
 	if (input->index >= solo_dev->nr_chans) {
 		int ret = solo_enum_ext_input(solo_dev, input);
+
 		if (ret < 0)
 			return ret;
 	} else {
diff --git a/drivers/staging/media/solo6x10/solo6x10.h b/drivers/staging/media/solo6x10/solo6x10.h
index 35f9486..c6154b0 100644
--- a/drivers/staging/media/solo6x10/solo6x10.h
+++ b/drivers/staging/media/solo6x10/solo6x10.h
@@ -16,10 +16,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
 #ifndef __SOLO6X10_H
-- 
2.0.0

