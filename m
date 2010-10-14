Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:24411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754434Ab0JNT3x (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Oct 2010 15:29:53 -0400
Date: Thu, 14 Oct 2010 15:29:37 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>,
	David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	mchehab@infradead.org, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [1/8] IR: plug races in IR raw thread.
Message-ID: <20101014192937.GA4224@redhat.com>
References: <1283808373-27876-2-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283808373-27876-2-git-send-email-maximlevitsky@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Sep 06, 2010 at 09:26:06PM -0000, Maxim Levitsky wrote:
> Unfortunelly (my fault) the kernel thread that now handles IR processing
> has classical races in regard to wakeup and stop.
> This patch hopefully closes them all.
> Tested with module reload running in a loop, while receiver is blasted
> with IR data for 10 minutes.
> 
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>

Carrying over ack from earlier(?) version of the patch:

Took a while to unwind everything in ir_raw_event_thread() in my head,
but now that I think I have it sorted out, yeah, that looks like the
processing logic all remains the same, with the addition of locking
that should prevent the race (also heavily supported by your testing).

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@redhat.com

