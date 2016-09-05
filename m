Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:13659 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754234AbcIEKwX (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 5 Sep 2016 06:52:23 -0400
Message-ID: <1473072735.23162.12.camel@mtksdaap41>
Subject: Re: [PATCH v5 0/9] Add MT8173 Video Decoder Driver
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <daniel.thompson@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        "Mauro Carvalho Chehab" <mchehab@osg.samsung.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Pawel Osciak <posciak@chromium.org>,
        Eddie Huang <eddie.huang@mediatek.com>,
        "Yingjoe Chen" <yingjoe.chen@mediatek.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-media@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <PoChun.Lin@mediatek.com>
Date: Mon, 5 Sep 2016 18:52:15 +0800
In-Reply-To: <91bd60ab-868a-78b8-a09d-544376913387@xs4all.nl>
References: <1472818800-22558-1-git-send-email-tiffany.lin@mediatek.com>
         <616d95a4-e6f3-5c42-d435-eb73795bd82c@xs4all.nl>
         <1473069011.23162.7.camel@mtksdaap41>
         <2d332670-edfd-5f2e-2c7f-4346e60baf75@xs4all.nl>
         <91bd60ab-868a-78b8-a09d-544376913387@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, 2016-09-05 at 12:09 +0200, Hans Verkuil wrote:
> On 09/05/2016 11:53 AM, Hans Verkuil wrote:
> > On 09/05/2016 11:50 AM, Tiffany Lin wrote:
> >> Hi Hans,
> >>
> >> On Mon, 2016-09-05 at 11:33 +0200, Hans Verkuil wrote:
> >>> On 09/02/2016 02:19 PM, Tiffany Lin wrote:
> >>>> ==============
> >>>>  Introduction
> >>>> ==============
> >>>>
> >>>> The purpose of this series is to add the driver for video codec hw embedded in the Mediatek's MT8173 SoCs.
> >>>> Mediatek Video Codec is able to handle video decoding and encoding of in a range of formats.
> >>>>
> >>>> This patch series rely on MTK VPU driver that have been merged in v4.8-rc1.
> >>>> Mediatek Video Decoder driver rely on VPU driver to load, communicate with VPU.
> >>>>
> >>>> Internally the driver uses videobuf2 framework, and MTK IOMMU and MTK SMI both have been merged in v4.6-rc1.
> >>>>
> >>>> [1]https://chromium-review.googlesource.com/#/c/245241/
> >>>
> >>> This patch series fails to apply to the media_tree master (patch 3/9). Can you rebase and repost?
> >>>
> >>> I'm ready to make a pull request for this, so I hope you can fix this soon.
> >>>
> >> I saw Encoder fix patches in fixes branch.
> >> This patch series is base on Encoder fix patches. 
> >>
> >> [media] vcodec:mediatek: Refine VP8 encoder driver
> >> [media] vcodec:mediatek: Refine H264 encoder driver
> >> [media] vcodec:mediatek: change H264 profile default to profile high
> >> [media] vcodec:mediatek: Add timestamp and timecode copy for V4L2
> >> Encoder
> >> [media] vcodec:mediatek: Fix visible_height larger than coded_height
> >> issue in s_fmt_out
> >> [media] vcodec:mediatek: Fix fops_vcodec_release flow for V4L2 Encoder
> >> [media] vcodec:mediatek:code refine for v4l2 Encoder driver
> >> [media] dvb_frontend: Use memdup_user() rather than duplicating its
> >> implementation
> >>
> >>
> >> If I do not rebase decoder patch series base on Encoder fix pathces.
> >> Then it will fail after Encoder fix patches merged.
> >>
> >> May I know what parent patch I need to rebase to to fix this issue?
> > 
> > Ah, OK. I will retest placing this on top of those fixes. I forgot about the
> > pending fixes. I'll handle this.
> 
> OK, that works much better when it is on top of the fixes.
> 
> Only one thing is missing: an entry in the MAINTAINERS file. Strange that that
> wasn't done for the encoder driver, we must have missed that. So can you make a
> patch adding the en/decoder driver to this file? I'm ready to make the pull
> request once I have that.
> 
Got it. I will check and update it.

I have a question about decoder device node.
In v5 decoder patch series, I do not add device node patch at end of
patch series.
I plain to put it in MT21C format patch series, is it ok?


best regards,
Tiffany



> Regards,
> 
> 	Hans


