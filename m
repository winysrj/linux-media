Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56156 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbcFXOfb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2016 10:35:31 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH/RFC v2 4/4] v4l: vsp1: Add HGO support
Date: Fri, 24 Jun 2016 17:35:51 +0300
Message-ID: <2199003.uUy7t6IokG@avalon>
In-Reply-To: <Pine.LNX.4.64.1606131726380.18676@axis700.grange>
References: <1463012283-3078-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1463012283-3078-5-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <Pine.LNX.4.64.1606131726380.18676@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Monday 13 Jun 2016 17:33:01 Guennadi Liakhovetski wrote:
> On Thu, 12 May 2016, Laurent Pinchart wrote:
> > The HGO is a Histogram Generator One-Dimension. It computes per-channel
> > histograms over a configurable region of the image with optional
> > subsampling.
> > 
> > Signed-off-by: Laurent Pinchart
> > <laurent.pinchart+renesas@ideasonboard.com>
> 
> [snip]
> 
> Do I understand this correctly, that with this if such a metadata device
> is opened, while no video data is streaming, all calls will succeed, but
> no buffers will be dequeued, i.e. the user-space application will hang in
> DQBUF or poll() / select() indefinitely?

That's correct. Same as with a mem-to-mem device, if you open the capture 
node, queue buffers and start streaming, DQBUF will wait until you start 
supplying buffers on the node at the other end of the pipeline.

-- 
Regards,

Laurent Pinchart

