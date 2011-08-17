Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:37832 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824Ab1HQAAz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2011 20:00:55 -0400
Date: Tue, 16 Aug 2011 18:03:15 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org,
	'Kyungmin Park' <kyungmin.park@samsung.com>,
	'Pawel Osciak' <pawel@osciak.com>,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Subject: Re: [PATCH] media: vb2: dma-sg allocator: change scatterlist
 allocation method
Message-ID: <20110816180315.4be6ac9b@tpl.lwn.net>
In-Reply-To: <004401cc5c00$24998ce0$6dcca6a0$%szyprowski@samsung.com>
References: <1312964617-3192-1-git-send-email-m.szyprowski@samsung.com>
	<201108122354.51720.laurent.pinchart@ideasonboard.com>
	<03bd01cc5bd6$40a86b10$c1f94130$%szyprowski@samsung.com>
	<201108161041.40789.laurent.pinchart@ideasonboard.com>
	<004401cc5c00$24998ce0$6dcca6a0$%szyprowski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 16 Aug 2011 12:34:56 +0200
Marek Szyprowski <m.szyprowski@samsung.com> wrote:

> Right, I wasn't aware of that, but it still doesn't look like an issue. The only
> 
> client of dma-sg allocator is marvell-ccic, which is used on x86 systems. If one
> needs dma-sg allocator on ARM, he should follow the suggestion from the 
> 74facffeca3795ffb5cf8898f5859fbb822e4c5d commit message.

Um...that driver runs on ARM, actually - the controller is part of the
ARMADA 610 SoC...

For the OLPC 1.75 there will never be a scatterlist longer than one
page, I don't think.  That controller can do HD, though, so longer
lists are possible in the future.

jon
