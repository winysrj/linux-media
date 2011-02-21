Return-path: <mchehab@pedra>
Received: from na3sys009aog106.obsmtp.com ([74.125.149.77]:45164 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752463Ab1BUHgr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Feb 2011 02:36:47 -0500
Date: Mon, 21 Feb 2011 09:36:40 +0200
From: Felipe Balbi <balbi@ti.com>
To: David Cohen <dacohen@gmail.com>
Cc: balbi@ti.com,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Thomas Weber <weber@corscience.de>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-omap@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>, Tejun Heo <tj@kernel.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] video: omap24xxcam: Fix compilation
Message-ID: <20110221073640.GA3094@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1297068547-10635-1-git-send-email-weber@corscience.de>
 <4D5A6353.7040907@maxwell.research.nokia.com>
 <20110215113717.GN2570@legolas.emea.dhcp.ti.com>
 <4D5A672A.7040000@samsung.com>
 <4D5A6874.1080705@corscience.de>
 <20110215115349.GQ2570@legolas.emea.dhcp.ti.com>
 <4D5A6EEC.5000908@maxwell.research.nokia.com>
 <AANLkTik+6fguqgH8Bpnpqo7Axmquy3caRMELTZVmuN1j@mail.gmail.com>
 <20110219150024.GA4487@legolas.emea.dhcp.ti.com>
 <AANLkTik5dwNZrUxjgjKeAQOsp610d6y_TNGg1b5Vc5Zd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik5dwNZrUxjgjKeAQOsp610d6y_TNGg1b5Vc5Zd@mail.gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On Sat, Feb 19, 2011 at 06:04:58PM +0200, David Cohen wrote:
> > I have to disagree. The fundamental problem is the circular dependency
> > between those two files:
> >
> > sched.h uses wait_queue_head_t defined in wait.h
> > wait.h uses TASK_* defined in sched.h
> >
> > So, IMO the real fix would be clear out the circular dependency. Maybe
> > introducing <linux/task.h> to define those TASK_* symbols and include
> > that on sched.h and wait.h
> >
> > Just dig a quick and dirty to try it out and works like a charm
> 
> We have 2 problems:
>  - omap24xxcam compilation broken
>  - circular dependency between sched.h and wait.h
> 
> To fix the broken compilation we can do what the rest of the kernel is
> doing, which is to include sched.h.
> Then, the circular dependency is fixed by some different approach
> which would probably change *all* current usage of TASK_*.

considering that 1 is caused by 2 I would fix 2.

> IMO, there's no need to create a dependency between those issues.

There's no dependency between them, it's just that the root cause for
this problem is a circular dependency between wait.h and sched.h

-- 
balbi
