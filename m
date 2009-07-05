Return-path: <linux-media-owner@vger.kernel.org>
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:49323 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbZGEP0G (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jul 2009 11:26:06 -0400
Date: Mon, 6 Jul 2009 00:25:57 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Wu Zhangjin <wuzhangjin@gmail.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
	Krzysztof Helt <krzysztof.h1@wp.pl>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ralf Baechle <ralf@linux-mips.org>, ???? <yanh@lemote.com>,
	zhangfx <zhangfx@lemote.com>
Subject: Re: [BUG] drivers/video/sis: deadlock introduced by "fbdev: add mutex for fb_mmap locking"
Message-ID: <20090705152557.GA10588@linux-sh.org>
References: <1246785112.14240.34.camel@falcon> <alpine.LFD.2.01.0907050715490.3210@localhost.localdomain> <20090705145203.GA8326@linux-sh.org> <alpine.LFD.2.01.0907050756280.3210@localhost.localdomain> <20090705150134.GB8326@linux-sh.org> <alpine.LFD.2.01.0907050816110.3210@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0907050816110.3210@localhost.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jul 05, 2009 at 08:19:40AM -0700, Linus Torvalds wrote:
> 
> 
> On Mon, 6 Jul 2009, Paul Mundt wrote:
> > >
> > > Why not "lock" as well?
> > 
> > I had that initially, but matroxfb will break if we do that, and
> > presently nothing cares about trying to take ->lock that early on.
> 
> I really would rather have consistency than some odd rules like that.
> 
> In particular - if matroxfb is different and needs its own lock 
> initialization because it doesn't use the common allocation routine, then 
> please make _that_ consistent too. Rather than have it special-case just 
> one lock that it needs to initialize separately, make it clear that since 
> it does its own allocations it needs to initialize _everything_ 
> separately.
> 
Ok, here is an updated version with an updated matroxfb and the sm501fb
change reverted.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 drivers/video/fbmem.c                |    2 --
 drivers/video/fbsysfs.c              |    3 +++
 drivers/video/matrox/matroxfb_base.c |    1 +
 drivers/video/sm501fb.c              |    2 --
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index 53ea056..53eb396 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1513,8 +1513,6 @@ register_framebuffer(struct fb_info *fb_info)
 		if (!registered_fb[i])
 			break;
 	fb_info->node = i;
-	mutex_init(&fb_info->lock);
-	mutex_init(&fb_info->mm_lock);
 
 	fb_info->dev = device_create(fb_class, fb_info->device,
 				     MKDEV(FB_MAJOR, i), NULL, "fb%d", i);
diff --git a/drivers/video/fbsysfs.c b/drivers/video/fbsysfs.c
index d4a2c11..afc04df 100644
--- a/drivers/video/fbsysfs.c
+++ b/drivers/video/fbsysfs.c
@@ -62,6 +62,9 @@ struct fb_info *framebuffer_alloc(size_t size, struct device *dev)
 	mutex_init(&info->bl_curve_mutex);
 #endif
 
+	mutex_init(&info->lock);
+	mutex_init(&info->mm_lock);
+
 	return info;
 #undef PADDING
 #undef BYTES_PER_LONG
diff --git a/drivers/video/matrox/matroxfb_base.c b/drivers/video/matrox/matroxfb_base.c
index 59c3a2e..76bc51b 100644
--- a/drivers/video/matrox/matroxfb_base.c
+++ b/drivers/video/matrox/matroxfb_base.c
@@ -2083,6 +2083,7 @@ static int matroxfb_probe(struct pci_dev* pdev, const struct pci_device_id* dumm
 	spin_lock_init(&ACCESS_FBINFO(lock.accel));
 	init_rwsem(&ACCESS_FBINFO(crtc2.lock));
 	init_rwsem(&ACCESS_FBINFO(altout.lock));
+	mutex_init(&ACCESS_FBINFO(fbcon).lock);
 	mutex_init(&ACCESS_FBINFO(fbcon).mm_lock);
 	ACCESS_FBINFO(irq_flags) = 0;
 	init_waitqueue_head(&ACCESS_FBINFO(crtc1.vsync.wait));
diff --git a/drivers/video/sm501fb.c b/drivers/video/sm501fb.c
index 16d4f4c..98f24f0 100644
--- a/drivers/video/sm501fb.c
+++ b/drivers/video/sm501fb.c
@@ -1624,8 +1624,6 @@ static int __devinit sm501fb_start_one(struct sm501fb_info *info,
 	if (!fbi)
 		return 0;
 
-	mutex_init(&info->fb[head]->mm_lock);
-
 	ret = sm501fb_init_fb(info->fb[head], head, drvname);
 	if (ret) {
 		dev_err(info->dev, "cannot initialise fb %s\n", drvname);
