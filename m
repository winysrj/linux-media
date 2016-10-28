Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:36328 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752582AbcJ1KkS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Oct 2016 06:40:18 -0400
Received: by mail-oi0-f68.google.com with SMTP id e12so9387601oib.3
        for <linux-media@vger.kernel.org>; Fri, 28 Oct 2016 03:40:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOJOY2MwyX++KbGLBXpf5nKihmrP+Qx5JgYJ==q-41t-znVwKQ@mail.gmail.com>
References: <20161028085224.GA9826@arch-desktop> <CAOJOY2MwyX++KbGLBXpf5nKihmrP+Qx5JgYJ==q-41t-znVwKQ@mail.gmail.com>
From: Marcel Hasler <mahasler@gmail.com>
Date: Fri, 28 Oct 2016 12:39:37 +0200
Message-ID: <CAOJOY2PVf8QVyzzeErUD21FMenNSGWDaY4jh4xPBp25rW6Vfvg@mail.gmail.com>
Subject: Fwd: [PATCH] stk1160: Give the chip some time to retrieve data from
 AC97 codec.
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch might need some explaining. I actually noticed this problem
early on while trying to fix the sound problem, but it was only this
morning that I realized the (trivial) cause of it.

I first noticed something strange going on when I read the AC97
registers from /proc/asound/cardX/codec97#0/ac97#0-0+regs using the
current version of the driver. Every time I read that file I would get
slightly different values, not only for one register but for several
of them. Also, every time I plugged in the device and opened alsamixer
I would be presented with a different set of mixer controls. So
obviously something was going wrong while talking to the AC97 chip.

When analyzing the USB trace I took from Windows (on VirtualBox) I
found long delays (2 ms) between control packets and wondered whether
those might be set by the driver on purpose. So I tried adding delays
in stk1160_[read|write]_reg, and sure enough, the problem disappeared.

In retrospective I suspect those long delays to really be the result
of virtualization overhead. I actually tried getting a native trace
using USBpcap, but unfortunately its timer resolution is so low that
it's impossible to get any useful data.

Once I realized what the actual problem was I removed the delays in
stk1160_[read|write]_reg and instead experimented with different
delays in stk1160_read_ac97 and found 20 us to be perfectly sufficient
to get reliable reads.

Now the strange thing about this problem is that it occurs on both of
my notebooks, but not on my desktop computer. I can only speculate
about the reason for this. My theory is that is has something to do
with the way different USB host controllers handle/buffer outgoing
control packets. Both of my notebooks are recent models by Acer (a
normal notebook and a cloudbook) and most likely use the same host
controller. My desktop motherboard on the other hand is a bit older.

So I wonder, have you experienced this problem on your own systems?

Best regards
Marcel

2016-10-28 10:52 GMT+02:00 Marcel Hasler <mahasler@gmail.com>:
> The STK1160 needs some time to transfer data from the AC97 registers into its own. On some
> systems reading the chip's own registers to soon will return wrong values. The "proper" way to
> handle this would be to poll STK1160_AC97CTL_0 after every read or write command until the
> command bit has been cleared, but this may not be worth the hassle.
>
> Signed-off-by: Marcel Hasler <mahasler@gmail.com>
> ---
>  drivers/media/usb/stk1160/stk1160-ac97.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/drivers/media/usb/stk1160/stk1160-ac97.c b/drivers/media/usb/stk1160/stk1160-ac97.c
> index 31bdd60d..caa65a8 100644
> --- a/drivers/media/usb/stk1160/stk1160-ac97.c
> +++ b/drivers/media/usb/stk1160/stk1160-ac97.c
> @@ -20,6 +20,7 @@
>   *
>   */
>
> +#include <linux/delay.h>
>  #include <linux/module.h>
>
>  #include "stk1160.h"
> @@ -61,6 +62,9 @@ static u16 stk1160_read_ac97(struct stk1160 *dev, u16 reg)
>          */
>         stk1160_write_reg(dev, STK1160_AC97CTL_0, 0x8b);
>
> +       /* Give the chip some time to transfer data */
> +       usleep_range(20, 40);
> +
>         /* Retrieve register value */
>         stk1160_read_reg(dev, STK1160_AC97_CMD, &vall);
>         stk1160_read_reg(dev, STK1160_AC97_CMD + 1, &valh);
> --
> 2.10.1
>
