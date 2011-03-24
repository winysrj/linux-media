Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.128.24]:25141 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932228Ab1CXI1o (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2011 04:27:44 -0400
Message-ID: <4D8B00FA.1090008@maxwell.research.nokia.com>
Date: Thu, 24 Mar 2011 10:29:46 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Daniel Lundborg <daniel.lundborg@prevas.se>
CC: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: OMAP3 isp single-shot
References: <loom.20110323T141429-496@post.gmane.org>
In-Reply-To: <loom.20110323T141429-496@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Daniel Lundborg wrote:
> Hello,

Hi Daniel,

(Cc'ing Laurent.)

> I am successfully using the gumstix overo board together with a camera sensor
> Aptina MT9V034 with the kernel 2.6.35 and patches from
> http://git.linuxtv.org/pinchartl/media.git (isp6).

Which branch did you use?

> I can use the media-ctl program and yavta to take pictures in continous
> streaming mode.
> 
> media-ctl -r -l '"mt9034 3-0048":0->"OMAP3 ISP CCDC":0[1], "OMAP3 ISP
> CCDC":1->"OMAP3 ISP CCDC output":0[1]'
> media-ctl -f '"mt9v034 3-0048":0[SGRBG10 752x480], "OMAP3 ISP CCDC":1[SGRBG10
> 752x480]
> 
> and then:
> 
> yavta -f SGRBG10 -s 752x480 -n 1 --capture=1 -F /dev/video2
> 
> 
> Is there a way to set the ISP in single shot mode?

Single shot for the ISP is the same as to queue just one buffer. I
assume the single shot mode is something that the sensor supports?

> I have tested setting the mt9v034 in snapshot mode and manually trigger the
> camera, but the ISP does not send a picture. Is there a way to solve this with
> the current OMAP3 isp code?

Do you get any errors, or you just don't get any video buffers?

As the sensor works in streaming mode, are you sure it outputs the image
of correct size in the single shot mode?

> I have before successfully used the isp parts from the Nokia N900 project..

This is nice to hear! :-)

Regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
