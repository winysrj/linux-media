Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:46605 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751036AbeEVNTZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 09:19:25 -0400
References: <20180517125033.18050-1-rui.silva@linaro.org> <20180517125033.18050-7-rui.silva@linaro.org> <20180518065824.csio2fgwsxo2g2ow@valkosipuli.retiisi.org.uk> <m3tvr5xt9t.fsf@linaro.org> <20180518221346.fy4264hehvjjcd4y@kekkonen.localdomain>
From: Rui Miguel Silva <rmfrfs@gmail.com>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Rui Miguel Silva <rui.silva@linaro.org>,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ryan Harkin <ryan.harkin@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Fabio Estevam <fabio.estevam@nxp.com>, mchehab@kernel.org,
        Shawn Guo <shawnguo@kernel.org>, linux-media@vger.kernel.org
Subject: Re: [PATCH v4 06/12] media: dt-bindings: add bindings for i.MX7 media driver
In-reply-to: <20180518221346.fy4264hehvjjcd4y@kekkonen.localdomain>
Date: Tue, 22 May 2018 14:19:21 +0100
Message-ID: <m336yjvndy.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,
On Fri 18 May 2018 at 22:13, Sakari Ailus wrote:
> On Fri, May 18, 2018 at 09:27:58AM +0100, Rui Miguel Silva 
> wrote:
>> > > +endpoint node
>> > > +-------------
>> > > +
>> > > +- data-lanes    : (required) an array specifying active 
>> > > physical
>> > > MIPI-CSI2
>> > > +		    data input lanes and their mapping to 
>> > > logical lanes; the
>> > > +		    array's content is unused, only its 
>> > > length is meaningful;
>
> Btw. do note that you may get a warning due to this from the 
> CSI-2 bus
> property parsing code if the lane numbers are wrong.
>
>> > > +
>> > > +- fsl,csis-hs-settle : (optional) differential receiver 
>> > > (HS-RX)
>> > > settle time;
>> > 
>> > Could you calculate this, as other drivers do? It probably 
>> > changes
>> > depending on the device runtime configuration.
>> 
>> The only reference to possible values to this parameter is 
>> given by
>> table in [0], can you point me out the formula for imx7 in the
>> documentation?
>
> I don't know imx7 but the other CSI-2 drivers need no such 
> system specific
> configuration.

Hum, I think there is at least one more (which this is compliant) 
that
also use this configuration parameter. [0]

---
Cheers,
	Rui

[0]: 
https://github.com/torvalds/linux/blob/a048a07d7f4535baa4cbad6bc024f175317ab938/Documentation/devicetree/bindings/media/samsung-mipi-csis.txt#L46
