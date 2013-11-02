Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:60761 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425Ab3KBQdm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Nov 2013 12:33:42 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCHv2 18/29] av7110_hw: Don't use dynamic static allocation
Date: Sat,  2 Nov 2013 11:31:26 -0200
Message-Id: <1383399097-11615-19-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
References: <1383399097-11615-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dynamic static allocation is evil, as Kernel stack is too low, and
compilation complains about it on some archs:

	drivers/media/pci/ttpci/av7110_hw.c:510:1: warning: 'av7110_fw_cmd' uses dynamic stack allocation [enabled by default]

Instead, let's enforce a limit for the buffer.

In the specific case of this driver, the maximum fw command size
is 6 + 2, as checked using:

	$ git grep -A1 av7110_fw_cmd drivers/media/pci/ttpci/

So, use 8 for the buffer size.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/pci/ttpci/av7110_hw.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/ttpci/av7110_hw.c b/drivers/media/pci/ttpci/av7110_hw.c
index f1cbfe526989..ca6672a29fbc 100644
--- a/drivers/media/pci/ttpci/av7110_hw.c
+++ b/drivers/media/pci/ttpci/av7110_hw.c
@@ -22,7 +22,7 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
  *
- * the project's page is at http://www.linuxtv.org/ 
+ * the project's page is at http://www.linuxtv.org/
  */
 
 /* for debugging ARM communication: */
@@ -488,11 +488,18 @@ static int av7110_send_fw_cmd(struct av7110 *av7110, u16* buf, int length)
 int av7110_fw_cmd(struct av7110 *av7110, int type, int com, int num, ...)
 {
 	va_list args;
-	u16 buf[num + 2];
+	u16 buf[8];
 	int i, ret;
 
 //	dprintk(4, "%p\n", av7110);
 
+	if (2 + num > sizeof(buf)) {
+		printk(KERN_WARNING
+		       "%s: %s len=%d is too big!\n",
+		       KBUILD_MODNAME, __func__, num);
+		return -EREMOTEIO;
+	}
+
 	buf[0] = ((type << 8) | com);
 	buf[1] = num;
 
-- 
1.8.3.1

