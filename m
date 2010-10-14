Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:50736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932241Ab0JNVqx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Oct 2010 17:46:53 -0400
Date: Thu, 14 Oct 2010 17:46:38 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>,
	David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	mchehab@infradead.org, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 7/8] IR: extend ir_raw_event and do refactoring
Message-ID: <20101014214638.GD2178@redhat.com>
References: <1283808373-27876-1-git-send-email-maximlevitsky@gmail.com>
 <1283808373-27876-8-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283808373-27876-8-git-send-email-maximlevitsky@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Sep 07, 2010 at 12:26:12AM +0300, Maxim Levitsky wrote:
> Add new event types for timeout & carrier report
> Move timeout handling from ir_raw_event_store_with_filter to
> ir-lirc-codec, where it is really needed.
> Now lirc bridge ensures proper gap handling.
> Extend lirc bridge for carrier & timeout reports
> 
> Note: all new ir_raw_event variables now should be initialized
> like that: DEFINE_IR_RAW_EVENT(ev);
> 
> To clean an existing event, use init_ir_raw_event(&ev);
> 
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>

Okay, so I think the end result of discussion on this patch was that we're
all pretty much fine with it going in, even the as-yet-unused duty_cycle
bit, as there *are* drivers that can use it sooner than later.

Acked-by: Jarod Wilson <jarod@redhat.com>


-- 
Jarod Wilson
jarod@redhat.com

