Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:49910 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751081AbZCGPEj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 7 Mar 2009 10:04:39 -0500
Date: Sat, 7 Mar 2009 16:04:46 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: morimoto.kuninori@renesas.com
Subject: [Q] bulk parameter settings
Message-ID: <Pine.LNX.4.64.0903071540310.4201@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

In a patch by Morimoto-san [1] he proposed a method to allow platforms to 
specify register address-value pairs to be directly flushed in by the 
driver into the sensor.

While I am not very fond of this approach, I cannot think of a proper way 
to do this. We used to have S_REGISTER ioctl()s, which even back then 
depended on advanced debugging, and are now even more discouraged. 
Besides, in his example he had 85 (!) register values, calling S_REGISTER 
85 times wouldn't be very efficient either, even if we accept it as a 
mainstream method.

Creating real new controls for all those registers (ok, maybe most of them 
already exist, or can be derived from others, which would probably leave 
us with 20-40 new controls) seems an overkill too.

Loading the settings as an array from user-space using the firmware-loader 
procedure, doesn't seem to fit very well - this is not firmware, this is 
not code that will run, these are just configuration values.

I can think of a couple more possibilities, but none of them makes me 
really happy. What do other drivers do or what is the best solution to 
this problem? I understand, in "closed" devices, where all components are 
fixed, and there are only a finate number of hardware configurations (PCI 
/ USB), this problem doesn't really exist, but with "gadgets" (as we from 
now on shall call all soc-camera users) hardware designers have a freedom 
to select single components to fit their specific needs.

Any thoughts?

Of all the above I would probably prefer to abuse the firmware loading 
procedure, or are there better options?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

http://www.spinics.net/lists/linux-media/msg02347.html
