Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:41855 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753731AbdAJWps (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Jan 2017 17:45:48 -0500
Date: Wed, 11 Jan 2017 07:45:43 +0900
From: Andi Shyti <andi.shyti@samsung.com>
To: kbuild test robot <lkp@intel.com>
Cc: sean.wang@mediatek.com, kbuild-all@01.org, mchehab@osg.samsung.com,
        hdegoede@redhat.com, hkallweit1@gmail.com, robh+dt@kernel.org,
        mark.rutland@arm.com, matthias.bgg@gmail.com, hverkuil@xs4all.nl,
        sean@mess.org, ivo.g.dimitrov.75@gmail.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        keyhaede@gmail.com
Subject: Re: [PATCH v2 2/2] media: rc: add driver for IR remote receiver on
 MT7623 SoC
Message-id: <20170110224543.uuoa7ofkvolz6inp@gangnam.samsung>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <201701102015.fSM15CvI%fengguang.wu@intel.com>
References: <CGME20170110120828epcas4p42482b7920c7a7dabd4c7794959f6d264@epcas4p4.samsung.com>
 <201701102015.fSM15CvI%fengguang.wu@intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean,

>    include/linux/compiler.h:253:8: sparse: attribute 'no_sanitize_address': unknown attribute
> >> drivers/media/rc/mtk-cir.c:215:41: sparse: too many arguments for function devm_rc_allocate_device
>    drivers/media/rc/mtk-cir.c: In function 'mtk_ir_probe':
>    drivers/media/rc/mtk-cir.c:215:11: error: too many arguments to function 'devm_rc_allocate_device'
>      ir->rc = devm_rc_allocate_device(dev, RC_DRIVER_IR_RAW);
>               ^~~~~~~~~~~~~~~~~~~~~~~
>    In file included from drivers/media/rc/mtk-cir.c:22:0:
>    include/media/rc-core.h:213:16: note: declared here
>     struct rc_dev *devm_rc_allocate_device(struct device *dev);
>                    ^~~~~~~~~~~~~~~~~~~~~~~
> 
> vim +/devm_rc_allocate_device +215 drivers/media/rc/mtk-cir.c
> 
>    209		ir->base = devm_ioremap_resource(dev, res);
>    210		if (IS_ERR(ir->base)) {
>    211			dev_err(dev, "failed to map registers\n");
>    212			return PTR_ERR(ir->base);
>    213		}
>    214	
>  > 215		ir->rc = devm_rc_allocate_device(dev, RC_DRIVER_IR_RAW);

this error comes because the patches I pointed out have not been
applied yet. I guess you can ignore them as long as you tested
yours on top those patches.

Andi
