Return-path: <linux-media-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3113 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab3DIWmZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Apr 2013 18:42:25 -0400
Date: Tue, 9 Apr 2013 18:42:23 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Peter Zijlstra <peterz@infradead.org>,
	Maarten Lankhorst <maarten.lankhorst@canonical.com>,
	linux-arch@vger.kernel.org, x86@kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
	rob clark <robclark@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@elte.hu>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] mutex: add support for reservation style locks, v2
Message-ID: <20130409224223.GD20739@home.goodmis.org>
References: <20130228102452.15191.22673.stgit@patser>
 <20130228102502.15191.14146.stgit@patser>
 <1364900432.18374.24.camel@laptop>
 <515AF1C1.7080508@canonical.com>
 <1364921954.20640.22.camel@laptop>
 <1365076908.2609.94.camel@laptop>
 <20130404133123.GW2228@phenom.ffwll.local>
 <CAKMK7uG_qLQrZUdE_LRANm7qXPvGUisBx-k=+y=F2gA3=odkrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uG_qLQrZUdE_LRANm7qXPvGUisBx-k=+y=F2gA3=odkrQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 04, 2013 at 06:56:58PM +0200, Daniel Vetter wrote:
> 
> I think for starters we need to have a slightly more interesting example:
> 
> 3 threads O, M, Y: O has the oldest ww_age/ticket, Y the youngest, M
> is in between.
> 2 ww_mutexes: A, B
> 
> Y has already acquired ww_mutex A, M has already acquired ww_mutex B.
> 

Now I probably missed it in the thread somewhere, but what makes task O
the oldest and Y the youngest? Is it the actual time from when the task
was created? What about setting an age as soon as it starts the process
of grabbing one of these locks? And it keeps the age until it
successfully grabs and releases all the locks again. It wont reset if it
had to drop the locks and start over.

Or am I totally not understanding what's going on here? Which could also
be the case ;-)

-- Steve

