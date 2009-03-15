Return-path: <linux-media-owner@vger.kernel.org>
Received: from vena.lwn.net ([206.168.112.25]:58971 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754413AbZCOWXm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2009 18:23:42 -0400
Date: Sun, 15 Mar 2009 16:23:38 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de
Subject: Re: RFC: ov7670 soc-camera driver
Message-ID: <20090315162338.3be11fec@bike.lwn.net>
In-Reply-To: <49BD3669.1070409@cam.ac.uk>
References: <49BD3669.1070409@cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 15 Mar 2009 17:10:01 +0000
Jonathan Cameron <jic23@cam.ac.uk> wrote:

> The primary control on this chip related to shutter rate is actualy
> the frame rate. There are rather complex (and largerly undocumented)
> interactions between this setting and the auto brightness controls
> etc. Anyone have any suggestions on a better way of specifying this?

Welcome to the world of the ov7670!  My conclusion, after working with
this sensor, is that is consists of something like 150 analog tweakers
disguised as digital registers.  Everything interacts with everything
else, many of the settings are completely undocumented, and that's not
to mention the weird multiplexor at 0x79.  It's hard to make this thing
work if you don't have a blessed set of settings from OmniVision.

> Clearly this driver shares considerable portions of code with
> Jonathan Corbet's driver (in tree). It would be complex to combine
> the two drivers, but perhaps people feel this would be worthwhile?

I think it's necessary, really.  Having two drivers for the same device
seems like a bad idea.  As Hans noted, he's already put quite a bit of
work into generalizing the ov7670 driver; I think it would be best to
work with him to get a driver that works for everybody.

Thanks,

jon
