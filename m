Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:58295 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382Ab0EGVSR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 May 2010 17:18:17 -0400
Received: from localhost (localhost [127.0.0.1])
	by tyrex.lisa.loc (Postfix) with ESMTP id 2BDBF968D5C9
	for <linux-media@vger.kernel.org>; Fri,  7 May 2010 23:18:14 +0200 (CEST)
From: "Hans-Peter Jansen" <hpj@urpla.net>
To: linux-media@vger.kernel.org
Subject: missing slab includes in hg tree
Date: Fri, 7 May 2010 23:18:04 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201005072318.05108.hpj@urpla.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

it takes a patch similar to the attached to compile the hg tree
against the current kernel.

From: "Hans-Peter Jansen" <hpj@urpla.net>

Include the missing kernel/slab.h in order to build with current 
kernel.

Signed-off-by: "Hans-Peter Jansen" <hpj@urpla.net>

--- v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/atbm8830.c~	2009-12-23 03:40:06.000000000 +0100
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/atbm8830.c	2010-05-05 23:40:47.477779081 +0200
@@ -19,6 +19,7 @@
  *    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include <linux/slab.h>
 #include <asm/div64.h>
 #include "dvb_frontend.h"
 
--- v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/dib0070.c~	2009-12-08 10:12:45.000000000 +0100
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/dib0070.c	2010-05-05 23:29:34.713743794 +0200
@@ -25,6 +25,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/i2c.h>
 
 #include "dvb_frontend.h"
--- v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/dib0090.c~	2010-01-26 09:36:53.000000000 +0100
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/dib0090.c	2010-05-05 23:30:12.965932306 +0200
@@ -25,6 +25,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/i2c.h>
 
 #include "dvb_frontend.h"
--- v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/dib3000mc.c~	2008-01-26 21:10:25.000000000 +0100
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/dib3000mc.c	2010-05-05 23:09:28.173784120 +0200
@@ -12,6 +12,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/i2c.h>
 #include "compat.h"
 
--- v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/dib7000m.c~	2008-09-11 10:09:40.000000000 +0200
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/dib7000m.c	2010-05-05 23:12:30.990595900 +0200
@@ -9,6 +9,7 @@
  *	published by the Free Software Foundation, version 2.
  */
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/i2c.h>
 #include "compat.h"
 
--- v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/dib7000p.c~	2009-10-07 13:56:59.000000000 +0200
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/dib7000p.c	2010-05-05 23:13:12.773925925 +0200
@@ -8,6 +8,7 @@
  *	published by the Free Software Foundation, version 2.
  */
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/i2c.h>
 #include "compat.h"
 
--- v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/dib8000.c~	2009-12-26 02:07:22.000000000 +0100
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/dib8000.c	2010-05-05 23:13:51.689738020 +0200
@@ -8,6 +8,7 @@
  *  published by the Free Software Foundation, version 2.
  */
 #include <linux/kernel.h>
+#include <linux/slab.h>
 #include <linux/i2c.h>
 #include "dvb_math.h"
 #include "compat.h"
--- v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/drx397xD.c~	2009-12-15 12:00:31.000000000 +0100
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/drx397xD.c	2010-05-05 23:20:26.693937426 +0200
@@ -26,6 +26,7 @@
 #include <linux/delay.h>
 #include <linux/string.h>
 #include <linux/firmware.h>
+#include <linux/slab.h>
 #include <asm/div64.h>
 
 #include "dvb_frontend.h"
--- v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/dvb-pll.c~	2009-07-21 10:03:02.000000000 +0200
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/dvb-pll.c	2010-05-05 23:04:09.301766763 +0200
@@ -19,6 +19,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/dvb/frontend.h>
 #include <asm/types.h>
 #include "compat.h"
--- v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/ec100.c~	2009-11-18 18:00:07.000000000 +0100
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/ec100.c	2010-05-05 23:51:25.730367097 +0200
@@ -19,6 +19,7 @@
  *
  */
 
+#include <linux/slab.h>
 #include "dvb_frontend.h"
 #include "ec100_priv.h"
 #include "ec100.h"
--- v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/itd1000.c~	2008-05-08 10:29:13.000000000 +0200
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/itd1000.c	2010-05-05 23:35:34.325806184 +0200
@@ -22,6 +22,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <linux/dvb/frontend.h>
 #include <linux/i2c.h>
 
