Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:34611 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754281Ab0JKPau (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Oct 2010 11:30:50 -0400
Date: Mon, 11 Oct 2010 09:30:48 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	Daniel Drake <dsd@laptop.org>
Subject: Re: [PATCH] viafb camera controller driver
Message-ID: <20101011093048.432ea83a@bike.lwn.net>
In-Reply-To: <201010111418.56274.laurent.pinchart@ideasonboard.com>
References: <20101010162313.5caa137f@bike.lwn.net>
	<201010111418.56274.laurent.pinchart@ideasonboard.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 11 Oct 2010 14:18:55 +0200
Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote:

> > +static __devexit int viacam_remove(struct platform_device *pdev)
> > +{
> > +	struct via_camera *cam = via_cam_info;  
> 
> And use it here.
> 
> Just call platform_set_drvdata(pdev, cam) in viacam_probe to store the struct 
> via_camera pointer in the platform device, and platform_get_drvdata(pdev) here 
> to retrieve it.

Yes, I know...but the fix isn't quite that simple because the platform
data is already used elsewhere.  What's needed is some sort of "viafb
subdevice instance" structure which can keep all of the pointers
together.  My plan is to do that, but it will require via-core changes
and I just don't have time for that right now.

Can I get away with this (it will cause no real-world trouble) with a
promise of a fix in the next month or two?  I have some other via-core
stuff (suspend/resume in particular) that I need to do anyway.

Thanks,

jon
