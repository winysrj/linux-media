Return-path: <mchehab@gaivota>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57265 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab0JaTi6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Oct 2010 15:38:58 -0400
Received: by wwe15 with SMTP id 15so5341482wwe.1
        for <linux-media@vger.kernel.org>; Sun, 31 Oct 2010 12:38:57 -0700 (PDT)
From: Patrick Boettcher <pboettcher@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PULL request for 2.6.37] Add Technisat SkyStar HD USB driver
Date: Sun, 31 Oct 2010 20:38:51 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Manu Abraham <abraham.manu@gmail.com>
References: <201010171450.18459.pboettcher@kernellabs.com> <4CBAEAA7.6050206@redhat.com>
In-Reply-To: <4CBAEAA7.6050206@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201010312038.51597.pboettcher@kernellabs.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Sunday 17 October 2010 14:23:03 Mauro Carvalho Chehab wrote:
> Em 17-10-2010 10:50, Patrick Boettcher escreveu:
> > Hi Mauro,
> > 
> > please
> > 
> > git pull git://github.com/pboettch/linux-2.6.git for_mauro
> > 
> > for the following changes:
> > 
> > technisat-usb2: added driver for Technisat's USB2.0 DVB-S/S2 receiver
> > stv090x: add tei-field to config-structure
> > stv090x: added function to control GPIOs from the outside
> 
> Both stv090x patches seem ok to me.
> 
> > Thanks in advance for pulling and commenting,
> 
> I have a few comments for the technisat-usb2:

Thanks for your comments, they were appreciated.

> [...]
> > +static int technisat_usb2_debug;
> > +module_param_named(debug, technisat_usb2_debug, int, 0644);
> 
> As this is static, you could just name it as:
> 
> 	static int debug;
> 
> and use module_param() instead.

OK.

> 
> > +static struct i2c_algorithm technisat_usb2_i2c_algo = {
> > +	.master_xfer   = technisat_usb2_i2c_xfer,
> > +	.functionality = technisat_usb2_i2c_func,
> > +
> > +#ifdef NEED_ALGO_CONTROL
> > +	.algo_control = dummy_algo_control,
> > +#endif
> 
> You don't need it. This is always false upstream.

OK.

> [...]
> Don't implement your own IR RC5 decoding logic. We have it already at IR
> core, and it is able to handle several protocols. Instead, just sent the
> raw events to RC core.
> 
> See drivers/media/dvb/siano/smsir.c for an example on how to do it.
>
> [...]
> 
> Also, don't put the RC tables at the driver. Move it to a separate file, at
> drivers/media/IR/keymaps/. This allows importing the RC keycodes by
> ir-keytable userspace tool (from v4l-utils.git).

Everythings' done. Ported to use ir-rc5-decoder. Rebased and squashed.

So, please pull now from:

git pull git://github.com/pboettch/linux-2.6.git for_mauro

thanks in advance and best regards,

--
Patrick Boettcher - KernelLabs
http://www.kernellabs.com/
