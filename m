Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:34634 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706Ab2I2TvV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Sep 2012 15:51:21 -0400
Date: Sat, 29 Sep 2012 13:51:20 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Albert Wang <twang13@marvell.com>
Cc: g.liakhovetski@gmx.de, linux-media@vger.kernel.org
Subject: Re: [PATCH 4/4] [media] marvell-ccic: core: add 3 frame buffers
 support in DMA_CONTIG mode
Message-ID: <20120929135120.0567e609@hpe.lwn.net>
In-Reply-To: <1348840059-21456-1-git-send-email-twang13@marvell.com>
References: <1348840059-21456-1-git-send-email-twang13@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 28 Sep 2012 21:47:39 +0800
Albert Wang <twang13@marvell.com> wrote:

> This patch adds support of 3 frame buffers in DMA-contiguous mode.
> 
> In current DMA_CONTIG mode, only 2 frame buffers can be supported.
> Actually, Marvell CCIC can support at most 3 frame buffers.
> 
> Currently 2 frame buffers mode will be used by default.
> To use 3 frame buffers mode, can do:
>   define MAX_FRAME_BUFS 3
> in mcam-core.h

I have no problem with the concept.  I honestly don't remember why I
only used the two-buffer mode for dma-contig; perhaps it's because
getting even two buffers can be a bit of a challenge on a lot of
systems, maybe.  The application really needs to be able to get at
least four buffers for the three-buffer mode to be worthwhile
(otherwise you're always in a situation where the driver owns less than
three and has to juggle things).  But we can certainly add it.

I wish this were two patches, though:
	1) Change lots of int variables to unsigned int (with reasoning
	   as to why we want to do that).
	2) Add three-buffer mode.

The mode should be runtime-selectable, as it is with the vmalloc mode.

Otherwise seems OK.

Thanks,

jon
