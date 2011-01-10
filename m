Return-path: <mchehab@pedra>
Received: from zone0.gcu-squad.org ([212.85.147.21]:15833 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab1AJObq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Jan 2011 09:31:46 -0500
Date: Mon, 10 Jan 2011 15:31:38 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: "Charles D. Krebs" <ckrebs@therealtimegroup.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-i2c@vger.kernel.org
Subject: Re: soc_camera Client Driver with Multiple I2C Addresses
Message-ID: <20110110153138.7871b267@endymion.delvare>
In-Reply-To: <Pine.LNX.4.64.1012280810140.21647@axis700.grange>
References: <E58C9D0E73364C3EB14B6D0A0EBB5433@RSI50>
	<Pine.LNX.4.64.1012280810140.21647@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 28 Dec 2010 08:55:41 +0100 (CET), Guennadi Liakhovetski wrote:
> Hi Charles
> 
> (linux-i2c added to cc)
> 
> On Mon, 27 Dec 2010, Charles D. Krebs wrote:
> 
> > Guennadi,
> > 
> > I'm developing a driver for a video receiver chip that has register 
> > banks on multiple I2C addresses on the same bus.  The data output is 
> > parallel and I will be connecting it to the sh host interface.  
> > Overall, the device appears to be suitable as a client driver to 
> > soc_camera.
> > 
> > I'm following the model for the MT9T112 driver, and this works just fine 
> > for communicating to any one of the device's I2C addresses.
> > 
> > How would you recommend registering more than one I2C address to an 
> > soc_camera client driver?
> 
> Honestly - don't know. The soc-camera model for now is pretty simple and 
> in some senses restrictive. But in principle, it should be possible to 
> code your case within its scope too. One of the possibilities would be to 
> register your platform data with one "main" i2c unit / address, and then 
> let the sensor register the rest in its probe. Is your chip configuration 
> fixed? Always the same number of i2c units with the same addresses? Or can 
> it vary? Maybe something like a multi-function device (drivers/mfd) would 
> suit your purpose well?
> 
> In fact, I think, it shouldn't be too complicated. As suggested above, 
> provide (but don't register, just follow other soc-camera platforms) one 
> main i2c device in the platform data, register the rest in your main 
> probe(), which will call your further probe()s. The easiest would be to 
> keep just one soc-camera instance and one v4l2-subdeice, but if you want, 
> you can explore the possibility of creating several v4l2-subdevices.

If you simply need to handle a device which several I2C addresses, you
can consider one the main address, and register the secondary addresses
in your probe() function using i2c_new_dummy(). See
drivers/misc/eeprom/at24.c for an example of how this is done.

I'm not sure I understand the problem at hand exactly though, so my
advice might be inappropriate.

-- 
Jean Delvare
