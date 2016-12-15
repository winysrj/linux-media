Return-path: <linux-media-owner@vger.kernel.org>
Received: from smida.it ([94.23.22.176]:36565 "EHLO smtp.smida.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752223AbcLOQ0k (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 11:26:40 -0500
Date: Fri, 16 Dec 2016 01:01:18 +0900
From: Andi Shyti <andi@etezian.org>
To: Sean Young <sean@mess.org>
Cc: Andi Shyti <andi.shyti@samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Shyti <andi@etezian.org>
Subject: Re: [PATCH v4 2/6] [media] rc-main: split setup and unregister
 functions
Message-ID: <20161215160118.77hz5kuqjmxuotry@jack.zhora.eu>
References: <20161214140030.28537-1-andi.shyti@samsung.com>
 <20161214140030.28537-3-andi.shyti@samsung.com>
 <20161215155049.GA23320@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161215155049.GA23320@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> > +	/* rc_open will be called here */
> > +	rc = input_register_device(dev->input_dev);
> > +	if (rc)
> > +		goto out_table;
> > +
> > +	dev->input_dev->dev.parent = &dev->dev;
> > +	memcpy(&dev->input_dev->id, &dev->input_id, sizeof(dev->input_id));
> > +	dev->input_dev->phys = dev->input_phys;
> > +	dev->input_dev->name = dev->input_name;
> 
> I was testing your changes, and with this patch none of my rc devices
> have input devices associated with them. The problem is that you've changed
> the order: input_register_device() should happen AFTER the preceding
> 4 lines.

This must have been a copy paste error and I don't have
transmitters to test it. Thanks for testing it. I will send it
again.

Andi