--- v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/lgdt3304.c~	2009-09-22 14:23:49.000000000 +0200
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/lgdt3304.c	2010-05-05 23:24:05.109812755 +0200
@@ -8,6 +8,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include "dvb_frontend.h"
 #include "lgdt3304.h"
 
--- v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/lgdt3305.c~	2009-05-30 10:43:34.000000000 +0200
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/lgdt3305.c	2010-05-05 23:24:49.269814998 +0200
@@ -21,6 +21,7 @@
 
 #include <asm/div64.h>
 #include "compat.h"
+#include <linux/slab.h>
 #include <linux/dvb/frontend.h>
 #include "dvb_math.h"
 #include "lgdt3305.h"
--- v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/lgs8gxx.c~	2009-12-15 12:00:31.000000000 +0100
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/lgs8gxx.c	2010-05-05 23:40:02.158045242 +0200
@@ -23,6 +23,7 @@
  *
  */
 
+#include <linux/slab.h>
 #include <asm/div64.h>
 
 #include "dvb_frontend.h"
--- v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/mb86a16.c~	2009-12-17 12:23:31.000000000 +0100
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/mb86a16.c	2010-05-05 23:52:38.961747498 +0200
@@ -19,6 +19,7 @@
 */
 
 #include <linux/init.h>
+#include <linux/slab.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
--- v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/s921_module.c~	2009-09-22 14:23:49.000000000 +0200
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/s921_module.c	2010-05-05 21:59:28.750040677 +0200
@@ -10,6 +10,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include "dvb_frontend.h"
 #include "s921_module.h"
 #include "s921_core.h"
--- v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/stb0899_drv.c~	2009-12-15 12:00:31.000000000 +0100
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/stb0899_drv.c	2010-05-05 22:10:05.658089756 +0200
@@ -23,6 +23,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
+#include <linux/slab.h>
 
 #include <linux/dvb/frontend.h>
 #include "dvb_frontend.h"
--- v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/stb6000.c~	2008-10-13 21:12:56.000000000 +0200
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/stb6000.c	2010-05-05 23:44:38.437780934 +0200
@@ -21,6 +21,7 @@
   */
 
 #include <linux/module.h>
+#include <linux/slab.h>
 #include "compat.h"
 #include <linux/dvb/frontend.h>
 #include <asm/types.h>
--- v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/stb6100.c~	2009-08-23 10:40:02.000000000 +0200
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/stb6100.c	2010-05-05 23:06:17.985743817 +0200
@@ -20,6 +20,7 @@
 */
 
 #include <linux/init.h>
+#include <linux/slab.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
--- v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/stv090x.c~	2010-03-14 09:47:00.000000000 +0100
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/stv090x.c	2010-05-05 23:45:57.921741856 +0200
@@ -20,6 +20,7 @@
 */
 
 #include <linux/init.h>
+#include <linux/slab.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
--- v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/stv6110.c~	2009-11-18 18:00:07.000000000 +0100
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/stv6110.c	2010-05-05 23:45:18.182014048 +0200
@@ -23,6 +23,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/dvb/frontend.h>
 
 #include <linux/types.h>
--- v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/stv6110x.c~	2010-03-14 09:47:00.000000000 +0100
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/stv6110x.c	2010-05-05 23:50:39.665892578 +0200
@@ -21,6 +21,7 @@
 */
 
 #include <linux/init.h>
+#include <linux/slab.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
--- v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/tda665x.c~	2010-02-22 09:53:30.000000000 +0100
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/tda665x.c	2010-05-05 23:39:11.533794540 +0200
@@ -18,6 +18,7 @@
 */
 
 #include <linux/init.h>
+#include <linux/slab.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 
--- v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/tda8261.c~	2010-01-17 10:59:55.000000000 +0100
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/tda8261.c	2010-05-05 23:28:51.641746978 +0200
@@ -21,6 +21,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/slab.h>
 
 #include "dvb_frontend.h"
 #include "tda8261.h"
--- v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/tda826x.c~	2008-04-22 12:09:46.000000000 +0200
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/tda826x.c	2010-05-05 23:27:55.206060432 +0200
@@ -21,6 +21,7 @@
   */
 
 #include <linux/module.h>
