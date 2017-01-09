Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:58099 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935260AbdAIMjq (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Jan 2017 07:39:46 -0500
Date: Mon, 9 Jan 2017 12:39:42 +0000
From: Sean Young <sean@mess.org>
To: Sean Wang <sean.wang@mediatek.com>
Cc: mchehab@osg.samsung.com, hdegoede@redhat.com, hkallweit1@gmail.com,
        robh+dt@kernel.org, mark.rutland@arm.com, matthias.bgg@gmail.com,
        andi.shyti@samsung.com, hverkuil@xs4all.nl,
        ivo.g.dimitrov.75@gmail.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        keyhaede@gmail.com
Subject: Re: [PATCH 2/2] media: rc: add driver for IR remote receiver on
 MT7623 SoC
Message-ID: <20170109123942.GA15215@gofer.mess.org>
References: <1483632384-8107-1-git-send-email-sean.wang@mediatek.com>
 <1483632384-8107-3-git-send-email-sean.wang@mediatek.com>
 <20170105171240.GA9136@gofer.mess.org>
 <1483687885.16976.19.camel@mtkswgap22>
 <20170108211624.GB7866@gofer.mess.org>
 <1483931601.16976.48.camel@mtkswgap22>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1483931601.16976.48.camel@mtkswgap22>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 09, 2017 at 11:13:21AM +0800, Sean Wang wrote:
> I had another question. I found multiple and same IR messages being
> received when using SONY remote controller. Should driver needs to
> report each message or only one of these to the upper layer ?

In general the driver shouldn't try to change any IR message, this should
be done in rc-core if necessary.

rc-core should handle this correctly. If the same key is received twice
within IR_KEYPRESS_TIMEOUT (250ms) then it not reported to the input
layer.

Thanks
Sean
