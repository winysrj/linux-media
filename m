Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:41391 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab2GNW3x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Jul 2012 18:29:53 -0400
Received: by obbuo13 with SMTP id uo13so7031102obb.19
        for <linux-media@vger.kernel.org>; Sat, 14 Jul 2012 15:29:52 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 14 Jul 2012 18:29:52 -0400
Message-ID: <CALzAhNVDnyjwNqcWDcgv2kgQ97Hr0gArk8=V_mL62J0cD0Ydag@mail.gmail.com>
Subject: staging/for_v3.6 is currently broken
From: Steven Toth <stoth@kernellabs.com>
To: Mauro Chehab <mchehab@infradead.org>
Cc: Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Looks like the new union in v4l2_ioctl_info breaks things.

-bash-4.1$ make -j6
make[1]: Nothing to be done for `all'.
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/generated/compile.h
  CC      drivers/media/video/v4l2-ioctl.o
drivers/media/video/v4l2-ioctl.c:1848:517: error: unknown field ‘func’
specified in initializer
drivers/media/video/v4l2-ioctl.c:1848:517: warning: missing braces
around initializer
drivers/media/video/v4l2-ioctl.c:1848:517: warning: (near
initialization for ‘v4l2_ioctls[0].<anonymous>’)
drivers/media/video/v4l2-ioctl.c:1848:517: warning: initialization
makes integer from pointer without a cast
drivers/media/video/v4l2-ioctl.c:1849:644: error: unknown field ‘func’
specified in initializer
drivers/media/video/v4l2-ioctl.c:1849:644: warning: initialization
makes integer from pointer without a cast

Removing the union and the code compiles, although that probably
wasn't the original authors intension.

diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
index 70e0efb..1f090c4 100644
--- a/drivers/media/video/v4l2-ioctl.c
+++ b/drivers/media/video/v4l2-ioctl.c
@@ -1802,11 +1802,9 @@ struct v4l2_ioctl_info {
        unsigned int ioctl;
        u32 flags;
        const char * const name;
-       union {
                u32 offset;
                int (*func)(const struct v4l2_ioctl_ops *ops,
                                struct file *file, void *fh, void *p);
-       };
        void (*debug)(const void *arg, bool write_only);
 };

FYI

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
