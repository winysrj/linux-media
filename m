Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47304 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752377AbdIRN0w (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Sep 2017 09:26:52 -0400
Date: Mon, 18 Sep 2017 16:26:49 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: "Yang, Wenyou" <Wenyou.Yang@Microchip.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH v4 3/3] media: ov7670: Add the s_power operation
Message-ID: <20170918132649.njqvbs3zq6b5iuej@valkosipuli.retiisi.org.uk>
References: <20170918064514.6841-1-wenyou.yang@microchip.com>
 <20170918064514.6841-4-wenyou.yang@microchip.com>
 <20170918073529.wssxfbgfwgd2jzpl@valkosipuli.retiisi.org.uk>
 <dd9ca418-e634-beb3-235f-b93e6abccbf5@Microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd9ca418-e634-beb3-235f-b93e6abccbf5@Microchip.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Wenyou,

On Mon, Sep 18, 2017 at 05:26:16PM +0800, Yang, Wenyou wrote:
> Hi Sakari,
> 
> 
> On 2017/9/18 15:35, Sakari Ailus wrote:
> > Hi Wenyou,
> > 
> > Thanks for the update.
> > 
> > The driver exposes controls that are accessible through the sub-device node
> > even if the device hasn't been powered on.
> > 
> > Many ISP and bridge drivers will also power the sensor down once the last
> > user of the user space device nodes disappears. You could keep the device
> > powered at all times or change the behaviour so that controls can be
> > accessed when the power is off.
> > 
> > The best option would be to convert the driver to use runtime PM.
> Yes, I agree with you.
> I also noticed there are a lot of things needed to improve except for it,
> such as the platform data via device tree.
> I would like do it in another patch set. I will continue to work on it.

Adding runtime PM support later on sound good to me.

> > An example of this can be found in drivers/media/i2c/ov13858.c .
> A good example, thank you for your providing.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
