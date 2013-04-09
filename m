Return-path: <linux-media-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28312 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760498Ab3DIW1J (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Apr 2013 18:27:09 -0400
Date: Tue, 9 Apr 2013 18:27:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Daniel Vetter <daniel@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@canonical.com>,
	linux-arch@vger.kernel.org, daniel.vetter@ffwll.ch, x86@kernel.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, robclark@gmail.com,
	tglx@linutronix.de, mingo@elte.hu, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 2/3] mutex: add support for reservation style locks, v2
Message-ID: <20130409222707.GB20739@home.goodmis.org>
References: <20130228102452.15191.22673.stgit@patser>
 <20130228102502.15191.14146.stgit@patser>
 <1364900432.18374.24.camel@laptop>
 <515AF1C1.7080508@canonical.com>
 <1364921954.20640.22.camel@laptop>
 <1365076908.2609.94.camel@laptop>
 <20130404133123.GW2228@phenom.ffwll.local>
 <1365093516.2609.109.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365093516.2609.109.camel@laptop>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Apr 04, 2013 at 06:38:36PM +0200, Peter Zijlstra wrote:
> On Thu, 2013-04-04 at 15:31 +0200, Daniel Vetter wrote:
> > Hm, I guess your aim with the TASK_DEADLOCK wakeup is to bound the
> > wait
> > times of older task.
> 
> No, imagine the following:
> 
> struct ww_mutex A, B;
> struct mutex C;
> 
> 	task-O	task-Y	task-X
> 	  	A
> 		B
> 			C
> 		C
> 	B
> 
> At this point O finds that Y owns B and thus we want to make Y 'yield'
> B to make allow B progress. Since Y is blocked, we'll send a wakeup.
> However Y is blocked on a different locking primitive; one that doesn't
> collaborate in the -EDEADLK scheme therefore we don't want the wakeup to
> succeed.

I'm confused to why the above is a problem. Task-X will eventually
release C, and then Y will release B and O will get to continue. Do we
have to drop them once the owner is blocked? Can't we follow the chain
like the PI code does?

-- Steve

