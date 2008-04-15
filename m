Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3FH0arK015489
	for <video4linux-list@redhat.com>; Tue, 15 Apr 2008 13:00:51 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3FGxsPn006538
	for <video4linux-list@redhat.com>; Tue, 15 Apr 2008 12:59:54 -0400
Date: Tue, 15 Apr 2008 13:59:33 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Toralf =?UTF-8?B?RsO2cnN0ZXI=?= <toralf.foerster@gmx.de>
Message-ID: <20080415135933.1a85fd2e@gaivota>
In-Reply-To: <200804061448.42888.toralf.foerster@gmx.de>
References: <200804061448.42888.toralf.foerster@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: build issue #469 for v2.6.25-rc8-166-g6fdf5e6 in pms.c :
 undefined reference to `video_usercopy'
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Hi Toralf,

On Sun, 6 Apr 2008 14:48:40 +0200
Toralf Förster <toralf.foerster@gmx.de> wrote:

> drivers/built-in.o: In function `pms_ioctl':
> pms.c:(.text+0x44947): undefined reference to `video_usercopy'
> drivers/built-in.o: In function `pms_do_ioctl':
> pms.c:(.text+0x44974): undefined reference to `video_devdata'
> drivers/built-in.o: In function `pms_read':
> pms.c:(.text+0x45025): undefined reference to `video_devdata'
> drivers/built-in.o: In function `cleanup_pms_module':
> pms.c:(.exit.text+0x5fe): undefined reference to `video_unregister_device'
> drivers/built-in.o: In function `init_pms_cards':
> pms.c:(.init.text+0x610d): undefined reference to `video_register_device'
> drivers/built-in.o:(.rodata+0x2ec8): undefined reference to `v4l_compat_ioctl32'
> drivers/built-in.o:(.rodata+0x2ed0): undefined reference to `video_exclusive_open'
> drivers/built-in.o:(.rodata+0x2ed8): undefined reference to `video_exclusive_release'
> make: *** [.tmp_vmlinux1] Error 1

Please try the enclosed patch. It should fix the issue.

Cheers,
Mauro

---
Fix build when CONFIG_VIDEO_PMS=y and VIDEO_V4L2_COMMON=m

Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>

diff -r 34e5c8ed9fcb linux/drivers/media/Kconfig
--- a/linux/drivers/media/Kconfig	Tue Apr 15 12:12:36 2008 -0300
+++ b/linux/drivers/media/Kconfig	Tue Apr 15 13:32:54 2008 -0300
@@ -30,7 +30,7 @@ config VIDEO_V4L2_COMMON
 	depends on (I2C || I2C=n) && VIDEO_DEV
 	default (I2C || I2C=n) && VIDEO_DEV
 
-config VIDEO_V4L1
+config VIDEO_ALLOW_V4L1
 	bool "Enable Video For Linux API 1 (DEPRECATED)"
 	depends on VIDEO_DEV && VIDEO_V4L2_COMMON
 	default VIDEO_DEV && VIDEO_V4L2_COMMON
@@ -59,9 +59,14 @@ config VIDEO_V4L1_COMPAT
 	  If you are unsure as to whether this is required, answer Y.
 
 config VIDEO_V4L2
-	bool
+	tristate
 	depends on VIDEO_DEV && VIDEO_V4L2_COMMON
 	default VIDEO_DEV && VIDEO_V4L2_COMMON
+
+config VIDEO_V4L1
+	tristate
+	depends on VIDEO_DEV && VIDEO_V4L2_COMMON && VIDEO_ALLOW_V4L1
+	default VIDEO_DEV && VIDEO_V4L2_COMMON && VIDEO_ALLOW_V4L1
 
 source "drivers/media/video/Kconfig"
 

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
