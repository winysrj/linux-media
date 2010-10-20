Return-path: <mchehab@pedra>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:3137 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758265Ab0JTHHy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Oct 2010 03:07:54 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] V4L/DVB: Add the via framebuffer camera controller driver
Date: Wed, 20 Oct 2010 09:07:35 +0200
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org,
	Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
	Daniel Drake <dsd@laptop.org>
References: <20101019183211.6af74f57@bike.lwn.net>
In-Reply-To: <20101019183211.6af74f57@bike.lwn.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010200907.35954.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wednesday, October 20, 2010 02:32:11 Jonathan Corbet wrote:
> OK, here's a new version of the patch, done against the V4L tree.  Now
> with 100% fewer compiler errors!  It took a while to figure out the API
> changes, and I'm not convinced I like them all - the controller driver
> didn't used to have to worry about format details, but now it does -
> but so it goes.

I'm afraid that that change is a sign of V4L growing up and being used in
much more demanding environments like the omap3. While the pixel format and
media bus format have a trivial mapping in this controller driver, things
become a lot more complicated if the same sensor driver were to be used in
e.g. the omap3 SoC.

The sensor driver does not know what the video will look like in memory. It
just passes the video data over a physical bus to some other device. That
other device is what usually determines how the video data it receives over
the bus is DMA-ed into memory. Simple devices just copy the video data almost
directly to memory, but more complex devices can do colorspace transformations,
dword swapping, 4:2:2 to 4:2:0 conversions, scaling, etc., etc.

So what finally arrives in memory may look completely different from what the
sensor supplies.

The consequence of supporting these more complex devices is that it also
makes simple device drivers a bit more complex.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
