Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49204 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755234AbaHLVub (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Aug 2014 17:50:31 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 02/10] [media] as102: get rid of FSF mail address
Date: Tue, 12 Aug 2014 18:50:16 -0300
Message-Id: <1407880224-374-3-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1407880224-374-1-git-send-email-m.chehab@samsung.com>
References: <1407880224-374-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make checkpatch happier by removing FSF mail address.

No functional changes.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/as102/as102_drv.c        | 4 ----
 drivers/media/usb/as102/as102_drv.h        | 4 ----
 drivers/media/usb/as102/as102_fe.c         | 4 ----
 drivers/media/usb/as102/as102_fw.c         | 4 ----
 drivers/media/usb/as102/as102_fw.h         | 4 ----
 drivers/media/usb/as102/as102_usb_drv.c    | 4 ----
 drivers/media/usb/as102/as102_usb_drv.h    | 4 ----
 drivers/media/usb/as102/as10x_cmd.c        | 4 ----
 drivers/media/usb/as102/as10x_cmd.h        | 4 ----
 drivers/media/usb/as102/as10x_cmd_cfg.c    | 4 ----
 drivers/media/usb/as102/as10x_cmd_stream.c | 4 ----
 drivers/media/usb/as102/as10x_handle.h     | 4 ----
 drivers/media/usb/as102/as10x_types.h      | 4 ----
 13 files changed, 52 deletions(-)

diff --git a/drivers/media/usb/as102/as102_drv.c b/drivers/media/usb/as102/as102_drv.c
index e0ee618e607a..d90a6651f03e 100644
--- a/drivers/media/usb/as102/as102_drv.c
+++ b/drivers/media/usb/as102/as102_drv.c
@@ -12,10 +12,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 #include <linux/kernel.h>
 #include <linux/errno.h>
diff --git a/drivers/media/usb/as102/as102_drv.h b/drivers/media/usb/as102/as102_drv.h
index 49d0c4259b00..d6e08e23b366 100644
--- a/drivers/media/usb/as102/as102_drv.h
+++ b/drivers/media/usb/as102/as102_drv.h
@@ -11,10 +11,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #include <linux/usb.h>
diff --git a/drivers/media/usb/as102/as102_fe.c b/drivers/media/usb/as102/as102_fe.c
index 67e55b84493f..29a6d38f91a9 100644
--- a/drivers/media/usb/as102/as102_fe.c
+++ b/drivers/media/usb/as102/as102_fe.c
@@ -12,10 +12,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 #include "as102_drv.h"
 #include "as10x_types.h"
diff --git a/drivers/media/usb/as102/as102_fw.c b/drivers/media/usb/as102/as102_fw.c
index f33f752c0aad..07d08c49f4d4 100644
--- a/drivers/media/usb/as102/as102_fw.c
+++ b/drivers/media/usb/as102/as102_fw.c
@@ -12,10 +12,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 #include <linux/kernel.h>
 #include <linux/errno.h>
diff --git a/drivers/media/usb/as102/as102_fw.h b/drivers/media/usb/as102/as102_fw.h
index 4bfc6849d95a..2732b784216d 100644
--- a/drivers/media/usb/as102/as102_fw.h
+++ b/drivers/media/usb/as102/as102_fw.h
@@ -11,10 +11,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 #define MAX_FW_PKT_SIZE	64
 
diff --git a/drivers/media/usb/as102/as102_usb_drv.c b/drivers/media/usb/as102/as102_usb_drv.c
index 86f83b9b1118..43133df771ff 100644
--- a/drivers/media/usb/as102/as102_usb_drv.c
+++ b/drivers/media/usb/as102/as102_usb_drv.c
@@ -12,10 +12,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 #include <linux/kernel.h>
 #include <linux/errno.h>
diff --git a/drivers/media/usb/as102/as102_usb_drv.h b/drivers/media/usb/as102/as102_usb_drv.h
index 1ad1ec52b11e..4fb1baa8cac0 100644
--- a/drivers/media/usb/as102/as102_usb_drv.h
+++ b/drivers/media/usb/as102/as102_usb_drv.h
@@ -12,10 +12,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 #ifndef _AS102_USB_DRV_H_
 #define _AS102_USB_DRV_H_
diff --git a/drivers/media/usb/as102/as10x_cmd.c b/drivers/media/usb/as102/as10x_cmd.c
index 9e49f15a7c9f..8868c52500ee 100644
--- a/drivers/media/usb/as102/as10x_cmd.c
+++ b/drivers/media/usb/as102/as10x_cmd.c
@@ -12,10 +12,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/media/usb/as102/as10x_cmd.h b/drivers/media/usb/as102/as10x_cmd.h
index e21ec6c702a9..1c9ea2c2175e 100644
--- a/drivers/media/usb/as102/as10x_cmd.h
+++ b/drivers/media/usb/as102/as10x_cmd.h
@@ -11,10 +11,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 #ifndef _AS10X_CMD_H_
 #define _AS10X_CMD_H_
diff --git a/drivers/media/usb/as102/as10x_cmd_cfg.c b/drivers/media/usb/as102/as10x_cmd_cfg.c
index b1e300d88753..833463343ada 100644
--- a/drivers/media/usb/as102/as10x_cmd_cfg.c
+++ b/drivers/media/usb/as102/as10x_cmd_cfg.c
@@ -11,10 +11,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/media/usb/as102/as10x_cmd_stream.c b/drivers/media/usb/as102/as10x_cmd_stream.c
index 1088ca1fe92f..126aea976639 100644
--- a/drivers/media/usb/as102/as10x_cmd_stream.c
+++ b/drivers/media/usb/as102/as10x_cmd_stream.c
@@ -11,10 +11,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
 #include <linux/kernel.h>
diff --git a/drivers/media/usb/as102/as10x_handle.h b/drivers/media/usb/as102/as10x_handle.h
index 5638b191b780..e535fffbcd94 100644
--- a/drivers/media/usb/as102/as10x_handle.h
+++ b/drivers/media/usb/as102/as10x_handle.h
@@ -11,10 +11,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 #ifdef __KERNEL__
 struct as10x_bus_adapter_t;
diff --git a/drivers/media/usb/as102/as10x_types.h b/drivers/media/usb/as102/as10x_types.h
index af26e057d9a2..f82d51e542e3 100644
--- a/drivers/media/usb/as102/as10x_types.h
+++ b/drivers/media/usb/as102/as10x_types.h
@@ -11,10 +11,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 #ifndef _AS10X_TYPES_H_
 #define _AS10X_TYPES_H_
-- 
1.9.3

