Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:32947 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751237AbdBEEP5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sat, 4 Feb 2017 23:15:57 -0500
Received: by mail-wm0-f46.google.com with SMTP id t18so25730690wmt.0
        for <linux-media@vger.kernel.org>; Sat, 04 Feb 2017 20:15:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAEsFdVM=d5x-ekuvQ9BtkzanPtRmZgOwkL_f4Z2UMPLT+roDzg@mail.gmail.com>
References: <58969EF9.2000703@gmail.com> <CAEsFdVM=d5x-ekuvQ9BtkzanPtRmZgOwkL_f4Z2UMPLT+roDzg@mail.gmail.com>
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
Date: Sun, 5 Feb 2017 15:15:55 +1100
Message-ID: <CAEsFdVNv9kfAePWokrdtqF_4k2Q2rrX5FyTvORYG-emXgSYvWw@mail.gmail.com>
Subject: Re: Failure of ./build
To: Bill Atwood <williamatwood41@gmail.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bill

with this patch I can get past the errors you are seeing. Those errors
are happening because recent changes in the mainline kernel have not
been reflected in the backport patches directory.

[Patch] remove unneeded pr_fmt patches

Recently  (bbdba43f) the pr_fmt macro was removed from ivtvfb.c, and
some lirc driver
files in staging were removed entirely (2933974c..f41003a23a). Update
pr_fmt.patch
to reflect those changes.
Signed-off-by: vincent.mcintyre@gmail.com.

diff --git a/backports/pr_fmt.patch b/backports/pr_fmt.patch
index edb56f5..3f374cc 100644
--- a/backports/pr_fmt.patch
+++ b/backports/pr_fmt.patch
@@ -322,18 +322,6 @@ index adcd09b..49382d3 100644
  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

  #include "cx25821-video.h"
-diff --git a/drivers/media/pci/ivtv/ivtvfb.c b/drivers/media/pci/ivtv/ivtvfb.c
-index 8b95eef..ce1cd12 100644
---- a/drivers/media/pci/ivtv/ivtvfb.c
-+++ b/drivers/media/pci/ivtv/ivtvfb.c
-@@ -38,6 +38,7 @@
-     Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
-  */
-
-+#undef pr_fmt
- #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
- #include <linux/module.h>
 diff --git a/drivers/media/pci/saa7134/saa7134.h
b/drivers/media/pci/saa7134/saa7134.h
 index 3849083..957d000 100644
 --- a/drivers/media/pci/saa7134/saa7134.h
@@ -1270,42 +1258,6 @@ index 5f7254d..8606ced 100644
  #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

  #include <linux/input.h>
-diff --git a/drivers/staging/media/lirc/lirc_bt829.c
b/drivers/staging/media/lirc/lirc_bt829.c
-index 44f5655..a45dd88 100644
---- a/drivers/staging/media/lirc/lirc_bt829.c
-+++ b/drivers/staging/media/lirc/lirc_bt829.c
-@@ -18,6 +18,7 @@
-  *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
- */
-
-+#undef pr_fmt
- #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
- #include <linux/kernel.h>
-diff --git a/drivers/staging/media/lirc/lirc_imon.c
b/drivers/staging/media/lirc/lirc_imon.c
-index a183e68..adad0cd 100644
---- a/drivers/staging/media/lirc/lirc_imon.c
-+++ b/drivers/staging/media/lirc/lirc_imon.c
-@@ -20,6 +20,7 @@
-  *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
-  */
-
-+#undef pr_fmt
- #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
- #include <linux/errno.h>
-diff --git a/drivers/staging/media/lirc/lirc_parallel.c
b/drivers/staging/media/lirc/lirc_parallel.c
-index 3906ac6..b554d48 100644
---- a/drivers/staging/media/lirc/lirc_parallel.c
-+++ b/drivers/staging/media/lirc/lirc_parallel.c
-@@ -22,6 +22,7 @@
-  *
-  */
-
-+#undef pr_fmt
- #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-
- /*** Includes ***/
 diff --git a/drivers/staging/media/lirc/lirc_sasem.c
