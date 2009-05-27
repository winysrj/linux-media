Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:7674 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761230AbZE0HSg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 May 2009 03:18:36 -0400
Date: Wed, 27 May 2009 09:18:31 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-next@vger.kernel.org, linux-media@vger.kernel.org,
	linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c: Simplified CONFIG_I2C=n interface.
Message-ID: <20090527091831.26b60d6d@hyperion.delvare>
In-Reply-To: <20090527070850.GA11221@linux-sh.org>
References: <20090527070850.GA11221@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 27 May 2009 16:08:50 +0900, Paul Mundt wrote:
> Another day, another module-related failure due to the i2c interface
> being used in code that optionally uses it:
> 
> ERROR: "i2c_new_device" [drivers/media/video/soc_camera.ko] undefined!
> ERROR: "i2c_get_adapter" [drivers/media/video/soc_camera.ko] undefined!
> ERROR: "i2c_put_adapter" [drivers/media/video/soc_camera.ko] undefined!
> ERROR: "i2c_unregister_device" [drivers/media/video/soc_camera.ko] undefined!
> make[2]: *** [__modpost] Error 1
> make[1]: *** [modules] Error 2
> make: *** [sub-make] Error 2
> 
> In the interest of not continually inserting i2c ifdefs in to every
> driver that supports an optional i2c interface, this provides a stubbed
> set of interfaces for the CONFIG_I2C=n case.
> 
> I've covered the obvious ones that cause the majority of the build
> failures, anything more involved really ought to have its dependencies
> fixed instead.

Violent nack. Drivers which optionally use I2C are a minority.
Designing them in such a way that a single #ifdef CONFIG_I2C will make
them work can't be that hard, really. Not to mention that having a
dozen stubs in i2c.h in the CONFIG_I2C=n case won't save you much work
at the driver level anyway, because you certainly need to run different
code paths depending on how the device is connected, and you also have
to differentiate between the "I2C support is missing" case and the "I2C
device registration failed" case, etc.

-- 
Jean Delvare
