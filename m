Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:7069 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756747AbZGCUhi (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Jul 2009 16:37:38 -0400
Date: Fri, 3 Jul 2009 22:37:32 +0200
From: Jean Delvare <khali@linux-fr.org>
To: LMML <linux-media@vger.kernel.org>
Cc: Andrzej Hajda <andrzej.hajda@wp.pl>,
	Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [PATCH] cx88: High resolution timer for Remote Controls
Message-ID: <20090703223732.7818aa3b@hyperion.delvare>
In-Reply-To: <20090702165035.3683b4cb@hyperion.delvare>
References: <20090702165035.3683b4cb@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2 Jul 2009 16:50:35 +0200, Jean Delvare wrote:
> From: Andrzej Hajda <andrzej.hajda@wp.pl>
> 
> Patch solves problem of missed keystrokes on some remote controls,
> as reported on http://bugzilla.kernel.org/show_bug.cgi?id=9637 .
> 
> Signed-off-by: Andrzej Hajda <andrzej.hajda@wp.pl>
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> ---
> Resending because last attempt resulted in folded lines:
> http://www.spinics.net/lists/linux-media/msg06884.html
> Patch was already resent by Andrzej on June 4th but apparently it was
> overlooked.
> 
> Trent Piepho commented on the compatibility with kernels older than
> 2.6.20 being possibly broken:
> http://www.spinics.net/lists/linux-media/msg06885.html
> I don't think this is the case. The kernel version test was there
> because the workqueue API changed in 2.6.20, but the hrtimer API did
> not have such a change. This is why the version check has gone.
> 
> It is highly probable that the hrtimer API had its own incompatible
> changes since it was introduced in kernel 2.6.16. By looking at the
> code, I found the following ones:
> 
> * hrtimer_forward_now() was added with kernel 2.6.25 only:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=5e05ad7d4e3b11f935998882b5d9c3b257137f1b
> But this is an inline function, so I presume this shouldn't be too
> difficult to add to a compatibility header.
> 
> * Before 2.6.21, HRTIMER_MODE_REL was named HRTIMER_REL:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=c9cb2e3d7c9178ab75d0942f96abb3abe0369906
> This too should be solvable in a compatibility header.
> 
> The rest doesn't seem to cause compatibility issues, but only actual
> testing would confirm that.

Actually there were more compatibility issues, the most important one
being that not all functions of the hrtimer API are exported before
2.6.22. So unfortunately this bug fix means that the cx88 driver will
no longer build on kernels < 2.6.22. I'll post a new patch with this
change, and another one for the hrtimer compatibility code.

-- 
Jean Delvare
