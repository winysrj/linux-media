Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.horus.com ([78.46.148.228]:45127 "EHLO mail.horus.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751836AbeDQTPA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 17 Apr 2018 15:15:00 -0400
Date: Tue, 17 Apr 2018 21:14:57 +0200
From: Matthias Reichl <hias@horus.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org, Carlo Caione <carlo@caione.org>,
        Kevin Hilman <khilman@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Alex Deryskyba <alex@codesnake.com>,
        Jonas Karlman <jonas@kwiboo.se>,
        linux-amlogic@lists.infradead.org
Subject: Re: [PATCH v2 7/7] media: rc: mceusb: allow the timeout to be
 configurable
Message-ID: <20180417191457.fhgsdega2kjqw3t2@camel2.lan>
References: <cover.1523221902.git.sean@mess.org>
 <02b5dac3b27169c6e6a4a070a2569b33fef47bbe.1523221902.git.sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02b5dac3b27169c6e6a4a070a2569b33fef47bbe.1523221902.git.sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean!

On Sun, Apr 08, 2018 at 10:19:42PM +0100, Sean Young wrote:
> mceusb devices have a default timeout of 100ms, but this can be changed.

We finally added a backport of the v2 series (and also the mce_kbd
series) to LibreELEC yesterday and ratcher quickly received 2 bugreports
from users using mceusb receivers.

Local testing on RPi/gpio-ir and Intel NUC/ite-cir was fine, I've
been using the v2 series for over a week without issues on
LibreELEC (RPi with kernel 4.14).

Here are the links to the bugreports and logs:
https://forum.kodi.tv/showthread.php?tid=298461&pid=2726684#pid2726684
https://forum.kodi.tv/showthread.php?tid=298462&pid=2726690#pid2726690

Both users are using similar mceusb receivers:

Log 1:
[    6.418218] rc rc0: Media Center Ed. eHome Infrared Remote Transceiver (147a:e017) as /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.3/1-1.3:1.0/rc/rc0
[    6.418358] input: Media Center Ed. eHome Infrared Remote Transceiver (147a:e017) as /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.3/1-1.3:1.0/rc/rc0/input0
[    6.419443] rc rc0: lirc_dev: driver ir-lirc-codec (mceusb) registered at minor = 0
[    6.608114] mceusb 1-1.3:1.0: Registered Formosa21 SnowflakeEmulation with mce emulator interface version 1
[    6.608125] mceusb 1-1.3:1.0: 0 tx ports (0x0 cabled) and 1 rx sensors (0x1 active)

Log 2:
[    3.023361] rc rc0: Media Center Ed. eHome Infrared Remote Transceiver (147a:e03e) as /devices/pci0000:00/0000:00:14.0/usb1/1-10/1-10:1.0/rc/rc0
[    3.023393] input: Media Center Ed. eHome Infrared Remote Transceiver (147a:e03e) as /devices/pci0000:00/0000:00:14.0/usb1/1-10/1-10:1.0/rc/rc0/input11
[    3.023868] rc rc0: lirc_dev: driver ir-lirc-codec (mceusb) registered at minor = 0
[    3.119384] input: eventlircd as /devices/virtual/input/input21
[    3.138625] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    3.196830] mceusb 1-10:1.0: Registered Formosa21 eHome Infrared Transceiver with mce emulator interface version 2
[    3.196836] mceusb 1-10:1.0: 0 tx ports (0x0 cabled) and 1 rx sensors (0x1 active)

In both cases ir-keytable doesn't report any scancodes and the
ir-ctl -r output contains very odd long space values where I'd expect
a short timeout instead:

gap between messages:
space 800
pulse 450
space 16777215
space 25400
pulse 2650
space 800

end of last message:
space 800
pulse 450
space 16777215
timeout 31750

This patch applied cleanly on 4.14 and the mceusb history from
4.14 to media/master looked rather unsuspicious. I'm not 100% sure
if I might have missed a dependency when backporting the patch
or if this is indeed an issue of this patch on these particular
(or maybe some more) mceusb receivers.

so long,

Hias

> Signed-off-by: Sean Young <sean@mess.org>
> ---
>  drivers/media/rc/mceusb.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
> index 69ba57372c05..c97cb2eb1c5f 100644
> --- a/drivers/media/rc/mceusb.c
> +++ b/drivers/media/rc/mceusb.c
> @@ -982,6 +982,25 @@ static int mceusb_set_tx_carrier(struct rc_dev *dev, u32 carrier)
>  	return 0;
>  }
>  
> +static int mceusb_set_timeout(struct rc_dev *dev, unsigned int timeout)
> +{
> +	u8 cmdbuf[4] = { MCE_CMD_PORT_IR, MCE_CMD_SETIRTIMEOUT, 0, 0 };
> +	struct mceusb_dev *ir = dev->priv;
> +	unsigned int units;
> +
> +	units = DIV_ROUND_CLOSEST(timeout, US_TO_NS(MCE_TIME_UNIT));
> +
> +	cmdbuf[2] = units >> 8;
> +	cmdbuf[3] = units;
> +
> +	mce_async_out(ir, cmdbuf, sizeof(cmdbuf));
> +
> +	/* get receiver timeout value */
> +	mce_async_out(ir, GET_RX_TIMEOUT, sizeof(GET_RX_TIMEOUT));
> +
> +	return 0;
> +}
> +
>  /*
>   * Select or deselect the 2nd receiver port.
>   * Second receiver is learning mode, wide-band, short-range receiver.
> @@ -1415,7 +1434,10 @@ static struct rc_dev *mceusb_init_rc_dev(struct mceusb_dev *ir)
>  	rc->dev.parent = dev;
>  	rc->priv = ir;
>  	rc->allowed_protocols = RC_PROTO_BIT_ALL_IR_DECODER;
> +	rc->min_timeout = US_TO_NS(MCE_TIME_UNIT);
>  	rc->timeout = MS_TO_NS(100);
> +	rc->max_timeout = 10 * IR_DEFAULT_TIMEOUT;
> +	rc->s_timeout = mceusb_set_timeout;
>  	if (!ir->flags.no_tx) {
>  		rc->s_tx_mask = mceusb_set_tx_mask;
>  		rc->s_tx_carrier = mceusb_set_tx_carrier;
> -- 
> 2.14.3
> 
