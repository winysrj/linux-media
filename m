Return-path: <linux-media-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.138]:36481 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750760AbdESIP6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 May 2017 04:15:58 -0400
Subject: Re: [RFC] V4L2 unified low-level decoder API
To: Hugues FRUCHET <hugues.fruchet@st.com>
References: <2890f845-eef2-5689-f154-fc76ae6abc8b@st.com>
 <816ba2d8-f1e7-ce34-3524-b2a3f1bf3d74@xs4all.nl>
 <fb4a4815-e1ff-081e-787a-0213e32a5405@st.com>
 <8f93f4f2df49431cb2750963c2f7b168@SFHDAG5NODE2.st.com>
 <48b04997-bd80-5640-4272-2c4d69c25a97@st.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        "florent.revest@free-electrons.com"
        <florent.revest@free-electrons.com>,
        "posciak@chromium.org" <posciak@chromium.org>,
        "tfiga@chromium.org" <tfiga@chromium.org>,
        "jung.zhao@rock-chips.com" <jung.zhao@rock-chips.com>,
        "laurent.pinchart@ideasonboard.com"
        <laurent.pinchart@ideasonboard.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: Randy Li <randy.li@rock-chips.com>
Message-ID: <817c32e2-270c-0879-7f29-ec4eae0bcaa1@rock-chips.com>
Date: Fri, 19 May 2017 16:15:49 +0800
MIME-Version: 1.0
In-Reply-To: <48b04997-bd80-5640-4272-2c4d69c25a97@st.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 05/19/2017 04:08 PM, Hugues FRUCHET wrote:
> Hi all,
> 
> Here is the latest st-delta MPEG2 code:
> [PATCH v6 0/3] Add support for MPEG-2 in DELTA video decoder
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg112067.html
> [PATCH v2 0/3] Add a libv4l plugin for video bitstream parsing
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg112076.html
> 
I would review it.
> Before merging this work Hans would like to have feedback from peers, in
> order to be sure that this is inline with other SoC vendors drivers
> expectations.
> 
> Thomasz, Pawel, could you give your view regarding ChromeOS and Rockchip
> driver ?
The work of the rockchip just re-start a few weeks age, I have just 
finished the driver probing type as I decide to make a clean beginning. 
The video IP of the rockchip is too complext with a different combine.