+#include <linux/slab.h>
 #include "compat.h"
 #include <linux/dvb/frontend.h>
 #include <asm/types.h>
--- v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/tua6100.c~	2008-04-12 14:02:13.000000000 +0200
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/tua6100.c	2010-05-05 23:34:17.801757479 +0200
@@ -29,6 +29,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/dvb/frontend.h>
 #include <asm/types.h>
 #include "compat.h"
--- v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/zl10036.c~	2010-01-14 10:54:20.000000000 +0100
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/frontends/zl10036.c	2010-05-05 23:17:20.337826424 +0200
@@ -28,6 +28,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/dvb/frontend.h>
 #include <linux/types.h>
 #include "compat.h"
--- v4l-dvb-hg20100429_2331/linux/drivers/media/IR/ir-keytable.c~	2010-03-19 10:39:28.000000000 +0100
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/IR/ir-keytable.c	2010-05-05 21:50:15.285787790 +0200
@@ -13,6 +13,7 @@
  */
 
 
+#include <linux/slab.h>
 #include <linux/input.h>
 #include "compat.h"
 #include <media/ir-common.h>
--- v4l-dvb-hg20100429_2331/linux/drivers/media/IR/ir-sysfs.c~	2010-04-15 09:28:33.000000000 +0200
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/IR/ir-sysfs.c	2010-05-05 21:54:33.137880132 +0200
@@ -13,6 +13,7 @@
  */
 
 #if LINUX_VERSION_CODE > KERNEL_VERSION(2, 6, 31)
+#include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/device.h>
 #include "compat.h"
--- v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/siano/smscoreapi.c~	2010-01-14 10:54:20.000000000 +0100
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/siano/smscoreapi.c	2010-05-05 22:05:51.822117430 +0200
@@ -27,6 +27,7 @@
 #include <linux/moduleparam.h>
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <linux/io.h>
 
 #include <linux/firmware.h>
--- v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/siano/smsdvb.c~	2009-12-26 02:07:22.000000000 +0100
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/siano/smsdvb.c	2010-05-06 00:04:03.741814675 +0200
@@ -20,6 +20,7 @@ along with this program.  If not, see <h
 ****************************************************************/
 
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <linux/init.h>
 
 #include "dmxdev.h"
--- v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/siano/smssdio.c~	2009-12-15 12:00:31.000000000 +0100
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/siano/smssdio.c	2010-05-06 00:04:55.089865583 +0200
@@ -35,6 +35,7 @@
 #include <linux/moduleparam.h>
 #include <linux/firmware.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <linux/mmc/card.h>
 #include <linux/mmc/sdio_func.h>
 #include <linux/mmc/sdio_ids.h>
--- v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/siano/smsusb.c~	2009-12-15 12:00:31.000000000 +0100
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/siano/smsusb.c	2010-05-06 00:02:47.617821886 +0200
@@ -21,6 +21,7 @@ along with this program.  If not, see <h
 
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/firmware.h>
 
--- v4l-dvb-hg20100429_2331/linux/sound/i2c/other/tea575x-tuner.c~	2009-12-15 12:00:32.000000000 +0100
+++ v4l-dvb-hg20100429_2331/linux/sound/i2c/other/tea575x-tuner.c	2010-05-05 22:20:13.093808059 +0200
@@ -24,6 +24,7 @@
 #include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/init.h>
+#include <linux/slab.h>
 #include <linux/version.h>
 #include "compat.h"
 #include <sound/core.h>
--- v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/ttusb-dec/ttusbdecfe.c~	2008-09-28 10:00:50.000000000 +0200
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/dvb/ttusb-dec/ttusbdecfe.c	2010-05-05 23:57:39.217928425 +0200
@@ -19,6 +19,7 @@
  *
  */
 
+#include <linux/slab.h>
 #include "dvb_frontend.h"
 #include "ttusbdecfe.h"
 
--- v4l-dvb-hg20100429_2331/linux/drivers/media/common/tuners/max2165.c~	2009-12-11 10:06:37.000000000 +0100
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/common/tuners/max2165.c	2010-05-05 22:53:50.518429320 +0200
@@ -23,6 +23,7 @@
 #include <linux/moduleparam.h>
 #include <linux/videodev2.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <linux/dvb/frontend.h>
 #include <linux/i2c.h>
 
