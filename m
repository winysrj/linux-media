Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:18415 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751845AbdGDKKL (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Jul 2017 06:10:11 -0400
Date: Tue, 04 Jul 2017 19:10:08 +0900
From: Andi Shyti <andi.shyti@samsung.com>
To: sean.wang@mediatek.com
Cc: mchehab@osg.samsung.com, sean@mess.org, hdegoede@redhat.com,
        hkallweit1@gmail.com, robh+dt@kernel.org, mark.rutland@arm.com,
        matthias.bgg@gmail.com, hverkuil@xs4all.nl,
        ivo.g.dimitrov.75@gmail.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 0/4] media: rc: add support for IR receiver on MT7622
 SoC
Message-id: <20170704101008.pgnjacbsk3twadzo@gangnam.samsung>
MIME-version: 1.0
Content-type: text/plain; charset="us-ascii"
Content-disposition: inline
In-reply-to: <cover.1498794408.git.sean.wang@mediatek.com>
References: <CGME20170630060312epcas4p351a77795e8469640d5177039f6b1955d@epcas4p3.samsung.com>
        <cover.1498794408.git.sean.wang@mediatek.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean,

> This patchset introduces Consumer IR (CIR) support for MT7622 SoC
> implements raw mode for more compatibility with different protocols
> as previously SoC did. Before adding support to MT7622 SoC, extra
> code refactor is done since there're major differences in register and
> field definition from the previous SoC.
> 
> Sean Wang (4):
>   dt-bindings: media: mtk-cir: Add support for MT7622 SoC
>   media: rc: mtk-cir: add platform data to adapt into various hardware
>   media: rc: mtk-cir: add support for MediaTek MT7622 SoC
>   MAINTAINERS: add entry for MediaTek CIR driver

for the whole patchset:

Reviewed-by: Andi Shyti <andi.shyti@samsung.com>

Andi
