Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:64390 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751016AbcGMBvq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 21:51:46 -0400
Message-ID: <1468374654.2462.17.camel@mtksdaap41>
Subject: Re: [PATCH v3 3/9] DocBook/v4l: Add compressed video formats used
 on MT8173 codec driver
From: tiffany lin <tiffany.lin@mediatek.com>
To: <nicolas@ndufresne.ca>
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
Date: Wed, 13 Jul 2016 09:50:54 +0800
In-Reply-To: <1468350511.8843.16.camel@gmail.com>
References: <1464611363-14936-1-git-send-email-tiffany.lin@mediatek.com>
	  <1464611363-14936-2-git-send-email-tiffany.lin@mediatek.com>
	  <1464611363-14936-3-git-send-email-tiffany.lin@mediatek.com>
	  <1464611363-14936-4-git-send-email-tiffany.lin@mediatek.com>
	  <5a793171-24a7-4e9e-8bfd-f668c789f8e0@xs4all.nl>
	 <1468205771.3725.8.camel@mtksdaap41>
	 <CAOMLVLiZU3D587dSyp2b2v4DV+MS9vh85bA4BoG7ddK6556rbA@mail.gmail.com>
	 <1468350511.8843.16.camel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nicolas,

On Tue, 2016-07-12 at 15:08 -0400, Nicolas Dufresne wrote:
> Le mardi 12 juillet 2016 à 16:16 +0800, Wu-Cheng Li (李務誠) a écrit :
> > Decoder hardware produces MT21 (compressed). Image processor can
> > convert it to a format that can be input of display driver. Tiffany.
> > When do you plan to upstream image processor (mtk-mdp)?
> > >
> > > It can be as input format for encoder, MDP and display drivers in
> > our
> > > platform.
> > I remember display driver can only accept uncompressed MT21. Right?
> > Basically V4L2_PIX_FMT_MT21 is compressed and is like an opaque
> > format. It's not usable until it's decompressed and converted by
> > image
> > processor.
> 
> Previously it was described as MediaTek block mode, and now as a
> MediaTek compressed format. It makes me think you have no idea what
> this pixel format really is. Is that right ?
> 
That's not right.
Its a compressed format as I document in "[PATCH v3 3/9] DocBook/v4l:
Add compressed video formats used on MT8173 codec driver."
In MT8173 platform, when using this format, we need Image Processor to
cover it to standard format as wucheng mentioned.
To prevent this ambiguous, I will change it to V4L2_PIX_FMT_M21C, it
means its compressed data. Is it ok?

best regards,
Tiffany

> The main reason why I keep asking, is that we often find similarities
> between what vendor like to call their proprietary formats. Doing the
> proper research helps not creating a mess like in Android where you
> have a lot of formats that all point to the same format. I believe
> there was the same concern when Samsung wanted to introduce their Z-
> flip-Z NV12 tile format. In the end they simply provided sufficient
> documentation so we could document it and implement software converters
> for test and validation purpose.
> 
> regards,
> Nicolas


