Return-path: <linux-media-owner@vger.kernel.org>
Received: from shell.v3.sk ([90.176.6.54]:51953 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729692AbeKFCue (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Nov 2018 21:50:34 -0500
Message-ID: <8fba7d230c028bafb5561595a06a30f94388e99c.camel@v3.sk>
Subject: Re: [PATCH] [media] ov7670: make "xclk" clock optional
From: Lubomir Rintel <lkundrak@v3.sk>
To: jacopo mondi <jacopo@jmondi.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Date: Mon, 05 Nov 2018 18:29:41 +0100
In-Reply-To: <20181105171504.GO20885@w540>
References: <20181004212903.364064-1-lkundrak@v3.sk>
         <20181105105841.GJ20885@w540>
         <272b2d009e056f36bfb08206772eb40bcdff00b0.camel@v3.sk>
         <20181105142252.GM20885@w540>
         <6fda4cc30820b415aa37e0a6487dfe66e561ec43.camel@v3.sk>
         <20181105171504.GO20885@w540>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2018-11-05 at 18:15 +0100, jacopo mondi wrote:
> Hi Lubo,
> 
> On Mon, Nov 05, 2018 at 04:22:15PM +0100, Lubomir Rintel wrote:
> > On Mon, 2018-11-05 at 15:22 +0100, jacopo mondi wrote:
> > > Hi Lubo,
> > > 
> > > On Mon, Nov 05, 2018 at 02:12:18PM +0100, Lubomir Rintel wrote:
> > > > Hello,
> > > > 
> > > > On Mon, 2018-11-05 at 11:58 +0100, jacopo mondi wrote:
> > > > > Hi Lubomir,
> > > > >    +Sakari in Cc
> > > > > 
> > > > > I just noticed this, and the patch is now in v4.20, but let me comment
> > > > > anyway on this.
> > > > > 
> > > > > On Thu, Oct 04, 2018 at 11:29:03PM +0200, Lubomir Rintel wrote:
> > > > > > When the "xclk" clock was added, it was made mandatory. This broke the
> > > > > > driver on an OLPC plaform which doesn't know such clock. Make it
> > > > > > optional.
> > > > > > 
> > > > > 
> > > > > I don't think this is correct. The sensor needs a clock to work.
> > > > > 
> > > > > With this patch clock_speed which is used to calculate
> > > > > the framerate is defaulted to 30MHz, crippling all the calculations if
> > > > > that default value doesn't match what is actually installed on the
> > > > > board.
> > > > 
> > > > How come? I kept this:
> > > > 
> > > > +             info->clock_speed = clk_get_rate(info->clk) / 1000000;
> > > 
> > > Yes, but only if
> > > if (info->clk) { }
> > > 
> > > if (!info->clk) the 'clock_speed' variable is defaulted to 30 at the
> > > beginning of the probe routine. Am I missing something obvious here?
> > 
> > Maybe. Or I am.
> > 
> > I thought you care about the situation where you *have* the clk, and
> > thus you shouldn't be caring about the defaults?
> > 
> 
> I care about the fact that with this version, the clock speed might be
> default to a totally random value making the driver malfunctioning. My
> specific use case doesn't matter.
> 
> > > > > If this patch breaks the OLPC, then might it be the DTS for said
> > > > > device needs to be fixed instead of working around the issue here?
> > > > 
> > > > No. Device tree is an ABI, and you can't just add mandatory properties.
> > > > 
> > > 
> > > Well, as I read the ov7670 bindings documentation:
> > > 
> > > Required Properties:
> > > - compatible: should be "ovti,ov7670"
> > > - clocks: reference to the xclk input clock.
> > > - clock-names: should be "xclk".
> > > 
> > > It was mandatory already since the bindings have been first created:
> > > bba582894a ("[media] ov7670: document device tree bindings")
> > > 
> > > And yes, bindings establishes an ABI we have not to break or make
> > > incompatible with DTs created for an older version of the same binding,
> > > but the DTs itself is free to change and we need to do so to update
> > > it when required (to fix bugs, add new components, enable/disable them
> > > etc).
> > 
> > Ah, right, you're correct. No DTS ABI breakage there. I guess it would
> > be fine to revert my patch if we provide the xclk on the OLPC instead.
> > 
> 
> Thanks I feel that would be the right thing to do.
> 
> > > > There's no DTS for OLPC XO-1 either; it's an OpenFirmware machine.
> > > > 
> > > 
> > > I thought OLPC was an ARM machine, that's why I mentioned DTS. Sorry
> > > about this.
> > 
> > Well, you're sort of right here. The XO-1.75 generation is ARM, the XO-
> > 1 is x86. They both use devicetree provided by the firmware. However,
> > they predate FDT (or the definitions of bindings that are used here for
> > tht matter) and the trees are unfortunately quite incomplete. The
> > sensor is not there.
> 
> Ouch. I see...
> 
> > > A quick read of the wikipedia page for "OpenFirmware" gives me back
> > > that it a standardized firmware interface:
> > > "Open Firmware allows the system to load platform-independent drivers
> > > directly from the PCI card, improving compatibility".
> > > 
> > > I know nothing on this, and that's not the point, so I'll better stop
> > > here and refrain to express how much the "loading platform-independent
> > > (BINARY) drivers from the PCI card" scares me :p
> > > 
> > > > You'd need to update all machines in the wild which is not realistic.
> > > 
> > > Machines which have received a kernel update which includes the patch
> > > that makes the clock for the sensor driver mandatory [1], will have their
> > > board files updated by the same kernel update, with the proper clock
> > > provider instantiated for that sensor.
> > > 
> > > That's what I would expect from a kernel update for those devices (or
> > > any device in general..)
> > > 
> > > If this didn't happen, blame OLPC kernel maintainers :p
> > > 
> > > [1] 0a024d634cee ("[media] ov7670: get xclk"); which went in v4.12
> > > 
> > > > Alternatively, something else than DT could provide the clock. If this
> > > > gets in, then the OLPC would work even without the xclk patch:
> > > > https://lore.kernel.org/lkml/20181105073054.24407-12-lkundrak@v3.sk/
> > > 
> > > That's what I meant, more or less.
> > > 
> > > If you don't have a DTS you have a board file, isn't it?
> > > ( arch/x86/platform/olpc/ maybe? )
> > 
> > The device tree on XO-1 is not constructed from a FDT, it's gotten from
> > the OpenFirmware. See arch/x86/platform/olpc/olpc_dt.c
> > 
> 
> Ouch^2
> 
> > But as I said -- it's hopelessly incomplete and is not going to be of
> > much help here. If you're curious, I've recently uploaded /proc/device-
> > tree dumps here, since someone else asked:
> > 
> > https://people.freedesktop.org/~lkundrak/olpc/
> > 
> > > The patch you linked here makes the video interface (the marvel-ccic
> > > one) provide the clock source for the sensor:
> > > 
> > > +	clkdev_create(mcam->mclk, "xclk", "%d-%04x",
> > > +		i2c_adapter_id(cam->i2c_adapter), ov7670_info.addr);
> > > +
> > > 
> > > While I would expect the board file to do that, as that's where all
> > > pieces gets put together, and it knows which clock source has to be
> > > fed to the sensor depending on your hardware design. As I don't know
> > > much of x86 or openfirmare, feel free to explain me why it is not
> > > possible ;)
> > 
> > Well, maybe. I don't think so. The clock is provided by the Cafe chip
> > (the bridge chip, also has i2c controller for the sensor control) that
> > sits on a PCI, which is discoverable. In theory there could be more of
> > them.
> > 
> > The driver is oddly structured for historic reasons. I'm mainly
> > interested in not breaking it more than it is. A good devicetree would
> > help, but we don't have the luxury.
> > 
> 
> I see. If the cci camera interface should be providing the clock in
> this setup, and it is not possible to get it from anywhere else, I
> would say let's go for that, even if it's a bit of a shortcut.
> 
> > > Anyway, my whole point is that the sensor needs a clock to work. With
> > > your patch if it is not provided it gets defaulted (if I'm not
> > > mis-reading the code) to a value that would break frame interval
> > > calculations. This is what concerns me and I would prefer the driver
> > > to fail probing quite nosily to make sure all its users (dts, board
> > > files etc) gets updated.
> > 
> > I still don't get this. It defaults to 30 Hz* as it used to before the
> > patch that introduced mandatory xclk, which seems perfectly reasonable.
> > Which configurations break?
> 
> I don't have anything that breaks, as my platforms provides a clock
> source to the driver. I'm just against changing the driver to
> workaround a platform issue, opening possibilities for future
> breakages and going against what the DT bindings describes as
> mandatory.
> 
> > * you said MHz before, I suppose that was a mistake?
> 
> I see a "clk_get_rate() / 10^6", so it's defintely 30MHz (the sensor
> supports input clock rates in the [10-48]MHz range. All image sensor
> I know of work with frequencies in the 10^6Hz order of magnitude.
> 
> > > > (I just got a kbuild failure message, so I'll surely be following up
> > > > with a v2.)
> > > > 
> > > > > Also, the DT bindings should be updated too if we decide this property
> > > > > can be omitted. At this point, with a follow-up patch.
> > > > 
> > > > Yes.
> > > > 
> > > This would actually be an ABI change (one that would not break
> > > retro-compatibility probably, but still...)
> > 
> > That, I think, is an okay thing to do.
> > 
> 
> It would be ok, but I think dropping a mandatory property to allow
> broken platform to continue stay broken is a bad idea.
> 
> I understand it might be a pain to fix for you, given the DT-loaded-from-PCI
> non-sense, but looking at your mentioned olpc_dt.c file, that DTS
> could be patched at run-time; but I understand having the cci
> providing the clock might be for sure easier.
> 
> What's your idea, do you still feel like this should be worked around
> in the driver?

Well, sort of.

The issue I was initially solving was that the original xclk patch
broke a platform that used to work. That is a regression and thus a
complete no-go regardless of how optimal the original solution was. In
such case reverting to the previous behavior is certainly an option.

Once there's a better solution (and that might be my marvel-ccic patch)
I, of course, have no objection to reverting the patch you find
objectionable and would be very happy to Ack it if needed.

Thank you,
Lubo
