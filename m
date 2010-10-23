Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:36034 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754671Ab0JWMNe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Oct 2010 08:13:34 -0400
Date: Sat, 23 Oct 2010 14:13:29 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: lirc-list@lists.sourceforge.net, Jarod Wilson <jarod@wilsonet.com>,
	mchehab@infradead.org, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/3] IR: extend ir_raw_event and do refactoring
Message-ID: <20101023121329.GA21845@hardeman.nu>
References: <1287269790-17605-1-git-send-email-maximlevitsky@gmail.com>
 <1287269790-17605-2-git-send-email-maximlevitsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1287269790-17605-2-git-send-email-maximlevitsky@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, Oct 17, 2010 at 12:56:28AM +0200, Maxim Levitsky wrote:
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
> Acked-by: Jarod Wilson <jarod@redhat.com>

I finally had a read-through of this patch. I like it. Note that we're 
going to have to change the decoders to also use the timeout event 
(since it basically behaves like a long space and e.g. the NEC decoder 
waits for the trailing space before sending a keydown). The same problem 
already exists for users of ir_raw_event_store_with_filter() though so 
the patch should still go in.

Acked-by: David Härdeman <david@hardeman.nu>

