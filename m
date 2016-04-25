Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36556 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754087AbcDYRRr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 13:17:47 -0400
Received: by mail-wm0-f67.google.com with SMTP id w143so22523010wmw.3
        for <linux-media@vger.kernel.org>; Mon, 25 Apr 2016 10:17:46 -0700 (PDT)
Subject: Re: [RFC PATCH 00/24] Make Nokia N900 cameras working
To: Pavel Machek <pavel@ucw.cz>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160425165848.GA10443@amd>
Cc: sakari.ailus@iki.fi, sre@kernel.org, pali.rohar@gmail.com,
	linux-media@vger.kernel.org
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Message-ID: <571E5134.10607@gmail.com>
Date: Mon, 25 Apr 2016 20:17:40 +0300
MIME-Version: 1.0
In-Reply-To: <20160425165848.GA10443@amd>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 25.04.2016 19:58, Pavel Machek wrote:
> Hi!
>
> Ok, let me try:
>
>> The needed pipeline could be made with:
>>
>> media-ctl -r
>> media-ctl -l '"vs6555 binner 2-0010":1 -> "video-bus-switch":2 [1]'
>> media-ctl -l '"video-bus-switch":0 -> "OMAP3 ISP CCP2":0 [1]'
>> media-ctl -l '"OMAP3 ISP CCP2":1 -> "OMAP3 ISP CCDC":0 [1]'
>> media-ctl -l '"OMAP3 ISP CCDC":2 -> "OMAP3 ISP preview":0 [1]'
>> media-ctl -l '"OMAP3 ISP preview":1 -> "OMAP3 ISP resizer":0 [1]'
>> media-ctl -l '"OMAP3 ISP resizer":1 -> "OMAP3 ISP resizer output":0 [1]'
>> media-ctl -V '"vs6555 pixel array 2-0010":0 [SGRBG10/648x488 (0,0)/648x488 (0,0)/648x488]'
>> media-ctl -V '"vs6555 binner 2-0010":1 [SGRBG10/648x488 (0,0)/648x488 (0,0)/648x488]'
>> media-ctl -V '"OMAP3 ISP CCP2":0 [SGRBG10 648x488]'
>> media-ctl -V '"OMAP3 ISP CCP2":1 [SGRBG10 648x488]'
>> media-ctl -V '"OMAP3 ISP CCDC":2 [SGRBG10 648x488]'
>> media-ctl -V '"OMAP3 ISP preview":1 [UYVY 648x488]'
>> media-ctl -V '"OMAP3 ISP resizer":1 [UYVY 656x488]'
>
> pavel@n900:/my/tui/ofone/camera$ sudo ./front.sh
> MPlayer svn r34540 (Debian), built with gcc-4.6 (C) 2000-2012 MPlayer
> Team
>
> Linux n900 4.6.0-rc5-176733-g8b658a3-dirty
> media-ctl from today's git.
>
>> and tested with:
>>
>> mplayer -tv driver=v4l2:width=656:height=488:outfmt=uyvy:device=/dev/video6 -vo xv -vf screenshot tv://
>>
>
> I can't do -vo xv ... fails for me, probably due to X
> configuration. Does it work with -vo x11 for you?
>
yes, -vo x11 works under maemo.

In linux-n900 branch we have a patch that reserves memory for omapfb - 
see 
https://github.com/freemangordon/linux-n900/commit/60f85dcb6a663efe687f58208861545d65210b55

also, because of a change in 4.6, 
https://github.com/freemangordon/linux-n900/commit/60f85dcb6a663efe687f58208861545d65210b55#diff-072444ea67d2aca6b402458f50d20edeR125 
needs a change to DMA_MEMORY_IO and the if bellow needs the relevant 
change as well.

This is needed for -vo xv (and any omapfb video playback) to reliably 
work under maemo.

> For me it shows window with green interior. And complains about v4l2:
> select timeouts. (I enabled these in .config):
>
> +CONFIG_VIDEO_BUS_SWITCH=y
> +CONFIG_VIDEO_SMIAREGS=y
> +CONFIG_VIDEO_ET8EK8=y
> +CONFIG_VIDEOBUF2_CORE=y
> +CONFIG_VIDEOBUF2_MEMOPS=y
> +CONFIG_VIDEOBUF2_DMA_CONTIG=y
> +CONFIG_VIDEO_OMAP3=y
> +CONFIG_VIDEO_SMIAPP_PLL=y
> +CONFIG_VIDEO_SMIAPP=y
>
> Any ideas?
> 									Pavel
>

Try to build those as modules. Also, do you have all the needed patches 
besides those in the patchset?

See https://github.com/freemangordon/linux-n900/commits/v4.6-rc4-n900-camera

Also, is there anything related in dmesg log?

Ivo
