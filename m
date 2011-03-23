Return-path: <mchehab@pedra>
Received: from smtp.nokia.com ([147.243.1.48]:37635 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626Ab1CWJxA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Mar 2011 05:53:00 -0400
Message-ID: <4D89C2ED.5080803@maxwell.research.nokia.com>
Date: Wed, 23 Mar 2011 11:52:45 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Michael Jones <michael.jones@matrix-vision.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	=?ISO-8859-1?Q?Lo=EFc_Akue?= <akue.loic@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Yordan Kamenov <ykamenov@mm-sol.com>
Subject: Re: [PATCH] omap3isp: implement ENUM_FMT
References: <4D889C61.905@matrix-vision.de>
In-Reply-To: <4D889C61.905@matrix-vision.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Michael,

Thanks for the patch.

Michael Jones wrote:
> From dccbd4a0a717ee72a3271075b1e3456a9c67ca0e Mon Sep 17 00:00:00 2001
> From: Michael Jones <michael.jones@matrix-vision.de>
> Date: Tue, 22 Mar 2011 11:47:22 +0100
> Subject: [PATCH] omap3isp: implement ENUM_FMT
> 
> Whatever format is currently being delivered will be declared as the only
> possible format
> 
> Signed-off-by: Michael Jones <michael.jones@matrix-vision.de>
> ---
> 
> Some V4L2 apps require ENUM_FMT, which is a mandatory ioctl for V4L2.
> This patch doesn't enumerate all of the formats which could possibly be
> set (as is intended by ENUM_FMT), but at least it reports the one that
> is currently set.

What would be the purpose of ENUM_FMT in this case? It provides no
additional information to user space, and the information it provides is
in fact incomplete. Using other formats is possible, but that requires
changes to the format configuration on links.

As the relevant format configuration is done on the subdevs and not on
the video nodes, the format configuration on the video nodes is very
limited and much affected by the state of the formats on the subdev pads
(which I think is right). This is not limited to ENUM_FMT but all format
related IOCTLs on the OMAP 3 ISP driver.

My view is that should a generic application want to change (or
enumerate) the format(s) on a video node, the application would need to
be using libv4l for that.

A compatibility layer implemented in libv4l (plugin, not the main
library) needs to configure the links in the first place, so
implementing ENUM_FMT in the plugin would not be a big deal. It could
even provide useful information. The possible results of the ENUM_FMT
would also depend on what kind of pipeline configuration does the plugin
support, though.

(Cc Yordan and Hans.)

I discussed this with Laurent initially and the conclusion was that more
discussion is required. :-) Hans: do you have an opinion on this?

Best regards,

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
