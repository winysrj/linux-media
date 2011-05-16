Return-path: <mchehab@pedra>
Received: from leo.clearchain.com ([199.73.29.74]:27273 "EHLO
	mail.clearchain.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295Ab1EPBgE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 May 2011 21:36:04 -0400
Date: Mon, 16 May 2011 11:35:44 +1000
From: Peter Hutterer <peter.hutterer@who-t.net>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Anssi Hannula <anssi.hannula@iki.fi>, linux-media@vger.kernel.org,
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	xorg-devel@lists.freedesktop.org
Subject: Re: IR remote control autorepeat / evdev
Message-ID: <20110516013544.GC11578@barra.bne.redhat.com>
References: <4DCA1496.20304@redhat.com>
 <4DCABA42.30505@iki.fi>
 <4DCABEAE.4080607@redhat.com>
 <4DCACE74.6050601@iki.fi>
 <4DCB213A.8040306@redhat.com>
 <4DCB2BD9.6090105@iki.fi>
 <4DCB336B.2090303@redhat.com>
 <4DCB39AF.2000807@redhat.com>
 <20110512060529.GA14710@barra.bne.redhat.com>
 <4DCCE2E6.3070703@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DCCE2E6.3070703@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, May 13, 2011 at 09:51:02AM +0200, Mauro Carvalho Chehab wrote:
> Em 12-05-2011 08:05, Peter Hutterer escreveu:
> > On Thu, May 12, 2011 at 03:36:47AM +0200, Mauro Carvalho Chehab wrote:
> >> Em 12-05-2011 03:10, Mauro Carvalho Chehab escreveu:
> >>> Em 12-05-2011 02:37, Anssi Hannula escreveu:
> >>
> >>>> I don't see any other places:
> >>>> $ git grep 'REP_PERIOD' .
> >>>> dvb/dvb-usb/dvb-usb-remote.c:   input_dev->rep[REP_PERIOD] =
> >>>> d->props.rc.legacy.rc_interval;
> >>>
> >>> Indeed, the REP_PERIOD is not adjusted on other drivers. I agree that we
> >>> should change it to something like 125ms, for example, as 33ms is too 
> >>> short, as it takes up to 114ms for a repeat event to arrive.
> >>>
> >> IMO, the enclosed patch should do a better job with repeat events, without
> >> needing to change rc-core/input/event logic.
> >>
> >> -
> >>
> >> Subject: Use a more consistent value for RC repeat period
> >> From: Mauro Carvalho Chehab <mchehab@redhat.com>
> >>
> >> The default REP_PERIOD is 33 ms. This doesn't make sense for IR's,
> >> as, in general, an IR repeat scancode is provided at every 110/115ms,
> >> depending on the RC protocol. So, increase its default, to do a
> >> better job avoiding ghost repeat events.
> >>
> >> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> >>
> >> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> >> index f53f9c6..ee67169 100644
> >> --- a/drivers/media/rc/rc-main.c
> >> +++ b/drivers/media/rc/rc-main.c
> >> @@ -1044,6 +1044,13 @@ int rc_register_device(struct rc_dev *dev)
> >>  	 */
> >>  	dev->input_dev->rep[REP_DELAY] = 500;
> >>  
> >> +	/*
> >> +	 * As a repeat event on protocols like RC-5 and NEC take as long as
> >> +	 * 110/114ms, using 33ms as a repeat period is not the right thing
> >> +	 * to do.
> >> +	 */
> >> +	dev->input_dev->rep[REP_PERIOD] = 125;
> >> +
> >>  	path = kobject_get_path(&dev->dev.kobj, GFP_KERNEL);
> >>  	printk(KERN_INFO "%s: %s as %s\n",
> >>  		dev_name(&dev->dev),
> > 
> > so if I get this right, a XkbSetControls(.. XkbRepeatKeysMask ...) by a
> > client to set the repeat rate would provide the same solution - for those
> > clients/devices affected. 
> 
> Yes, if we preserve the same logic. The above will probably still generate
> ghost repeats if the user keeps the IR pressed for a long time, as we're using
> a separate timer at the rc-core logic than the one used inside evdev.
> 
> > The interesting question is how clients would identify the devices that are
> > affected by this (other than trial and error).
> 
> That is easy. I've added a logic that detects it on Xorg evdev on some RFC patches
> I've prepared in the past to allow using a keycode with more than 247 for IR's.
> I'll work on a new version for it and submit again when I have some time.
> Anyway, I'm enclosing a patch with the old version. 

Note that "clients" refers to X clients, i.e. applications. While it's
usually trivial to add new functionality to evdev or other drivers, exposing
information to the actual client requires some protocol extension or
additions to existing extensions. While we have mechanisms in place for
devices to be labelled, we don't have anyone to actually read this
information (or even some standard on how to apply the labels).

>From the implementation-side, we not only need to flag the devices in the
driver (like you've outlined in the patch below), we then need to get this
information into the X server so that the server doesn't repeat. XKB has a
per-key-repeat flag which we may be able to use but we need to also override
client-side key repeat setting (for this device only). XKB doesn't allow for
a repeat rate change request to fail, so we have to essentially tell client
they have succeeded in setting their repeat rate while using a completely
different one.
Technically, you can override the repeat setting requested by the client
if you simply send out an event when you change it back to the hardware
setting. This then looks like some other client has changed it but the
danger is that it may send stubborn clients into an infinite loop.

How much that really matters I don't know.

Letting clients know which device is an RC control at least means that the
overriding should be expected, but that brings us back to the labelling
issue.

But either way, to even get this to the "override" stage you need three
patches:
- evdev: recognise and flag the devices
- X server: introduce an API to pass this information on to the server
- X server: fixes to the XKB system to disable autorepeat for devices
  flagged accordingly and override requests to change the repeat rate.

Cheers,
  Peter

