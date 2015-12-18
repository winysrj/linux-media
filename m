Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:61959 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964980AbbLRUcF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2015 15:32:05 -0500
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Ondrej Zary <linux@rainbow-software.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 1/1] tea575x: convert to library
Date: Fri, 18 Dec 2015 22:32:00 +0200
Message-Id: <1450470720-89768-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The module is used only as a library for now. Remove module init and exit
routines to show this.

While here, remove FSF snail address and attach EXPORT_SYMBOL() macros to
corresponding functions.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/media/radio/tea575x.c | 21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff --git a/drivers/media/radio/tea575x.c b/drivers/media/radio/tea575x.c
index 43d1ea5..21cd5de 100644
--- a/drivers/media/radio/tea575x.c
+++ b/drivers/media/radio/tea575x.c
@@ -14,10 +14,6 @@
  *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  *   GNU General Public License for more details.
  *
- *   You should have received a copy of the GNU General Public License
- *   along with this program; if not, write to the Free Software
- *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
- *
  */
 
 #include <linux/delay.h>
@@ -226,6 +222,7 @@ void snd_tea575x_set_freq(struct snd_tea575x *tea)
 	snd_tea575x_write(tea, tea->val);
 	tea->freq = snd_tea575x_val_to_freq(tea, tea->val);
 }
+EXPORT_SYMBOL(snd_tea575x_set_freq);
 
 /*
  * Linux Video interface
@@ -582,25 +579,11 @@ int snd_tea575x_init(struct snd_tea575x *tea, struct module *owner)
 
 	return 0;
 }
+EXPORT_SYMBOL(snd_tea575x_init);
 
 void snd_tea575x_exit(struct snd_tea575x *tea)
 {
 	video_unregister_device(&tea->vd);
 	v4l2_ctrl_handler_free(tea->vd.ctrl_handler);
 }
-
-static int __init alsa_tea575x_module_init(void)
-{
-	return 0;
-}
-
-static void __exit alsa_tea575x_module_exit(void)
-{
-}
-
-module_init(alsa_tea575x_module_init)
-module_exit(alsa_tea575x_module_exit)
-
-EXPORT_SYMBOL(snd_tea575x_init);
 EXPORT_SYMBOL(snd_tea575x_exit);
-EXPORT_SYMBOL(snd_tea575x_set_freq);
-- 
2.6.4

