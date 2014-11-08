Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53051 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753263AbaKHXKM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 8 Nov 2014 18:10:12 -0500
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Timo Ahonen <timo.ahonen@nokia.com>
Subject: [PATCH 01/10] smiapp: Remove FSF's address from the license header
Date: Sun,  9 Nov 2014 01:09:22 +0200
Message-Id: <1415488171-27636-2-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1415488171-27636-1-git-send-email-sakari.ailus@iki.fi>
References: <1415488171-27636-1-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove FSF's address information from the license header in the smiapp
driver and the smiapp-pll PLL calculator. This should no longer be needed,
and would be rendered outdated in case the FSF chooses to relocate its
office.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Timo Ahonen <timo.ahonen@nokia.com>
---
 drivers/media/i2c/smiapp-pll.c             |    6 ------
 drivers/media/i2c/smiapp-pll.h             |    6 ------
 drivers/media/i2c/smiapp/smiapp-core.c     |    6 ------
 drivers/media/i2c/smiapp/smiapp-limits.c   |    6 ------
 drivers/media/i2c/smiapp/smiapp-limits.h   |    6 ------
 drivers/media/i2c/smiapp/smiapp-quirk.c    |    6 ------
 drivers/media/i2c/smiapp/smiapp-quirk.h    |    6 ------
 drivers/media/i2c/smiapp/smiapp-reg-defs.h |    6 ------
 drivers/media/i2c/smiapp/smiapp-reg.h      |    6 ------
 drivers/media/i2c/smiapp/smiapp-regs.c     |    6 ------
 drivers/media/i2c/smiapp/smiapp-regs.h     |    6 ------
 drivers/media/i2c/smiapp/smiapp.h          |    6 ------
 12 files changed, 72 deletions(-)

diff --git a/drivers/media/i2c/smiapp-pll.c b/drivers/media/i2c/smiapp-pll.c
index e40d902..2b84d09 100644
--- a/drivers/media/i2c/smiapp-pll.c
+++ b/drivers/media/i2c/smiapp-pll.c
@@ -14,12 +14,6 @@
  * WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
  */
 
 #include <linux/gcd.h>
diff --git a/drivers/media/i2c/smiapp-pll.h b/drivers/media/i2c/smiapp-pll.h
index e8f035a..77f7ff2f 100644
--- a/drivers/media/i2c/smiapp-pll.h
+++ b/drivers/media/i2c/smiapp-pll.h
@@ -14,12 +14,6 @@
  * WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
  */
 
 #ifndef SMIAPP_PLL_H
diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index e2d2b8f..512eeed 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -18,12 +18,6 @@
  * WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
  */
 
 #include <linux/clk.h>
diff --git a/drivers/media/i2c/smiapp/smiapp-limits.c b/drivers/media/i2c/smiapp/smiapp-limits.c
index 847cb23..784b114 100644
--- a/drivers/media/i2c/smiapp/smiapp-limits.c
+++ b/drivers/media/i2c/smiapp/smiapp-limits.c
@@ -14,12 +14,6 @@
  * WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
  */
 
 #include "smiapp.h"
diff --git a/drivers/media/i2c/smiapp/smiapp-limits.h b/drivers/media/i2c/smiapp/smiapp-limits.h
index 343e9c3..b201248 100644
--- a/drivers/media/i2c/smiapp/smiapp-limits.h
+++ b/drivers/media/i2c/smiapp/smiapp-limits.h
@@ -14,12 +14,6 @@
  * WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
  */
 
 #define SMIAPP_LIMIT_ANALOGUE_GAIN_CAPABILITY			0
diff --git a/drivers/media/i2c/smiapp/smiapp-quirk.c b/drivers/media/i2c/smiapp/smiapp-quirk.c
index e0bee87..dd4ae6f 100644
--- a/drivers/media/i2c/smiapp/smiapp-quirk.c
+++ b/drivers/media/i2c/smiapp/smiapp-quirk.c
@@ -14,12 +14,6 @@
  * WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
  */
 
 #include <linux/delay.h>
diff --git a/drivers/media/i2c/smiapp/smiapp-quirk.h b/drivers/media/i2c/smiapp/smiapp-quirk.h
index 46e9ea8..3a3c3e5 100644
--- a/drivers/media/i2c/smiapp/smiapp-quirk.h
+++ b/drivers/media/i2c/smiapp/smiapp-quirk.h
@@ -14,12 +14,6 @@
  * WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
  */
 
 #ifndef __SMIAPP_QUIRK__
diff --git a/drivers/media/i2c/smiapp/smiapp-reg-defs.h b/drivers/media/i2c/smiapp/smiapp-reg-defs.h
index c488ef0..f928d4c 100644
--- a/drivers/media/i2c/smiapp/smiapp-reg-defs.h
+++ b/drivers/media/i2c/smiapp/smiapp-reg-defs.h
@@ -14,12 +14,6 @@
  * WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
  */
 #define SMIAPP_REG_MK_U8(r) ((SMIAPP_REG_8BIT << 16) | (r))
 #define SMIAPP_REG_MK_U16(r) ((SMIAPP_REG_16BIT << 16) | (r))
diff --git a/drivers/media/i2c/smiapp/smiapp-reg.h b/drivers/media/i2c/smiapp/smiapp-reg.h
index b0dcbb8..4c8b406 100644
--- a/drivers/media/i2c/smiapp/smiapp-reg.h
+++ b/drivers/media/i2c/smiapp/smiapp-reg.h
@@ -14,12 +14,6 @@
  * WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
  */
 
 #ifndef __SMIAPP_REG_H_
diff --git a/drivers/media/i2c/smiapp/smiapp-regs.c b/drivers/media/i2c/smiapp/smiapp-regs.c
index a209800..6b6c20b 100644
--- a/drivers/media/i2c/smiapp/smiapp-regs.c
+++ b/drivers/media/i2c/smiapp/smiapp-regs.c
@@ -14,12 +14,6 @@
  * WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
  */
 
 #include <linux/delay.h>
diff --git a/drivers/media/i2c/smiapp/smiapp-regs.h b/drivers/media/i2c/smiapp/smiapp-regs.h
index 3552112..6dd0e49 100644
--- a/drivers/media/i2c/smiapp/smiapp-regs.h
+++ b/drivers/media/i2c/smiapp/smiapp-regs.h
@@ -14,12 +14,6 @@
  * WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
  */
 
 #ifndef SMIAPP_REGS_H
diff --git a/drivers/media/i2c/smiapp/smiapp.h b/drivers/media/i2c/smiapp/smiapp.h
index f88f8ec..8fded46 100644
--- a/drivers/media/i2c/smiapp/smiapp.h
+++ b/drivers/media/i2c/smiapp/smiapp.h
@@ -14,12 +14,6 @@
  * WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
  */
 
 #ifndef __SMIAPP_PRIV_H_
-- 
1.7.10.4

