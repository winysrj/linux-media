Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:36440 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750827AbZDFP6p (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Apr 2009 11:58:45 -0400
Date: Mon, 6 Apr 2009 17:58:57 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH] Add ov9655 camera driver
In-Reply-To: <dcfc60e44b2c05b865fd.1239026767@SCT-Book>
Message-ID: <Pine.LNX.4.64.0904061755230.4285@axis700.grange>
References: <dcfc60e44b2c05b865fd.1239026767@SCT-Book>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 6 Apr 2009, Stefan Herbrechtsmeier wrote:

> Add a driver for the OmniVision ov9655 camera sensor.
> The driver use the soc_camera framework.
> It was tested on the BeBot robot with a PXA270 processor.
> 
> Signed-off-by: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>

Hans, does it make sense to include this one or shall we wait for gspca on 
this one too?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
