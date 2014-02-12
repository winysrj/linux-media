Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:11116 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbaBLJCq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Feb 2014 04:02:46 -0500
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	Daniel Jeong <gshark.jeong@gmail.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 1/3] lm3560: remove FSF address from the license
Date: Wed, 12 Feb 2014 11:02:05 +0200
Message-Id: <1392195727-1494-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There is no need to keep the FSF address inside each file. Moreover, it might
change in future which will make this one obsolete.

There is no functional change.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/media/i2c/lm3560.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/media/i2c/lm3560.c b/drivers/media/i2c/lm3560.c
index d98ca3a..fea37a3 100644
--- a/drivers/media/i2c/lm3560.c
+++ b/drivers/media/i2c/lm3560.c
@@ -15,12 +15,6 @@
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
-- 
1.9.0.rc3

