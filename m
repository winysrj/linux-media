Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:38603 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756566AbcB0Res (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Feb 2016 12:34:48 -0500
Subject: Re: [PATCH] v4l2: remove MIPI CSI-2 driver for SH-Mobile platforms
To: Simon Horman <horms+renesas@verge.net.au>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
References: <1456279679-11342-1-git-send-email-horms+renesas@verge.net.au>
 <56CD5A19.4000906@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56D1DE32.1030604@xs4all.nl>
Date: Sat, 27 Feb 2016 18:34:42 +0100
MIME-Version: 1.0
In-Reply-To: <56CD5A19.4000906@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/24/2016 08:22 AM, Hans Verkuil wrote:
> On 02/24/2016 03:07 AM, Simon Horman wrote:
>> This driver does not appear to have ever been used by any SoC's defconfig
>> and does not appear to support DT. In sort it seems unused an unlikely
>> to be used.
> 
> I prefer to move it to staging/media first for 1-2 kernel cycles. Just in case
> someone does need this.

Now that I looked more closely how it is used I think plain removal is best.

There are two options:

1) If I can manage to make a replacement ceu driver (although without cropping
support), then the old ceu and csi drivers can both go to staging and removed
later.

2) If the ceu driver has to stay longer, then the csi part has to be stripped.
Moving just the csi part to staging is not feasible given how ceu and csi work
together. It would make sense that I do this job since I can test on this board,
at least with the composite input.

Regards,

	Hans