The pixel format will begin in JPEG then AVC. I am now more familiar 
with those codec now.
> Laurent, could you give your view regarding Renesas driver ?
> 
> I have also added in appendice [7] the materials presented by Laurent at
> ELC 2017 in Portland to introduce stateless video codecs and V4L2
> request API, thanks for this presentation Laurent.
> 
> 
> Best regards,
> Hugues.
> 
>> On 02/07/2017 08:21 AM, Hugues FRUCHET wrote:
>> Hi,
>>
>> Here is an update regarding MPEG-2 implementation based on ST video decoder:
>> * MPEG-2 API + DELTA kernel driver:
>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg107405.html
>> * libv4l-codecparsers plugin including MPEG-2 back-end:
>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg107812.html
>>
>> Please note that this is implemented & functional using currently available V4L2 control framework (no Request API), assuming that user side keeps unicity of S_EXT_CTRL() / QBUF(OUTPUT) pair.
>> Request API will remove this constraint, but the point here is to define control interface, as far as I have understood code, Request API will not affect those control definitions.
>>
>> Some updates inline thereafter regarding activities on this subject; me for MPEG-2 on ST platform and Randy Li, Nicolas Dufresne, Ayaka for H264 on Rockchip platform:
>>
>>
>> On 11/14/2016 10:55 AM, Hans Verkuil wrote:
>>> On 10/27/2016 09:42 AM, Hugues FRUCHET wrote:
>>>> Hi,
>>>>
>>>> This RFC aims to start discussions in order to define the codec
>>>> specific controls structures to fulfill the low-level decoder API
>>>> needed by non "Stream API" based decoders ("stateless" or "Frame API" based decoders).
>>>
>>> Let's refer to this as 'stateful' decoders and 'stateless' decoders.
>>> This is the preferred terminology (and much more descriptive than
>>> 'Stream' vs 'Frame'). It's also not really a new API, although it does
>>> rely on the Request API.
>>>
>>>> Several implementation exists now which runs on several SoC and
>>>> various software frameworks.
>>>> The idea is to find the communalities between all those
>>>> implementations and SoC to define a single unified interface in V4L2 includes.
>>>> Even if "Request API" is needed to pass those codec specific controls
>>>> from userspace down to kernel on a per-buffer basis, we can start
>>>> discussions and define the controls in parallel of its development.
>>>> We can even propose some implementations based on existing V4L2
>>>> control framework (which doesn't support "per-frame" basis) by
>>>> ensuring atomicity of sequence S_EXT_CTRL(header[i])/QBUF(stream[i]).
>>>> Constraint can then be relaxed when "Request API" is merged.
>>>>
>>>> I would like to propose to work on a "per-codec" basis, having at
>>>> least
>>>> 2 different SoC and 2 different frameworks to test and validate controls.
>>>> To do so, I have tried to identify some people that have worked on
>>>> this subject and have proposed some implementations, feel free to
>>>> correct me and enhance the list if needed:
>>>> * MPEG2/MPEG4
>>>>       - Florent Revest for Allwinner A13 CedarX support [1] tested with
>>>> VLC -> libVA + sunxi-cedrus-drv-video -> V4L2
>>>>       - Myself for STMicroelectronics Delta support [2] tested with
>>>> GStreamer V4L2 -> libv4l2 + libv4l-delta plugin -> V4L2
>> Available on ST platform with [2] & [2.1] patchset series.
>>
>>>>
>>>> * VP8
>>>> - Pawel Osciak for Rockchip RK3288, RK3399? VPU Support [3] tested
>>>> with Chromium -> V4L2
>>>> - Jung Zhao for Rockchip RK3288 VPU support [4] <cannot find the
>>>> framework used>
>>>>
>>>> * H264
>>>> - Pawel Osciak for Rockchip RK3288, RK3399? VPU Support [5] tested
>>>> with Chromium -> V4L2
>>>> - Randy Li for Rockchip RK3288  VPU support [6] tested with VLC? ->
>>>> libVA + rockchip-va-driver -> V4L2 VLC? -> libVDPAU +
>>>> rockchip-va-driver -> V4L2
>> Tested with Gstreamer -> VA-API element -> Rockchip VA-API driver -> V4L2 https://github.com/rockchip-linux/libvdpau-rockchip
>>
>> Study on-going for H264 userland/kernel partitioning in this thread:
>> Request API: stateless VPU: the buffer mechanism and DPB management:
>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg107165.html
>>
>>>>
>>>> I can work to define MPEG2/MPEG4 controls and propose functional
>>>> implementations for those codecs, and will be glad to co-work with
>>>> you Florent.
>>>> I can help on H264 on a code review basis based on the functional
>>>> H264 setup I have in-house and codec knowledge, but I cannot provide
>>>> implementation in a reasonable timeframe, same for VP8.
>>>>
>>>> Apart of very details of each codec, we have also to state about
>>>> generic concerns such as:
>>>> - new pixel format introduction (VP8 => VP8F, H264 => S264, MPG2 =>
>>>> MG2F, MPG4 => MG4F)
>>>> - new device caps to indicate that driver requires extra headers ?
>>>> maybe not needed because redundant with new pixel format
>>>
>>> That's indeed typically signaled through the pixelformat.
>>>
>>
>> [2] is implemented this way in [media] v4l: add parsed MPEG-2 support, two new pixel format MG1P and MG2P ("P" for "Parsed") have been introduced:
>> +#define V4L2_PIX_FMT_MPEG1_PARSED v4l2_fourcc('M', 'G', '1', 'P') /*
>> MPEG1 with parsing metadata given through controls */
>> +#define V4L2_PIX_FMT_MPEG2_PARSED v4l2_fourcc('M', 'G', '2', 'P') /*
>> MPEG2 with parsing metadata given through controls */
>>
>> libv4l plugin [2.1] intercepts the pixel format information negotiated
>> between user and driver (enum_fmt/try_fmt/get_fmt/s_fmt) and selects the
>> right parser to use to convert MPEG-2 compressed format to new "MPEG-2
>> parsed" compressed format required by kernel driver.
>> Plugin is designed to support several formats.
>>
>>
>>>> - continue to modify v4l2-controls.h ? or do we add some new specific
>>>> header files (H264 is huge!) ?
>>>> - how to manage sequence header & picture header, optional/extended
>>>> controls (MPEG2 sequence/picture extensions, H264 SEI, ...). Personally
>>>> I have added flags inside a single control structure, H264 is done in a
>>>> different way using several controls (SPS/PPS/SLICE/DECODE/...)
>>>>
>>>> Thanks you to all of you for your attention and feel free to react on
>>>> this topic if you are interested to work on this subject.
>>>
>>> As long as the V4L2 driver underpins the various solutions I am happy :-)
>>>
>>> I do think that having a libv4l plugin will be useful since it will make
>>> it easy for applications that support the stateful decoder to use the
>>> same code for a stateless decoder by seamlessly using the plugin.
>>>
>>> This does not prevent other approaches at the same time, of course.
>>>
>>> Regards,
>>>
>>> Hans
>>>
>> [2] implements new extended controls for MPEG-2 in [media] v4l: add
>> parsed MPEG-2 support
>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg107406.html
>> This has been done in uapi/linux/v4l2-controls.h as extension of already
>> existing MPEG video controls, defining one control per "header" (so not
>> using a single control with selection flag):
>> #define V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_HDR
>> #define V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_EXT
>> #define V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_DISPLAY_EXT
>> #define V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_MATRIX_EXT
>> #define V4L2_CID_MPEG_VIDEO_MPEG2_PIC_HDR
>> #define V4L2_CID_MPEG_VIDEO_MPEG2_PIC_EXT
>>
>> Those controls and their associated data structure have been defined
>> based on MPEG-2 standard ISO/IEC 13818-2.
>>
>>>>
>>>> Best regards,
>>>> Hugues.
>>>>
>>>> [0] [ANN] Codec & Request API Brainstorm meeting Oct 10 &
>>>> 11https://www.spinics.net/lists/linux-media/msg106699.html
>>>> [1] MPEG2 A13 CedarXhttp://www.spinics.net/lists/linux-media/msg104823.html
>>>> [1] MPEG4 A13 CedarXhttp://www.spinics.net/lists/linux-media/msg104817.html
>>>> [2] MPEG2 STi4xx
>>>> Deltahttp://www.spinics.net/lists/linux-media/msg106240.html
>> [2] MPEG2 DELTA kernel driver: http://www.mail-archive.com/linux-
>> media@vger.kernel.org/msg107405.html
>> [2.1] MPEG2 libv4l plugin:
>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg107812.html
>>
>>>> [2] MPEG4 STi4xx Delta is also supported but not yet pushed
>>>> [3] VP8 Rockchip RK3288, RK3399?
>>>> VPUhttps://chromium.googlesource.com/chromiumos/overlays/chromiumos-overlay/+/refs/heads/master/sys-kernel/linux-headers/files/0002-CHROMIUM-v4l-Add-VP8-low-level-decoder-API-controls.patch
>>>> [4] VP8 Rockchip RK3288
>>>> VPUhttp://www.spinics.net/lists/linux-media/msg97997.html
>>>> [5] H264 Rockchip RK3288, RK3399?
>>>> VPUhttps://chromium.googlesource.com/chromiumos/overlays/chromiumos-overlay/+/refs/heads/master/sys-kernel/linux-headers/files/0001-CHROMIUM-media-headers-Import-V4L2-headers-from-Chro.patch
>>>> [6] H264 Rockchip RK3288
>>>> VPUhttp://www.spinics.net/lists/linux-media/msg105095.html
>> https://github.com/rockchip-linux/libvdpau-rockchip
>> https://github.com/rockchip-linux/gstreamer-rockchip
>> https://github.com/rockchip-linux/mpp
> [7] "2017 is the Year of the Linux Video Codec Drivers" presentation
> done by Laurent Pinchart @ ELC 2017 Portland
> https://www.youtube.com/watch?v=Y5P8CE9RtFs
> http://events.linuxfoundation.org/sites/events/files/slides/20170223-elc.pdf
> 

-- 
Randy Li
