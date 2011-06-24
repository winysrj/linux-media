Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:42684 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719Ab1FXU1C (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2011 16:27:02 -0400
Date: Fri, 24 Jun 2011 14:27:01 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	'Pawel Osciak' <pawel@osciak.com>
Cc: linux-media@vger.kernel.org
Subject: The return value of __vb2_queue_alloc()
Message-ID: <20110624142701.0c5c7a7e@bike.lwn.net>
In-Reply-To: <20110624141927.1c89a033@bike.lwn.net>
References: <20110624141927.1c89a033@bike.lwn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, 24 Jun 2011 14:19:27 -0600
Jonathan Corbet <corbet@lwn.net> wrote:

> Here's a little something I decided to hack on rather than addressing all
> the real work I have to do.

...and while I was looking at this code, I noticed one little curious
thing:

int vb2_reqbufs(struct vb2_queue *q, struct v4l2_requestbuffers *req)
{
/* ... */
	/* Finally, allocate buffers and video memory */
	ret = __vb2_queue_alloc(q, req->memory, num_buffers, num_planes,
				plane_sizes);
	if (ret < 0) {
		dprintk(1, "Memory allocation failed with error: %d\n", ret);
		return ret;
	}

If you actually look at __vb2_queue_alloc(), it claims to return the
number of buffers actually allocated, and an inspection of the code bears
up that claim.  So it can never return a negative value.  Do you maybe
want "if (ret <= 0) {" there instead?  One assumes there will be few
drivers so accommodating as to work with zero buffers.

Thanks,

jon
