Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:34654
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1760072AbcLBLJx (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Dec 2016 06:09:53 -0500
Date: Fri, 2 Dec 2016 09:09:48 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Marcel Hasler <mahasler@gmail.com>
Cc: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v3 4/4] stk1160: Give the chip some time to retrieve
 data from AC97 codec.
Message-ID: <20161202090948.0efd0678@vento.lan>
In-Reply-To: <20161127111236.GA1691@arch-desktop>
References: <20161127110732.GA5338@arch-desktop>
        <20161127111236.GA1691@arch-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 27 Nov 2016 12:12:36 +0100
Marcel Hasler <mahasler@gmail.com> escreveu:

> The STK1160 needs some time to transfer data from the AC97 registers into its own. On some
> systems reading the chip's own registers to soon will return wrong values. The "proper" way to
> handle this would be to poll STK1160_AC97CTL_0 after every read or write command until the
> command bit has been cleared, but this may not be worth the hassle.
> 
> Signed-off-by: Marcel Hasler <mahasler@gmail.com>
> ---
>  drivers/media/usb/stk1160/stk1160-ac97.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/media/usb/stk1160/stk1160-ac97.c b/drivers/media/usb/stk1160/stk1160-ac97.c
> index 60327af..b39f51b 100644
> --- a/drivers/media/usb/stk1160/stk1160-ac97.c
> +++ b/drivers/media/usb/stk1160/stk1160-ac97.c
> @@ -23,6 +23,7 @@
>   *
>   */
>  
> +#include <linux/delay.h>
>  #include <linux/module.h>
>  
>  #include "stk1160.h"
> @@ -64,6 +65,14 @@ static u16 stk1160_read_ac97(struct stk1160 *dev, u16 reg)
>  	 */
>  	stk1160_write_reg(dev, STK1160_AC97CTL_0, 0x8b);
>  
> +	/*
> +	 * Give the chip some time to transfer the data.
> +	 * The proper way would be to poll STK1160_AC97CTL_0
> +	 * until the command bit has been cleared, but this
> +	 * may not be worth the hassle.

Why not? Relying on a fixed amount time is not nice.

Take a look at em28xx_is_ac97_ready() function, at
drivers/media/usb/em28xx/em28xx-core.c to see how this could be
implemented instead.


> +	 */
> +	usleep_range(20, 40);
> +

>  	/* Retrieve register value */
>  	stk1160_read_reg(dev, STK1160_AC97_CMD, &vall);
>  	stk1160_read_reg(dev, STK1160_AC97_CMD + 1, &valh);



Thanks,
Mauro
