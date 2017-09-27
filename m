Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:37265 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752046AbdI0SZU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 27 Sep 2017 14:25:20 -0400
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 13/13] staging: atomisp: Remove FSF snail address
Date: Wed, 27 Sep 2017 21:25:08 +0300
Message-Id: <20170927182508.52119-14-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20170927182508.52119-1-andriy.shevchenko@linux.intel.com>
References: <20170927182508.52119-1-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Snail address is subject to change, remove it completely from the code.

This has been done using the following script:

	sed -i '/You should/,/02110-1301/d' \
		$(git grep -n -w Franklin -- drivers/staging/media/atomisp/ | cut -f1 -d:)

No functional change intended.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/staging/media/atomisp/i2c/gc0310.h                            | 4 ----
 drivers/staging/media/atomisp/i2c/libmsrlisthelper.c                  | 4 ----
 drivers/staging/media/atomisp/i2c/lm3554.c                            | 4 ----
 drivers/staging/media/atomisp/i2c/mt9m114.c                           | 4 ----
 drivers/staging/media/atomisp/i2c/mt9m114.h                           | 4 ----
 drivers/staging/media/atomisp/i2c/ov2680.h                            | 4 ----
 drivers/staging/media/atomisp/i2c/ov2722.h                            | 4 ----
 drivers/staging/media/atomisp/i2c/ov5693/ad5823.h                     | 4 ----
 drivers/staging/media/atomisp/i2c/ov5693/ov5693.c                     | 4 ----
 drivers/staging/media/atomisp/i2c/ov5693/ov5693.h                     | 4 ----
 drivers/staging/media/atomisp/i2c/ov8858.c                            | 4 ----
 drivers/staging/media/atomisp/i2c/ov8858.h                            | 4 ----
 drivers/staging/media/atomisp/i2c/ov8858_btns.h                       | 4 ----
 drivers/staging/media/atomisp/include/linux/atomisp.h                 | 4 ----
 drivers/staging/media/atomisp/include/linux/atomisp_platform.h        | 4 ----
 drivers/staging/media/atomisp/include/linux/libmsrlisthelper.h        | 4 ----
 drivers/staging/media/atomisp/include/media/lm3554.h                  | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/atomisp-regs.h             | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_acc.c              | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_acc.h              | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c              | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.h              | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_common.h           | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat.h           | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c     | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.h     | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c   | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.h   | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_csi2.c             | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_csi2.h             | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_dfs_tables.h       | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.c            | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.h            | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_file.c             | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_file.h             | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c             | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.h             | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_helper.h           | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_internal.h         | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c            | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.h            | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.c           | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.h           | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_tables.h           | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_tpg.c              | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_tpg.h              | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_trace_event.h      | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c             | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.h             | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c                  | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c               | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_dynamic_pool.c     | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_reserved_pool.c    | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_vm.c               | 4 ----
 .../media/atomisp/pci/atomisp2/hrt/hive_isp_css_custom_host_hrt.h     | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.c  | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.h  | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm.h          | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm_bo.h       | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm_bo_dev.h   | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm_common.h   | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm_pool.h     | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm_vm.h       | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/include/mmu/isp_mmu.h      | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/include/mmu/sh_mmu.h       | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/include/mmu/sh_mmu_mrfld.h | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/mmu/isp_mmu.c              | 4 ----
 drivers/staging/media/atomisp/pci/atomisp2/mmu/sh_mmu_mrfld.c         | 4 ----
 68 files changed, 272 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/gc0310.h b/drivers/staging/media/atomisp/i2c/gc0310.h
