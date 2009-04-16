Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:34672 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756773AbZDPTE6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Apr 2009 15:04:58 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/5] soc-camera: convert to platform device
References: <Pine.LNX.4.64.0904151356480.4729@axis700.grange>
	<87ljq1mz7f.fsf@free.fr> <87tz4o7al6.fsf@free.fr>
	<Pine.LNX.4.64.0904161955140.4947@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Thu, 16 Apr 2009 21:04:47 +0200
In-Reply-To: <Pine.LNX.4.64.0904161955140.4947@axis700.grange> (Guennadi Liakhovetski's message of "Thu\, 16 Apr 2009 20\:14\:38 +0200 \(CEST\)")
Message-ID: <87d4bch12o.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

>>  - I unload and reload mt9m111 and pxa_camera
>>     => not any better
>
> Actually, I think, in this case it should be found again, as long as you 
> reload pxa-camera while i2c-pxa is already loaded.
Damn, you're right. I cross-checked, and reloading pxa_camera rescans the
sensor.

>> What I'm getting at is that if soc_camera is loaded before the i2c host driver,
>> no camera will get any chance to work. Is that normal considering the new driver
>> model ?
>> I was naively thinking that there would be a "rescan" when the "control" was
>> being available for a sensor.
>
> Yes, unfortunately, it is "normal":-( On the one hand, we shouldn't really 
> spend _too_ much time on this intermediate version, because, as I said, it 
> is just a preparatory step for v4l2-subdev. We just have to make sure it 
> doesn't introduce any significant regressions and doesn't crash too often. 
OK. So from my side everything is OK (let aside my nitpicking in mioa701.c and
mt9m111.c).

> OTOH, this is also how it is with v4l2-subdev. With it you first must have 
> the i2c-adapter driver loaded. Then, when a match between a camera host 
> and a camera client (sensor) platform device is detected, it is reported 
> to the v4l2-subdev core, which loads the respective camera i2c driver.
OK, why not.

> If you then unload the camera-host and i2c adapter drivers, and then you load
> the camera-host driver, it then fails to get the adapter, and if you then load
> it, nothing else happens. To reprobe you have to unload and reload the camera
> host driver.

So be it. I'm sure we'll be through it once more in the v4l2-subdev transition,
so I'll let aside any objection I could mutter :)

Cheers.

--
Robert
