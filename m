Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:34102 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1162364AbdAFDn4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 5 Jan 2017 22:43:56 -0500
Date: Fri, 06 Jan 2017 12:43:46 +0900
From: Andi Shyti <andi.shyti@samsung.com>
To: sean.wang@mediatek.com
Cc: mchehab@osg.samsung.com, hdegoede@redhat.com, hkallweit1@gmail.com,
        robh+dt@kernel.org, mark.rutland@arm.com, matthias.bgg@gmail.com,
        hverkuil@xs4all.nl, sean@mess.org, ivo.g.dimitrov.75@gmail.com,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        keyhaede@gmail.com
Subject: Re: [PATCH 2/2] media: rc: add driver for IR remote receiver on MT7623
 SoC
Message-id: <20170106034346.7njhyhtsc4yado5c@gangnam.samsung>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <1483632384-8107-3-git-send-email-sean.wang@mediatek.com>
References: <1483632384-8107-1-git-send-email-sean.wang@mediatek.com>
 <CGME20170105160810epcas3p1b7a85197c15fbbe87e08c736259935d6@epcas3p1.samsung.com>
 <1483632384-8107-3-git-send-email-sean.wang@mediatek.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean,

> +	ir->rc = rc_allocate_device();

Yes, you should use devm_rc_allocate_device(...)

Besides, standing to this patch which is not in yet:

https://lkml.org/lkml/2016/12/18/39

rc_allocate_device should provide the driver type during
allocation, so it should be:

	ir->rc = rc_allocate_device(RC_DRIVER_IR_RAW);

and this line can be removed:

> +	ir->rc->driver_type = RC_DRIVER_IR_RAW;

I don't know when Mauro will take the patch above.

Andi