b/drivers/staging/media/lirc/lirc_sasem.c
 index b080fde..baa93b9 100644
 --- a/drivers/staging/media/lirc/lirc_sasem.c



However - when I apply the above, the build still falls over, at:

  CC [M]  /home/me/git/clones/media_build/v4l/lgdt3306a.o
/home/me/git/clones/media_build/v4l/lgdt3306a.c: In function 'lgdt3306a_select':
/home/me/git/clones/media_build/v4l/lgdt3306a.c:2140:30: error:
implicit declaration of function 'i2c_mux_priv'
[-Werror=implicit-function-declaration]
  struct i2c_client *client = i2c_mux_priv(muxc);
                              ^
/home/me/git/clones/media_build/v4l/lgdt3306a.c:2140:30: warning:
initialization makes pointer from integer without a cast
[-Wint-conversion]
/home/me/git/clones/media_build/v4l/lgdt3306a.c: In function
'lgdt3306a_deselect':
/home/me/git/clones/media_build/v4l/lgdt3306a.c:2148:30: warning:
initialization makes pointer from integer without a cast
[-Wint-conversion]
  struct i2c_client *client = i2c_mux_priv(muxc);
                              ^
/home/me/git/clones/media_build/v4l/lgdt3306a.c: In function 'lgdt3306a_probe':
/home/me/git/clones/media_build/v4l/lgdt3306a.c:2182:16: error:
implicit declaration of function 'i2c_mux_alloc'
[-Werror=implicit-function-declaration]
  state->muxc = i2c_mux_alloc(client->adapter, &client->dev,
                ^
/home/me/git/clones/media_build/v4l/lgdt3306a.c:2183:13: error:
'I2C_MUX_LOCKED' undeclared (first use in this function)
       1, 0, I2C_MUX_LOCKED,
             ^
/home/me/git/clones/media_build/v4l/lgdt3306a.c:2183:13: note: each
undeclared identifier is reported only once for each function it
appears in
/home/me/git/clones/media_build/v4l/lgdt3306a.c:2189:13: error:
dereferencing pointer to incomplete type 'struct i2c_mux_core'
  state->muxc->priv = client;
             ^
/home/me/git/clones/media_build/v4l/lgdt3306a.c:2190:8: error:
implicit declaration of function 'i2c_mux_add_adapter'
[-Werror=implicit-function-declaration]
  ret = i2c_mux_add_adapter(state->muxc, 0, 0, 0);
        ^
/home/me/git/clones/media_build/v4l/lgdt3306a.c: In function 'lgdt3306a_remove':
/home/me/git/clones/media_build/v4l/lgdt3306a.c:2214:2: error:
implicit declaration of function 'i2c_mux_del_adapters'
[-Werror=implicit-function-declaration]
  i2c_mux_del_adapters(state->muxc);
  ^
cc1: some warnings being treated as errors
scripts/Makefile.build:264: recipe for target
'/home/me/git/clones/media_build/v4l/lgdt3306a.o' failed
make[3]: *** [/home/me/git/clones/media_build/v4l/lgdt3306a.o] Error 1
Makefile:1420: recipe for target
'_module_/home/me/git/clones/media_build/v4l' failed
make[2]: *** [_module_/home/me/git/clones/media_build/v4l] Error 2
make[2]: Leaving directory '/usr/src/linux-headers-4.4.0-59-generic'
Makefile:51: recipe for target 'default' failed
make[1]: *** [default] Error 2
make[1]: Leaving directory '/home/me/git/clones/media_build/v4l'
Makefile:26: recipe for target 'all' failed
make: *** [all] Error 2
build failed at ./build line 491, <IN> line 4.

Fixing this is presently beyond me.
Kind regards
Vince
