Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:50859 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab3LJHse (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 02:48:34 -0500
Date: Tue, 10 Dec 2013 08:48:30 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
cc: linux-media@vger.kernel.org, m.szyprowski@samsung.com,
	pawel@osciak.com, laurent.pinchart@ideasonboard.com,
	awalls@md.metrocast.net, kyungmin.park@samsung.com,
	k.debski@samsung.com, s.nawrocki@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>,
	"Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [RFCv4 PATCH 7/8] vb2: return ENODATA in start_streaming in case
 of too few buffers.
In-Reply-To: <1386596592-48678-8-git-send-email-hverkuil@xs4all.nl>
Message-ID: <Pine.LNX.4.64.1312100847350.30411@axis700.grange>
References: <1386596592-48678-1-git-send-email-hverkuil@xs4all.nl>
 <1386596592-48678-8-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 9 Dec 2013, Hans Verkuil wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This works together with the retry_start_streaming mechanism to allow userspace
> to start streaming even if not all required buffers have been queued.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Kamil Debski <k.debski@samsung.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---

[snip]

>  drivers/media/platform/soc_camera/mx2_camera.c  | 2 +-

Provided ENOBUFS is used instead of ENODATA:

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
