Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:10470 "EHLO
	mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752529AbcHOJKz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2016 05:10:55 -0400
Message-ID: <1471252247.28498.8.camel@mtksdaap41>
Subject: Re: [PATCH v3 0/9] Add MT8173 Video Decoder Driver
From: Tiffany Lin <tiffany.lin@mediatek.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Hans Verkuil <hans.verkuil@cisco.com>,
	<daniel.thompson@linaro.org>, "Rob Herring" <robh+dt@kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Pawel Osciak <posciak@chromium.org>,
	Eddie Huang <eddie.huang@mediatek.com>,
	Yingjoe Chen <yingjoe.chen@mediatek.com>,
	<devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-media@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, <PoChun.Lin@mediatek.com>
Date: Mon, 15 Aug 2016 17:10:47 +0800
In-Reply-To: <74aa2d31-97dd-d274-e07d-b4532c0f4fa5@xs4all.nl>
References: <1464611363-14936-1-git-send-email-tiffany.lin@mediatek.com>
	 <bdac7fe1-6425-2a3d-777f-86cfd1ee26e0@xs4all.nl>
	 <1471251821.28498.7.camel@mtksdaap41>
	 <74aa2d31-97dd-d274-e07d-b4532c0f4fa5@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,


On Mon, 2016-08-15 at 11:07 +0200, Hans Verkuil wrote:
> On 08/15/2016 11:03 AM, Tiffany Lin wrote:
> > Hi Hans,
> > 
> > I upstream v4 on 8/10, I don't know why this version is not shown in
> > https://patchwork.kernel.org.
> > But I could see it in other link.
> > http://www.spinics.net/lists/arm-kernel/msg523095.html
> > I refine DocBook and vb2 queue_setup function in v4.
> > 
> > For the MT21 format, if I put MT21 into separate patch, this patch
> > series will build fail, I was confused how to fix this issue?
> 
> Just don't implement that pixelformat yet. I.e. everything else can be
> implemented, just don't add MT21 to the list of pixelformats. Do that in
> a separate patch at the end.
> 
> If that pixelformat isn't exposed, then nobody will use it either :-)
> 
Got it now.
Thanks a lot.


best regards,
Tiffany

> Regards,
> 
> 	Hans


