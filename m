Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:62665 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab0G3VW7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jul 2010 17:22:59 -0400
Date: 30 Jul 2010 23:22:00 +0200
From: lirc@bartelmus.de (Christoph Bartelmus)
To: maximlevitsky@gmail.com
Cc: linux-input@vger.kernel.org
Cc: linux-media@vger.kernel.org
Cc: lirc-list@lists.sourceforge.net
Cc: mchehab@redhat.com
Message-ID: <BTpNtKTJjFB@christoph>
References: <1280489933-20865-11-git-send-email-maximlevitsky@gmail.com>
Subject: Re: [PATCH 10/13] IR: extend interfaces to support more device settings LIRC: add new IOCTL that enables learning mode (wide band receiver)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

Maxim Levitsky "maximlevitsky@gmail.com" wrote:

> Still missing features: carrier report & timeout reports.
> Will need to pack these into ir_raw_event


Hm, this patch changes the LIRC interface but I can't see the according  
patch to the documentation.

[...]
>   * @tx_ir: transmit IR
>   * @s_idle: optional: enable/disable hardware idle mode, upon which,
> +<<<<<<< current
>   *	device doesn't interrupt host untill it sees IR data
> +=======

Huh?

> +	device doesn't interrupt host untill it sees IR data
> + * @s_learning_mode: enable wide band receiver used for learning
+>>>>>>>> patched

s/untill/until/

[...]
>  #define LIRC_CAN_MEASURE_CARRIER          0x02000000
> +#define LIRC_CAN_HAVE_WIDEBAND_RECEIVER   0x04000000

LIRC_CAN_USE_WIDEBAND_RECEIVER

[...]
> @@ -145,7 +146,7 @@
>   * if enabled from the next key press on the driver will send
>   * LIRC_MODE2_FREQUENCY packets
>   */
> -#define LIRC_SET_MEASURE_CARRIER_MODE  _IOW('i', 0x0000001d, __u32)
> +#define LIRC_SET_MEASURE_CARRIER_MODE	_IOW('i', 0x0000001d, __u32)
>
>  /*
>   * to set a range use
> @@ -162,4 +163,6 @@
>  #define LIRC_SETUP_START               _IO('i', 0x00000021)
>  #define LIRC_SETUP_END                 _IO('i', 0x00000022)
>
> +#define LIRC_SET_WIDEBAND_RECEIVER     _IOW('i', 0x00000023, __u32)

If you really want this new ioctl, then it should be clarified how it  
behaves in relation to LIRC_SET_MEASURE_CARRIER_MODE.

Do you have to enable the wide-band receiver explicitly before you can  
enable carrier reports or does enabling carrier reports implicitly switch  
to the wide-band receiver?

What happens if carrier mode is enabled and you explicitly turn off the  
wide-band receiver?

And while we're at interface stuff:
Do we really need LIRC_SETUP_START and LIRC_SETUP_END? It is only used  
once in lircd during startup.

Christoph
