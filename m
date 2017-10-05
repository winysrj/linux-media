Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout02.posteo.de ([185.67.36.66]:42219 "EHLO mout02.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751275AbdJELy1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 5 Oct 2017 07:54:27 -0400
Received: from submission (posteo.de [89.146.220.130])
        by mout02.posteo.de (Postfix) with ESMTPS id AA7D220BF9
        for <linux-media@vger.kernel.org>; Thu,  5 Oct 2017 13:54:25 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8BIT
Date: Thu, 05 Oct 2017 13:54:24 +0200
From: Martin Kepplinger <martink@posteo.de>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org
Subject: Re: platform: coda: how to use firmware-imx binary
 =?UTF-8?Q?releases=3F=20/=20how=20to=20use=20VDOA=20on=20imx=36=3F?=
In-Reply-To: <1507191578.8473.1.camel@pengutronix.de>
References: <ef7cc5b91829f383842a1e4692af5b07@posteo.de>
 <1507108964.11691.6.camel@pengutronix.de>
 <7dd05afd338e81d293d0424e0b8e6b6a@posteo.de>
 <1507191578.8473.1.camel@pengutronix.de>
Message-ID: <e0335e29f79b719c6f315473b3db74ad@posteo.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 05.10.2017 10:19 schrieb Philipp Zabel:
> Hi Martin,
> 
> On Thu, 2017-10-05 at 09:43 +0200, Martin Kepplinger wrote:
>> I'm running a little off-topic here, but with the newest firmware 
>> too, 
>> my
>> coda driver says "Video Data Order Adapter: Disabled" when started
>> by video playback via v4l2.
> 
> This message is most likely just a result of the VDOA not supporting 
> the
> selected capture format. In vdoa_context_configure, you can see that 
> the
> VDOA only writes YUYV or NV12.

ok. I'll have to look into it, and just in case you see a problem on 
first sight:
this is what coda says with debug level 1, when doing

gst-launch-1.0 playbin uri=file:///data/test2_hd480.h264 
video-sink=fbdevsink

with the video file being (ffprobe)

Input #0, h264, from 'test2_hd480.h264':
   Duration: N/A, bitrate: N/A
     Stream #0:0: Video: h264 (High), yuv420p(progressive), 852x480, 24 
fps, 24 tbr, 1200k tbn, 48 tbc


after some s_ctrl: id/val printings:

[   98.833023] coda 2040000.vpu: Created instance 0 (cefc5000)
[   98.837550] coda 2040000.vpu: Releasing instance cefc5000
[   98.839080] coda 2040000.vpu: s_ctrl: id = 9963796, val = 0
[   98.839091] coda 2040000.vpu: s_ctrl: id = 9963797, val = 0
[   98.839100] coda 2040000.vpu: Created instance 0 (ceeb2000)
[   98.842867] coda 2040000.vpu: Releasing instance ceeb2000
[   98.845435] coda 2040000.vpu: s_ctrl: id = 9963796, val = 0
[   98.845447] coda 2040000.vpu: s_ctrl: id = 9963797, val = 0
[   98.845458] coda 2040000.vpu: Created instance 0 (cefc5000)
[   98.851652] coda 2040000.vpu: Setting format for type 2, wxh: 
852x480, fmt: H264 L
[   98.851670] coda 2040000.vpu: Setting format for type 1, wxh: 
852x480, fmt: NV12 T
[   98.854800] coda 2040000.vpu: get 2 buffer(s) of size 819200 each.
[   99.022191] coda 2040000.vpu: get 2 buffer(s) of size 622080 each.
[   99.025904] coda 2040000.vpu: Video Data Order Adapter: Disabled
[   99.025922] coda 2040000.vpu: H264 Profile/Level: High L3
[   99.026214] coda 2040000.vpu: __coda_start_decoding instance 0 now: 
864x480
[   99.036277] coda 2040000.vpu: 0: not ready: need 2 buffers available 
(1, 0)
[   99.063157] coda 2040000.vpu: job ready


so while the video is shown, the VDOA is "disabled".

                           thanks a lot for your help


(it's shown far from fluent yet, almost frame by frame, but that's ok 
for now... I'll still need to
took into the v4l2 interface for the imx6 IPU)


> 
>> (imx6, running linux 4.14-rc3, imx-vdoa is probed and never removed,
>> a dev_info "probed" would maybe be useful for others too?)
>> 
>> It supsequently fails with
>> 
>> cma: cma_alloc: alloc failed, req-size: 178 pages, ret: -12
> 
> That is -ENOMEM. Is CMA enabled and sufficiently large? For example,
> 
> CONFIG_CMA=y
> CONFIG_CMA_DEBUGFS=y
> CONFIG_DMA_CMA=y
> CONFIG_CMA_SIZE_MBYTES=256
> CONFIG_CMA_SIZE_SEL_MBYTES=y
> 

My cma buffer size was indeed just too small.
