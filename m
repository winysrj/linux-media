Return-path: <linux-media-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.137]:43915 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752132AbcKECow (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 4 Nov 2016 22:44:52 -0400
Subject: Re: [RFC] V4L2 unified low-level decoder API
To: Hugues FRUCHET <hugues.fruchet@st.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <58C70A34B28DE743B9604C8841D375C2793D2999@SAFEX1MAIL5.st.com>
 <aab23d5d-d41d-78e1-7324-77b9d98ee127@rock-chips.com>
 <e6b89733-465e-74d3-45b9-0a39d1136779@st.com>
Cc: "posciak@chromium.org" <posciak@chromium.org>,
        Florent Revest <florent.revest@free-electrons.com>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "herman.chen@rock-chips.com" <herman.chen@rock-chips.com>,
        "eddie.cai" <eddie.cai@rock-chips.com>,
        "linux-rockchip@lists.infradead.org"
        <linux-rockchip@lists.infradead.org>,
        "nicolas.dufresne@collabora.co.uk" <nicolas.dufresne@collabora.co.uk>,
        =?UTF-8?B?5p6X6YeR5Y+R?= <alpha.lin@rock-chips.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        =?UTF-8?B?6LW15L+K?= <jung.zhao@rock-chips.com>
From: Randy Li <randy.li@rock-chips.com>
Message-ID: <6d308d93-b0be-45b6-f330-ee00bea5d5a0@rock-chips.com>
Date: Sat, 5 Nov 2016 10:44:22 +0800
MIME-Version: 1.0
In-Reply-To: <e6b89733-465e-74d3-45b9-0a39d1136779@st.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 11/04/2016 09:55 PM, Hugues FRUCHET wrote:
> Hi Randy,
>
> thanks for reply, some comments below:
>
>
> On 10/27/2016 03:08 AM, Randy Li wrote:
>>
>>
>> On 10/26/2016 11:09 PM, Hugues FRUCHET wrote:
>>> Hi,
>>>
>>>
>>>
>>> This RFC aims to start discussions in order to define the codec specific
>>> controls structures to fulfill the low-level decoder API needed by non
>>> “Stream API” based decoders (“stateless” or “Frame API” based decoders).
>>>
>>> Several implementation exists now which runs on several SoC and various
>>> software frameworks.
>>>
>>> The idea is to find the communalities between all those implementations
>>> and SoC to define a single unified interface in V4L2 includes.
>>>
>>> Even if “Request API” is needed to pass those codec specific controls
>>> from userspace down to kernel on a per-buffer basis, we can start
>>> discussions and define the controls in parallel of its development.
>> Yes, I have sent a one for H.264 decoder and JPEG encoder.
>>>
>>> We can even propose some implementations based on existing V4L2 control
>>> framework (which doesn’t support “per-frame” basis) by ensuring
>>> atomicity of sequence S_EXT_CTRL(header[i])/QBUF(stream[i]). Constraint
>>> can then be relaxed when “Request API” is merged.
>>>
>>>
>>>
>>> I would like to propose to work on a “per-codec” basis, having at least
>>> 2 different SoC and 2 different frameworks to test and validate controls.
>>>
>>> To do so, I have tried to identify some people that have worked on this
>>> subject and have proposed some implementations, feel free to correct me
>>> and enhance the list if needed:
>>>
>>> * MPEG2/MPEG4
>>>
>>>    - Florent Revest for Allwinner A13 CedarX support [1] tested with VLC
>>> -> libVA + sunxi-cedrus-drv-video -> V4L2
>>>
>>>    - Myself for STMicroelectronics Delta support [2] tested with
>>> GStreamer V4L2 -> libv4l2 + libv4l-delta plugin -> V4L2
>>>
>>>
>>>
>>> * VP8
>>>
>>> - Pawel Osciak for Rockchip RK3288, RK3399? VPU Support [3] tested with
>>> Chromium -> V4L2
>>>
>>> - Jung Zhao for Rockchip RK3288 VPU support [4] <cannot find the
>>> framework used>
>> There is rockchip VDPAU driver supporting it, but it is .
>
> Could you point out the code that is used ? Which application is used on
> top of VDPAU ?
https://github.com/rockchip-linux/libvdpau-rockchip
>
>>>
>>>
>>>
>>> * H264
>>>
>>> - Pawel Osciak for Rockchip RK3288, RK3399? VPU Support [5] tested with
>>> Chromium -> V4L2
>>>
>>> - Randy Li for Rockchip RK3288  VPU support [6] tested with VLC? ->
>>> libVA + rockchip-va-driver -> V4L2
>> I only tested it with Gstreamer -> VA-API element -> Rockchip VA-API
>> driver -> V4L2
>
> OK got it, thks !
>
>>>
>>>                                                                                                                          VLC?
>>> -> libVDPAU + rockchip-va-driver -> V4L2
>>>
>>> I can work to define MPEG2/MPEG4 controls and propose functional
>>> implementations for those codecs, and will be glad to co-work with you
>>> Florent.
>> But it may not work with Rockchip's SoC, you may check the following branch
>> https://github.com/hizukiayaka/rockchip-video-driver/tree/rk_v4l2_mix
>
> I have checked code and I have only found H264 support, do I miss
> something ?
No, I have said above, only H264 decoder and JPEG encoder are supported 
in currently Rockchip VA-API driver. And H264 decoder depends on a 
Rockchip H264 parser. The rk_v4l2_mix just a branch make that clearly, 
it could get what the VA-API doesn't offer from code.
>
>>>
>>> I can help on H264 on a code review basis based on the functional H264
>>> setup I have in-house and codec knowledge, but I cannot provide
>>> implementation in a reasonable timeframe, same for VP8.
>>>
>>>
>>>
>>> Apart of very details of each codec, we have also to state about generic
>>> concerns such as:
>>>
>>> -          new pixel format introduction (VP8 => VP8F, H264 => S264,
>>> MPG2 => MG2F, MPG4 => MG4F)
>> I don't think it is necessary.
>
> But currently it is done that way in all patches proposals I have seen
> so far, including rockchip:
> rockchip_decoder_v4l2.c:{VAProfileH264Baseline,V4L2_PIX_FMT_H264_SLICE},
It is Google's idea, it would be removed with new version kernel driver 
of mine. Also I don't like multiplanes image format from Google driver.
>
> We have to state about it all together. Seems natural to me to do this
> way instead of device caps.
> Doing so user knows that the driver is based on "Frame API" -so
> additional headers are required to decode input stream- and not
> on "Stream API" -H264 stream can be decoded directly-.
 > We should probably use something else then "STREAMING" in the
 > capabilities instead of duplicating all the encoding formats (exception
 > to H264 byte-stream and H264 AVC, that also applies to streaming
 > drivers and there is not easy way to introduce stream-format in the API
 > atm). Other then that, this solution works, so it could just be
 > considered the right way, I just find it less elegant personally.
I agree with Nicolas.
>
>

>>>
>>> Best regards,
>>>
>>> Hugues.
>>>
>>>
>>>
>>> [0] [ANN] Codec & Request API Brainstorm meeting Oct 10 & 11
>>> https://www.spinics.net/lists/linux-media/msg106699.html
>>>
>>> [1] MPEG2 A13 CedarX http://www.spinics.net/lists/linux-media/msg104823.html
>>>
>>> [1] MPEG4 A13 CedarX http://www.spinics.net/lists/linux-media/msg104817.html
>>>
>>> [2] MPEG2 STi4xx Delta
>>> http://www.spinics.net/lists/linux-media/msg106240.html
>>>
>>> [2] MPEG4 STi4xx Delta is also supported but not yet pushed
>>>
>>> [3] VP8 Rockchip RK3288, RK3399? VPU
>>> https://chromium.googlesource.com/chromiumos/overlays/chromiumos-overlay/+/refs/heads/master/sys-kernel/linux-headers/files/0002-CHROMIUM-v4l-Add-VP8-low-level-decoder-API-controls.patch
>>>
>>>
>>> [4] VP8 Rockchip RK3288 VPU
>>> http://www.spinics.net/lists/linux-media/msg97997.html
>>>
>>> [5] H264 Rockchip RK3288, RK3399? VPU
>>> https://chromium.googlesource.com/chromiumos/overlays/chromiumos-overlay/+/refs/heads/master/sys-kernel/linux-headers/files/0001-CHROMIUM-media-headers-Import-V4L2-headers-from-Chro.patch
>>>
>>> [6] H264 Rockchip RK3288 VPU
>>> http://www.spinics.net/lists/linux-media/msg105095.html
>>>

-- 
Randy Li
The third produce department


