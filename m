Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:55700 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751823AbcBEBoy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Feb 2016 20:44:54 -0500
Message-ID: <1454636687.24985.2.camel@mtksdaap41>
Subject: Re: [PATCH v3 1/8] dt-bindings: Add a binding for Mediatek Video
 Processor
From: tiffany lin <tiffany.lin@mediatek.com>
To: Rob Herring <robh@kernel.org>
CC: "daniel.thompson@linaro.org" <daniel.thompson@linaro.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Daniel Kurtz <djkurtz@chromium.org>,
	Eddie Huang =?UTF-8?Q?=28=E9=BB=83=E6=99=BA=E5=82=91=29?=
	<eddie.huang@mediatek.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>,
	Andrew-CT Chen =?UTF-8?Q?=28=E9=99=B3=E6=99=BA=E8=BF=AA=29?=
	<Andrew-CT.Chen@mediatek.com>
Date: Fri, 5 Feb 2016 09:44:47 +0800
In-Reply-To: <CAL_JsqJqQ+QRgg6HGQeGk0=rBEwQq7i-ZfoDahZwXLuvMC-=_A@mail.gmail.com>
References: <1451902316-55931-1-git-send-email-tiffany.lin@mediatek.com>
	 <1451902316-55931-2-git-send-email-tiffany.lin@mediatek.com>
	 <20160104141506.GA22801@rob-hp-laptop> <1454586583.7571.3.camel@mtksdaap41>
	 <CAL_JsqJqQ+QRgg6HGQeGk0=rBEwQq7i-ZfoDahZwXLuvMC-=_A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,


On Thu, 2016-02-04 at 12:04 -0600, Rob Herring wrote:
> On Thu, Feb 4, 2016 at 5:49 AM, tiffany lin <tiffany.lin@mediatek.com> wrote:
> > Hi Rob,
> >
> >
> >
> >
> > On Mon, 2016-01-04 at 22:15 +0800, Rob Herring wrote:
> >> On Mon, Jan 04, 2016 at 06:11:49PM +0800, Tiffany Lin wrote:
> >> > From: Andrew-CT Chen <andrew-ct.chen@mediatek.com>
> >> >
> >> > Add a DT binding documentation of Video Processor Unit for the
> >> > MT8173 SoC from Mediatek.
> >> >
> >> > Signed-off-by: Andrew-CT Chen <andrew-ct.chen@mediatek.com>
> >> > Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
> >>
> >> Please add acks when sending new versions as I already acked the last
> >> version.
> >>
> > Since we remove iommu attach and add 4GB support for VPU.
> > We send the new device tree and binding document.
> > We do not add Acked-by in v4 patches.
> 
> Okay, then you should explain that in the patch.
> 
Got it. I explained that in cover-letter "[PATCH v4 0/8] Add MT8173
Video Encoder Driver and VPU Driver", I will explain it in the patch in
next version.

> Rob


