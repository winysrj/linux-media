Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60080 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756297AbZE0KP5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 May 2009 06:15:57 -0400
Received: from lyakh (helo=localhost)
	by axis700.grange with local-esmtp (Exim 4.63)
	(envelope-from <g.liakhovetski@gmx.de>)
	id 1M9GB1-0001wt-ME
	for linux-media@vger.kernel.org; Wed, 27 May 2009 12:16:03 +0200
Date: Wed, 27 May 2009 12:16:03 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Image filter controls
Message-ID: <Pine.LNX.4.64.0905271207060.5154@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I have to implement 2 filter controls: a boolean colour filter control to 
switch a fluorescent light band-stop filter on and off, and an also 
boolean control to switch a low-pass (border denoising, I think) filter. I 
found the following two filters in the existing API:

	case V4L2_CID_COLOR_KILLER:		return "Color Killer";
	case V4L2_CID_COLORFX:			return "Color Effects";

can I use one of them for the fluorescent light filter? Which one would be 
more appropriate - COLOR_KILLER means switch to BW or only kill some 
specific colour component? As for the low-pass filter, can I use

	case V4L2_CID_SHARPNESS:		return "Sharpness";

for it? Would it then be sharpness-off == filter-on? Or shall I add new 
controls or use driver-private ones?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
