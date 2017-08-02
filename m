Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:4455 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751591AbdHBCYL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 1 Aug 2017 22:24:11 -0400
Message-ID: <1501640647.17690.25.camel@mtkswgap22>
Subject: Re: [PATCH v1 0/4] media: rc: add support for IR receiver on MT7622
 SoC
From: Sean Wang <sean.wang@mediatek.com>
To: <mchehab@kernel.org>, <mchehab@osg.samsung.com>, <sean@mess.org>,
        <mchehab@osg.samsung.com>
CC: Andi Shyti <andi.shyti@samsung.com>, <hdegoede@redhat.com>,
        <hkallweit1@gmail.com>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <matthias.bgg@gmail.com>,
        <hverkuil@xs4all.nl>, <ivo.g.dimitrov.75@gmail.com>,
        <linux-media@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Date: Wed, 2 Aug 2017 10:24:07 +0800
In-Reply-To: <20170704101008.pgnjacbsk3twadzo@gangnam.samsung>
References: <CGME20170630060312epcas4p351a77795e8469640d5177039f6b1955d@epcas4p3.samsung.com>
         <cover.1498794408.git.sean.wang@mediatek.com>
         <20170704101008.pgnjacbsk3twadzo@gangnam.samsung>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi, Mauro and Sean

Just a gentle ping on the whole patchset porting MediaTek CIR to another
platform.

	Sean


On Tue, 2017-07-04 at 19:10 +0900, Andi Shyti wrote:
> Hi Sean,
> 
> > This patchset introduces Consumer IR (CIR) support for MT7622 SoC
> > implements raw mode for more compatibility with different protocols
> > as previously SoC did. Before adding support to MT7622 SoC, extra
> > code refactor is done since there're major differences in register and
> > field definition from the previous SoC.
> > 
> > Sean Wang (4):
> >   dt-bindings: media: mtk-cir: Add support for MT7622 SoC
> >   media: rc: mtk-cir: add platform data to adapt into various hardware
> >   media: rc: mtk-cir: add support for MediaTek MT7622 SoC
> >   MAINTAINERS: add entry for MediaTek CIR driver
> 
> for the whole patchset:
> 
> Reviewed-by: Andi Shyti <andi.shyti@samsung.com>
> 
> Andi
