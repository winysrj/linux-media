Return-path: <linux-media-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.140]:45619 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753115AbcJ0BIU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Oct 2016 21:08:20 -0400
Subject: Re: [RFC] V4L2 unified low-level decoder API
To: Hugues FRUCHET <hugues.fruchet@st.com>,
        "posciak@chromium.org" <posciak@chromium.org>,
        "jung.zhao@rock-chips.com" <jung.zhao@rock-chips.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <58C70A34B28DE743B9604C8841D375C2793D2999@SAFEX1MAIL5.st.com>
Cc: Florent Revest <florent.revest@free-electrons.com>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "herman.chen@rock-chips.com" <herman.chen@rock-chips.com>,
        "eddie.cai" <eddie.cai@rock-chips.com>,
        "linux-rockchip@lists.infradead.org"
        <linux-rockchip@lists.infradead.org>,
        "nicolas.dufresne@collabora.co.uk" <nicolas.dufresne@collabora.co.uk>,
        =?UTF-8?B?5p6X6YeR5Y+R?= <alpha.lin@rock-chips.com>
From: Randy Li <randy.li@rock-chips.com>
Message-ID: <aab23d5d-d41d-78e1-7324-77b9d98ee127@rock-chips.com>
Date: Thu, 27 Oct 2016 09:08:08 +0800
MIME-Version: 1.0
In-Reply-To: <58C70A34B28DE743B9604C8841D375C2793D2999@SAFEX1MAIL5.st.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 10/26/2016 11:09 PM, Hugues FRUCHET wrote:
> Hi,
>
>
>
> This RFC aims to start discussions in order to define the codec specific
> controls structures to fulfill the low-level decoder API needed by non
> “Stream API” based decoders (“stateless” or “Frame API” based decoders).
>
> Several implementation exists now which runs on several SoC and various
> software frameworks.
>
> The idea is to find the communalities between all those implementations
> and SoC to define a single unified interface in V4L2 includes.
>
> Even if “Request API” is needed to pass those codec specific controls
> from userspace down to kernel on a per-buffer basis, we can start
> discussions and define the controls in parallel of its development.
Yes, I have sent a one for H.264 decoder and JPEG encoder.
>
> We can even propose some implementations based on existing V4L2 control
> framework (which doesn’t support “per-frame” basis) by ensuring
> atomicity of sequence S_EXT_CTRL(header[i])/QBUF(stream[i]). Constraint
> can then be relaxed when “Request API” is merged.
>
>
>
> I would like to propose to work on a “per-codec” basis, having at least
> 2 different SoC and 2 different frameworks to test and validate controls.
>
> To do so, I have tried to identify some people that have worked on this
> subject and have proposed some implementations, feel free to correct me
> and enhance the list if needed:
>
> * MPEG2/MPEG4
>
>    - Florent Revest for Allwinner A13 CedarX support [1] tested with VLC
> -> libVA + sunxi-cedrus-drv-video -> V4L2
>
>    - Myself for STMicroelectronics Delta support [2] tested with
> GStreamer V4L2 -> libv4l2 + libv4l-delta plugin -> V4L2
>
>
>
> * VP8
>
> - Pawel Osciak for Rockchip RK3288, RK3399? VPU Support [3] tested with
> Chromium -> V4L2
>
> - Jung Zhao for Rockchip RK3288 VPU support [4] <cannot find the
> framework used>
There is rockchip VDPAU driver supporting it, but it is .
>
>
>
> * H264
>
> - Pawel Osciak for Rockchip RK3288, RK3399? VPU Support [5] tested with
> Chromium -> V4L2
>
> - Randy Li for Rockchip RK3288  VPU support [6] tested with VLC? ->
> libVA + rockchip-va-driver -> V4L2
I only tested it with Gstreamer -> VA-API element -> Rockchip VA-API 
driver -> V4L2
>
>                                                                                                                          VLC?
> -> libVDPAU + rockchip-va-driver -> V4L2
>
> I can work to define MPEG2/MPEG4 controls and propose functional
> implementations for those codecs, and will be glad to co-work with you
> Florent.
But it may not work with Rockchip's SoC, you may check the following branch
https://github.com/hizukiayaka/rockchip-video-driver/tree/rk_v4l2_mix
>
> I can help on H264 on a code review basis based on the functional H264
> setup I have in-house and codec knowledge, but I cannot provide
> implementation in a reasonable timeframe, same for VP8.
>
>
>
> Apart of very details of each codec, we have also to state about generic
> concerns such as:
>
> -          new pixel format introduction (VP8 => VP8F, H264 => S264,
> MPG2 => MG2F, MPG4 => MG4F)
I don't think it is necessary.
>
> -          new device caps to indicate that driver requires extra
> headers ? maybe not needed because redundant with new pixel format
I prefer this one.
>
> -          continue to modify v4l2-controls.h ? or do we add some new
> specific header files (H264 is huge!) ?
Not huge. You could check rockchip's kernel.
>
> -          how to manage sequence header & picture header,
> optional/extended controls (MPEG2 sequence/picture extensions, H264 SEI,
> …). Personally I have added flags inside a single control structure,
> H264 is done in a different way using several controls
> (SPS/PPS/SLICE/DECODE/…)
the last one is dpb, except the dpb, it would have the same numbers of 
controls to those structures defined in VA-API H264 decoder.
>
>
> Thanks you to all of you for your attention and feel free to react on
> this topic if you are interested to work on this subject.
Currently, I have to pause the process of VA-API drive, and moving to 
the other idea I have said before, creating a new API in userspace(but 
won't archive the goal I set before in this step). There are some 
shortages in VA-API I have said in last email making the performance in 
4K video and extending the Gstreamer VA-API is a little difficult job 
and need more time.
And the development for the new VPU driver for rockchip would pause a 
while as well.

It would not be a long time(a few weeks) and I am still available in my 
free time(at home). It is good to know the wheel begin to roll. And do 
feel free to assign job to me.
>
>
>
> Best regards,
>
> Hugues.
>
>
>
> [0] [ANN] Codec & Request API Brainstorm meeting Oct 10 & 11
> https://www.spinics.net/lists/linux-media/msg106699.html
>
> [1] MPEG2 A13 CedarX http://www.spinics.net/lists/linux-media/msg104823.html
>
> [1] MPEG4 A13 CedarX http://www.spinics.net/lists/linux-media/msg104817.html
>
> [2] MPEG2 STi4xx Delta
> http://www.spinics.net/lists/linux-media/msg106240.html
>
> [2] MPEG4 STi4xx Delta is also supported but not yet pushed
>
> [3] VP8 Rockchip RK3288, RK3399? VPU
> https://chromium.googlesource.com/chromiumos/overlays/chromiumos-overlay/+/refs/heads/master/sys-kernel/linux-headers/files/0002-CHROMIUM-v4l-Add-VP8-low-level-decoder-API-controls.patch
>
>
> [4] VP8 Rockchip RK3288 VPU
> http://www.spinics.net/lists/linux-media/msg97997.html
>
> [5] H264 Rockchip RK3288, RK3399? VPU
> https://chromium.googlesource.com/chromiumos/overlays/chromiumos-overlay/+/refs/heads/master/sys-kernel/linux-headers/files/0001-CHROMIUM-media-headers-Import-V4L2-headers-from-Chro.patch
>
> [6] H264 Rockchip RK3288 VPU
> http://www.spinics.net/lists/linux-media/msg105095.html
>
>
>

-- 
Randy Li
The third produce department