--- v4l-dvb-hg20100429_2331/linux/drivers/media/common/tuners/mc44s803.c~	2009-02-10 09:06:58.000000000 +0100
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/common/tuners/mc44s803.c	2010-05-05 22:54:47.410257079 +0200
@@ -21,6 +21,7 @@
 
 #include <linux/module.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <linux/dvb/frontend.h>
 #include <linux/i2c.h>
 
--- v4l-dvb-hg20100429_2331/linux/drivers/media/common/tuners/mt2060.c~	2009-02-18 10:08:34.000000000 +0100
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/common/tuners/mt2060.c	2010-05-05 22:40:30.493992368 +0200
@@ -23,6 +23,7 @@
 
 #include <linux/module.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <linux/dvb/frontend.h>
 #include <linux/i2c.h>
 #include "compat.h"
--- v4l-dvb-hg20100429_2331/linux/drivers/media/common/tuners/mt20xx.c~	2009-02-27 08:20:17.000000000 +0100
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/common/tuners/mt20xx.c	2010-05-05 21:34:33.353900782 +0200
@@ -5,6 +5,7 @@
  * This "mt20xx" module was split apart from the original "tuner" module.
  */
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <linux/i2c.h>
 #include "compat.h"
 #include <linux/videodev2.h>
--- v4l-dvb-hg20100429_2331/linux/drivers/media/common/tuners/mt2131.c~	2008-08-30 20:45:28.000000000 +0200
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/common/tuners/mt2131.c	2010-05-05 22:47:19.101872884 +0200
@@ -21,6 +21,7 @@
 
 #include <linux/module.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <linux/dvb/frontend.h>
 #include <linux/i2c.h>
 #include "compat.h"
--- v4l-dvb-hg20100429_2331/linux/drivers/media/common/tuners/mt2266.c~	2008-04-27 14:24:32.000000000 +0200
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/common/tuners/mt2266.c	2010-05-05 22:42:16.621822969 +0200
@@ -16,6 +16,7 @@
 
 #include <linux/module.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <linux/dvb/frontend.h>
 #include <linux/i2c.h>
 #include "compat.h"
--- v4l-dvb-hg20100429_2331/linux/drivers/media/common/tuners/mxl5007t.c~	2009-11-24 09:41:28.000000000 +0100
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/common/tuners/mxl5007t.c	2010-05-05 22:52:42.653985278 +0200
@@ -19,6 +19,7 @@
  */
 
 #include <linux/i2c.h>
+#include <linux/slab.h>
 #include <linux/types.h>
 #include "compat.h"
 #include <linux/videodev2.h>
--- v4l-dvb-hg20100429_2331/linux/drivers/media/common/tuners/qt1010.c~	2009-07-28 22:49:32.000000000 +0200
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/common/tuners/qt1010.c	2010-05-05 22:48:50.393947994 +0200
@@ -18,6 +18,7 @@
  *  along with this program; if not, write to the Free Software
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
+#include <linux/slab.h>
 #include "qt1010.h"
 #include "compat.h"
 #include "qt1010_priv.h"
--- v4l-dvb-hg20100429_2331/linux/drivers/media/common/tuners/tda18271-fe.c~	2009-11-01 11:43:34.000000000 +0100
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/common/tuners/tda18271-fe.c	2010-05-05 22:23:45.502365117 +0200
@@ -19,6 +19,7 @@
 */
 
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include "compat.h"
 #include <linux/videodev2.h>
 #include "tda18271-priv.h"
--- v4l-dvb-hg20100429_2331/linux/drivers/media/common/tuners/tda827x.c~	2009-03-29 17:07:02.000000000 +0200
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/common/tuners/tda827x.c	2010-05-05 21:44:23.029756296 +0200
@@ -19,6 +19,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/slab.h>
 #include <asm/types.h>
 #include "compat.h"
 #include <linux/dvb/frontend.h>
--- v4l-dvb-hg20100429_2331/linux/drivers/media/common/tuners/tda8290.c~	2010-01-14 10:54:20.000000000 +0100
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/common/tuners/tda8290.c	2010-05-05 21:37:57.089886093 +0200
@@ -21,6 +21,7 @@
 */
 
 #include <linux/i2c.h>
