Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62073 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab0G3WBQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jul 2010 18:01:16 -0400
Subject: Re: [PATCH 10/13] IR: extend interfaces to support more device
 settings LIRC: add new IOCTL that enables learning mode (wide band receiver)
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Christoph Bartelmus <lirc@bartelmus.de>
Cc: linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	lirc-list@lists.sourceforge.net, mchehab@redhat.com
In-Reply-To: <BTpNtKTJjFB@christoph>
References: <1280489933-20865-11-git-send-email-maximlevitsky@gmail.com>
	 <BTpNtKTJjFB@christoph>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 31 Jul 2010 01:01:04 +0300
Message-ID: <1280527264.3159.10.camel@maxim-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 2010-07-30 at 23:22 +0200, Christoph Bartelmus wrote: 
> Hi!
> 
> Maxim Levitsky "maximlevitsky@gmail.com" wrote:
> 
> > Still missing features: carrier report & timeout reports.
> > Will need to pack these into ir_raw_event
> 
> 
> Hm, this patch changes the LIRC interface but I can't see the according  
> patch to the documentation.
> 
> [...]
> >   * @tx_ir: transmit IR
> >   * @s_idle: optional: enable/disable hardware idle mode, upon which,
> > +<<<<<<< current
> >   *	device doesn't interrupt host untill it sees IR data
> > +=======
> 
> Huh?
:-)


> 
> > +	device doesn't interrupt host untill it sees IR data
> > + * @s_learning_mode: enable wide band receiver used for learning
> +>>>>>>>> patched
> 
> s/untill/until/
> 
> [...]
> >  #define LIRC_CAN_MEASURE_CARRIER          0x02000000
> > +#define LIRC_CAN_HAVE_WIDEBAND_RECEIVER   0x04000000
> 
> LIRC_CAN_USE_WIDEBAND_RECEIVER

OK. 
> 
> [...]
> > @@ -145,7 +146,7 @@
> >   * if enabled from the next key press on the driver will send
> >   * LIRC_MODE2_FREQUENCY packets
> >   */
> > -#define LIRC_SET_MEASURE_CARRIER_MODE  _IOW('i', 0x0000001d, __u32)
> > +#define LIRC_SET_MEASURE_CARRIER_MODE	_IOW('i', 0x0000001d, __u32)
> >
> >  /*
> >   * to set a range use
> > @@ -162,4 +163,6 @@
> >  #define LIRC_SETUP_START               _IO('i', 0x00000021)
> >  #define LIRC_SETUP_END                 _IO('i', 0x00000022)
> >
> > +#define LIRC_SET_WIDEBAND_RECEIVER     _IOW('i', 0x00000023, __u32)
> 
> If you really want this new ioctl, then it should be clarified how it  
> behaves in relation to LIRC_SET_MEASURE_CARRIER_MODE.

In my opinion, I won't need the LIRC_SET_MEASURE_CARRIER_MODE,
I would just optionally turn that on in learning mode.
You disagree, and since that is not important (besides TX and learning
features are present only at fraction of ENE devices. The only user I
did the debugging with, doesn't seem to want to help debug that code
anymore...)

But anyway, in current state I want these features to be independent.
Driver will enable learning mode if it have to.

I'll add the documentation.



> 
> Do you have to enable the wide-band receiver explicitly before you can  
> enable carrier reports or does enabling carrier reports implicitly switch  
> to the wide-band receiver?
I would implicitly switch the learning mode on, untill user turns off
the carrier reports.

> 
> What happens if carrier mode is enabled and you explicitly turn off the  
> wide-band receiver?
Wouldn't it be better to have one ioctl for both after all?

> 
> And while we're at interface stuff:
> Do we really need LIRC_SETUP_START and LIRC_SETUP_END? It is only used  
> once in lircd during startup.
I don't think so.

Best regards,
Maxim Levitsky

