Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:52714 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752849AbcKNJzL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Nov 2016 04:55:11 -0500
Subject: Re: [RFC] V4L2 unified low-level decoder API
To: Hugues FRUCHET <hugues.fruchet@st.com>,
        "florent.revest@free-electrons.com"
        <florent.revest@free-electrons.com>,
        "hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
        "posciak@chromium.org" <posciak@chromium.org>,
        "jung.zhao@rock-chips.com" <jung.zhao@rock-chips.com>,
        "randy.li@rock-chips.com" <randy.li@rock-chips.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <2890f845-eef2-5689-f154-fc76ae6abc8b@st.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <816ba2d8-f1e7-ce34-3524-b2a3f1bf3d74@xs4all.nl>
Date: Mon, 14 Nov 2016 10:55:04 +0100
MIME-Version: 1.0
In-Reply-To: <2890f845-eef2-5689-f154-fc76ae6abc8b@st.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/27/2016 09:42 AM, Hugues FRUCHET wrote:
> Hi,
> 
> This RFC aims to start discussions in order to define the codec specific 
> controls structures to fulfill the low-level decoder API needed by non 
> "Stream API" based decoders ("stateless" or "Frame API" based decoders).

Let's refer to this as 'stateful' decoders and 'stateless' decoders. This
is the preferred terminology (and much more descriptive than 'Stream' vs
'Frame'). It's also not really a new API, although it does rely on the
Request API.

> Several implementation exists now which runs on several SoC and various 
> software frameworks.
> The idea is to find the communalities between all those implementations 
> and SoC to define a single unified interface in V4L2 includes.
> Even if "Request API" is needed to pass those codec specific controls 
> from userspace down to kernel on a per-buffer basis, we can start 
> discussions and define the controls in parallel of its development.
> We can even propose some implementations based on existing V4L2 control 
> framework (which doesn't support "per-frame" basis) by ensuring 
> atomicity of sequence S_EXT_CTRL(header[i])/QBUF(stream[i]). Constraint 
> can then be relaxed when "Request API" is merged.
> 
> I would like to propose to work on a "per-codec" basis, having at least 
> 2 different SoC and 2 different frameworks to test and validate controls.
> To do so, I have tried to identify some people that have worked on this 
> subject and have proposed some implementations, feel free to correct me 
> and enhance the list if needed:
> * MPEG2/MPEG4
>     - Florent Revest for Allwinner A13 CedarX support [1] tested with 
> VLC -> libVA + sunxi-cedrus-drv-video -> V4L2
>     - Myself for STMicroelectronics Delta support [2] tested with 
> GStreamer V4L2 -> libv4l2 + libv4l-delta plugin -> V4L2
> 
> * VP8
> - Pawel Osciak for Rockchip RK3288, RK3399? VPU Support [3] tested with 
> Chromium -> V4L2
> - Jung Zhao for Rockchip RK3288 VPU support [4] <cannot find the 
> framework used>
> 
> * H264
> - Pawel Osciak for Rockchip RK3288, RK3399? VPU Support [5] tested with 
> Chromium -> V4L2
> - Randy Li for Rockchip RK3288  VPU support [6] tested with VLC? -> 
> libVA + rockchip-va-driver -> V4L2
> VLC? -> libVDPAU + rockchip-va-driver -> V4L2
> 
> I can work to define MPEG2/MPEG4 controls and propose functional 
> implementations for those codecs, and will be glad to co-work with you 
> Florent.
> I can help on H264 on a code review basis based on the functional H264 
> setup I have in-house and codec knowledge, but I cannot provide 
> implementation in a reasonable timeframe, same for VP8.
> 
> Apart of very details of each codec, we have also to state about generic 
> concerns such as:
> - new pixel format introduction (VP8 => VP8F, H264 => S264, MPG2 => 
> MG2F, MPG4 => MG4F)
> - new device caps to indicate that driver requires extra headers ? maybe 
> not needed because redundant with new pixel format

That's indeed typically signaled through the pixelformat.

> - continue to modify v4l2-controls.h ? or do we add some new specific 
> header files (H264 is huge!) ?
> - how to manage sequence header & picture header, optional/extended 
> controls (MPEG2 sequence/picture extensions, H264 SEI, ...). Personally 
> I have added flags inside a single control structure, H264 is done in a 
> different way using several controls (SPS/PPS/SLICE/DECODE/...)
> 
> Thanks you to all of you for your attention and feel free to react on 
> this topic if you are interested to work on this subject.

As long as the V4L2 driver underpins the various solutions I am happy :-)

I do think that having a libv4l plugin will be useful since it will make
it easy for applications that support the stateful decoder to use the
same code for a stateless decoder by seamlessly using the plugin.

This does not prevent other approaches at the same time, of course.

Regards,

	Hans

> 
> Best regards,
> Hugues.
> 
> [0] [ANN] Codec & Request API Brainstorm meeting Oct 10 & 
> 11https://www.spinics.net/lists/linux-media/msg106699.html
> [1] MPEG2 A13 CedarXhttp://www.spinics.net/lists/linux-media/msg104823.html
> [1] MPEG4 A13 CedarXhttp://www.spinics.net/lists/linux-media/msg104817.html
> [2] MPEG2 STi4xx 
> Deltahttp://www.spinics.net/lists/linux-media/msg106240.html
> [2] MPEG4 STi4xx Delta is also supported but not yet pushed
> [3] VP8 Rockchip RK3288, RK3399? 
> VPUhttps://chromium.googlesource.com/chromiumos/overlays/chromiumos-overlay/+/refs/heads/master/sys-kernel/linux-headers/files/0002-CHROMIUM-v4l-Add-VP8-low-level-decoder-API-controls.patch 
> [4] VP8 Rockchip RK3288 
> VPUhttp://www.spinics.net/lists/linux-media/msg97997.html
> [5] H264 Rockchip RK3288, RK3399? 
> VPUhttps://chromium.googlesource.com/chromiumos/overlays/chromiumos-overlay/+/refs/heads/master/sys-kernel/linux-headers/files/0001-CHROMIUM-media-headers-Import-V4L2-headers-from-Chro.patch
> [6] H264 Rockchip RK3288 
> VPUhttp://www.spinics.net/lists/linux-media/msg105095.html
> N�����r��y���b�X��ǧv�^�)޺{.n�+����{���bj)���w*jg��������ݢj/���z�ޖ��2�ޙ���&�)ߡ�a�����G���h��j:+v���w�٥
> 
