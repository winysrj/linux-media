Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3925 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051AbaHNJyY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Aug 2014 05:54:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 18/20] cx23885: remove FSF address as per checkpatch
Date: Thu, 14 Aug 2014 11:54:03 +0200
Message-Id: <1408010045-24016-19-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1408010045-24016-1-git-send-email-hverkuil@xs4all.nl>
References: <1408010045-24016-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

These addresses are usually out-of-date and the top-level license will
always have the right address. So drop it from these sources.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx23885/altera-ci.c     |  4 ----
 drivers/media/pci/cx23885/altera-ci.h     |  4 ----
 drivers/media/pci/cx23885/cimax2.c        |  4 ----
 drivers/media/pci/cx23885/cimax2.h        |  4 ----
 drivers/media/pci/cx23885/cx23885-417.c   |  4 ----
 drivers/media/pci/cx23885/cx23885-alsa.c  |  4 ----
 drivers/media/pci/cx23885/cx23885-av.c    |  5 -----
 drivers/media/pci/cx23885/cx23885-av.h    |  5 -----
 drivers/media/pci/cx23885/cx23885-cards.c |  6 ------
 drivers/media/pci/cx23885/cx23885-core.c  |  4 ----
 drivers/media/pci/cx23885/cx23885-dvb.c   |  5 -----
 drivers/media/pci/cx23885/cx23885-f300.c  |  4 ----
 drivers/media/pci/cx23885/cx23885-i2c.c   | 12 ------------
 drivers/media/pci/cx23885/cx23885-input.c |  5 -----
 drivers/media/pci/cx23885/cx23885-input.h |  5 -----
 drivers/media/pci/cx23885/cx23885-ioctl.c |  4 ----
 drivers/media/pci/cx23885/cx23885-ioctl.h |  4 ----
 drivers/media/pci/cx23885/cx23885-ir.c    |  5 -----
 drivers/media/pci/cx23885/cx23885-ir.h    |  5 -----
 drivers/media/pci/cx23885/cx23885-reg.h   |  4 ----
 drivers/media/pci/cx23885/cx23885-vbi.c   |  4 ----
 drivers/media/pci/cx23885/cx23885-video.c |  5 -----
 drivers/media/pci/cx23885/cx23885-video.h |  5 -----
 drivers/media/pci/cx23885/cx23885.h       |  4 ----
 drivers/media/pci/cx23885/cx23888-ir.c    |  5 -----
 drivers/media/pci/cx23885/cx23888-ir.h    |  5 -----
 drivers/media/pci/cx23885/netup-eeprom.c  |  4 ----
 drivers/media/pci/cx23885/netup-eeprom.h  |  4 ----
 drivers/media/pci/cx23885/netup-init.c    |  4 ----
 drivers/media/pci/cx23885/netup-init.h    |  4 ----
 30 files changed, 141 deletions(-)

diff --git a/drivers/media/pci/cx23885/altera-ci.c b/drivers/media/pci/cx23885/altera-ci.c
index f57b333..2bbbf54 100644
--- a/drivers/media/pci/cx23885/altera-ci.c
+++ b/drivers/media/pci/cx23885/altera-ci.c
@@ -16,10 +16,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 /*
diff --git a/drivers/media/pci/cx23885/altera-ci.h b/drivers/media/pci/cx23885/altera-ci.h
index 4998c96..5028f0c 100644
--- a/drivers/media/pci/cx23885/altera-ci.h
+++ b/drivers/media/pci/cx23885/altera-ci.h
@@ -16,10 +16,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 #ifndef __ALTERA_CI_H
 #define __ALTERA_CI_H
diff --git a/drivers/media/pci/cx23885/cimax2.c b/drivers/media/pci/cx23885/cimax2.c
index 16fa7ea..631e4f2 100644
--- a/drivers/media/pci/cx23885/cimax2.c
+++ b/drivers/media/pci/cx23885/cimax2.c
@@ -17,10 +17,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #include "cx23885.h"
diff --git a/drivers/media/pci/cx23885/cimax2.h b/drivers/media/pci/cx23885/cimax2.h
index 518744a..565e958 100644
--- a/drivers/media/pci/cx23885/cimax2.h
+++ b/drivers/media/pci/cx23885/cimax2.h
@@ -17,10 +17,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #ifndef CIMAX2_H
diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index a17238a..f1ef901 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -18,10 +18,6 @@
  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #include <linux/module.h>
diff --git a/drivers/media/pci/cx23885/cx23885-alsa.c b/drivers/media/pci/cx23885/cx23885-alsa.c
index cbbf9ad..1b162ee 100644
--- a/drivers/media/pci/cx23885/cx23885-alsa.c
+++ b/drivers/media/pci/cx23885/cx23885-alsa.c
@@ -15,10 +15,6 @@
  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #include <linux/module.h>
diff --git a/drivers/media/pci/cx23885/cx23885-av.c b/drivers/media/pci/cx23885/cx23885-av.c
index c443b7a..877dad8 100644
--- a/drivers/media/pci/cx23885/cx23885-av.c
+++ b/drivers/media/pci/cx23885/cx23885-av.c
@@ -14,11 +14,6 @@
  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- *  02110-1301, USA.
  */
 
 #include "cx23885.h"
