Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f213.google.com ([209.85.220.213]:34983 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbZKWRJS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 12:09:18 -0500
Received: by fxm5 with SMTP id 5so4865060fxm.28
        for <linux-media@vger.kernel.org>; Mon, 23 Nov 2009 09:09:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1258978370.3058.25.camel@palomino.walls.org>
References: <1257913905.28958.32.camel@palomino.walls.org>
	 <829197380911221904uedc18e5qbc9a37cfcee23b5d@mail.gmail.com>
	 <1258978370.3058.25.camel@palomino.walls.org>
Date: Mon, 23 Nov 2009 12:09:22 -0500
Message-ID: <829197380911230909u27f6df33icbbc52c5268a1658@mail.gmail.com>
Subject: Re: cx18: Reprise of YUV frame alignment improvements
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andy Walls <awalls@radix.net>
Cc: ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 23, 2009 at 7:12 AM, Andy Walls <awalls@radix.net> wrote:
> 5. If you don't give an MDL back to the firmware, it never uses it
> again.  That's why you see the sweep-up log messages.  As soon as an MDL
> is skipped *on the order of the depth* of q_busy times, when looking for
> the currently DMA_DONE'd MDL, that skipped MDL must have been dropped.
> It is picked up and put back into rotation then.

Perhaps I am misinterpreting the definition of "sweep-up" in this
context.  Don't the buffers get forcefully returned to the pool at
that point?  If so, why would I see the same error over and over long
after the CPU utilization has dropped back to a reasonable level.

I feel like I must be missing something here.

1.  CPU load goes up (ok)
2.  Packets start to get dropped (expected)
3.  CPU load goes back down (ok)
4.  Packets continue to get dropped and never recycled, even after
minutes of virtually no CPU load?

I can totally appreciate the notion that the video would look choppy
when the system is otherwise under high load, but my expectation would
be that once the load drops back to 0, the video should look fine
(perhaps with some small window of time where it is still recovering).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
