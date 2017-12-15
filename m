Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:39183 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755048AbdLOMlZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 07:41:25 -0500
Received: by mail-pg0-f68.google.com with SMTP id w7so5722265pgv.6
        for <linux-media@vger.kernel.org>; Fri, 15 Dec 2017 04:41:25 -0800 (PST)
Received: from ubuntu.windy (c122-106-151-124.carlnfd1.nsw.optusnet.com.au. [122.106.151.124])
        by smtp.gmail.com with ESMTPSA id y127sm10579078pgb.86.2017.12.15.04.41.22
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 15 Dec 2017 04:41:23 -0800 (PST)
Date: Fri, 15 Dec 2017 23:41:13 +1100
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: linux-media@vger.kernel.org
Subject: more build failures
Message-ID: <20171215124111.GA29657@ubuntu.windy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Don't get me wrong, I appreciate the vast amount of work going on here.
Just letting you know what I'm seeing.

+ date
Friday 15 December  23:28:52 AEDT 2017
+ uname -a
Linux ubuntu 4.4.0-103-generic #126-Ubuntu SMP Mon Dec 4 16:23:28 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
+ cat /proc/version_signature
Ubuntu 4.4.0-103.126-generic 4.4.98

...

+ git --no-pager log -1
commit 4058fea6b2507661d66af5298c048d7c55338f42
Author: Jasmin Jessich <jasmin@anw.at>
Date:   Tue Dec 12 12:49:01 2017 -0500

    fixup v3.13_ddbridge_pcimsi.patch
    
    Required after the ddbridge 0.9.32 bump in media_tree.
    
    Signed-off-by: Jasmin Jessich <jasmin@anw.at>
    Signed-off-by: Daniel Scheller <d.scheller@gmx.net>

...

+ git --no-pager log -1
commit 0393e735649dc41358adb7b603bd57dad1ed3260
Author: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date:   Tue Oct 17 13:15:54 2017 -0400

    media: uvcvideo: Stream error events carry no data
    
    According to the UVC specification, stream error events carry no data.
    Fix a buffer overflow (that should be harmless given data alignment)
    when reporting the stream error event by removing the data byte from the
    message.
    
    Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

...

$ make allyesconfig
make -C /home/me/git/clones/media_build/v4l allyesconfig
make[1]: Entering directory '/home/me/git/clones/media_build/v4l'
No version yet, using 4.4.0-103-generic
make[2]: Entering directory '/home/me/git/clones/media_build/linux'
Syncing with dir ../media/
Applying patches for kernel 4.4.0-103-generic
patch -s -f -N -p1 -i ../backports/api_version.patch
patch -s -f -N -p1 -i ../backports/pr_fmt.patch
patch -s -f -N -p1 -i ../backports/debug.patch
patch -s -f -N -p1 -i ../backports/drx39xxj.patch
patch -s -f -N -p1 -i ../backports/v4.14_compiler_h.patch
patch -s -f -N -p1 -i ../backports/v4.14_saa7146_timer_cast.patch
patch -s -f -N -p1 -i ../backports/v4.14_module_param_call.patch
patch -s -f -N -p1 -i ../backports/v4.12_revert_solo6x10_copykerneluser.patch
patch -s -f -N -p1 -i ../backports/v4.10_sched_signal.patch
1 out of 1 hunk FAILED
The text leading up to this was:
--------------------------
|diff --git a/drivers/staging/media/lirc/lirc_zilog.c b/drivers/staging/media/lirc/lirc_zilog.c
|index 015e41bd036e..fd61081b47d9 100644
|--- a/drivers/staging/media/lirc/lirc_zilog.c
|+++ b/drivers/staging/media/lirc/lirc_zilog.c
--------------------------
No file to patch.  Skipping patch.
1 out of 1 hunk ignored
Makefile:130: recipe for target 'apply_patches' failed
make[2]: *** [apply_patches] Error 1
make[2]: Leaving directory '/home/me/git/clones/media_build/linux'
Makefile:374: recipe for target 'allyesconfig' failed
make[1]: *** [allyesconfig] Error 2
make[1]: Leaving directory '/home/me/git/clones/media_build/v4l'
Makefile:26: recipe for target 'allyesconfig' failed
make: *** [allyesconfig] Error 2
can't select all drivers at ./build line 525
+ status=29
+ date
Friday 15 December  23:29:17 AEDT 2017
+ [ 0 = 29 ]
