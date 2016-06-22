Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36758 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbcFVLU3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2016 07:20:29 -0400
Date: Wed, 22 Jun 2016 13:18:30 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Sebastian Reichel <sre@kernel.org>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	pali.rohar@gmail.com, linux-media@vger.kernel.org
Subject: Re: Nokia N900 cameras -- pipeline setup in python (was Re: [RFC
 PATCH 00/24] Make Nokia N900 cameras working)
Message-ID: <20160622111830.GA26788@amd>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160427030850.GA17034@earth>
 <20160617164226.GA27876@amd>
 <20160617171214.GA5830@amd>
 <20160620205904.GL24980@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160620205904.GL24980@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

I tried to capture 1.2Mpix images, then scale them down to 800x600
using hardware... and results were  kernel dying.

[12552.400146] [<c062561c>] (isp_video_start_streaming) from
[<c061c6e8>] (vb2_start_streaming+0x5c/0x154)
[12552.400146] [<c061c6e8>] (vb2_start_streaming) from [<c061e5f8>]
(vb2_core_streamon+0x104/0x160)
[12552.400177] [<c061e5f8>] (vb2_core_streamon) from [<c0625260>]
(isp_video_streamon+0x17c/0x27c)
[12552.400207] [<c0625260>] (isp_video_streamon) from [<c0607a28>]
(v4l_streamon+0x18/0x1c)
[12552.400238] [<c0607a28>] (v4l_streamon) from [<c06096ac>]
(__video_do_ioctl+0x24c/0x2e8)
[12552.400268] [<c06096ac>] (__video_do_ioctl) from [<c060b2b0>]
(video_usercopy+0x110/0x600)
[12552.400299] [<c060b2b0>] (video_usercopy) from [<c060645c>]
(v4l2_ioctl+0x98/0xb8)
[12552.400329] [<c060645c>] (v4l2_ioctl) from [<c0269d28>]
(do_vfs_ioctl+0x80/0x948)
[12552.400329] [<c0269d28>] (do_vfs_ioctl) from [<c026a654>]
(SyS_ioctl+0x64/0x74)
[12552.400360] [<c026a654>] (SyS_ioctl) from [<c0107860>]
(ret_fast_syscall+0x0/0x3c)
[12552.400390] ---[ end trace b4627b34449829a7 ]---
[12552.400421] In-band Error seen by MPU  at address 0
[12552.400421] ------------[ cut here ]------------
[12552.400451] WARNING: CPU: 0 PID: 3936 at
drivers/bus/omap_l3_smx.c:166 omap3_l3_app_irq+0xcc/0x124
[12552.400482] Modules linked in:
[12552.400482] CPU: 0 PID: 3936 Comm: mplayer Tainted: G        W
4.6.0-177572-g501bb64-dirty #360
[12552.400512] Hardware name: Nokia RX-51 board

I did more experiments before, and usually it does not end like
this. Usually, when I set up capture with greater resolution than cca
800x600, I get 4 copies of image above each other.

If you know how to get images with greater resolution, let me know.

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
