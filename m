Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:36278 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab0IHP0u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Sep 2010 11:26:50 -0400
MIME-Version: 1.0
In-Reply-To: <1283808373-27876-8-git-send-email-maximlevitsky@gmail.com>
References: <1283808373-27876-1-git-send-email-maximlevitsky@gmail.com>
	<1283808373-27876-8-git-send-email-maximlevitsky@gmail.com>
Date: Wed, 8 Sep 2010 11:26:48 -0400
Message-ID: <AANLkTinr6mN=t=vNnR3pSBxXb0ud=Ymrqn_WyDNkUJTz@mail.gmail.com>
Subject: Re: [PATCH 7/8] IR: extend ir_raw_event and do refactoring
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
> ---
>  drivers/media/IR/ene_ir.c          |    4 +-
>  drivers/media/IR/ir-core-priv.h    |   13 ++++++-
>  drivers/media/IR/ir-jvc-decoder.c  |    5 +-
>  drivers/media/IR/ir-lirc-codec.c   |   78 +++++++++++++++++++++++++++++++-----
>  drivers/media/IR/ir-nec-decoder.c  |    5 +-
>  drivers/media/IR/ir-raw-event.c    |   45 +++++++-------------
>  drivers/media/IR/ir-rc5-decoder.c  |    5 +-
>  drivers/media/IR/ir-rc6-decoder.c  |    5 +-
>  drivers/media/IR/ir-sony-decoder.c |    5 +-
>  drivers/media/IR/mceusb.c          |    3 +-
>  drivers/media/IR/streamzap.c       |    8 ++-
>  include/media/ir-core.h            |   40 ++++++++++++++++---
>  12 files changed, 153 insertions(+), 63 deletions(-)
...
> @@ -162,22 +164,48 @@ u32 ir_g_keycode_from_table(struct input_dev *input_dev, u32 scancode);
>  /* From ir-raw-event.c */
>
>  struct ir_raw_event {
> -       unsigned                        pulse:1;
> -       unsigned                        duration:31;
> +       union {
> +               u32             duration;
> +
> +               struct {
> +                       u32     carrier;
> +                       u8      duty_cycle;
> +               };
> +       };
> +
> +       unsigned                pulse:1;
> +       unsigned                reset:1;
> +       unsigned                timeout:1;
> +       unsigned                carrier_report:1;
>  };

I'm generally good with this entire patch, but the union usage looks a
bit odd, as the members aren't of the same size, which is generally
what I've come to expect looking at other code. I'd be inclined to
simply move duty_cycle out of the union and leave just duration and
carrier in it. However, as discussed on irc and upon looking at the
code, we don't actually do anything useful with duty_cycle yet, so
perhaps just cut it out entirely for the moment, and add it later when
its of use.

-- 
Jarod Wilson
jarod@wilsonet.com