diff --git a/drivers/media/pci/cx23885/cx23885-av.h b/drivers/media/pci/cx23885/cx23885-av.h
index d2915c3..97f232f 100644
--- a/drivers/media/pci/cx23885/cx23885-av.h
+++ b/drivers/media/pci/cx23885/cx23885-av.h
@@ -14,11 +14,6 @@
  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- *  02110-1301, USA.
  */
 
 #ifndef _CX23885_AV_H_
diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
index c2b6080..21e500b 100644
--- a/drivers/media/pci/cx23885/cx23885-cards.c
+++ b/drivers/media/pci/cx23885/cx23885-cards.c
@@ -13,10 +13,6 @@
  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *
  *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #include <linux/init.h>
@@ -1970,5 +1966,3 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 	}
 	}
 }
-
-/* ------------------------------------------------------------------ */
diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index 2599af1..8663f7b 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -13,10 +13,6 @@
  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *
  *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #include <linux/init.h>
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 376b0a6..4f643ae 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -13,10 +13,6 @@
  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *
  *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #include <linux/module.h>
@@ -1717,4 +1713,3 @@ int cx23885_dvb_unregister(struct cx23885_tsport *port)
 
 	return 0;
 }
-
diff --git a/drivers/media/pci/cx23885/cx23885-f300.c b/drivers/media/pci/cx23885/cx23885-f300.c
index 5444cc5..6f817d8 100644
--- a/drivers/media/pci/cx23885/cx23885-f300.c
+++ b/drivers/media/pci/cx23885/cx23885-f300.c
@@ -22,10 +22,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #include "cx23885.h"
diff --git a/drivers/media/pci/cx23885/cx23885-i2c.c b/drivers/media/pci/cx23885/cx23885-i2c.c
index 4887314..fd71306 100644
--- a/drivers/media/pci/cx23885/cx23885-i2c.c
+++ b/drivers/media/pci/cx23885/cx23885-i2c.c
@@ -13,10 +13,6 @@
  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *
  *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #include <linux/module.h>
@@ -386,11 +382,3 @@ void cx23885_av_clk(struct cx23885_dev *dev, int enable)
 
 	i2c_xfer(&dev->i2c_bus[2].i2c_adap, &msg, 1);
 }
-
-/* ----------------------------------------------------------------------- */
-
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
diff --git a/drivers/media/pci/cx23885/cx23885-input.c b/drivers/media/pci/cx23885/cx23885-input.c
index 1940c18..9d37fe6 100644
--- a/drivers/media/pci/cx23885/cx23885-input.c
+++ b/drivers/media/pci/cx23885/cx23885-input.c
@@ -28,11 +28,6 @@
  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- *  02110-1301, USA.
  */
 
 #include <linux/slab.h>
diff --git a/drivers/media/pci/cx23885/cx23885-input.h b/drivers/media/pci/cx23885/cx23885-input.h
index 87dc44e..6199c7e 100644
--- a/drivers/media/pci/cx23885/cx23885-input.h
+++ b/drivers/media/pci/cx23885/cx23885-input.h
@@ -14,11 +14,6 @@
  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- *  02110-1301, USA.
  */
 
 #ifndef _CX23885_INPUT_H_
diff --git a/drivers/media/pci/cx23885/cx23885-ioctl.c b/drivers/media/pci/cx23885/cx23885-ioctl.c
index 9c16786..d2cdd40 100644
--- a/drivers/media/pci/cx23885/cx23885-ioctl.c
+++ b/drivers/media/pci/cx23885/cx23885-ioctl.c
@@ -15,10 +15,6 @@
  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *
  *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #include "cx23885.h"
diff --git a/drivers/media/pci/cx23885/cx23885-ioctl.h b/drivers/media/pci/cx23885/cx23885-ioctl.h
index 92d9f07..cc5dbb6 100644
--- a/drivers/media/pci/cx23885/cx23885-ioctl.h
+++ b/drivers/media/pci/cx23885/cx23885-ioctl.h
@@ -15,10 +15,6 @@
  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *
  *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #ifndef _CX23885_IOCTL_H_
diff --git a/drivers/media/pci/cx23885/cx23885-ir.c b/drivers/media/pci/cx23885/cx23885-ir.c
index bfef193..89dc4cc 100644
--- a/drivers/media/pci/cx23885/cx23885-ir.c
+++ b/drivers/media/pci/cx23885/cx23885-ir.c
@@ -14,11 +14,6 @@
  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- *  02110-1301, USA.
  */
 
 #include <media/v4l2-device.h>
