Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.matrix-vision.com ([78.47.19.71]:51481 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574Ab3FLQUR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Jun 2013 12:20:17 -0400
Message-ID: <51B89EDA.90107@matrix-vision.de>
Date: Wed, 12 Jun 2013 18:16:26 +0200
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media ML <linux-media@vger.kernel.org>
Subject: double-buffering with the omap3 parallel interface
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent & co.,

I'd like to look at what the maximum possible frame rates are for a 
sensor connected to the OMAP3 ISP CCDC via the parallel interface, 
writing frames directly to memory.  I understand that there is some 
minimum amount of time required between frames to pass on the finished 
frame and set up the address to be written to for the next frame.  From 
the manual it looks like a double buffering scheme would've been 
available on a different sensor interface, but isn't on the parallel one.

Do I see that right?  Is it impossible to use double buffering of any 
sort while using the parallel interface to memory?

I'm still using an older version of the driver, but I've browsed the 
current state of the code, too.  What behavior do you expect if the time 
between frames is too short for the buffer management?  Can it be 
recovered from?  Has this behavior changed in recent versions?

I see from the ISP block diagram that the "circular buffer" is between 
the SBL and the MMU.  Could this maybe be used to help the situation? 
It seems to currently not be used at all along this path.

thanks,
Michael

MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner, Erhard Meier
