Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:36767 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbbGREvS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jul 2015 00:51:18 -0400
Received: by pdjr16 with SMTP id r16so72561287pdj.3
        for <linux-media@vger.kernel.org>; Fri, 17 Jul 2015 21:51:18 -0700 (PDT)
Received: from shambles.windy (c122-106-152-45.carlnfd1.nsw.optusnet.com.au. [122.106.152.45])
        by smtp.gmail.com with ESMTPSA id da3sm13015861pdb.8.2015.07.17.21.51.15
        for <linux-media@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 Jul 2015 21:51:17 -0700 (PDT)
Date: Sat, 18 Jul 2015 14:51:03 +1000
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: linux-media@vger.kernel.org
Subject: [patch] fix failure when applying backports/debug.patch
Message-ID: <20150718045023.GA3204@shambles.windy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

backports/debug.patch has gotten out of sync with the main tree.
The last patch hunk fails:
...
Applying patches for kernel 3.13.0-57-generic
patch -s -f -N -p1 -i ../backports/api_version.patch
patch -s -f -N -p1 -i ../backports/pr_fmt.patch
patch -s -f -N -p1 -i ../backports/debug.patch
1 out of 1 hunk FAILED
make[2]: *** [apply_patches] Error 1
make[2]: Leaving directory `/home/vjm/git/clones/media_build/linux'
make[1]: *** [allyesconfig] Error 2
make[1]: Leaving directory `/home/vjm/git/clones/media_build/v4l'
make: *** [allyesconfig] Error 2
can't select all drivers at ./build line 490, <IN> line 4.



This happens because this change removed the #define DEBUG line

commit 890024ad144902bfa637f23b94b396701a88ed88
Author: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Date:   Fri Jul 3 16:11:41 2015 -0300

    [media] stk1160: Reduce driver verbosity

    These messages are not really informational, and just makes the driver's
    output too verbose. This commit changes some messages to a debug level,
    removes a really useless "driver loaded" message and finally undefines
    the DEBUG macro.

    Signed-off-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
    Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>


$ git diff e3e30f63389a319ca45161b07eb74e60f1e7ea20 890024ad144902bfa637f23b94b396701a88ed88 drivers/media/usb/stk1160/stk1160.h
diff --git a/drivers/media/usb/stk1160/stk1160.h
b/drivers/media/usb/stk1160/stk1160.h
index 3922a6c..72cc8e8 100644
--- a/drivers/media/usb/stk1160/stk1160.h
+++ b/drivers/media/usb/stk1160/stk1160.h
@@ -58,7 +58,6 @@
  * new drivers should use.
  *
  */
-#define DEBUG
 #ifdef DEBUG
 #define stk1160_dbg(fmt, args...) \
        printk(KERN_DEBUG "stk1160: " fmt,  ## args)


The following should fix the issue

diff --git a/backports/debug.patch b/backports/debug.patch
index a222783..cbd9526 100644
--- a/backports/debug.patch
+++ b/backports/debug.patch
@@ -35,7 +35,7 @@ index fb2acc5..8edffcb 100644
  #endif

 diff --git a/drivers/media/usb/stk1160/stk1160.h
b/drivers/media/usb/stk1160/stk1160.h
-index abdea48..2eed017 100644
+index 72cc8e8..323e5d7 100644
 --- a/drivers/media/usb/stk1160/stk1160.h
 +++ b/drivers/media/usb/stk1160/stk1160.h
 @@ -58,6 +58,7 @@
@@ -43,6 +43,6 @@ index abdea48..2eed017 100644
   *
   */
 +#undef DEBUG
- #define DEBUG
  #ifdef DEBUG
  #define stk1160_dbg(fmt, args...) \
+       printk(KERN_DEBUG "stk1160: " fmt,  ## args)