diff --git a/drivers/media/pci/cx23885/cx23885-ir.h b/drivers/media/pci/cx23885/cx23885-ir.h
index 0c9d8bd..8e93d1f 100644
--- a/drivers/media/pci/cx23885/cx23885-ir.h
+++ b/drivers/media/pci/cx23885/cx23885-ir.h
@@ -14,11 +14,6 @@
  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- *  02110-1301, USA.
  */
 
 #ifndef _CX23885_IR_H_
diff --git a/drivers/media/pci/cx23885/cx23885-reg.h b/drivers/media/pci/cx23885/cx23885-reg.h
index a99936e..2d3cbaf 100644
--- a/drivers/media/pci/cx23885/cx23885-reg.h
+++ b/drivers/media/pci/cx23885/cx23885-reg.h
@@ -13,10 +13,6 @@
  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *
  *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #ifndef _CX23885_REG_H_
diff --git a/drivers/media/pci/cx23885/cx23885-vbi.c b/drivers/media/pci/cx23885/cx23885-vbi.c
index 358776e..67b71f9 100644
--- a/drivers/media/pci/cx23885/cx23885-vbi.c
+++ b/drivers/media/pci/cx23885/cx23885-vbi.c
@@ -13,10 +13,6 @@
  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *
  *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index ff45417..defdf74 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -13,10 +13,6 @@
  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *
  *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #include <linux/init.h>
@@ -1286,4 +1282,3 @@ fail_unreg:
 	cx23885_video_unregister(dev);
 	return err;
 }
-
diff --git a/drivers/media/pci/cx23885/cx23885-video.h b/drivers/media/pci/cx23885/cx23885-video.h
index c961a2b..291e8f3 100644
--- a/drivers/media/pci/cx23885/cx23885-video.h
+++ b/drivers/media/pci/cx23885/cx23885-video.h
@@ -12,11 +12,6 @@
  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- *  02110-1301, USA.
  */
 
 #ifndef _CX23885_VIDEO_H_
diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index f542ced..c306aa3 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -13,10 +13,6 @@
  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *
  *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #include <linux/pci.h>
diff --git a/drivers/media/pci/cx23885/cx23888-ir.c b/drivers/media/pci/cx23885/cx23888-ir.c
index 2c951de..8ac968b 100644
--- a/drivers/media/pci/cx23885/cx23888-ir.c
+++ b/drivers/media/pci/cx23885/cx23888-ir.c
@@ -14,11 +14,6 @@
  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- *  02110-1301, USA.
  */
 
 #include <linux/kfifo.h>
diff --git a/drivers/media/pci/cx23885/cx23888-ir.h b/drivers/media/pci/cx23885/cx23888-ir.h
index d2de41c..ff74a93 100644
--- a/drivers/media/pci/cx23885/cx23888-ir.h
+++ b/drivers/media/pci/cx23885/cx23888-ir.h
@@ -14,11 +14,6 @@
  *  but WITHOUT ANY WARRANTY; without even the implied warranty of
  *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the Free Software
- *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- *  02110-1301, USA.
  */
 
 #ifndef _CX23888_IR_H_
diff --git a/drivers/media/pci/cx23885/netup-eeprom.c b/drivers/media/pci/cx23885/netup-eeprom.c
index 98a48f5..b6542ee 100644
--- a/drivers/media/pci/cx23885/netup-eeprom.c
+++ b/drivers/media/pci/cx23885/netup-eeprom.c
@@ -17,10 +17,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #
diff --git a/drivers/media/pci/cx23885/netup-eeprom.h b/drivers/media/pci/cx23885/netup-eeprom.h
index 13926e1..90cac5b 100644
--- a/drivers/media/pci/cx23885/netup-eeprom.h
+++ b/drivers/media/pci/cx23885/netup-eeprom.h
@@ -16,10 +16,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #ifndef NETUP_EEPROM_H
diff --git a/drivers/media/pci/cx23885/netup-init.c b/drivers/media/pci/cx23885/netup-init.c
index 0044fef..76d9487 100644
--- a/drivers/media/pci/cx23885/netup-init.c
+++ b/drivers/media/pci/cx23885/netup-init.c
@@ -17,10 +17,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #include "cx23885.h"
diff --git a/drivers/media/pci/cx23885/netup-init.h b/drivers/media/pci/cx23885/netup-init.h
index d26ae4b..daaa212 100644
--- a/drivers/media/pci/cx23885/netup-init.h
+++ b/drivers/media/pci/cx23885/netup-init.h
@@ -17,9 +17,5 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 extern void netup_initialize(struct cx23885_dev *dev);
-- 
2.1.0.rc1

