Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:50637 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018Ab3DJJaY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Apr 2013 05:30:24 -0400
Received: by mail-ee0-f51.google.com with SMTP id c4so120742eek.10
        for <linux-media@vger.kernel.org>; Wed, 10 Apr 2013 02:30:23 -0700 (PDT)
Date: Wed, 10 Apr 2013 11:33:22 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
	Daniel Vetter <daniel@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@canonical.com>,
	linux-arch@vger.kernel.org, daniel.vetter@ffwll.ch, x86@kernel.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, robclark@gmail.com,
	tglx@linutronix.de, mingo@elte.hu, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 2/3] mutex: add support for reservation style locks, v2
Message-ID: <20130410093322.GH27612@phenom.ffwll.local>
References: <20130228102452.15191.22673.stgit@patser>
 <20130228102502.15191.14146.stgit@patser>
 <1364900432.18374.24.camel@laptop>
 <515AF1C1.7080508@canonical.com>
 <1364921954.20640.22.camel@laptop>
 <1365076908.2609.94.camel@laptop>
 <20130404133123.GW2228@phenom.ffwll.local>
 <1365093662.2609.111.camel@laptop>
 <20130409222808.GC20739@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130409222808.GC20739@home.goodmis.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 09, 2013 at 06:28:08PM -0400, Steven Rostedt wrote:
> On Thu, Apr 04, 2013 at 06:41:02PM +0200, Peter Zijlstra wrote:
> > On Thu, 2013-04-04 at 15:31 +0200, Daniel Vetter wrote:
> > > The thing is now that you're not expected to hold these locks for a
> > > long
> > > time - if you need to synchronously stall while holding a lock
> > > performance
> > > will go down the gutters anyway. And since most current
> > > gpus/co-processors
> > > still can't really preempt fairness isn't that high a priority,
> > > either.
> > > So we didn't think too much about that.
> > 
> > Yeah but you're proposing a new synchronization primitive for the core
> > kernel.. all such 'fun' details need to be considered, not only those
> > few that bear on the one usecase.
> 
> Which bares the question, what other use cases are there?

Tbh I don't see any other either - but I agree with Peter and thinking
things through and making the api a bit more generic seems to help in
clarifying the semantics. Reminds me that I still need to draw a few
diagrams ;-)
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
