Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:46764 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754876Ab1FVOLn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 22 Jun 2011 10:11:43 -0400
Date: Wed, 22 Jun 2011 08:11:41 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-media@vger.kernel.org, g.liakhovetski@gmx.de,
	'Kassey Lee' <ygli@marvell.com>,
	'Pawel Osciak' <pawel@osciak.com>
Subject: Re: [PATCH 1/5] marvell-cam: convert to videobuf2
Message-ID: <20110622081141.2db38381@bike.lwn.net>
In-Reply-To: <003e01cc30e4$8c36f370$a4a4da50$%szyprowski@samsung.com>
References: <1308597280-138673-1-git-send-email-corbet@lwn.net>
	<1308597280-138673-2-git-send-email-corbet@lwn.net>
	<003e01cc30e4$8c36f370$a4a4da50$%szyprowski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Wed, 22 Jun 2011 15:59:04 +0200
Marek Szyprowski <m.szyprowski@samsung.com> wrote:

> > This is a basic, naive conversion to the videobuf2 infrastructure, removing
> > a lot of code in the process.  For now, we're using vmalloc, which is
> > suboptimal, but it does match what the cafe driver did before.  
> 
> Could you elaborate a bit why vmalloc is suboptimal for your case?

Because it requires copying every frame in kernel space.  That's not a
problem with the vb2 vmalloc implementation, obviously, it's just inherent
in that approach.  Systems with the old Cafe controller are probably stuck
with it (though CMA might just make contiguous DMA operation possible); I
hope to not see it used on anything newer.

(Other comments noted, thanks.)

jon
