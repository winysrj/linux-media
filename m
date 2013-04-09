Return-path: <linux-media-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20883 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754795Ab3DIW2K (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Apr 2013 18:28:10 -0400
Date: Tue, 9 Apr 2013 18:28:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Daniel Vetter <daniel@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@canonical.com>,
	linux-arch@vger.kernel.org, daniel.vetter@ffwll.ch, x86@kernel.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, robclark@gmail.com,
	tglx@linutronix.de, mingo@elte.hu, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 2/3] mutex: add support for reservation style locks, v2
Message-ID: <20130409222808.GC20739@home.goodmis.org>
References: <20130228102452.15191.22673.stgit@patser>
 <20130228102502.15191.14146.stgit@patser>
 <1364900432.18374.24.camel@laptop>
 <515AF1C1.7080508@canonical.com>
 <1364921954.20640.22.camel@laptop>
 <1365076908.2609.94.camel@laptop>
 <20130404133123.GW2228@phenom.ffwll.local>
 <1365093662.2609.111.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365093662.2609.111.camel@laptop>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 04, 2013 at 06:41:02PM +0200, Peter Zijlstra wrote:
> On Thu, 2013-04-04 at 15:31 +0200, Daniel Vetter wrote:
> > The thing is now that you're not expected to hold these locks for a
> > long
> > time - if you need to synchronously stall while holding a lock
> > performance
> > will go down the gutters anyway. And since most current
> > gpus/co-processors
> > still can't really preempt fairness isn't that high a priority,
> > either.
> > So we didn't think too much about that.
> 
> Yeah but you're proposing a new synchronization primitive for the core
> kernel.. all such 'fun' details need to be considered, not only those
> few that bear on the one usecase.

Which bares the question, what other use cases are there?

-- Steve

