Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.uni-paderborn.de ([131.234.142.9]:44527 "EHLO
	mail.uni-paderborn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbbFDO4w (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Jun 2015 10:56:52 -0400
MIME-Version: 1.0
In-Reply-To: <5806279.gupgOqozEz@avalon>
References: <CALcgO_6mcTpEORqWMVzPONYHZH-h8bBMDMddkKxSyrc7F3-oiQ@mail.gmail.com>
	<20150602161224.GG16478@atomide.com>
	<5806279.gupgOqozEz@avalon>
Date: Thu, 4 Jun 2015 16:56:47 +0200
Message-ID: <CALcgO_7uZae-PE4QjZsfVKW59bhme3vjjfYfu5GJPVsJD61J7Q@mail.gmail.com>
Subject: Re: [RFC] v4l: omap4iss: DT bindings development
From: Michael Allwright <michael.allwright@upb.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-media@vger.kernel.org,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Arnd Bergmann <arnd@arndb.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Tero Kristo <t-kristo@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thank you for the replies. Laurent I have started using the platform
data to see if I can determine whether I have a software problem or a
hardware problem. One thing that is confusing me, is how are memory
resources are supposed to be properly mapped to a kernel module in a
DT enabled kernel using the hwmod abstraction layer.

It seems that the omap4iss driver in the mainline is expecting
resources to be declared in the format that was changed around about
this commit: https://www.gitorious.org/omap4-v4l2-camera/omap4-v4l2-camera/commit/8304f13d002dfaf618473a551dbbc35cfcdc2742

In the driver in the mainline, these resources are acquired in the
probe function by this loop here from iss.c:1397
for (i = 1; i < OMAP4_ISS_MEM_LAST; i++) { ret =
iss_map_mem_resource(pdev, iss, i); if (ret) goto error_iss; }

However the definitions of these registers have completely disappeared
in the mainline, nor are they in the master branches of linux-media or
linux-omap (see arch/arm/mach-omap2/devices.c / h). Interesting enough
the definitions for the OMAP3 ISP are still there. Furthermore looking
at the omap_hwmod_44xx_data.c in these branches I can see the hwmod
layer is only declaring the first 0xff bytes of address space starting
at 0x52000000, this obviously doesn't include the CSIA/B registers nor
the CAMERARX registers which are all at addresses >0x520000ff.

TLDR: omap4iss seems somewhat broken in the mainline (3.17),
linux-media (master) and linux-omap (master), which repo/branch are
you using for testing? Or what happened to the omap4_iss_resources
array?

All the best,

Michael Allwright

PhD Student
Paderborn Institute for Advanced Studies in Computer Science and Engineering

University of Paderborn
Office-number 02-47
Zukunftsmeile 1
33102 Paderborn
Germany


On 2 June 2015 at 18:22, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> On Tuesday 02 June 2015 09:12:25 Tony Lindgren wrote:
>> * Michael Allwright <michael.allwright@upb.de> [150602 01:41]:
>> > Hi Everyone,
>> >
>> > I'm working on the DT bindings for the OMAP4 ISS at the moment, but I
>> > am unable to capture any data in my test setup. As detailed below, it
>> > seems that everything has been configured correctly however I never
>> > get any interrupts from the ISS unless I do something drastic like
>> > removing one of the wires from the clock differential pair which
>> > results in constant complex IO error interrupts from CSIA until I
>> > restore the physical connection.
>> >
>> > My test setup includes a OV6540 sensor camera module (MIPI) from
>> > Lepoard Imaging, an Duovero COM from Gumstix and breakout boards
>> > forming an interconnect between the two. The sensor is connected to
>> > CSI21 on the OMAP4 using a clock lane (on position 1, default
>> > polarity) and a single data lane (on position 2, default polarity),
>> > the sensor input clock XVCLK uses the OMAP4 auxclk1_ck channel (rounds
>> > to 19.2MHz when asked for 24MHz).
>> >
>> > The relevant parts of my device tree can be seen here:
>> > https://gist.github.com/allsey87/fdf1feb6eb6a94158638 - I'm actually
>> > somewhat unclear what effect stating the ti,hwmod="iss" parameter has.
>> > Does anything else need to be done here? As far as I can tell I think
>> > all clocks and power has been switched on. I do make two function
>> > calls to the PM API in the ISS probe function, i.e.:
>> >
>> > pm_runtime_enable(&pdev->dev);
>> > r = pm_runtime_get_sync(&pdev->dev);
>>
>> The ti,hwmod = "iss" hooks up the device with the PM runtime, see
>> omap_hwmod_44xx_data.c for "iss".
>>
>> > Regarding my debugging, this is what I have checked so far
>> >
>> > * Changing the pixel rate of the sensor - this lead me to discover a
>> > possible bug in iss.c or perhaps my ov5640 driver, as the
>> > V4L2_CID_PIXEL_RATE control was always returning zero. I patched this
>> > by copying what Laurent has done in the OMAP3ISP driver which now
>> > works.
>> > * As I only have a 100MHz scope, I had to slow down the camera
>> > significantly (MIPI clock => 10-12MHz range) to verify that I was
>> > getting reasonable output from the sensor (i.e. signals that were
>> > characteristic of CSI2/MIPI). I checked the calculations and made sure
>> > these updated values came across via the V4L2_CID_PIXEL_RATE control
>> > and ended up in the THS_TERM and THS_SETTLE fields of register 0.
>> > * Using the omapconf tool, I have manually and one by one pulled up
>> > the CSI2 pins and verified multiple times all connections to the
>> > sensor module and have even manually tried swapping the DP/DN pairs in
>> > case they were still somehow backwards despite previous testing
>> > * Verified that the interrupt service routine is called by generating
>> > a test interrupt HS_VS from inside the ISS i.e.
>> >
>> > ./omapconf write ISS_HL_IRQENABLE_SET_5 0x00020000
>> > ./omapconf write ISS_HL_IRQSTATUS_RAW_5 0x00020000
>> >
>> > * Verified that the default CMA region is being used, it ends up in
>> > the ping-pong resisters of the ISS.
>> >
>> > Additional information:
>> >
>> > * Initialisation of pipe line and stream commands:
>> >
>> > media-ctl -r -l '"OMAP4 ISS CSI2a":1 -> "OMAP4 ISS CSI2a output":0 [1]'
>> > media-ctl -V '"ov5640 2-003c":0 [UYVY 640x480]','"OMAP4 ISS CSI2a":0
>> > [UYVY 640x480]'
>> > yavta /dev/video0 -c4 -n1 -s640x480 -fUYVY -Fov5640-640x480-#.uyvy
>> >
>> > * Output from OMAPCONF tool is in the second part of:
>> > https://gist.github.com/allsey87/fdf1feb6eb6a94158638
>> >
>> > Anyway, at this point, I'm almost completely out of ideas on how to
>> > move forwards so any suggestions, criticisms or help of any nature
>> > would be appreciated!
>>
>> Usually it's pinmuxing or some regulator or clock not enabled. Or
>> incorrect hwmod sysc and syss configuration for iss that prevents
>> enabling it properly.
>
> And have you tried the same setup with platform data ?
>
> --
> Regards,
>
> Laurent Pinchart
>
