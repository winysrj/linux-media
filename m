Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail2.matrix-vision.com ([85.214.244.251]:36806 "EHLO
	mail2.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755349Ab2CPOFY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Mar 2012 10:05:24 -0400
Message-ID: <4F6348D7.9070409@matrix-vision.de>
Date: Fri, 16 Mar 2012 15:06:15 +0100
From: Michael Jones <michael.jones@matrix-vision.de>
MIME-Version: 1.0
To: linux-media ML <linux-media@vger.kernel.org>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: reading config parameters of omap3-isp subdevs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I am playing around with some parameters in the previewer on the ISP. 
With ioctl VIDIOC_OMAP3ISP_PRV_CFG I am able to write the various 
parameters but what I'm missing is a way to read them.  For example, I 
have no way to adjust only coef2 in 'struct omap3isp_prev_wbal' while 
leaving the others unchanged.  If I could first read the whole 
omap3isp_prev_wbal structure, then I could change just the things I want 
to change.  This seems like it would be common functionality for such 
ioctls.  I didn't find any previous discussion related to this.

I could imagine either adding a r/w flag to 'struct 
omap3isp_prev_update_config' or adding a new ioctl entirely.  I think I 
would prefer the r/w flag.  Feedback?

I noticed that other ISP subdevs have similar ioctls.  Perhaps a similar 
thing would be useful there, but right now I'm only looking at the 
previewer.

-Michael

MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner, Erhard Meier
