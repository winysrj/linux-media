Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:36519 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750963AbcGNHaR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jul 2016 03:30:17 -0400
Message-ID: <1468481410.27199.17.camel@mtksdaap41>
Subject: Re: [PATCH v3 3/9] DocBook/v4l: Add compressed video formats used
 on MT8173 codec driver
From: tiffany lin <tiffany.lin@mediatek.com>
To: Nicolas Dufresne <nicolas@ndufresne.ca>
CC: Wu-Cheng Li =?UTF-8?Q?=28=E6=9D=8E=E5=8B=99=E8=AA=A0=29?=
	<wuchengli@chromium.org>, Hans Verkuil <hverkuil@xs4all.nl>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Daniel Thompson <daniel.thompson@linaro.org>,
	"Rob Herring" <robh+dt@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>,
	Lin PoChun <PoChun.Lin@mediatek.com>
Date: Thu, 14 Jul 2016 15:30:10 +0800
In-Reply-To: <1468418157.2867.12.camel@ndufresne.ca>
References: <1464611363-14936-1-git-send-email-tiffany.lin@mediatek.com>
	  <1464611363-14936-2-git-send-email-tiffany.lin@mediatek.com>
	  <1464611363-14936-3-git-send-email-tiffany.lin@mediatek.com>
	  <1464611363-14936-4-git-send-email-tiffany.lin@mediatek.com>
	  <5a793171-24a7-4e9e-8bfd-f668c789f8e0@xs4all.nl>
	  <1468205771.3725.8.camel@mtksdaap41>
	  <CAOMLVLiZU3D587dSyp2b2v4DV+MS9vh85bA4BoG7ddK6556rbA@mail.gmail.com>
	  <1468350511.8843.16.camel@gmail.com> <1468350842.8843.18.camel@gmail.com>
	 <1468375209.2462.20.camel@mtksdaap41>
	 <1468418157.2867.12.camel@ndufresne.ca>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nicolas,

On Wed, 2016-07-13 at 09:55 -0400, Nicolas Dufresne wrote:
> Le mercredi 13 juillet 2016 à 10:00 +0800, tiffany lin a écrit :
> > Hi Nicolas,
> > 
> > On Tue, 2016-07-12 at 15:14 -0400, Nicolas Dufresne wrote:
> > > Le mardi 12 juillet 2016 à 15:08 -0400, Nicolas Dufresne a écrit :
> > > > Le mardi 12 juillet 2016 à 16:16 +0800, Wu-Cheng Li (李務誠) a écrit
> > :
> > > > > Decoder hardware produces MT21 (compressed). Image processor
> > can
> > > > > convert it to a format that can be input of display driver.
> > > > > Tiffany.
> > > > > When do you plan to upstream image processor (mtk-mdp)?
> > > > > > 
> > > > > > It can be as input format for encoder, MDP and display
> > drivers in
> > > > > our
> > > > > > platform.
> > > > > I remember display driver can only accept uncompressed MT21.
> > Right?
> > > > > Basically V4L2_PIX_FMT_MT21 is compressed and is like an opaque
> > > > > format. It's not usable until it's decompressed and converted
> > by
> > > > > image
> > > > > processor.
> > > > 
> > > > Previously it was described as MediaTek block mode, and now as a
> > > > MediaTek compressed format. It makes me think you have no idea
> > what
> > > > this pixel format really is. Is that right ?
> > > > 
> > > > The main reason why I keep asking, is that we often find
> > similarities
> > > > between what vendor like to call their proprietary formats. Doing
> > the
> > > > proper research helps not creating a mess like in Android where
> > you
> > > > have a lot of formats that all point to the same format. I
> > believe
> > > > there was the same concern when Samsung wanted to introduce their
> > Z-
> > > > flip-Z NV12 tile format. In the end they simply provided
> > sufficient
> > > > documentation so we could document it and implement software
> > > > converters
> > > > for test and validation purpose.
> > > 
> > > Here's the kind of information we want in the documentation.
> > > 
> > > https://chromium.googlesource.com/chromium/src/media/+/master/base/
> > vide
> > > o_types.h#40
> > > 
> > >   // MediaTek proprietary format. MT21 is similar to NV21 except
> > the memory
> > >   // layout and pixel layout (swizzles). 12bpp with Y plane
> > followed by a 2x2
> > >   // interleaved VU plane. Each image contains two buffers -- Y
> > plane and VU
> > >   // plane. Two planes can be non-contiguous in memory. The
> > starting addresses
> > >   // of Y plane and VU plane are 4KB alignment.
> > >   // Suppose image dimension is (width, height). For both Y plane
> > and VU plane:
> > >   // Row pitch = ((width+15)/16) * 16.
> > >   // Plane size = Row pitch * (((height+31)/32)*32)
> > > 
> > > Now obviously this is incomplete, as the swizzling need to be
> > documented of course.
> > > 
> > Because it's finally a compressed format from our codec hw, we cannot
> > describe its swizzling.
> 
> Can you clarify why it cannot be described ? I don't buy any argument
> that it's impossible to convert without hardware. Intel did document
> their compressed formats.
> 
What's the Intel compressed formats? Could you provide link so we could
reference how they provide this information.

> Debugging an integration with such format that we have literally
> decided to no make public is a pain. A lot of decoder got abandoned or
> never used because of that.
> 
> It would be nice to explain the architecture you are suggesting to make
> this decoder useful. How will userspace application be able to use your
> decoder. Will the image processor usable outside the display path ?
> People might want to do transcoding, or other relatively common task
> that does not imply a display.
> 

In MT8173 platform, it has MDP driver, it could convert
V4L2_PIX_FMT_MT21 to V4L2_PIX_FMT_NV12M or V4L2_PIX_FMT_YUV420M.

MDP is stand alone driver, it is usable outside the display path.

NV12M/YUV420M/MT21 -> MDP -> NV12M/YUV420M

NV12M/NV21M/YUV420M/YVU420M -> mt8173 Encoder -> H264/VP8

H264/VP8/VP9 -> mtk8173 Decoder -> MT21

When encode with MT21 source, the pipeline will be:
MT21 -> MDP driver-> NV12M/NV21M/YUV420M/YVU420M -> Encoder -> H264/VP8

When playback, the pipeline will be:
H264/VP8/VP9 -> Decoder driver -> MT21 -> MDP Driver -> DRM


best regards,
Tiffany


> regards,
> Nicolas
> 
> p.s.
> A small note to Wu-Cheng, the definition of the DRM format in your
> Chromium branch is not correct. DRM uses format modifier, such that the
> format is the family, in your case it's most likely NV21, and the
> modifier is the compression or tiling algorithm in place (or both as
> needed).


