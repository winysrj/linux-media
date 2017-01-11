Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw02.mediatek.com ([210.61.82.184]:60912 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1763131AbdAKJ1Z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Jan 2017 04:27:25 -0500
Message-ID: <1484126839.4057.32.camel@mtkswgap22>
Subject: Re: [PATCH v2 2/2] media: rc: add driver for IR remote receiver on
 MT7623 SoC
From: Sean Wang <sean.wang@mediatek.com>
To: Andi Shyti <andi.shyti@samsung.com>
CC: kbuild test robot <lkp@intel.com>, <kbuild-all@01.org>,
        <mchehab@osg.samsung.com>, <hdegoede@redhat.com>,
        <hkallweit1@gmail.com>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <matthias.bgg@gmail.com>,
        <hverkuil@xs4all.nl>, <sean@mess.org>,
        <ivo.g.dimitrov.75@gmail.com>, <linux-media@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <keyhaede@gmail.com>
Date: Wed, 11 Jan 2017 17:27:19 +0800
In-Reply-To: <20170110224543.uuoa7ofkvolz6inp@gangnam.samsung>
References: <CGME20170110120828epcas4p42482b7920c7a7dabd4c7794959f6d264@epcas4p4.samsung.com>
         <201701102015.fSM15CvI%fengguang.wu@intel.com>
         <20170110224543.uuoa7ofkvolz6inp@gangnam.samsung>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

okay, I will continue to work based on your changes unless someone else
has concerns

On Wed, 2017-01-11 at 07:45 +0900, Andi Shyti wrote:
> Hi Sean,
> 
> >    include/linux/compiler.h:253:8: sparse: attribute 'no_sanitize_address': unknown attribute
> > >> drivers/media/rc/mtk-cir.c:215:41: sparse: too many arguments for function devm_rc_allocate_device
> >    drivers/media/rc/mtk-cir.c: In function 'mtk_ir_probe':
> >    drivers/media/rc/mtk-cir.c:215:11: error: too many arguments to function 'devm_rc_allocate_device'
> >      ir->rc = devm_rc_allocate_device(dev, RC_DRIVER_IR_RAW);
> >               ^~~~~~~~~~~~~~~~~~~~~~~
> >    In file included from drivers/media/rc/mtk-cir.c:22:0:
> >    include/media/rc-core.h:213:16: note: declared here
> >     struct rc_dev *devm_rc_allocate_device(struct device *dev);
> >                    ^~~~~~~~~~~~~~~~~~~~~~~
> > 
> > vim +/devm_rc_allocate_device +215 drivers/media/rc/mtk-cir.c
> > 
> >    209		ir->base = devm_ioremap_resource(dev, res);
> >    210		if (IS_ERR(ir->base)) {
> >    211			dev_err(dev, "failed to map registers\n");
> >    212			return PTR_ERR(ir->base);
> >    213		}
> >    214	
> >  > 215		ir->rc = devm_rc_allocate_device(dev, RC_DRIVER_IR_RAW);
> 
> this error comes because the patches I pointed out have not been
> applied yet. I guess you can ignore them as long as you tested
> yours on top those patches.
> 
> Andi


