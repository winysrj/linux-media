Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53119 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396Ab3DUXOA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Apr 2013 19:14:00 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mark Brown <broonie@kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, Mike Turquette <mturquette@linaro.org>
Subject: Re: [GIT PULL FOR v3.10] Camera sensors patches
Date: Mon, 22 Apr 2013 01:14:07 +0200
Message-ID: <1905734.rpqfOCmvCu@avalon>
In-Reply-To: <20130417113639.1c98f574@redhat.com>
References: <3775187.HOcoQVPfEE@avalon> <20130417135503.GL13687@opensource.wolfsonmicro.com> <20130417113639.1c98f574@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Wednesday 17 April 2013 11:36:39 Mauro Carvalho Chehab wrote:
> Em Wed, 17 Apr 2013 14:55:03 +0100 Mark Brown escreveu:
> > On Tue, Apr 16, 2013 at 08:04:52PM +0200, Sylwester Nawrocki wrote:
> > > It's probably more clean to provide a dummy clock/regulator in a host
> > > driver (platform) than to add something in a sub-device drivers that
> > > would resolve which resources should be requested and which not.
> > 
> > Yes, that's the general theory for regulators at least - it allows the
> > device driver to just trundle along and not worry about how the board is
> > hooked up.  The other issue it resolves that you didn't mention is that
> > it avoids just ignoring errors which isn't terribly clever.
> 
> I agree. Adding dummy clock/regulator at the host platform driver makes
> sense, as the platform driver knows how the board is hooked up; keeping
> it at the I2C driver doesn't make sense, so the code needs to be moved
> away from it.
> 
> Laurent,
> 
> Could you please work on a patch moving that code to the host platform
> driver?

I think that Mark's point was that the regulators should be provided by 
platform code (in the generic sense, it could be DT on ARM, board code, or a 
USB bridge driver for a webcam that uses the mt9p031 sensor) and used by the 
sensor driver. That's exactly what my mt9p031 patch does.

-- 
Regards,

Laurent Pinchart

