Return-path: <mchehab@pedra>
Received: from mail1.matrix-vision.com ([78.47.19.71]:47937 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab0JZPIP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Oct 2010 11:08:15 -0400
Message-ID: <4CC6EEDC.20206@matrix-vision.de>
Date: Tue, 26 Oct 2010 17:08:12 +0200
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: laurent.pinchart@ideasonboard.com,
	"sakari.ailus@maxwell.research.nokia.com"
	<sakari.ailus@maxwell.research.nokia.com>
Subject: controls, subdevs, and media framework
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

I'm trying to understand how the media framework and V4L2 share the responsibility of configuring a video device.  Referring to the ISP code on Laurent's media-0004-omap3isp branch, the video device is now split up into several devices... suppose you have a sensor delivering raw bayer data to the CCDC.  I could get this raw data from the /dev/video2 device (named "OMAP3 ISP CCDC output") or I could get YUV data from the previewer or resizer.  But I would no longer have a single device where I could ENUM_FMT and see that I could get either.  Correct?

Having settled on a particular video device, (how) do regular controls (ie. VIDIOC_[S|G]_CTRL) work?  I don't see any support for them in ispvideo.c.  Is it just yet to be implemented?  Or is it expected that the application will access the subdevs individually?

Basically the same Q for CROPCAP:  isp_video_cropcap passes it on to the last link in the chain, but none of the subdevs in the ISP currently have a cropcap function implemented (yet).  Does this still need to be written?

-- 
Michael Jones

MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner
