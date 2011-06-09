Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:39511 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756653Ab1FIWrd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jun 2011 18:47:33 -0400
Date: Thu, 9 Jun 2011 16:47:31 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Kassey Lee <ygli@marvell.com>
Cc: g.liakhovetski@gmx.de, linux-media@vger.kernel.org,
	ytang5@marvell.com, qingx@marvell.com, jwan@marvell.com,
	leiwen@marvell.com
Subject: Re: [PATCH] V4L/DVB: v4l: Add driver for Marvell PXA910 CCIC
Message-ID: <20110609164731.0b91b9f8@bike.lwn.net>
In-Reply-To: <1307530660-25464-1-git-send-email-ygli@marvell.com>
References: <1307530660-25464-1-git-send-email-ygli@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi, Kassey,

I've been looking at the driver some to understand how you're using the
hardware.  One quick question:

> The driver is based on soc-camera + videobuf2 frame
> work, and only USERPTR is supported.

Since you're limited to contiguous DMA (does the PXA910 even support
scatter/gather mode?), USERPTR is going to be very limiting.  Is the
application mapping I/O memory elsewhere in the system with the
expectation of having the video frames go directly there?  Could you tell
me how that works?  I'd like to understand the use case here.

FWIW, I believe that videobuf2 would support the MMAP mode with no
additional effort on your part; any reason why you haven't enabled that?

Thanks,

jon
