Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2.matrix-vision.com ([85.214.244.251]:54098 "EHLO
	mail2.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab2GCJoa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Jul 2012 05:44:30 -0400
Message-ID: <4FF2BF79.2020302@matrix-vision.de>
Date: Tue, 03 Jul 2012 11:46:33 +0200
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: linux-media ML <linux-media@vger.kernel.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: capture_mem limitations in OMAP ISP
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent & co.,

I'm looking at the memory limitations in the omap3isp driver.  'struct 
isp_video' contains member 'capture_mem', which is set separately for 
each of our v4l2 video device nodes.  The CCDC, for example, has 
capture_mem = 4096 * 4096 * 3 = 48MB, while the previewer and resizer 
each have twice that. Where do these numbers come from?

Is the CCDC incapable of DMA'ing more than 48MB into memory?  I know 
that ISP_VIDEO_MAX_BUFFERS also limits the # of buffers, but I assume 
this is basically an arbitrary number so we can have a finite array of 
isp_video_buffer's.  The 48MB, on the other hand, looks like it might 
have a good reason.

thanks,
Michael

MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner, Erhard Meier
