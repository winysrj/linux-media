Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41144 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932872AbcDYSkT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 14:40:19 -0400
Date: Mon, 25 Apr 2016 20:40:16 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: sakari.ailus@iki.fi, sre@kernel.org, pali.rohar@gmail.com,
	linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 00/24] Make Nokia N900 cameras working
Message-ID: <20160425184016.GC10443@amd>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160425165848.GA10443@amd>
 <571E5134.10607@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <571E5134.10607@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

> >I can't do -vo xv ... fails for me, probably due to X
> >configuration. Does it work with -vo x11 for you?
> >
> yes, -vo x11 works under maemo.

Ok, good.

> In linux-n900 branch we have a patch that reserves memory for omapfb - see https://github.com/freemangordon/linux-n900/commit/60f85dcb6a663efe687f58208861545d65210b55
> 
> also, because of a change in 4.6, https://github.com/freemangordon/linux-n900/commit/60f85dcb6a663efe687f58208861545d65210b55#diff-072444ea67d2aca6b402458f50d20edeR125
> needs a change to DMA_MEMORY_IO and the if bellow needs the relevant change
> as well.

> This is needed for -vo xv (and any omapfb video playback) to reliably work
> under maemo.

I don't have that kind of acceleration working.

> >For me it shows window with green interior. And complains about v4l2:
> >select timeouts. (I enabled these in .config):
> >
> >+CONFIG_VIDEO_BUS_SWITCH=y
> >+CONFIG_VIDEO_SMIAREGS=y
> >+CONFIG_VIDEO_ET8EK8=y
> >+CONFIG_VIDEOBUF2_CORE=y
> >+CONFIG_VIDEOBUF2_MEMOPS=y
> >+CONFIG_VIDEOBUF2_DMA_CONTIG=y
> >+CONFIG_VIDEO_OMAP3=y
> >+CONFIG_VIDEO_SMIAPP_PLL=y
> >+CONFIG_VIDEO_SMIAPP=y
> >
> >Any ideas?
> >									Pavel
> >
> 
> Try to build those as modules. Also, do you have all the needed patches
> besides those in the patchset?
> 
> See https://github.com/freemangordon/linux-n900/commits/v4.6-rc4-n900-camera
> 
> Also, is there anything related in dmesg log?

Modules are tricky. I hate modules. I did patch with

https://lkml.org/lkml/2016/4/16/14
https://lkml.org/lkml/2016/4/16/33

+ the series. And yes, there seems to be explanation in the dmesg:

[ 6134.261993] DISPC: channel 0 xres 800 yres 480
[ 6134.262023] DISPC: pck 24000000
[ 6134.262023] DISPC: hsw 4 hfp 28 hbp 24 vsw 3 vfp 3 vbp 4
[ 6134.262023] DISPC: vsync_level 0 hsync_level 0 data_pclk_edge 1
de_level 1 sync_pclk_edge 1
[ 6134.262023] DISPC: hsync 28037Hz, vsync 57Hz
[ 6134.262054] DISPC: lck = 72000000 (1)
[ 6134.262054] DISPC: pck = 24000000 (3)
[ 6190.075103] omap3isp 480bc000.isp: Unable to stop OMAP3 ISP resizer
[ 6192.075347] omap3isp 480bc000.isp: CCDC stop timeout!
[ 6192.075408] omap3isp 480bc000.isp: Unable to stop OMAP3 ISP CCDC
[ 6292.293670] DISPC: dispc_runtime_put
[ 6292.293701] DISPC: dispc_save_context
[ 6292.293762] DISPC: context saved
[ 6292.294342] DSS: dss_save_context
[ 6292.294372] DSS: context saved
[ 6297.056976] DISPC: dispc_runtime_get
[ 6297.057067] DSS: dss_restore_context
[ 6297.057067] DSS: context restored
[ 6297.057159] DSS: set fck to 72000000
[ 6297.057159] DISPC: lck = 72000000 (1)
[ 6297.057159] DISPC: pck = 24000000 (3)

Let me check the github...
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
