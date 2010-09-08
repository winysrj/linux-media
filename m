Return-path: <mchehab@pedra>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:61419 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab0IHOrJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Sep 2010 10:47:09 -0400
MIME-Version: 1.0
In-Reply-To: <1283808373-27876-5-git-send-email-maximlevitsky@gmail.com>
References: <1283808373-27876-1-git-send-email-maximlevitsky@gmail.com>
	<1283808373-27876-5-git-send-email-maximlevitsky@gmail.com>
Date: Wed, 8 Sep 2010 10:47:09 -0400
Message-ID: <AANLkTikoT0MEQFBAPcZtVccbMa5106wipxdhmzVoacyZ@mail.gmail.com>
Subject: Re: [PATCH 4/8] IR: fix keys beeing stuck down forever.
From: Jarod Wilson <jarod@wilsonet.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: lirc-list@lists.sourceforge.net,
	=?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>,
	mchehab@infradead.org, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Mon, Sep 6, 2010 at 5:26 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> The logic in ir_timer_keyup was inverted.
>
> In case that values aren't equal,
> the meaning of the time_is_after_eq_jiffies(ir->keyup_jiffies) is that
> ir->keyup_jiffies is after the the jiffies or equally that
> that jiffies are before the the ir->keyup_jiffies which is
> exactly the situation we want to avoid (that the timeout is in the future)
> Confusing Eh?

Yeah, seen time_is_{before,after}_jiffies use accidentally inverted a
couple of times... Kinda hints that we could use better names and/or
descriptions of the functions, but maybe people just need to read more
carefully (dunno, haven't looked to see what's there for usage
descriptions already)... Anyway.

> Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> ---
>  drivers/media/IR/ir-keytable.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Acked-by: Jarod Wilson <jarod@redhat.com>

-- 
Jarod Wilson
jarod@wilsonet.com
