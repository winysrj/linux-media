Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:49346 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755670Ab1EZLBZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 May 2011 07:01:25 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Daniel Lundborg" <Daniel.Lundborg@prevas.se>
Subject: Re: omap3isp - H3A auto white balance
Date: Thu, 26 May 2011 13:01:30 +0200
Cc: linux-media@vger.kernel.org
References: <CA7B7D6C54015B459601D68441548157C5A3FC@prevas1.prevas.se>
In-Reply-To: <CA7B7D6C54015B459601D68441548157C5A3FC@prevas1.prevas.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105261301.32159.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Daniel,

On Thursday 26 May 2011 10:57:39 Daniel Lundborg wrote:
> 
> Hello,
> 
> I am developing a camera sensor driver for the Aptina MT9V034. I am only
> using it in snapshot mode and I can successfully trigger the sensor and
> receive pictures using the latest omap3isp driver from
> git://linuxtv.org/pinchartl/media.git branch omap3isp-next-sensors with
> kernel 2.6.38.
> 
> I configure the sensor with media-ctl:
> 
> media-ctl -r -l '"mt9v034 3-0048":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP
> CCDC":1->"OMAP3 ISP CCDC output":0[1]'
> 
> media-ctl -f '"mt9v034 3-0048":0[SGRBG10 752x480], "OMAP3 ISP
> CCDC":1[SGRBG10 752x480]'
> 
> And take pictures with yavta:
> 
> ./yavta -f SGRBG10 -s 752x480 -n 6 --capture=6 -F /dev/video2
> 
> My trouble is that I am always receiving whiter pictures when I wait a
> moment before triggering the sensor to take a picture. If I take several
> pictures in a row with for instance 20 ms between them, they all look
> ok. But if I wait for 100 ms the picture will get much whiter.
> 
> I have turned off auto exposure and auto gain in the sensor and the
> LED_OUT signal always have the same length (in this case 8 msec).

I assume you've measured it with a scope ?

Try disabling black level calibration and row noise correction as well. Please 
also double-check that AEC and AGC are disabled. I've had a similar issue with 
an MT9V032 sensor, where a bug in the driver enabled AEC/AGC instead of 
disabling them.

Do you have a light source connected to the LED_OUT signal ? If so, can you 
try disabling it and using a constant light source ?

> Why would the pictures become whiter if I wait a moment before taking a
> picture?
>
> If I set the sensor in streaming mode all pictures look like they
> should.
> 
> Could there be something with the H3A auto white balance or auto exposure?

The OMAP3 ISP isn't able to apply any H3A algorithm to the images by itself. 
The H3A hardware support only computes statistics, and a userspace application 
then needs to compute parameters (such as exposure time and gains) based on 
the statistics, and apply them to the hardware. As yavta doesn't include H3A 
algorithms, the differences in picture brightness can only come from the 
sensor.

-- 
Regards,

Laurent Pinchart
