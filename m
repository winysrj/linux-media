Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:56025 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756740AbdKOILH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Nov 2017 03:11:07 -0500
Received: by mail-yw0-f194.google.com with SMTP id q37so2049282ywa.12
        for <linux-media@vger.kernel.org>; Wed, 15 Nov 2017 00:11:07 -0800 (PST)
Received: from mail-yw0-f180.google.com (mail-yw0-f180.google.com. [209.85.161.180])
        by smtp.gmail.com with ESMTPSA id r12sm3748103ywa.102.2017.11.15.00.11.06
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Nov 2017 00:11:06 -0800 (PST)
Received: by mail-yw0-f180.google.com with SMTP id q126so15785910ywq.10
        for <linux-media@vger.kernel.org>; Wed, 15 Nov 2017 00:11:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171115072927.29367-1-jacob-chen@iotwrt.com>
References: <20171115072927.29367-1-jacob-chen@iotwrt.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Wed, 15 Nov 2017 16:03:23 +0800
Message-ID: <CAAFQd5B9S7fZFEvTDuK8d1KyYmzH0szFDATsg1ZYeSViO2Kfrg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] Rockchip ISP1 Driver
To: Jacob Chen <jacob-chen@iotwrt.com>
Cc: "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, nicolas@ndufresne.ca,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Shunqian Zheng <zhengsq@rock-chips.com>,
        =?UTF-8?B?6ZKf5Lul5bSH?= <zyc@rock-chips.com>,
        Eddie Cai <eddie.cai.linux@gmail.com>,
        Jeffy <jeffy.chen@rock-chips.com>,
        Allon Huang <allon.huang@rock-chips.com>,
        Philipp Zabel <p.zabel@pengutronix.de>, slongerbeam@gmail.com,
        linux@armlinux.org.uk
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacob,

Thanks for sending the series!

On Wed, Nov 15, 2017 at 3:29 PM, Jacob Chen <jacob-chen@iotwrt.com> wrote:
> This patch series add a ISP(Camera) v4l2 driver for rockchip rk3288/rk3399 SoC.
>
> TODO:
>   - Thomas is rewriting the binding code between isp, phy, sensors, i hope we could get suggestions.
>         https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/768633/2
>     rules:
>       - There are many mipi interfaces("rx0", "dxrx0")(actually it also could be parallel interface) in SoC and isp can decide which one will be used.
>       - Sometimes there will be more than one senor in a mipi phy, the sofrware should decide which one is used(media link).
>       - rk3399 have two isp.

Also the two ISP subsystems have their own, completely different, CSI2
PHY blocks, so we need to make the ISP driver work with two different
PHY drivers.

>   - Add a dummy buffer(dma_alloc_coherent) so drvier won't hold buffer.
>   - Finish all TODO comments(mostly about hardware) in driver.
>
> To help do a quick review, i have push source code to my Github.
>   https://github.com/wzyy2/linux/tree/rkisp1/drivers/media/platform/rockchip/isp1
>
> Below are some infomations about driver/hardware:
>
> Rockchip ISP1 have many Hardware Blocks(simplied):
>
>   MIPI      --> ISP --> DCrop(Mainpath) --> RSZ(Mainpath) --> DMA(Mainpath)
>   DMA-Input -->     --> DCrop(Selfpath) --> RSZ(Selfpath) --> DMA(Selfpath);)
>
> (Acutally the TRM(rk3288, isp) could be found online...... which contains a more detailed block diagrams ;-P)
>
> The funcitons of each hardware block:
>
>   Mainpath : up to 4k resolution, support raw/yuv format
>   Selfpath : up tp 1080p, support rotate, support rgb/yuv format
>   RSZ: scaling
>   DCrop: crop
>   ISP: 3A, Color processing, Crop
>   MIPI: MIPI Camera interface
>
> Media pipelines:
>
>   Mainpath, Selfpath <-- ISP subdev <-- MIPI  <-- Sensor
>   3A stats           <--            <-- 3A parms
>
> Code struct:
>
>   capture.c : Mainpath, Selfpath, RSZ, DCROP : capture device.
>   rkisp1.c : ISP : v4l2 sub-device.
>   isp_params.c : 3A parms : output device.
>   isp_stats.c : 3A stats : capture device.
>   mipi_dphy_sy.c : MIPI : sperated v4l2 sub-device.
>
> Usage:
>   ChromiumOS:
>     use below v4l2-ctl command to capture frames.
>
>       v4l2-ctl --verbose -d /dev/video4 --stream-mmap=2
>       --stream-to=/tmp/stream.out --stream-count=60 --stream-poll
>
>     use below command to playback the video on your PC.
>
>       mplayer /tmp/stream.out -loop 0 --demuxer=rawvideo
>       --rawvideo=w=800:h=600:size=$((800*600*2)):format=yuy2
>     or
>       mplayer ./stream.out -loop 0 -demuxer rawvideo -rawvideo
>       w=800:h=600:size=$((800*600*2)):format=yuy2
>
>   Linux:
>     use rkcamsrc gstreamer plugin(just a modified v4l2src) to preview.
>
>       gst-launch-1.0 rkcamsrc device=/dev/video0 io-mode=4 disable-3A=true
>       videoconvert ! video/x-raw,format=NV12,width=640,height=480 ! kmssink

Is the rkcamsrc plugin source available somewhere to download?

Thanks,
Tomasz
