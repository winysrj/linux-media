Return-path: <linux-media-owner@vger.kernel.org>
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:59152 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762766AbZE0H26 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 May 2009 03:28:58 -0400
Date: Wed, 27 May 2009 16:28:44 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-next@vger.kernel.org, linux-media@vger.kernel.org,
	linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c: Simplified CONFIG_I2C=n interface.
Message-ID: <20090527072843.GB11221@linux-sh.org>
References: <20090527070850.GA11221@linux-sh.org> <20090527091831.26b60d6d@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527091831.26b60d6d@hyperion.delvare>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 27, 2009 at 09:18:31AM +0200, Jean Delvare wrote:
> On Wed, 27 May 2009 16:08:50 +0900, Paul Mundt wrote:
> > Another day, another module-related failure due to the i2c interface
> > being used in code that optionally uses it:
> > 
> > ERROR: "i2c_new_device" [drivers/media/video/soc_camera.ko] undefined!
> > ERROR: "i2c_get_adapter" [drivers/media/video/soc_camera.ko] undefined!
> > ERROR: "i2c_put_adapter" [drivers/media/video/soc_camera.ko] undefined!
> > ERROR: "i2c_unregister_device" [drivers/media/video/soc_camera.ko] undefined!
> > make[2]: *** [__modpost] Error 1
> > make[1]: *** [modules] Error 2
> > make: *** [sub-make] Error 2
> > 
> > In the interest of not continually inserting i2c ifdefs in to every
> > driver that supports an optional i2c interface, this provides a stubbed
> > set of interfaces for the CONFIG_I2C=n case.
> > 
> > I've covered the obvious ones that cause the majority of the build
> > failures, anything more involved really ought to have its dependencies
> > fixed instead.
> 
> Violent nack. Drivers which optionally use I2C are a minority.

If they were a minority we wouldn't be hitting them on a weekly basis,
and other busses already do similar things for similar reasons. You may
not like it, but it's much less distasteful than littering random i2c
ifdefs around every driver that chooses to have an optional i2c
interface. If every multi-bus driver was forced to go through these sorts
of hoops, the drivers would be even less readable than they already are
today.
