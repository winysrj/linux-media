Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:38426 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751512AbdHJIcl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Aug 2017 04:32:41 -0400
Date: Thu, 10 Aug 2017 14:02:35 +0530
From: Harold Gomez <haroldgmz11@gmail.com>
To: mchehab@kernel.org
Cc: gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Subject: drivers:staging:media:atomisp:12c:ab1302.c fix CHECK
Message-ID: <20170810083235.GA2362@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CHECK: Do not include the paragraph about writing to the Free Software
Foundation's mailing address from the sample GPL notice.
The FSF has changed addresses in the past, and may do so again.
Linux already includes a copy of the GPL.

remove the unnecessary paragraph

Signed-off-by: Harold Gomez <haroldgmz11@gmail.com>
---
 drivers/staging/media/atomisp/i2c/ap1302.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/staging/media/atomisp/i2c/ap1302.c b/drivers/staging/media/atomisp/i2c/ap1302.c
index bacffbe..9d6ce36 100644
--- a/drivers/staging/media/atomisp/i2c/ap1302.c
+++ b/drivers/staging/media/atomisp/i2c/ap1302.c
@@ -11,11 +11,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA.
- *
  */
 
 #include "../include/linux/atomisp.h"
-- 
2.1.4
