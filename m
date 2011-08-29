Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:62684 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab1H2MGM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Aug 2011 08:06:12 -0400
Date: Mon, 29 Aug 2011 14:05:22 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Marek Szyprowski <m.szyprowski@samsung.com>
cc: linux-media@vger.kernel.org,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Jonathan Corbet <corbet@lwn.net>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?=
	<u.kleine-koenig@pengutronix.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Marin Mitov <mitov@issp.bas.bg>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Josh Wu <josh.wu@atmel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH v3] media: vb2: change queue initialization order
In-Reply-To: <1314618332-13262-1-git-send-email-m.szyprowski@samsung.com>
Message-ID: <Pine.LNX.4.64.1108291402270.31184@axis700.grange>
References: <1314618332-13262-1-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Marek

On Mon, 29 Aug 2011, Marek Szyprowski wrote:

> This patch changes the order of operations during stream on call. Now the
> buffers are first queued to the driver and then the start_streaming method
> is called.
> 
> This resolves the most common case when the driver needs to know buffer
> addresses to enable dma engine and start streaming. Additional parameter
> to start_streaming method have been added to simplify drivers code. The
> driver are now obliged to check if the number of queued buffers is high
> enough to enable hardware streaming. If not - it can return an error. In
> such case all the buffers that have been pre-queued are invalidated.
> 
> This patch also updates all videobuf2 clients to work properly with the
> changed order of operations.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> CC: Pawel Osciak <pawel@osciak.com>
> CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> CC: Hans Verkuil <hverkuil@xs4all.nl>
> CC: Tomasz Stanislawski <t.stanislaws@samsung.com>
> CC: Sylwester Nawrocki <s.nawrocki@samsung.com>
> CC: Kamil Debski <k.debski@samsung.com>
> CC: Jonathan Corbet <corbet@lwn.net>
> CC: Josh Wu <josh.wu@atmel.com>
> CC: Hans de Goede <hdegoede@redhat.com>
> CC: Paul Mundt <lethal@linux-sh.org>
> ---
> 
> Hello,
> 
> This is yet another version of the patch that introduces significant
> changes in the vb2 streamon operation. I've decided to remove the
> additional parameter to buf_queue callback and added a few cleanups here
> and there. This patch also includes an update for all vb2 clients.

Just for the record: These are not all vb2 clients. A simple grep for 
something like vb2_ops gives you also

drivers/media/video/mx3_camera.c
drivers/media/video/sh_mobile_ceu_camera.c

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