+#include <linux/slab.h>
 #include <linux/delay.h>
 #include "compat.h"
 #include <linux/videodev2.h>
--- v4l-dvb-hg20100429_2331/linux/drivers/media/common/tuners/tea5761.c~	2009-02-27 08:20:17.000000000 +0100
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/common/tuners/tea5761.c	2010-05-05 21:42:15.061925129 +0200
@@ -8,6 +8,7 @@
  */
 
 #include <linux/i2c.h>
+#include <linux/slab.h>
 #include <linux/delay.h>
 #include "compat.h"
 #include <linux/videodev2.h>
--- v4l-dvb-hg20100429_2331/linux/drivers/media/common/tuners/tea5767.c~	2009-02-27 08:20:17.000000000 +0100
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/common/tuners/tea5767.c	2010-05-05 21:40:14.441926433 +0200
@@ -11,6 +11,7 @@
  */
 
 #include <linux/i2c.h>
+#include <linux/slab.h>
 #include <linux/delay.h>
 #include "compat.h"
 #include <linux/videodev2.h>
--- v4l-dvb-hg20100429_2331/linux/drivers/media/common/tuners/tuner-xc2028.c~	2010-03-04 15:53:18.000000000 +0100
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/common/tuners/tuner-xc2028.c	2010-05-05 20:59:14.877872485 +0200
@@ -15,6 +15,7 @@
 #include <linux/delay.h>
 #include <media/tuner.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 #include "compat.h"
 #include <asm/unaligned.h>
 #include "tuner-i2c.h"
--- v4l-dvb-hg20100429_2331/linux/drivers/media/common/tuners/xc5000.c~	2009-10-29 10:31:40.000000000 +0100
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/common/tuners/xc5000.c	2010-05-05 22:34:48.385814194 +0200
@@ -25,6 +25,7 @@
 #include <linux/moduleparam.h>
 #include <linux/videodev2.h>
 #include <linux/delay.h>
+#include <linux/slab.h>
 #include <linux/dvb/frontend.h>
 #include <linux/i2c.h>
 
--- v4l-dvb-hg20100429_2331/linux/drivers/media/video/videobuf-dma-contig.c~	2009-12-11 10:06:37.000000000 +0100
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/video/videobuf-dma-contig.c	2010-05-05 22:59:24.289809381 +0200
@@ -20,6 +20,7 @@
 #include <linux/pagemap.h>
 #include <linux/dma-mapping.h>
 #include <linux/sched.h>
+#include <linux/slab.h>
 #include <media/videobuf-dma-contig.h>
 #include "compat.h"
 
--- v4l-dvb-hg20100429_2331/linux/drivers/media/video/stk-webcam.h~	2008-10-14 09:48:05.000000000 +0200
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/video/stk-webcam.h	2010-05-05 22:15:22.209798017 +0200
@@ -23,6 +23,7 @@
 #define STKWEBCAM_H
 
 #include <linux/usb.h>
+#include <linux/slab.h>
 #include <media/v4l2-common.h>
 
 #define DRIVER_VERSION		"v0.0.1"
--- v4l-dvb-hg20100429_2331/linux/drivers/media/video/uvc/uvc_ctrl.c~	2010-04-07 10:26:36.000000000 +0200
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/video/uvc/uvc_ctrl.c	2010-05-05 22:27:56.698531499 +0200
@@ -20,6 +20,7 @@
 #include <linux/usb.h>
 #include <linux/videodev2.h>
 #include <linux/vmalloc.h>
+#include <linux/slab.h>
 #include <linux/wait.h>
 #include <asm/atomic.h>
 
--- v4l-dvb-hg20100429_2331/linux/drivers/media/video/uvc/uvc_status.c~	2009-08-06 09:45:31.000000000 +0200
+++ v4l-dvb-hg20100429_2331/linux/drivers/media/video/uvc/uvc_status.c	2010-05-05 22:31:01.833770880 +0200
@@ -13,6 +13,7 @@
 
 #include <linux/kernel.h>
 #include <linux/input.h>
+#include <linux/slab.h>
 #include <linux/usb.h>
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2, 6, 18)
 #include <linux/usb_input.h>
