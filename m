Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51448 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751165AbeBUVBo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 16:01:44 -0500
Date: Wed, 21 Feb 2018 23:01:40 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2] videodev2.h: add helper to validate colorspace
Message-ID: <20180221210140.qf77u5yf6ja6cmdi@valkosipuli.retiisi.org.uk>
References: <20180214103643.8245-1-niklas.soderlund+renesas@ragnatech.se>
 <20180219222804.GD8442@bigcity.dyn.berto.se>
 <94142433-a72d-ddd4-22bc-b36380f4efbc@xs4all.nl>
 <2556801.UsItpXbr2P@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2556801.UsItpXbr2P@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent and Hans,

On Wed, Feb 21, 2018 at 10:16:25PM +0200, Laurent Pinchart wrote:
> No, I'm sorry, for MC-based drivers this isn't correct. The media entity that 
> symbolizes the DMA engine indeed has a sink pad, but it's a video node, not a 
> subdev. It thus has no media bus format configured for its sink pad. The 
> closest pad in the pipeline that has a media bus format is the source pad of 
> the subdev connected to the video node.
> 
> There's no communication within the kernel at G/S_FMT time between the video 
> node and its connected subdev. The only time we look at the pipeline as a 
> whole is when starting the stream to validate that the pipeline is correctly 
> configured. We thus have to implement G/S_FMT on the video node without any 
> knowledge about the connected subdev, and thus accept any colorspace.

A few more notes related to this --- there's no propagation of sub-device
format across the entities; there were several reasons for the design
choice. The V4L2 pixel format in the video node must be compatible with the
sub-device format when streaming is started. And... the streaming will
start in the pipeline defined by the enabled links to/from the video node.
In principle nothign prevents having multiple links there, and at the time
S_FMT IOCTL is called on the video node, none of those links could be
enabled. And that's perfectly valid use of the API.

A lot of the DMA engine drivers are simply devices that receive data and
write that to system memory, they really don't necessarily know anything
else. For the hardware this data is just pixels (or even bits, especially
in the case of CSI-2!).

So I agree with Laurent here that requiring correct colour space for
[GS]_FMT IOCTLs on video nodes in the general case is not feasible
(especially on MC-centric devices), due to the way the Media controller
pipeline and formats along that pipeline are configured and validated (i.e.
at streamon time).

But what to do here then? The colourspace field is not verified even in
link validation so there's no guarantee it's correctly set more or less
anywhere else than in the source of the stream. And if the stream has
multiple sources with different colour spaces, then what do you do? That's
perhaps a theoretical case but the current frameworks and APIs do in
principle support that.

Perhaps we should specify that the user should always set the same
colourspace on the sink end of a link that was there in the source? The
same should likely apply to the rest of the fields apart from width, height
and code, too. Before the user configures formats this doesn't work though,
and this does not address the matter with v4l2-compliance.

Granted that the drivers will themselves handle the colour space
information correctly, it'd still provide a way for the user to gain the
knowledge of the colour space which I believe is what matters.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
