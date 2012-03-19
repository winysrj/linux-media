Return-path: <linux-media-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:39748 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161962Ab2CSQ6U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Mar 2012 12:58:20 -0400
Date: Mon, 19 Mar 2012 16:56:44 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Tom Cooksey" <tom.cooksey@arm.com>
Cc: "'Rob Clark'" <rob.clark@linaro.org>,
	<linaro-mm-sig@lists.linaro.org>,
	<dri-devel@lists.freedesktop.org>, <linux-media@vger.kernel.org>,
	<rschultz@google.com>, "Rob Clark" <rob@ti.com>,
	<sumit.semwal@linaro.org>, <patches@linaro.org>
Subject: Re: [PATCH] RFC: dma-buf: userspace mmap support
Message-ID: <20120319165644.3e4ce4ad@pyx>
In-Reply-To: <000101cd05ef$3eab78c0$bc026a40$@cooksey@arm.com>
References: <1331775148-5001-1-git-send-email-rob.clark@linaro.org>
	<000001cd0399$9e57db90$db0792b0$@cooksey@arm.com>
	<20120317201719.121f4104@pyx>
	<000101cd05ef$3eab78c0$bc026a40$@cooksey@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> If the API was to also be used for synchronization it would have to
> include an atomic "prepare multiple" ioctl which blocked until all
> the buffers listed by the application were available. In the same

Too slow already. You are now serializing stuff while what we want to do
really is

	nobody_else_gets_buffers_next([list])
	on available(buffer)
		dispatch_work(buffer)

so that you can maximise parallelism without allowing deadlocks. If
you've got a high memory bandwith and 8+ cores the 'stop everything'
model isn't great.

> This might be a good argument for keeping synchronization and cache
> maintenance separate, though even ignoring synchronization I would
> think being able to issue cache maintenance operations for multiple
> buffers in a single ioctl might present some small efficiency gains.
> However as Rob points out, CPU access is already in slow/legacy
> territory.

Dangerous assumption. I do think they should be separate. For one it
makes the case of synchronization needed but hardware cache management
much easier to split cleanly. Assuming CPU access is slow/legacy reflects
a certain model of relatively slow CPU and accelerators where falling off
the acceleration path is bad. On a higher end processor falling off the
acceleration path isn't a performance matter so much as a power concern.

> KDS we differentiated jobs which needed "exclusive access" to a
> buffer and jobs which needed "shared access" to a buffer. Multiple
> jobs could access a buffer at the same time if those jobs all

Makes sense as it's a reader/writer lock and it reflects MESI/MOESI
caching and cache policy in some hardware/software assists.

> display controller will be reading the front buffer, but the GPU
> might also need to read that front buffer. So perhaps adding
> "read-only" & "read-write" access flags to prepare could also be
> interpreted as shared & exclusive accesses, if we went down this
> route for synchronization that is. :-)

mmap includes read/write info so probably using that works out. It also
means that you have the stuff mapped in a way that will bus error or
segfault anyone who goofs rather than give them the usual 'deep
weirdness' behaviour you get with mishandling of caching bits.

Alan
