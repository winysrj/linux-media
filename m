Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53204 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbcFRL2b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Jun 2016 07:28:31 -0400
Date: Sat, 18 Jun 2016 13:28:27 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	pali.rohar@gmail.com, sre@kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH 1/1] v4l: Add camera voice coil lens control class,
 current control
Message-ID: <20160618112827.GE20130@amd>
References: <20160527205140.GA26767@amd>
 <575DD89F.20607@gmail.com>
 <20160617221149.GB31380@amd>
 <1475378.4YrS70O1yW@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1475378.4YrS70O1yW@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

> If someone has analyzed the existing voice coil lens controllers and could 
> share the result, in term of what parameters need to be controlled by the 
> system and how they should be controlled, that would be very appreciated. Even 
> better would be a real userspace implementation of a voice coil lens control 
> algorithm.

Userspace implementation exists, it is called fcam-dev. What it
does... Starts capture, selects focus speed, makes it go through focus
range, looks for the sharpest image in the stream.

Then it computes time when the image was sharpest and thus lens
position, and goes back there.

So for ad5820, we need basically focus position and focus speed. (And
some 16/64 option).

Other coil drivers also have PWM vs. linear option.

Best regards,

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
