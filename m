Return-path: <linux-media-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3973 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943Ab3DIWSe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Apr 2013 18:18:34 -0400
Date: Tue, 9 Apr 2013 18:18:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	daniel.vetter@ffwll.ch, x86@kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	robclark@gmail.com, tglx@linutronix.de, mingo@elte.hu,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v2 2/3] mutex: add support for reservation style locks, v2
Message-ID: <20130409221830.GA20739@home.goodmis.org>
References: <20130228102452.15191.22673.stgit@patser>
 <20130228102502.15191.14146.stgit@patser>
 <1364900432.18374.24.camel@laptop>
 <515AF1C1.7080508@canonical.com>
 <1364921954.20640.22.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364921954.20640.22.camel@laptop>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 02, 2013 at 06:59:14PM +0200, Peter Zijlstra wrote:
> 
> So how about we call the thing something like:
> 
>   struct ww_mutex; /* wound/wait */

Reading this I can't help but think of Elmer Fudd saying "Round Robin"
as "Wound Wobin"

-- Steve

> 
>   int mutex_wound_lock(struct ww_mutex *); /* returns -EDEADLK */
>   int mutex_wait_lock(struct ww_mutex *);  /* does not fail */
> 
