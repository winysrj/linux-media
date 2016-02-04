Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:33223 "EHLO
	mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S965744AbcBDLtt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Feb 2016 06:49:49 -0500
Message-ID: <1454586583.7571.3.camel@mtksdaap41>
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
Date: Thu, 4 Feb 2016 19:49:43 +0800
In-Reply-To: <20160104141506.GA22801@rob-hp-laptop>
References: <1451902316-55931-1-git-send-email-tiffany.lin@mediatek.com>
	 <1451902316-55931-2-git-send-email-tiffany.lin@mediatek.com>
	 <20160104141506.GA22801@rob-hp-laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,




On Mon, 2016-01-04 at 22:15 +0800, Rob Herring wrote:
> On Mon, Jan 04, 2016 at 06:11:49PM +0800, Tiffany Lin wrote:
> > From: Andrew-CT Chen <andrew-ct.chen@mediatek.com>
> > 
> > Add a DT binding documentation of Video Processor Unit for the
> > MT8173 SoC from Mediatek.
> > 
> > Signed-off-by: Andrew-CT Chen <andrew-ct.chen@mediatek.com>
> > Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
> 
> Please add acks when sending new versions as I already acked the last 
> version.
> 
Since we remove iommu attach and add 4GB support for VPU.
We send the new device tree and binding document.
We do not add Acked-by in v4 patches.

> Acked-by: Rob Herring <robh@kernel.org>

best regards,
Tiffany

