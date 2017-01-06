Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgw01.mediatek.com ([210.61.82.183]:62741 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1030735AbdAFHlk (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Jan 2017 02:41:40 -0500
Message-ID: <1483688490.16976.26.camel@mtkswgap22>
Subject: Re: [PATCH 2/2] media: rc: add driver for IR remote receiver on
 MT7623 SoC
From: Sean Wang <sean.wang@mediatek.com>
To: Andi Shyti <andi.shyti@samsung.com>
CC: <mchehab@osg.samsung.com>, <hdegoede@redhat.com>,
        <hkallweit1@gmail.com>, <robh+dt@kernel.org>,
        <mark.rutland@arm.com>, <matthias.bgg@gmail.com>,
        <hverkuil@xs4all.nl>, <sean@mess.org>,
        <ivo.g.dimitrov.75@gmail.com>, <linux-media@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <keyhaede@gmail.com>
Date: Fri, 6 Jan 2017 15:41:30 +0800
In-Reply-To: <20170106034346.7njhyhtsc4yado5c@gangnam.samsung>
References: <1483632384-8107-1-git-send-email-sean.wang@mediatek.com>
         <CGME20170105160810epcas3p1b7a85197c15fbbe87e08c736259935d6@epcas3p1.samsung.com>
         <1483632384-8107-3-git-send-email-sean.wang@mediatek.com>
         <20170106034346.7njhyhtsc4yado5c@gangnam.samsung>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andi,

Thank for your reminder. I will refine the code based on your work.
to have elegant code and easy error handling.

Sean

On Fri, 2017-01-06 at 12:43 +0900, Andi Shyti wrote:
> Hi Sean,
> 
> > +	ir->rc = rc_allocate_device();
> 
> Yes, you should use devm_rc_allocate_device(...)
> 
> Besides, standing to this patch which is not in yet:
> 
> https://lkml.org/lkml/2016/12/18/39
> 
> rc_allocate_device should provide the driver type during
> allocation, so it should be:
> 
> 	ir->rc = rc_allocate_device(RC_DRIVER_IR_RAW);
> 
> and this line can be removed:
> 
> > +	ir->rc->driver_type = RC_DRIVER_IR_RAW;
> 
> I don't know when Mauro will take the patch above.
> 
> Andi


