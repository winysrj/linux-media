Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:43451 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570AbZDPRte (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Apr 2009 13:49:34 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/5] soc-camera: convert to platform device
References: <Pine.LNX.4.64.0904151356480.4729@axis700.grange>
	<87ljq1mz7f.fsf@free.fr>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Thu, 16 Apr 2009 19:49:25 +0200
In-Reply-To: <87ljq1mz7f.fsf@free.fr> (Robert Jarzmik's message of "Wed\, 15 Apr 2009 22\:36\:20 +0200")
Message-ID: <87tz4o7al6.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Robert Jarzmik <robert.jarzmik@free.fr> writes:

> I need to make some additionnal tests with I2C loading/unloading, but otherwise
> it works perfectly for (soc_camera / pxa_camera /mt9m111 combination).

Guennadi,

I made some testing, and there is something I don't understand in the new device
model.
This is the testcase I'm considering :
 - I unload i2c-pxa, pxa-camera, mt9m111, soc-camera modules
 - I load pxa-camera, mt9m111, soc-camera modules
 - I then load i2c-pxa
    => the mt9m111 is not detected
 - I unload and reload mt9m111 and pxa_camera
    => not any better
 - I unload soc_camera, mt9m111, pxa_camera and reload
    => this time the video device is detected

What I'm getting at is that if soc_camera is loaded before the i2c host driver,
no camera will get any chance to work. Is that normal considering the new driver
model ?
I was naively thinking that there would be a "rescan" when the "control" was
being available for a sensor.

Cheers.

--
Robert
