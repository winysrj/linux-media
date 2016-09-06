Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:41031
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932939AbcIFTdM (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2016 15:33:12 -0400
Date: Tue, 6 Sep 2016 16:33:07 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Johan Fjeldtvedt <jaffe1@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCHv2 3/4] pulse8-cec: add notes about behavior in
 autonomous mode
Message-ID: <20160906163307.3334ba54@vento.lan>
In-Reply-To: <1471856694-14182-4-git-send-email-jaffe1@gmail.com>
References: <1471856694-14182-1-git-send-email-jaffe1@gmail.com>
        <1471856694-14182-4-git-send-email-jaffe1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 22 Aug 2016 11:04:53 +0200
Johan Fjeldtvedt <jaffe1@gmail.com> escreveu:

> The pulse8 dongle has some quirky behaviors when in autonomous mode.
> Document these.
> 
> Signed-off-by: Johan Fjeldtvedt <jaffe1@gmail.com>

While it is ok to add this at a note on the driver, IMHO, the best would
be to write a rst file for this driver, when it moves from staging,
adding those notes there too.

Regards,
Mauro

> ---
>  drivers/staging/media/pulse8-cec/pulse8-cec.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/drivers/staging/media/pulse8-cec/pulse8-cec.c b/drivers/staging/media/pulse8-cec/pulse8-cec.c
> index 37c8418..aa679a3 100644
> --- a/drivers/staging/media/pulse8-cec/pulse8-cec.c
> +++ b/drivers/staging/media/pulse8-cec/pulse8-cec.c
> @@ -10,6 +10,29 @@
>   * this archive for more details.
>   */
>  
> +/*
> + * Notes:
> + *
> + * - Devices with firmware version < 2 do not store their configuration in
> + *   EEPROM.
> + *
> + * - In autonomous mode, only messages from a TV will be acknowledged, even
> + *   polling messages. Upon receiving a message from a TV, the dongle will
> + *   respond to messages from any logical address.
> + *
> + * - In autonomous mode, the dongle will by default reply Feature Abort
> + *   [Unrecognized Opcode] when it receives Give Device Vendor ID. It will
> + *   however observe vendor ID's reported by other devices and possibly
> + *   alter this behavior. When TV's (and TV's only) report that their vendor ID
> + *   is LG (0x00e091), the dongle will itself reply that it has the same vendor
> + *   ID, and it will respond to at least one vendor specific command.
> + *
> + * - In autonomous mode, the dongle is known to attempt wakeup if it receives
> + *   <User Control Pressed> ["Power On"], ["Power] or ["Power Toggle"], or if it
> + *   receives <Set Stream Path> with its own physical address. It also does this
> + *   if it receives <Vendor Specific Command> [0x03 0x00] from an LG TV.
> + */
> +
>  #include <linux/completion.h>
>  #include <linux/init.h>
>  #include <linux/interrupt.h>



Thanks,
Mauro
