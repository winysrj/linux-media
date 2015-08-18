Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:33866 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbbHSFLx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Aug 2015 01:11:53 -0400
Date: Tue, 18 Aug 2015 13:22:02 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, thomas@tommie-lie.de, sean@mess.org,
	linux-input@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	lars@opdenkamp.eu, kamil@wypas.org,
	Hans Verkuil <hansverk@cisco.com>
Subject: Re: [PATCHv8 07/15] cec: add HDMI CEC framework
Message-ID: <20150818202202.GA18724@dtor-pixel>
References: <cover.1439886203.git.hans.verkuil@cisco.com>
 <87a579ddacf90718a166fbb8a777b5d8cd05200b.1439886203.git.hans.verkuil@cisco.com>
 <20150818100020.GM7557@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150818100020.GM7557@n2100.arm.linux.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 18, 2015 at 11:00:20AM +0100, Russell King - ARM Linux wrote:
> On Tue, Aug 18, 2015 at 10:26:32AM +0200, Hans Verkuil wrote:
> > +	/* Part 2: Initialize and register the character device */
> > +	cdev_init(&cecdev->cdev, &cec_devnode_fops);
> > +	cecdev->cdev.owner = owner;
> > +
> > +	ret = cdev_add(&cecdev->cdev, MKDEV(MAJOR(cec_dev_t), cecdev->minor),
> > +									1);
> > +	if (ret < 0) {
> > +		pr_err("%s: cdev_add failed\n", __func__);
> > +		goto error;
> > +	}
> > +
> > +	/* Part 3: Register the cec device */
> > +	cecdev->dev.bus = &cec_bus_type;
> > +	cecdev->dev.devt = MKDEV(MAJOR(cec_dev_t), cecdev->minor);
> > +	cecdev->dev.release = cec_devnode_release;
> > +	if (cecdev->parent)
> > +		cecdev->dev.parent = cecdev->parent;
> > +	dev_set_name(&cecdev->dev, "cec%d", cecdev->minor);
> > +	ret = device_register(&cecdev->dev);
> 
> It's worth pointing out that you can greatly simplify the lifetime
> handling (you don't need to get and put cecdev->dev) if you make
> the cdev a child of the cecdev->dev.
> 
> If you grep for kobj.parent in drivers/ you'll see many drivers are
> doing this.
> 
> 	cecdev->cdev.kobj.parent = &cecdev->dev.kobj;
> 
> but you will need to call device_initialize() on cecdev->dev first,
> and use device_add() here.

This is basically a requirement if one embeds both device and a cdev
into the same structure. Trying to do get/put in the driver is racy,
you need to let framework know (by setting cdve's parent to the device
structure).

Thanks.

-- 
Dmitry