index 7e97e45b4f79..c422d0398fc7 100644
--- a/drivers/staging/media/atomisp/i2c/gc0310.h
+++ b/drivers/staging/media/atomisp/i2c/gc0310.h
@@ -12,10 +12,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 
diff --git a/drivers/staging/media/atomisp/i2c/libmsrlisthelper.c b/drivers/staging/media/atomisp/i2c/libmsrlisthelper.c
index decb65cfd7c9..81e5ec0c2b64 100644
--- a/drivers/staging/media/atomisp/i2c/libmsrlisthelper.c
+++ b/drivers/staging/media/atomisp/i2c/libmsrlisthelper.c
@@ -10,10 +10,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 #include <linux/i2c.h>
diff --git a/drivers/staging/media/atomisp/i2c/lm3554.c b/drivers/staging/media/atomisp/i2c/lm3554.c
index f74380074177..36bfc385ee65 100644
--- a/drivers/staging/media/atomisp/i2c/lm3554.c
+++ b/drivers/staging/media/atomisp/i2c/lm3554.c
@@ -12,10 +12,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 #include <linux/module.h>
diff --git a/drivers/staging/media/atomisp/i2c/mt9m114.c b/drivers/staging/media/atomisp/i2c/mt9m114.c
index 09018d5ccaf2..f327f5b7c874 100644
--- a/drivers/staging/media/atomisp/i2c/mt9m114.c
+++ b/drivers/staging/media/atomisp/i2c/mt9m114.c
@@ -12,10 +12,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 
diff --git a/drivers/staging/media/atomisp/i2c/mt9m114.h b/drivers/staging/media/atomisp/i2c/mt9m114.h
index 1ad1b1ac55e7..0af79d77a404 100644
--- a/drivers/staging/media/atomisp/i2c/mt9m114.h
+++ b/drivers/staging/media/atomisp/i2c/mt9m114.h
@@ -12,10 +12,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 
diff --git a/drivers/staging/media/atomisp/i2c/ov2680.h b/drivers/staging/media/atomisp/i2c/ov2680.h
index 198c158de3f2..bf4897347df7 100644
--- a/drivers/staging/media/atomisp/i2c/ov2680.h
+++ b/drivers/staging/media/atomisp/i2c/ov2680.h
@@ -12,10 +12,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 
diff --git a/drivers/staging/media/atomisp/i2c/ov2722.h b/drivers/staging/media/atomisp/i2c/ov2722.h
index 3ee8eaadba49..d8a973d71699 100644
--- a/drivers/staging/media/atomisp/i2c/ov2722.h
+++ b/drivers/staging/media/atomisp/i2c/ov2722.h
@@ -12,10 +12,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 
diff --git a/drivers/staging/media/atomisp/i2c/ov5693/ad5823.h b/drivers/staging/media/atomisp/i2c/ov5693/ad5823.h
index 2dd894989cd9..4de44569fe54 100644
--- a/drivers/staging/media/atomisp/i2c/ov5693/ad5823.h
+++ b/drivers/staging/media/atomisp/i2c/ov5693/ad5823.h
@@ -12,10 +12,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 
diff --git a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c
index 33651ec0218f..a7f6336689ae 100644
--- a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c
+++ b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.c
@@ -12,10 +12,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 
diff --git a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.h b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.h
index b94a72a300d4..2ea63807c56d 100644
--- a/drivers/staging/media/atomisp/i2c/ov5693/ov5693.h
+++ b/drivers/staging/media/atomisp/i2c/ov5693/ov5693.h
@@ -12,10 +12,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 
diff --git a/drivers/staging/media/atomisp/i2c/ov8858.c b/drivers/staging/media/atomisp/i2c/ov8858.c
index 51bda5c73128..534812391155 100644
--- a/drivers/staging/media/atomisp/i2c/ov8858.c
+++ b/drivers/staging/media/atomisp/i2c/ov8858.c
@@ -12,10 +12,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 
diff --git a/drivers/staging/media/atomisp/i2c/ov8858.h b/drivers/staging/media/atomisp/i2c/ov8858.h
index 0f1b76e49a34..6c89568bb44e 100644
--- a/drivers/staging/media/atomisp/i2c/ov8858.h
+++ b/drivers/staging/media/atomisp/i2c/ov8858.h
@@ -12,10 +12,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 
diff --git a/drivers/staging/media/atomisp/i2c/ov8858_btns.h b/drivers/staging/media/atomisp/i2c/ov8858_btns.h
index 5cf03c220876..f81851306832 100644
--- a/drivers/staging/media/atomisp/i2c/ov8858_btns.h
+++ b/drivers/staging/media/atomisp/i2c/ov8858_btns.h
@@ -12,10 +12,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 
diff --git a/drivers/staging/media/atomisp/include/linux/atomisp.h b/drivers/staging/media/atomisp/include/linux/atomisp.h
index d67dd658cff9..b5533197226d 100644
--- a/drivers/staging/media/atomisp/include/linux/atomisp.h
+++ b/drivers/staging/media/atomisp/include/linux/atomisp.h
@@ -12,10 +12,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 #ifdef CSS15
diff --git a/drivers/staging/media/atomisp/include/linux/atomisp_platform.h b/drivers/staging/media/atomisp/include/linux/atomisp_platform.h
index 2dae4935ed75..e0f0c379e7ce 100644
--- a/drivers/staging/media/atomisp/include/linux/atomisp_platform.h
+++ b/drivers/staging/media/atomisp/include/linux/atomisp_platform.h
@@ -12,10 +12,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 #ifndef ATOMISP_PLATFORM_H_
diff --git a/drivers/staging/media/atomisp/include/linux/libmsrlisthelper.h b/drivers/staging/media/atomisp/include/linux/libmsrlisthelper.h
index 589f4eae38ca..8988b37943b3 100644
--- a/drivers/staging/media/atomisp/include/linux/libmsrlisthelper.h
+++ b/drivers/staging/media/atomisp/include/linux/libmsrlisthelper.h
@@ -10,10 +10,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 #ifndef __LIBMSRLISTHELPER_H__
diff --git a/drivers/staging/media/atomisp/include/media/lm3554.h b/drivers/staging/media/atomisp/include/media/lm3554.h
index df17d546f661..9276ce44d907 100644
--- a/drivers/staging/media/atomisp/include/media/lm3554.h
+++ b/drivers/staging/media/atomisp/include/media/lm3554.h
@@ -12,10 +12,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 #ifndef _LM3554_H_
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp-regs.h b/drivers/staging/media/atomisp/pci/atomisp2/atomisp-regs.h
index 513a430ee01a..5d102a4f8aff 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp-regs.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp-regs.h
@@ -12,10 +12,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_acc.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_acc.c
index 1eac329339b7..a6638edee360 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_acc.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_acc.c
@@ -12,10 +12,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_acc.h b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_acc.h
index 5b58e7d9ca5b..56386154643b 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_acc.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_acc.h
@@ -12,10 +12,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
index b0c647f4d250..998d3a06477b 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.c
@@ -14,10 +14,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 #include <linux/firmware.h>
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.h b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.h
index 31ba4e613d13..429cadbbb809 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_cmd.h
@@ -14,10 +14,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_common.h b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_common.h
index 69d1526da362..2558193045a6 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_common.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_common.h
@@ -14,10 +14,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat.h b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat.h
index fb8b8fab4e92..3ef850cd25bd 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat.h
@@ -12,10 +12,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
index 05897b747349..a86c764c5e9c 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.c
@@ -12,10 +12,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.h b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.h
index b62ad9082018..b03711668eda 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_css20.h
@@ -12,10 +12,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c
index 0592ac1f2832..44c21813a06e 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.c
@@ -12,10 +12,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 #ifdef CONFIG_COMPAT
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.h b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.h
index 750478f614d6..685da0f48bab 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_compat_ioctl32.h
@@ -12,10 +12,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 #ifndef __ATOMISP_COMPAT_IOCTL32_H__
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_csi2.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_csi2.c
index 2c5036685447..fa03b78c3580 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_csi2.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_csi2.c
@@ -12,10 +12,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_csi2.h b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_csi2.h
index faa9cf7e05c0..0191d28a55bc 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_csi2.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_csi2.h
@@ -12,10 +12,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 #ifndef __ATOMISP_CSI2_H__
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_dfs_tables.h b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_dfs_tables.h
index 204d941cdb6c..54e28605b5de 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_dfs_tables.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_dfs_tables.h
@@ -12,10 +12,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 #ifndef	__ATOMISP_DFS_TABLES_H__
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.c
index 9f74b2dcbfaf..7129b88456cb 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.c
@@ -12,10 +12,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.h b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.h
index 5cb717b0c1c2..b91bfef21639 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_drvfs.h
@@ -12,10 +12,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_file.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_file.c
index c766119bf798..377ec2a9fa6d 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_file.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_file.c
@@ -14,10 +14,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_file.h b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_file.h
index 1b86abd35c38..61fdeb5ee60a 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_file.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_file.h
@@ -14,10 +14,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c
index d8cfed358d55..abe71433a353 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.c
@@ -14,10 +14,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.h b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.h
index 8471e391501a..2faab3429d43 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_fops.h
@@ -14,10 +14,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_helper.h b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_helper.h
index e9650cb75ba5..55ba185b43a0 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_helper.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_helper.h
@@ -14,10 +14,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 #ifndef _atomisp_helper_h_
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_internal.h b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_internal.h
index 6c1eb417361d..52a6f8002048 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_internal.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_internal.h
@@ -14,10 +14,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 #ifndef __ATOMISP_INTERNAL_H__
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c
index dd59167237c1..9609a06b5fcb 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.c
@@ -14,10 +14,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.h b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.h
index fb5fadb5332b..0d2785b9ef99 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_ioctl.h
@@ -14,10 +14,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.c
index d27a50e66be2..70b53988553c 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.c
@@ -12,10 +12,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 #include <linux/module.h>
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.h b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.h
index ba5c2ab14253..f3d61827ae8c 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_subdev.h
@@ -12,10 +12,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 #ifndef __ATOMISP_SUBDEV_H__
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_tables.h b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_tables.h
index af09218d8b71..319ded6a96da 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_tables.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_tables.h
@@ -14,10 +14,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 #ifndef	__ATOMISP_TABLES_H__
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_tpg.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_tpg.c
index 48b96048cab4..b71cc7bcdbab 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_tpg.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_tpg.c
@@ -14,10 +14,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_tpg.h b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_tpg.h
index 64ab60f02e85..af354c4bfd3e 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_tpg.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_tpg.h
@@ -14,10 +14,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_trace_event.h b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_trace_event.h
index 5ce282d6c939..462b296554c7 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_trace_event.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_trace_event.h
@@ -12,10 +12,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 #undef TRACE_SYSTEM
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
index 5a6dd3789acd..22e043963ec7 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.c
@@ -14,10 +14,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 #include <linux/module.h>
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.h b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.h
index 191b2e57a810..944a6cf40a2f 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_v4l2.h
@@ -14,10 +14,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
index b8aae4ba5a78..a1c81c12718c 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm.c
@@ -14,10 +14,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 /*
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
index e6ddfbf0c4e2..60a3741d2231 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_bo.c
@@ -14,10 +14,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 /*
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_dynamic_pool.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_dynamic_pool.c
index 19e0e9ee37de..d5c1b8975fff 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_dynamic_pool.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_dynamic_pool.c
@@ -14,10 +14,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 /*
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_reserved_pool.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_reserved_pool.c
index bf6586805f7f..f8b2dc85f1a4 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_reserved_pool.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_reserved_pool.c
@@ -14,10 +14,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 /*
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_vm.c b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_vm.c
index 0722a68a49e7..23b44f26730e 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_vm.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hmm/hmm_vm.c
@@ -14,10 +14,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 /*
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_custom_host_hrt.h b/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_custom_host_hrt.h
index 46a5d29e2d3a..fb38fc540b81 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_custom_host_hrt.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_custom_host_hrt.h
@@ -14,10 +14,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 #ifndef _hive_isp_css_custom_host_hrt_h_
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.c b/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.c
index 2e78976bb2ac..a94958bde718 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.c
@@ -14,10 +14,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.h b/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.h
index 1328944a7afd..15c2dfb6794e 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/hrt/hive_isp_css_mm_hrt.h
@@ -14,10 +14,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm.h b/drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm.h
index 6b9fb1b2caaf..1e135c7c6d9b 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm.h
@@ -14,10 +14,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm_bo.h b/drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm_bo.h
index dffd6e9cf693..bd44ebbc427c 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm_bo.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm_bo.h
@@ -14,10 +14,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm_bo_dev.h b/drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm_bo_dev.h
index a9446adb4c70..9e51a657ece4 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm_bo_dev.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm_bo_dev.h
@@ -14,10 +14,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm_common.h b/drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm_common.h
index f1593aa38ce1..00885203fb14 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm_common.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm_common.h
@@ -14,10 +14,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm_pool.h b/drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm_pool.h
index 1ba360433d88..bf24e44462bc 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm_pool.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm_pool.h
@@ -14,10 +14,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 #ifndef __HMM_POOL_H__
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm_vm.h b/drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm_vm.h
index 07d40662de32..52098161082d 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm_vm.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/include/hmm/hmm_vm.h
@@ -14,10 +14,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/include/mmu/isp_mmu.h b/drivers/staging/media/atomisp/pci/atomisp2/include/mmu/isp_mmu.h
index 6b4eefc929e2..560014add005 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/include/mmu/isp_mmu.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/include/mmu/isp_mmu.h
@@ -14,10 +14,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 /*
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/include/mmu/sh_mmu.h b/drivers/staging/media/atomisp/pci/atomisp2/include/mmu/sh_mmu.h
index 06041e94cbb2..031c0398bf65 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/include/mmu/sh_mmu.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/include/mmu/sh_mmu.h
@@ -14,10 +14,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 #ifndef	SH_MMU_H_
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/include/mmu/sh_mmu_mrfld.h b/drivers/staging/media/atomisp/pci/atomisp2/include/mmu/sh_mmu_mrfld.h
index b9bad9f06235..662e98f41da2 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/include/mmu/sh_mmu_mrfld.h
+++ b/drivers/staging/media/atomisp/pci/atomisp2/include/mmu/sh_mmu_mrfld.h
@@ -14,10 +14,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/mmu/isp_mmu.c b/drivers/staging/media/atomisp/pci/atomisp2/mmu/isp_mmu.c
index 706bd43e8b1b..e36c2a33b41a 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/mmu/isp_mmu.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/mmu/isp_mmu.c
@@ -14,10 +14,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 /*
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/mmu/sh_mmu_mrfld.c b/drivers/staging/media/atomisp/pci/atomisp2/mmu/sh_mmu_mrfld.c
index 97546bd124cd..c59bcc982966 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/mmu/sh_mmu_mrfld.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/mmu/sh_mmu_mrfld.c
@@ -14,10 +14,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
  *
  */
 #include "type_support.h"
-- 
2.14.1
