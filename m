Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:51864 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646Ab1BRMd2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Feb 2011 07:33:28 -0500
Message-ID: <4D5E6708.9000500@infradead.org>
Date: Fri, 18 Feb 2011 10:33:12 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Michal Nazarewicz <mina86@mina86.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hansverk@cisco.com>, Qing Xu <qingx@marvell.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Neil Johnson <realdealneil@gmail.com>,
	Robert Jarzmik <robert.jarzmik@free.fr>,
	Uwe Taeubert <u.taeubert@road.de>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	Eino-Ville Talvala <talvala@stanford.edu>
Subject: Re: [RFD] frame-size switching: preview / single-shot use-case
References: <4D5D9B57.3090809@gmail.com> <op.vq2lapd13l0zgt@mnazarewicz-glaptop> <201102181131.30920.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201102181131.30920.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 18-02-2011 08:31, Laurent Pinchart escreveu:
> It's a trade-off between memory and speed. Preallocating still image capture 
> buffers will give you better snapshot performances, at the expense of memory.
> 
> The basic problems we have here is that taking snapshots is slow with the 
> current API if we need to stop capture, free buffers, change the format, 
> allocate new buffers (and perform cache management operations) and restart the 
> stream. To fix this we're considering a way to preallocate still image capture 
> buffers, but I'm open to proposals for other ways to solve the issue :-)

>From the above operations, considering that CMA is used to reserve a
non-shared memory with enough space for the new buffer size/qtd, I don't
think that the most expensive operation would be to realloc the memory.

The logic to stop/start streaming seems to be the most consuming one, as driver
will need to wait for the current I/O operation to complete, and this can
take hundreds of milisseconds (the duration of one frame).

How much time would CMA need to free and re-allocate the buffers for, let's
say, something in the range of 1-10 MB, on a pre-allocated, non shared memory
space?

Cheers
Mauro
