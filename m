Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.horus.com ([78.46.148.228]:48819 "EHLO mail.horus.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753731AbeDSWR1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 18:17:27 -0400
Date: Fri, 20 Apr 2018 00:17:23 +0200
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
Message-ID: <20180419221723.s6kx7nip6ue2d43o@camel2.lan>
References: <cover.1523221902.git.sean@mess.org>
 <02b5dac3b27169c6e6a4a070a2569b33fef47bbe.1523221902.git.sean@mess.org>
 <20180417191457.fhgsdega2kjqw3t2@camel2.lan>
 <20180418112428.zk3lmdxoqv46weph@gofer.mess.org>
 <20180418174229.jurjnyqbtkyctjvb@camel2.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180418174229.jurjnyqbtkyctjvb@camel2.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean,

On Wed, Apr 18, 2018 at 07:42:29PM +0200, Matthias Reichl wrote:
> Hi Sean,
> 
> On Wed, Apr 18, 2018 at 12:24:29PM +0100, Sean Young wrote:
> > Hello Hias,
> > 
> > On Tue, Apr 17, 2018 at 09:14:57PM +0200, Matthias Reichl wrote:
> > > On Sun, Apr 08, 2018 at 10:19:42PM +0100, Sean Young wrote:
> > > > mceusb devices have a default timeout of 100ms, but this can be changed.
> > > 
> > > We finally added a backport of the v2 series (and also the mce_kbd
> > > series) to LibreELEC yesterday and ratcher quickly received 2 bugreports
> > > from users using mceusb receivers.
> > > 
> > > Local testing on RPi/gpio-ir and Intel NUC/ite-cir was fine, I've
> > > been using the v2 series for over a week without issues on
> > > LibreELEC (RPi with kernel 4.14).
> > > 
> > > Here are the links to the bugreports and logs:
> > > https://forum.kodi.tv/showthread.php?tid=298461&pid=2726684#pid2726684
> > > https://forum.kodi.tv/showthread.php?tid=298462&pid=2726690#pid2726690
> > > 
> > > Both users are using similar mceusb receivers:
> > > 
> > > Log 1:
> > > [    6.418218] rc rc0: Media Center Ed. eHome Infrared Remote Transceiver (147a:e017) as /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.3/1-1.3:1.0/rc/rc0
> > > [    6.418358] input: Media Center Ed. eHome Infrared Remote Transceiver (147a:e017) as /devices/platform/soc/3f980000.usb/usb1/1-1/1-1.3/1-1.3:1.0/rc/rc0/input0
> > > [    6.419443] rc rc0: lirc_dev: driver ir-lirc-codec (mceusb) registered at minor = 0
> > > [    6.608114] mceusb 1-1.3:1.0: Registered Formosa21 SnowflakeEmulation with mce emulator interface version 1
> > > [    6.608125] mceusb 1-1.3:1.0: 0 tx ports (0x0 cabled) and 1 rx sensors (0x1 active)
> > > 
> > > Log 2:
> > > [    3.023361] rc rc0: Media Center Ed. eHome Infrared Remote Transceiver (147a:e03e) as /devices/pci0000:00/0000:00:14.0/usb1/1-10/1-10:1.0/rc/rc0
> > > [    3.023393] input: Media Center Ed. eHome Infrared Remote Transceiver (147a:e03e) as /devices/pci0000:00/0000:00:14.0/usb1/1-10/1-10:1.0/rc/rc0/input11
> > > [    3.023868] rc rc0: lirc_dev: driver ir-lirc-codec (mceusb) registered at minor = 0
> > > [    3.119384] input: eventlircd as /devices/virtual/input/input21
> > > [    3.138625] ip6_tables: (C) 2000-2006 Netfilter Core Team
> > > [    3.196830] mceusb 1-10:1.0: Registered Formosa21 eHome Infrared Transceiver with mce emulator interface version 2
> > > [    3.196836] mceusb 1-10:1.0: 0 tx ports (0x0 cabled) and 1 rx sensors (0x1 active)
> > > 
> > > In both cases ir-keytable doesn't report any scancodes and the
> > > ir-ctl -r output contains very odd long space values where I'd expect
> > > a short timeout instead:
> > > 
> > > gap between messages:
> > > space 800
> > > pulse 450
> > > space 16777215
> > > space 25400
> > > pulse 2650
> > > space 800
> > > 
> > > end of last message:
> > > space 800
> > > pulse 450
> > > space 16777215
> > > timeout 31750
> > > 
> > > This patch applied cleanly on 4.14 and the mceusb history from
> > > 4.14 to media/master looked rather unsuspicious. I'm not 100% sure
> > > if I might have missed a dependency when backporting the patch
> > > or if this is indeed an issue of this patch on these particular
> > > (or maybe some more) mceusb receivers.
> > 
> > Thanks again for a great bug report and analysis! So, it seems with the
> > shorter timeout, some mceusb devices add a specific "timeout" code to
> > the IR data stream (0x80) rather than a space. The current mceusb code
> > resets the decoders in this case, causing the IR decoders to reset and
> > lirc to report a space of 0xffffff.
> > 
> > Turns out that one of my mceusb devices also suffers from this, I don't
> > know how I missed this. Anyway hopefully this will solve the problem.
> 
> Thanks a lot for the quick fix!
> 
> I can't test myself as I don't have the hardware, but we will
> include the patch in tonight's LibreELEC build and I asked the
> users to test it. I'll keep you posted about the outcome.

One of the affected users reported back that the fix worked fine!

I'm keeping an eye on further reports but so far I'd say everything's
working really well.

Great job and thanks a lot for the improvements!

so long,

Hias

> 
> so long,
> 
> Hias
> 
> > 
> > 
> > Thanks
> > 
> > Sean
> > 
> > >>From 92d27b206e51993e927dc0b3aba210a621eef3d0 Mon Sep 17 00:00:00 2001
> > From: Sean Young <sean@mess.org>
> > Date: Wed, 18 Apr 2018 10:36:25 +0100
> > Subject: [PATCH] media: rc: mceusb: IR of length 0 means IR timeout, not reset
> > 
> > The last usb packet with IR data will end with 0x80 (MCE_IRDATA_TRAILER).
> > If we reset the decoder state at this point, IR decoding can fail.
> > 
> > Signed-off-by: Sean Young <sean@mess.org>
> > ---
> >  drivers/media/rc/mceusb.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
> > index c97cb2eb1c5f..5c0bf61fae26 100644
> > --- a/drivers/media/rc/mceusb.c
> > +++ b/drivers/media/rc/mceusb.c
> > @@ -1201,7 +1201,12 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
> >  			if (ir->rem) {
> >  				ir->parser_state = PARSE_IRDATA;
> >  			} else {
> > -				ir_raw_event_reset(ir->rc);
> > +				init_ir_raw_event(&rawir);
> > +				rawir.timeout = 1;
> > +				rawir.duration = ir->rc->timeout;
> > +				if (ir_raw_event_store_with_filter(ir->rc,
> > +								   &rawir))
> > +					event = true;
> >  				ir->pulse_tunit = 0;
> >  				ir->pulse_count = 0;
> >  			}
> > -- 
> > 2.14.3
> > 
