Return-path: <linux-media-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:54577 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762923Ab3DDQqI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Apr 2013 12:46:08 -0400
Received: from dhcp-089-099-019-018.chello.nl ([89.99.19.18] helo=dyad.programming.kicks-ass.net)
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1UNnId-0007KL-OD
	for linux-media@vger.kernel.org; Thu, 04 Apr 2013 16:46:07 +0000
Message-ID: <1365093965.2609.116.camel@laptop>
Subject: Re: [PATCH v2 2/3] mutex: add support for reservation style locks,
 v2
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
	linux-arch@vger.kernel.org, daniel.vetter@ffwll.ch, x86@kernel.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, robclark@gmail.com,
	tglx@linutronix.de, mingo@elte.hu, linux-media@vger.kernel.org
Date: Thu, 04 Apr 2013 18:46:05 +0200
In-Reply-To: <20130404133123.GW2228@phenom.ffwll.local>
References: <20130228102452.15191.22673.stgit@patser>
	 <20130228102502.15191.14146.stgit@patser>
	 <1364900432.18374.24.camel@laptop> <515AF1C1.7080508@canonical.com>
	 <1364921954.20640.22.camel@laptop> <1365076908.2609.94.camel@laptop>
	 <20130404133123.GW2228@phenom.ffwll.local>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2013-04-04 at 15:31 +0200, Daniel Vetter wrote:
> I'm a bit confused about the different classes you're talking about.
> Since
> the ticket queue is currently a global counter there's only one class
> of
> ww_mutexes. 

Right, so that's not something that's going to fly.. we need to support
multiple users, including nesting of those. Again, you're adding
something to the generic kernel infrastructure, it had better be usable
:-)

> I guess we could change that once a second user shows up

No, we fix that before it all goes in. I would _so_ hate to find out it
cannot be 'fixed' and be stuck with a half-arsed sync primitive in the
core kernel that's only every usable by the one existent user.

So for now, forget all about TTM, DMA-BUF and other such coolness
except to verify that whatever we end up with does indeed work for the
case you need it for ;-)

