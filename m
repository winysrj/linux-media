Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59840 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752346AbcFVHqM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2016 03:46:12 -0400
Date: Wed, 22 Jun 2016 10:22:15 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: Sebastian Reichel <sre@kernel.org>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	pali.rohar@gmail.com, linux-media@vger.kernel.org
Subject: Re: Nokia N900 cameras -- pipeline setup in python (was Re: [RFC
 PATCH 00/24] Make Nokia N900 cameras working)
Message-ID: <20160622072214.GR24980@valkosipuli.retiisi.org.uk>
References: <20160420081427.GZ32125@valkosipuli.retiisi.org.uk>
 <1461532104-24032-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
 <20160427030850.GA17034@earth>
 <20160617164226.GA27876@amd>
 <20160617171214.GA5830@amd>
 <20160620205904.GL24980@valkosipuli.retiisi.org.uk>
 <20160621180549.GA9602@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160621180549.GA9602@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

On Tue, Jun 21, 2016 at 08:05:49PM +0200, Pavel Machek wrote:
> Hi!
> 
> > > > First, I re-did pipeline setup in python, it seems slightly less hacky
> > > > then in shell.
> > > > 
> > > > I tried to modify fcam-dev to work with the new interface, but was not
> > > > successful so far. I can post patches if someone is interested
> > > > (mplayer works for me, but that's not too suitable for taking photos).
> > > > 
> > > > I tried to get gstreamer to work, with something like:
> > > 
> > > While trying to debug gstreamer, I ran v4l2-compliance, and it seems
> > > to suggest that QUERYCAP is required... but it is not present on
> > > /dev/video2 or video6.
> > 
> > It's not saying that it wouldn't be present, but the content appears wrong.
> > It should have the real bus information there rather than just "media".
> > 
> > See e.g. drivers/media/platform/vsp1/vsp1_drv.c . I suppose that should be
> > right.
> > 
> > Feel free to submit a patch. :-)
> 
> For now I'd not know what to change, sorry :-(. Perhaps we can debug
> it after the support is merged into mainline.

A single line change to change the bus field contents to the actual bus
address.

	grep -A1 platform: drivers/media/platform/vsp1/vsp1_drv.c

> 
> Another weirdness:
> 
> yavta, on v4l-subdev12 :
> 
> control 0x00a40906 `Sensivity' min 0 max 0 step 1 default 0 current 65536.
> 
> Min and max being the same, I don't think I can control the
> sensitivity. I guess I'll have to provid  more light for the tests for
> now...

That control should be removed. I think I concluded its value is the same
for all the modes...

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
