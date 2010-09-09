Return-path: <mchehab@pedra>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:56291 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab0IIENm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Sep 2010 00:13:42 -0400
MIME-Version: 1.0
In-Reply-To: <1283808373-27876-2-git-send-email-maximlevitsky@gmail.com>
References: <1283808373-27876-1-git-send-email-maximlevitsky@gmail.com>
	<1283808373-27876-2-git-send-email-maximlevitsky@gmail.com>
Date: Thu, 9 Sep 2010 00:13:41 -0400
Message-ID: <AANLkTimKo6kotF52LPBZ5iZpEFq-BE5cBD3Q_y8idETq@mail.gmail.com>
Subject: Re: [PATCH 1/8] IR: plug races in IR raw thread.
From: Jarod Wilson <jarod@wilsonet.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: lirc-list@lists.sourceforge.net,
	=?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	mchehab@infradead.org, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Mon, Sep 6, 2010 at 5:26 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> Unfortunelly (my fault) the kernel thread that now handles IR processing
> has classical races in regard to wakeup and stop.
> This patch hopefully closes them all.
> Tested with module reload running in a loop, while receiver is blasted
> with IR data for 10 minutes.
>
> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>

Took a while to unwind everything in ir_raw_event_thread() in my head,
but now that I think I have it sorted out, yeah, that looks like the
processing logic all remains the same, with the addition of locking
that should prevent the race (also heavily supported by your testing).

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@wilsonet.com
