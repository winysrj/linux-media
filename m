Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:41962 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab0JKXUd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Oct 2010 19:20:33 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] viafb camera controller driver
Date: Tue, 12 Oct 2010 01:20:31 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	Daniel Drake <dsd@laptop.org>
References: <20101010162313.5caa137f@bike.lwn.net> <201010111418.56274.laurent.pinchart@ideasonboard.com> <20101011093048.432ea83a@bike.lwn.net>
In-Reply-To: <20101011093048.432ea83a@bike.lwn.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010120120.32270.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Jonathan,

On Monday 11 October 2010 17:30:48 Jonathan Corbet wrote:
> On Mon, 11 Oct 2010 14:18:55 +0200
> 
> Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:
> > > +static __devexit int viacam_remove(struct platform_device *pdev)
> > > +{
> > > +	struct via_camera *cam = via_cam_info;
> > 
> > And use it here.
> > 
> > Just call platform_set_drvdata(pdev, cam) in viacam_probe to store the
> > struct via_camera pointer in the platform device, and
> > platform_get_drvdata(pdev) here to retrieve it.
> 
> Yes, I know...but the fix isn't quite that simple because the platform
> data is already used elsewhere.

Aren't you mistaking platform_data and platform device drvdata ? 
platform_{gs}et_drvdata() access the 
platform_device::device::device_private::driver_data, which is a private 
pointer reserved for driver-specific information. pdev->dev.platform_data is a 
private pointer that stores platform-specific data (often configuration data) 
in the platform device.

> What's needed is some sort of "viafb subdevice instance" structure which can
> keep all of the pointers together.  My plan is to do that, but it will
> require via-core changes and I just don't have time for that right now.
> 
> Can I get away with this (it will cause no real-world trouble) with a
> promise of a fix in the next month or two?  I have some other via-core
> stuff (suspend/resume in particular) that I need to do anyway.

If the platform device driver data is really used by something else, OK. But 
don't dare not keeping your promise ;-)

-- 
Regards,

Laurent Pinchart
