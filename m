Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:64466 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398Ab1JCK5M (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Oct 2011 06:57:12 -0400
Date: Mon, 3 Oct 2011 12:57:10 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [RFC] subdevice PM: .s_power() deprecation?
Message-ID: <Pine.LNX.4.64.1110031138370.14314@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all

(The original .s_power() author added to cc;-))

Here comes one more Request for Discussion from me.

Short: on what events, at which level and how shall subdevice PM be 
envoked?

Subdevices can have varying and arbitrarily complex Power Management 
methods. On-SoC subdevices would typically be powered on and off by 
writing to some system registers. External subdevices (sensors etc.) can 
be powered on or off by something as simple as a GPIO, or can use several 
power regulators, supplying power to different device circuits. This 
means, a part of this knowledge belongs directly to the driver, while 
another part of it comes from platform data. The driver itself knows, 
whether it can control device's power, using internal capabilities, or it 
has to request a certain number of regulators. In the latter case, 
perhaps, it would be sane to assume, that if a certain regulator is not 
available, then the respective voltage is supplied by the system 
statically.

When to invoke? Subdeices can be used in two cases: for configuration and 
for data processing (streaming). For configuration the driver can choose 
one of two approaches: (1) cache all configuration requests and only 
execute them on STREAMON. Advantages: (a) the device can be kept off all 
the time during configuration, (b) the order is unimportant: the driver 
only stores values and applies them in the "correct" order. Disadvantages: 
(a) if the result of any such operation cannot be fully predicted by the 
driver, it cannot be reported to the user immediately after the operation 
execution but only at the STREAMON time (does anyone know any such 
"volatile" operations?), (b) the order is lost (is this important?). (2) 
execute all operations immediately. Advantages and disadvantages: just 
invert those from (1) above.

So far individual drivers decide themselves which way to go. This way only 
drivers themselves know, when and what parts of the device they have to 
power on and off for configuration. The only thing the bridge driver can 
be sure about is, that all the involved subdevices in the pipeline have to 
be powered on during streaming. But even then - maybe the driver can and 
wants to power the i2c circuitry off for that time?

All the above makes me think, that .s_power() methods are actually useless 
in the "operation context." The bridge has basically no way to know, when 
and which parts of the subdevice to power on or off. Subdevice 
configuration is anyway always performed, using the driver, and for 
streaming all participating subdevices just have to be informed about 
streaming begin and end.

The only pure PM activity, that subdevice drivers have to be informed 
about are suspends and resumes. Normal bus PM callbacks are not always 
usable in our case. E.g., you cannot use i2c PM, because i2c can well be 
resumed before the bridge and then camera sensors typically still cannot 
be accessed over i2c.

Therefore I propose to either deprecate (and later remove) .s_power() and 
add .suspend() and .resume() instead or repurpose .s_power() to be _only_ 
used for system-wide suspending and resuming. Even for runtime PM the 
subdevice driver has all the chances to decide itself when and how to save 
power, so, again, there is no need to be called from outside.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
