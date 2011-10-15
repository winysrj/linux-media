Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpo05.poczta.onet.pl ([213.180.142.136]:40592 "EHLO
	smtpo05.poczta.onet.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab1JOUzZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Oct 2011 16:55:25 -0400
Message-ID: <4E99F33B.3050708@poczta.onet.pl>
Date: Sat, 15 Oct 2011 22:55:23 +0200
From: Piotr Chmura <chmooreck@poczta.onet.pl>
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Greg KH <gregkh@suse.de>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mauro Carvalho Chehab <maurochehab@gmail.com>,
	Patrick Dickey <pdickeybeta@gmail.com>,
	LMML <linux-media@vger.kernel.org>, devel@driverdev.osuosl.org
Subject: [PATCH 7/7] staging/as102: cleanup - get rid unnecessary LINUX and
 WIN32 defines
References: <4E7F1FB5.5030803@gmail.com> <CAGoCfixneQG=S5wy2qZZ50+PB-QNTFx=GLM7RYPuxfXtUy6Ecg@mail.gmail.com> <4E7FF0A0.7060004@gmail.com> <CAGoCfizyLgpEd_ei-SYEf6WWs5cygQJNjKPNPOYOQUqF773D4Q@mail.gmail.com> <20110927094409.7a5fcd5a@stein> <20110927174307.GD24197@suse.de> <20110927213300.6893677a@stein> <4E999733.2010802@poczta.onet.pl>
In-Reply-To: <4E999733.2010802@poczta.onet.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

staging/as102: cleanup - get rid unnecessary LINUX and WIN32 defines

Cleanup code: Remove of unnecessary defines WIN32 and LINUX.
We are always on linux so code (includes) for WIN32 compatibility is totally useless.

Signed-off-by: Piotr Chmura<chmooreck@poczta.onet.pl>
Cc: Devin Heitmueller<dheitmueller@kernellabs.com>
Cc: Greg HK<gregkh@suse.de>

diff -Nur linux.as102.06-editor/drivers/staging/as102/as10x_cmd.c linux.as102.07-defines/drivers/staging/as102/as10x_cmd.c
--- linux.as102.06-editor/drivers/staging/as102/as10x_cmd.c	2011-10-14 23:25:27.000000000 +0200
+++ linux.as102.07-defines/drivers/staging/as102/as10x_cmd.c	2011-10-14 23:46:57.000000000 +0200
@@ -18,29 +18,8 @@
   * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
   */

-#if defined(LINUX)&&  defined(__KERNEL__) /* linux kernel implementation */
  #include<linux/kernel.h>
  #include "as102_drv.h"
-#elif defined(WIN32)
-#if defined(__BUILDMACHINE__)&&  (__BUILDMACHINE__ == WinDDK)
-/* win32 ddk implementation */
-#include "wdm.h"
-#include "Device.h"
-#include "endian_mgmt.h" /* FIXME */
-#else /* win32 sdk implementation */
-#include<windows.h>
-#include "types.h"
-#include "util.h"
-#include "as10x_handle.h"
-#include "endian_mgmt.h"
-#endif
-#else /* all other cases */
-#include<string.h>
-#include "types.h"
-#include "util.h"
-#include "as10x_handle.h"
-#include "endian_mgmt.h" /* FIXME */
-#endif /* __KERNEL__ */

  #include "as10x_types.h"
  #include "as10x_cmd.h"
diff -Nur linux.as102.06-editor/drivers/staging/as102/as10x_cmd_cfg.c linux.as102.07-defines/drivers/staging/as102/as10x_cmd_cfg.c
--- linux.as102.06-editor/drivers/staging/as102/as10x_cmd_cfg.c	2011-10-14 23:24:05.000000000 +0200
+++ linux.as102.07-defines/drivers/staging/as102/as10x_cmd_cfg.c	2011-10-14 23:46:32.000000000 +0200
@@ -17,29 +17,8 @@
   * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
   */

-#if defined(LINUX)&&  defined(__KERNEL__) /* linux kernel implementation */
  #include<linux/kernel.h>
  #include "as102_drv.h"
-#elif defined(WIN32)
-#if defined(__BUILDMACHINE__)&&  (__BUILDMACHINE__ == WinDDK)
-/* win32 ddk implementation */
-#include "wdm.h"
-#include "Device.h"
-#include "endian_mgmt.h" /* FIXME */
-#else /* win32 sdk implementation */
-#include<windows.h>
-#include "types.h"
-#include "util.h"
-#include "as10x_handle.h"
-#include "endian_mgmt.h"
-#endif
-#else /* all other cases */
-#include<string.h>
-#include "types.h"
-#include "util.h"
-#include "as10x_handle.h"
-#include "endian_mgmt.h" /* FIXME */
-#endif /* __KERNEL__ */

  #include "as10x_types.h"
  #include "as10x_cmd.h"
diff -Nur linux.as102.06-editor/drivers/staging/as102/as10x_cmd_stream.c linux.as102.07-defines/drivers/staging/as102/as10x_cmd_stream.c
--- linux.as102.06-editor/drivers/staging/as102/as10x_cmd_stream.c	2011-10-14 23:24:32.000000000 +0200
+++ linux.as102.07-defines/drivers/staging/as102/as10x_cmd_stream.c	2011-10-14 23:46:46.000000000 +0200
@@ -16,28 +16,8 @@
   * along with this program; if not, write to the Free Software
   * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
   */
-#if defined(LINUX)&&  defined(__KERNEL__) /* linux kernel implementation */
  #include<linux/kernel.h>
  #include "as102_drv.h"
-#elif defined(WIN32)
-#if defined(DDK) /* win32 ddk implementation */
-#include "wdm.h"
-#include "Device.h"
-#include "endian_mgmt.h" /* FIXME */
-#else /* win32 sdk implementation */
-#include<windows.h>
-#include "types.h"
-#include "util.h"
-#include "as10x_handle.h"
-#include "endian_mgmt.h"
-#endif
-#else /* all other cases */
-#include<string.h>
-#include "types.h"
-#include "util.h"
-#include "as10x_handle.h"
-#include "endian_mgmt.h" /* FIXME */
-#endif /* __KERNEL__ */

  #include "as10x_cmd.h"

diff -Nur linux.as102.06-editor/drivers/staging/as102/Makefile linux.as102.07-defines/drivers/staging/as102/Makefile
--- linux.as102.06-editor/drivers/staging/as102/Makefile	2011-10-14 17:55:02.000000000 +0200
+++ linux.as102.07-defines/drivers/staging/as102/Makefile	2011-10-14 23:47:30.000000000 +0200
@@ -2,4 +2,4 @@

  obj-$(CONFIG_DVB_AS102) += dvb-as102.o

-EXTRA_CFLAGS += -DLINUX -DCONFIG_AS102_USB -Idrivers/media/dvb/dvb-core
+EXTRA_CFLAGS += -DCONFIG_AS102_USB -Idrivers/media/dvb/dvb-core



