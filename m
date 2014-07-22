Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42701 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbaGVQDv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 12:03:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Enrico <ebutera@users.sourceforge.net>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Enric Balletbo Serra <eballetbo@gmail.com>,
	stefan@herbrechtsmeier.net
Subject: Re: [PATCH 00/11] OMAP3 ISP BT.656 support
Date: Tue, 22 Jul 2014 18:04:03 +0200
Message-ID: <5099401.EbLZaQU31t@avalon>
In-Reply-To: <CA+2YH7t0rzko=Ssg7Qe8oC_qXUTr=uFzDqBqmPtAAbQ2dAntNA@mail.gmail.com>
References: <1401133812-8745-1-git-send-email-laurent.pinchart@ideasonboard.com> <CA+2YH7urbO6C-a6UMB+1JKN2z7F0CDmqh0184cCzXHbW1ADfXA@mail.gmail.com> <CA+2YH7t0rzko=Ssg7Qe8oC_qXUTr=uFzDqBqmPtAAbQ2dAntNA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Enrico,

On Tuesday 22 July 2014 17:52:27 Enrico wrote:
> On Tue, Jun 24, 2014 at 5:19 PM, Enrico <ebutera@users.berlios.de> wrote:
> > On Tue, May 27, 2014 at 10:38 AM, Enrico <ebutera@users.berlios.de> wrote:
> >> On Mon, May 26, 2014 at 9:50 PM, Laurent Pinchart wrote:
> >>> Hello,
> >>> 
> >>> This patch sets implements support for BT.656 and interlaced formats in
> >>> the OMAP3 ISP driver. Better late than never I suppose, although given
> >>> how long this has been on my to-do list there's probably no valid
> >>> excuse.
> >> 
> >> Thanks Laurent!
> >> 
> >> I hope to have time soon to test it :)
> > 
> > Hi Laurent,
> > 
> > i wanted to try your patches but i'm having a problem (probably not
> > caused by your patches).
> > 
> > I merged media_tree master and omap3isp branches, applied your patches
> > and added camera platform data in pdata-quirks, but when loading the
> > omap3-isp driver i have:
> > 
> > omap3isp: clk_set_rate for cam_mclk failed
> > 
> > The returned value from clk_set_rate is -22 (EINVAL), but i can't see
> > any other debug message to track it down. Any ides?
> > I'm testing it on an igep proton (omap3530 version).
> 
> I found out that my previous email was not working anymore, so i
> didn't read about Stefan patch (ti,set-rate-parent).
> 
> With that patch i can setup my pipeline (attached), but i can't make
> yavta capture:
> 
> root@igep00x0:~/field# ./yavta -f UYVY -n4 -s 720x624 -c100 /dev/video2
> Device /dev/video2 opened.
> Device `OMAP3 ISP CCDC output' on `media' is a video output (without
> mplanes) device.
> Video format set: UYVY (59565955) 720x624 (stride 1440) field none
> buffer size 898560
> Video format: UYVY (59565955) 720x624 (stride 1440) field none buffer
> size 898560
> 4 buffers requested.
> length: 898560 offset: 0 timestamp type/source: mono/EoF
> Buffer 0/0 mapped at address 0xb6ce4000.
> length: 898560 offset: 901120 timestamp type/source: mono/EoF
> Buffer 1/0 mapped at address 0xb6c08000.
> length: 898560 offset: 1802240 timestamp type/source: mono/EoF
> Buffer 2/0 mapped at address 0xb6b2c000.
> length: 898560 offset: 2703360 timestamp type/source: mono/EoF
> Buffer 3/0 mapped at address 0xb6a50000.
> Unable to start streaming: Invalid argument (22).
> 4 buffers released.
> 
> strace:
> 
> ioctl(3, VIDIOC_STREAMON, 0xbef9c75c)   = -1 EINVAL (Invalid argument)
> 
> any ideas?

You will need to upgrade media-ctl and yavta to versions that support 
interlaced formats. media-ctl has been moved to v4l-utils 
(http://git.linuxtv.org/cgit.cgi/v4l-utils.git/) and yavta is hosted at 
git://git.ideasonboard.org/yavta.git. You want to use the master branch for 
both trees.

-- 
Regards,

Laurent Pinchart

