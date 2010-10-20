Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:43677 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab0JTMxY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Oct 2010 08:53:24 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] V4L/DVB: Add the via framebuffer camera controller  driver
Date: Wed, 20 Oct 2010 14:53:37 +0200
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
	Florian Tobias Schandinat <florianschandinat@gmx.de>,
	Daniel Drake <dsd@laptop.org>
References: <20101019183211.6af74f57@bike.lwn.net> <98c230e3e395b0bff3cc6e83eb20813c.squirrel@webmail.xs4all.nl> <4CBEE52E.3070704@infradead.org>
In-Reply-To: <4CBEE52E.3070704@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010201453.39145.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

On Wednesday 20 October 2010 14:48:46 Mauro Carvalho Chehab wrote:
> Em 20-10-2010 10:40, Hans Verkuil escreveu:

[snip]

> > Regarding gspca: reversed engineered drivers typically do not use
> > subdevices. (actually gspca doesn't use subdevs at all). So the problem
> > doesn't exist. The whole concept of a reversed engineered sensor
> > sub-device driver makes no sense.
> 
> I don't agree. I think that gspca driver should be converted to use
> sensor drivers, instead of reinventing the wheel for each new webcam.

That's not always possible, as some USB bridges can only perform I2C writes 
and no I2C reads (or, if they can, the feature isn't used by the Windows 
driver and can't be understood by reverse engineering). Most sensor drivers 
will perform I2C reads at least to identify the sensor.

-- 
Regards,

Laurent Pinchart
