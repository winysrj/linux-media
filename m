Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:39813 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758962Ab2HXWF1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Aug 2012 18:05:27 -0400
Date: Sat, 25 Aug 2012 00:05:18 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] rc: do not sleep when the driver blocks on IR
 completion
Message-ID: <20120824220518.GA19354@hardeman.nu>
References: <1345756715-17643-1-git-send-email-sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1345756715-17643-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 23, 2012 at 10:18:35PM +0100, Sean Young wrote:
>Some drivers wait for the IR device to complete sending before
>returning, so sleeping should not be done.

I'm not quite sure what the purpose is. Even if a driver waits for TX to
finish, the lirc imposed sleep isn't harmful in any way.

As far as I can tell, the iguanair driver waits for the usb packet to be
submitted, not for IR TX to finish.

As for winbond-cir, it would be simple enough to change it so that it
doesn't wait for TX to finish (which seems to be a better solution).

Having the TX methods as asynchronous as possible is probably a better
way to go...as I expect a future TX API to be asynchronous.

>
>Signed-off-by: Sean Young <sean@mess.org>
>---
> drivers/media/rc/iguanair.c      | 1 +
> drivers/media/rc/ir-lirc-codec.c | 5 +++++
> drivers/media/rc/winbond-cir.c   | 1 +
> include/media/rc-core.h          | 2 ++
> 4 files changed, 9 insertions(+)
>
>diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
>index 66ba237..7f1941d 100644
>--- a/drivers/media/rc/iguanair.c
>+++ b/drivers/media/rc/iguanair.c
>@@ -519,6 +519,7 @@ static int __devinit iguanair_probe(struct usb_interface *intf,
> 	rc->s_tx_mask = iguanair_set_tx_mask;
> 	rc->s_tx_carrier = iguanair_set_tx_carrier;
> 	rc->tx_ir = iguanair_tx;
>+	rc->tx_ir_drains = 1;
> 	rc->driver_name = DRIVER_NAME;
> 	rc->map_name = RC_MAP_RC6_MCE;
> 	rc->timeout = MS_TO_NS(100);
>diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
>index 569124b..dd21917 100644
>--- a/drivers/media/rc/ir-lirc-codec.c
>+++ b/drivers/media/rc/ir-lirc-codec.c
>@@ -144,6 +144,11 @@ static ssize_t ir_lirc_transmit_ir(struct file *file, const char __user *buf,
> 	if (ret < 0)
> 		goto out;
> 
>+	if (dev->tx_ir_drains) {
>+		ret *= sizeof(unsigned int);
>+		goto out;
>+	}
>+
> 	for (i = 0; i < ret; i++)
> 		duration += txbuf[i];
> 
>diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
>index 54ee348..b1b6d34 100644
>--- a/drivers/media/rc/winbond-cir.c
>+++ b/drivers/media/rc/winbond-cir.c
>@@ -1029,6 +1029,7 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
> 	data->dev->s_idle = wbcir_idle_rx;
> 	data->dev->s_tx_mask = wbcir_txmask;
> 	data->dev->s_tx_carrier = wbcir_txcarrier;
>+	data->dev->tx_ir_drains = 1;
> 	data->dev->tx_ir = wbcir_tx;
> 	data->dev->priv = data;
> 	data->dev->dev.parent = &device->dev;
>diff --git a/include/media/rc-core.h b/include/media/rc-core.h
>index b0c494a..fc2318c 100644
>--- a/include/media/rc-core.h
>+++ b/include/media/rc-core.h
>@@ -64,6 +64,7 @@ enum rc_driver_type {
>  * @last_keycode: keycode of last keypress
>  * @last_scancode: scancode of last keypress
>  * @last_toggle: toggle value of last command
>+ * @tx_ir_drains: tx_ir returns after IR has been sent
>  * @timeout: optional time after which device stops sending data
>  * @min_timeout: minimum timeout supported by device
>  * @max_timeout: maximum timeout supported by device
>@@ -108,6 +109,7 @@ struct rc_dev {
> 	u32				last_keycode;
> 	u32				last_scancode;
> 	u8				last_toggle;
>+	unsigned			tx_ir_drains:1;
> 	u32				timeout;
> 	u32				min_timeout;
> 	u32				max_timeout;
>-- 
>1.7.11.4
>

-- 
David Härdeman
