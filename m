Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:49266 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757780Ab3GRLEO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jul 2013 07:04:14 -0400
Received: by mail-we0-f180.google.com with SMTP id w56so2702060wes.25
        for <linux-media@vger.kernel.org>; Thu, 18 Jul 2013 04:04:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1374111202-23288-1-git-send-email-ljalvs@gmail.com>
References: <1374111202-23288-1-git-send-email-ljalvs@gmail.com>
Date: Thu, 18 Jul 2013 14:04:13 +0300
Message-ID: <CAF0Ff2mycZXUK_3OHE9L59eRyYsKNbRmq-je_ieKm=BbMyXpMA@mail.gmail.com>
Subject: Re: [PATCH] cx23885: Fix interrupt storm that happens in some cards
 when IR is enabled.
From: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 18, 2013 at 4:33 AM, Luis Alves <ljalvs@gmail.com> wrote:

> Signed-off-by: Luis Alves <ljalvs@gmail.com>
> ---
>  drivers/media/pci/cx23885/cx23885-cards.c |   22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
>
> diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
> index 7e923f8..89ce132 100644
> --- a/drivers/media/pci/cx23885/cx23885-cards.c
> +++ b/drivers/media/pci/cx23885/cx23885-cards.c
> @@ -1081,6 +1081,27 @@ int cx23885_tuner_callback(void *priv, int component, int command, int arg)
>         return 0;
>  }
>
> +void cx23885_ir_setup(struct cx23885_dev *dev)
> +{
> +       struct i2c_msg msg;
> +       char buffer[2];
> +
> +       /* this should stop the IR interrupt
> +          storm that happens in some cards */
> +       msg.addr = 0x4c;
> +       msg.flags = 0;
> +       msg.len = 2;
> +       msg.buf = buffer;
> +
> +       buffer[0] = 0x1f;
> +       buffer[1] = 0x80;
> +       i2c_transfer(&dev->i2c_bus[2].i2c_adap, &msg, 1);
> +
> +       buffer[0] = 0x23;
> +       buffer[1] = 0x80;
> +       i2c_transfer(&dev->i2c_bus[2].i2c_adap, &msg, 1);
> +}
> +

hi All,

i didn't want to interfere thus far for that series of related
patches, but because it starts to become a little ridiculous -
actually that's what happens when you copy&paste someone else's work
without having any understanding how and why that code (even very
simple as code) was invented (but it's not that simple to invent it
though) - in this particular case - that same code you can track back
to several years ago when drivers for TBS 698x cards was released by
me. so, for whatever reason that code wasn't up-streamed by me - lack
of time, NDAs, etc. and i don't mind that be up-streamed by someone
who wants to do it (after all it was released under GPL as patch to
GPL code), what i find as highly inappropriate when the author of the
code is perfectly known and it's known to who submit the above patch,
at least as a courtesy, if you wish, the original author of the code
to be included to CC - what about if i'm not subscribed to linux-media
or even if i missed to spot the email as part of linux-media and i as
the one who mind it have something in mind. so, i must say that i
totally agree with questions and concerns Devin Heitmueller
<dheitmueller@kernellabs.com> raised in regards to that code - when
it's highly specific to particular design and who submit it doesn't
really know what it does and those you know are not allow to say, it's
just increase the risk to pollute the mainline drivers rather then
improve them and that's why it needs at least to be put in right place
- not affect boards for which it's not intended. also, i think when
what that code does is not clear it should be a comment from where it
comes and the same if it wasn't open-source, but made with clean-room
reverse-engineering - that again should be mentioned, because it
implies you don't understand, at least fully, the work and you can't
really maintain what you submit as patches in case of problems.

best regards,
konstantin
