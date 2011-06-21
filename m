Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:37490 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554Ab1FUROW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jun 2011 13:14:22 -0400
Date: Tue, 21 Jun 2011 11:14:20 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: 'Pawel Osciak' <pawel@osciak.com>, linux-media@vger.kernel.org
Subject: Re: vb2: holding buffers until after start_streaming()
Message-ID: <20110621111420.4ef5472e@bike.lwn.net>
In-Reply-To: <005601cc302d$427c0f70$c7742e50$%szyprowski@samsung.com>
References: <20110617125713.293f484d@bike.lwn.net>
	<BANLkTimPrkXUuTGCfrp8KyqhFNvfjoCzSw@mail.gmail.com>
	<003101cc2f0b$207f9680$617ec380$%szyprowski@samsung.com>
	<20110620094838.56daf754@bike.lwn.net>
	<005601cc302d$427c0f70$c7742e50$%szyprowski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, 21 Jun 2011 18:07:03 +0200
Marek Szyprowski <m.szyprowski@samsung.com> wrote:

> I have an idea to introduce a new flags to let device driver tell vb2
> weather it supports 'streaming without buffers' or not. This way the
> order of operations in vb2_streamon() function can be switched and vb2
> can also return an error if one will try to enable streaming on device
> that cannot do it without buffers pre-queued.

Do you really need a flag?  If a driver absolutely cannot stream without
buffers queued (and can't be fixed to start streaming for real when the
buffers show up) it should just return -EINVAL from start_streaming() or
some such.  The driver must be aware of its limitations regardless, but
there's no need to push that awareness into vb2 as well.

(FWIW, I wouldn't switch the order of operations in vb2_streamon(); I
would just take out the "if (q->streaming)" test at the end of vb2_qbuf()
and pass the buffers through directly.  But maybe that's just me.)

Thanks,

jon
