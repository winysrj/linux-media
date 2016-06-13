Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:51546 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423867AbcFMPda (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jun 2016 11:33:30 -0400
Date: Mon, 13 Jun 2016 17:33:01 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH/RFC v2 4/4] v4l: vsp1: Add HGO support
In-Reply-To: <1463012283-3078-5-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Message-ID: <Pine.LNX.4.64.1606131726380.18676@axis700.grange>
References: <1463012283-3078-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1463012283-3078-5-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Thu, 12 May 2016, Laurent Pinchart wrote:

> The HGO is a Histogram Generator One-Dimension. It computes per-channel
> histograms over a configurable region of the image with optional
> subsampling.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

[snip]

Do I understand this correctly, that with this if such a metadata device 
is opened, while no video data is streaming, all calls will succeed, but 
no buffers will be dequeued, i.e. the user-space application will hang in 
DQBUF or poll() / select() indefinitely?

Thanks
Guennadi
