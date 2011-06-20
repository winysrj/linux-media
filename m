Return-path: <mchehab@pedra>
Received: from tex.lwn.net ([70.33.254.29]:52375 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303Ab1FTPsk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 11:48:40 -0400
Date: Mon, 20 Jun 2011 09:48:38 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: 'Pawel Osciak' <pawel@osciak.com>, linux-media@vger.kernel.org
Subject: Re: vb2: holding buffers until after start_streaming()
Message-ID: <20110620094838.56daf754@bike.lwn.net>
In-Reply-To: <003101cc2f0b$207f9680$617ec380$%szyprowski@samsung.com>
References: <20110617125713.293f484d@bike.lwn.net>
	<BANLkTimPrkXUuTGCfrp8KyqhFNvfjoCzSw@mail.gmail.com>
	<003101cc2f0b$207f9680$617ec380$%szyprowski@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 20 Jun 2011 07:30:11 +0200
Marek Szyprowski <m.szyprowski@samsung.com> wrote:

> Because of that I decided to call start_streaming first, before the 
> __enqueue_in_driver() to ensure the drivers will get their methods
> called always in the same order, whatever used does. 

It still seems like the "wrong" order to me; it means that
start_streaming() can't actually start streaming.  But, as has been
pointed out, the driver can't count on the buffers being there in any
case.  This ordering does, at least, expose situations where the driver
author didn't think that buffers might not have been queued yet.

(BTW, lest people think I'm complaining too much, let it be said that vb2
is, indeed, a big improvement over its predecessor.)

Thanks,

jon
