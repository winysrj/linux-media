Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52815 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab2FZV1O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jun 2012 17:27:14 -0400
Received: by dady13 with SMTP id y13so443637dad.19
        for <linux-media@vger.kernel.org>; Tue, 26 Jun 2012 14:27:14 -0700 (PDT)
Date: Tue, 26 Jun 2012 14:27:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Antti Palosaari <crope@iki.fi>, Kay Sievers <kay@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFC 3/4] em28xx: Workaround for new udev versions
Message-ID: <20120626212710.GA4572@kroah.com>
References: <4FE9169D.5020300@redhat.com>
 <1340739262-13747-1-git-send-email-mchehab@redhat.com>
 <1340739262-13747-4-git-send-email-mchehab@redhat.com>
 <20120626204242.GC3885@kroah.com>
 <4FEA27BE.8020306@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FEA27BE.8020306@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 26, 2012 at 06:21:02PM -0300, Mauro Carvalho Chehab wrote:
> Em 26-06-2012 17:42, Greg KH escreveu:
> > On Tue, Jun 26, 2012 at 04:34:21PM -0300, Mauro Carvalho Chehab wrote:
> >> New udev-182 seems to be buggy: even when usermode is enabled, it
> >> insists on needing that probe would defer any firmware requests.
> >> So, drivers with firmware need to defer probe for the first
> >> driver's core request, otherwise an useless penalty of 30 seconds
> >> happens, as udev will refuse to load any firmware.
> >>
> >> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> >> ---
> >>
> >> Note: this patch adds an ugly printk there, in order to allow testing it better.
> >> This will be removed at the final version.
> >>
> >>   drivers/media/video/em28xx/em28xx-cards.c |   39 +++++++++++++++++++++++++----
> >>   1 file changed, 34 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
> >> index 9229cd2..9a1c16c 100644
> >> --- a/drivers/media/video/em28xx/em28xx-cards.c
> >> +++ b/drivers/media/video/em28xx/em28xx-cards.c
> >> @@ -60,6 +60,8 @@ static unsigned int card[]     = {[0 ... (EM28XX_MAXBOARDS - 1)] = UNSET };
> >>   module_param_array(card,  int, NULL, 0444);
> >>   MODULE_PARM_DESC(card,     "card type");
> >>   
> >> +static bool is_em28xx_initialized;
> >> +
> >>   /* Bitmask marking allocated devices from 0 to EM28XX_MAXBOARDS - 1 */
> >>   static unsigned long em28xx_devused;
> >>   
> >> @@ -3167,11 +3169,14 @@ static int em28xx_usb_probe(struct usb_interface *interface,
> >>   	 * postponed, as udev may not be ready yet to honour firmware
> >>   	 * load requests.
> >>   	 */
> >> +printk("em28xx: init = %d, userspace_is_disabled = %d, needs firmware = %d\n",
> >> +	is_em28xx_initialized,
> >> +	is_usermodehelp_disabled(), em28xx_boards[id->driver_info].needs_firmware);
> > 
> > debug code?
> 
> Yes, temporary debug code, for people @linux-media that might be interested
> on testing the patch. It will be removed at the final version, of course.
> 
> > Also, this doesn't seem wise.  probe() will be called and
> > is_em28xx_initialized will be 0 before it can be set if the device is
> > present when the module is loaded.  But, if a new device is added to the
> > system after probe() already runs, is_em28xx_initialized will be 1, yet
> > it isn't true for this new device.
> 
> Yes.

So you really want that?  That doesn't make any sense, sorry.

> > So this doesn't seem like a valid solution, even if you were wanting to
> > paper over a udev bug.
> 
> The problem with udev-182 is that it blocks firmware load while
> mode_init() is happening. Only after the end of module_init(), udev will
> handle request_firmware.

How does udev "know" that module_init() is completed, or even in the
picture at all?  Is this due to the change to use kmod?

And you really should be using the async firmware loading path, that
would solve this problem entirely, right?

> This is what happens before this patch series:
> 
> [    3.605783] tvp5150 0-005c: tvp5150am1 detected.
> [    3.627674] tuner 0-0061: Tuner -1 found with type(s) Radio TV.
> [    3.633695] xc2028 0-0061: creating new instance
> [    3.638406] xc2028 0-0061: type set to XCeive xc2028/xc3028 tuner
> [   64.422633] xc2028 0-0061: Error: firmware xc3028-v27.fw not found.
> [   64.429090] em28xx #0: Config register raw data: 0xd0
> [   64.434959] em28xx #0: AC97 vendor ID = 0xffffffff
> [   64.440206] em28xx #0: AC97 features = 0x6a90
> [   64.444654] em28xx #0: Empia 202 AC97 audio processor detected
> [   64.607494] em28xx #0: v4l2 driver version 0.1.3
> [  125.574760] xc2028 0-0061: Error: firmware xc3028-v27.fw not found.
> [  125.645012] em28xx #0: V4L2 video device registered as video0
> [  125.650851] em28xx #0: V4L2 VBI device registered as vbi0
> 
> The 60s delay is due to the bug (firmware doesn't load there just
> because I didn't ask dracut to add it there).

Ok, if you ask for firmware that you don't have, stalling is normal.
Not good though, and one big reason you should switch to using the async
model of firmware loading (a long time ago I wanted that to be the only
model, but I lost that argument...)

> After the patch series, the artificial delay introduced due to udev-182
> goes away:

Wait, if the firmware isn't present, how could any delay go away?  Why
would it go away?

still confused,

greg k-h
