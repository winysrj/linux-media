Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:50092 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754177Ab0JKMTB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Oct 2010 08:19:01 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] viafb camera controller driver
Date: Mon, 11 Oct 2010 14:18:55 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	Daniel Drake <dsd@laptop.org>
References: <20101010162313.5caa137f@bike.lwn.net>
In-Reply-To: <20101010162313.5caa137f@bike.lwn.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010111418.56274.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Jonathan,

On Monday 11 October 2010 00:23:13 Jonathan Corbet wrote:
> Howdy, all,
> 
> Well, that took a whole lot longer than I had hoped...but, attached, is a
> new version of the viafb camera driver patch, done against 2.6.36-rc7.
> I've tried to address most of Laurent's comments from back in June; in
> particular, I have:
> 
>  - Gotten rid of the static device structure

Thanks. There's one more left, and it's easy to remove, see below.

>  - Fixed some locking glitches
>  - Fixed a bit of device initialization silliness.
> 
> One thing I have *not* done is to push locking down into the ov7670
> driver.  That would be a good thing to do at some point, but playing with
> that driver was beyond the scope of what I was trying to do here.
> 
> This driver will still need some OLPC bits to work properly, but Daniel is
> working on that.  This version of the driver does work on XO-1.5 systems,
> modulo some 2.6.36 API changes.

[snip]

> +/*
> + * Yes, this is a hack, but there's only going to be one of these
> + * on any system we know of.
> + */
> +static struct via_camera *via_cam_info;

That's what I'm talking about.

[snip]

> +static __devinit int viacam_probe(struct platform_device *pdev)
> +{

[snip]

> +	/*
> +	 * Basic structure initialization.
> +	 */
> +	cam = kzalloc (sizeof(struct via_camera), GFP_KERNEL);
> +	if (cam == NULL)
> +		return -ENOMEM;
> +	via_cam_info = cam;

You set it here.

[snip]

> +static __devexit int viacam_remove(struct platform_device *pdev)
> +{
> +	struct via_camera *cam = via_cam_info;

And use it here.

Just call platform_set_drvdata(pdev, cam) in viacam_probe to store the struct 
via_camera pointer in the platform device, and platform_get_drvdata(pdev) here 
to retrieve it.

-- 
Regards,

Laurent Pinchart
