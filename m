Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966457Ab3DQOgz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Apr 2013 10:36:55 -0400
Date: Wed, 17 Apr 2013 11:36:39 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mark Brown <broonie@kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, Mike Turquette <mturquette@linaro.org>
Subject: Re: [GIT PULL FOR v3.10] Camera sensors patches
Message-ID: <20130417113639.1c98f574@redhat.com>
In-Reply-To: <20130417135503.GL13687@opensource.wolfsonmicro.com>
References: <3775187.HOcoQVPfEE@avalon>
	<8085333.TIMqcSUBaO@avalon>
	<20130415094248.2272db90@redhat.com>
	<1471330.zeTIWizKy8@avalon>
	<516D8C1E.2080704@redhat.com>
	<516D92C4.2040403@samsung.com>
	<20130417135503.GL13687@opensource.wolfsonmicro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 17 Apr 2013 14:55:03 +0100
Mark Brown <broonie@kernel.org> escreveu:

> On Tue, Apr 16, 2013 at 08:04:52PM +0200, Sylwester Nawrocki wrote:
> 
> > It's probably more clean to provide a dummy clock/regulator in a host driver
> > (platform) than to add something in a sub-device drivers that would resolve
> > which resources should be requested and which not.
> 
> Yes, that's the general theory for regulators at least - it allows the
> device driver to just trundle along and not worry about how the board is
> hooked up.  The other issue it resolves that you didn't mention is that
> it avoids just ignoring errors which isn't terribly clever.

I agree. Adding dummy clock/regulator at the host platform driver makes
sense, as the platform driver knows how the board is hooked up; keeping 
it at the I2C driver doesn't make sense, so the code needs to be moved
away from it.

Laurent,

Could you please work on a patch moving that code to the host platform
driver?

Thanks!
Mauro
