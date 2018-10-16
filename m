Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:39466 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbeJPU7K (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 Oct 2018 16:59:10 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Vladimir Zapolskiy <vz@mleia.com>
Cc: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
        kieran.bingham@ideasonboard.com, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] mfd: ds90ux9xx: add TI DS90Ux9xx de-/serializer MFD driver
Date: Tue, 16 Oct 2018 16:08:49 +0300
Message-ID: <2613241.lUsdUIHyZO@avalon>
In-Reply-To: <735126c6-9780-a9ef-4fd0-699d6876ed37@mleia.com>
References: <20181008211205.2900-1-vz@mleia.com> <3599186.afdMBtdL0k@avalon> <735126c6-9780-a9ef-4fd0-699d6876ed37@mleia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vladimir,

On Friday, 12 October 2018 16:59:27 EEST Vladimir Zapolskiy wrote:
> On 10/12/2018 04:01 PM, Laurent Pinchart wrote:
> > On Friday, 12 October 2018 14:47:52 EEST Kieran Bingham wrote:
> >> On 12/10/18 11:58, Vladimir Zapolskiy wrote:
> >>> On 10/12/2018 12:20 PM, Kieran Bingham wrote:
> >>>> On 12/10/18 09:39, Lee Jones wrote:
> >>>>> On Fri, 12 Oct 2018, Vladimir Zapolskiy wrote:
> >>>>>> On 10/12/2018 09:03 AM, Lee Jones wrote:
> >>>>>>> On Tue, 09 Oct 2018, Vladimir Zapolskiy wrote:
> >>>>>>>> From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
> >>>>>>>> 
> >>>>>>>> The change adds I2C device driver for TI DS90Ux9xx de-/serializers,
> >>>>>>>> support of subdevice controllers is done in separate drivers,
> >>>>>>>> because not all IC functionality may be needed in particular
> >>>>>>>> situations, and this can be fine grained controlled in device tree.
> >>>>>>>> 
> >>>>>>>> The development of the driver was a collaborative work, the
> >>>>>>>> contribution done by Balasubramani Vivekanandan includes:
> >>>>>>>> * original implementation of the driver based on a reference
> >>>>>>>> driver,
> >>>>>>>> * regmap powered interrupt controller support on serializers,
> >>>>>>>> * support of implicitly or improperly specified in device tree ICs,
> >>>>>>>> * support of device properties and attributes: backward compatible
> >>>>>>>>   mode, low frequency operation mode, spread spectrum clock
> >>>>>>>>   generator.
> >>>>>>>> 
> >>>>>>>> Contribution by Steve Longerbeam:
> >>>>>>>> * added ds90ux9xx_read_indirect() function,
> >>>>>>>> * moved number of links property and added
> >>>>>>>> ds90ux9xx_num_fpd_links(),
> >>>>>>>> * moved and updated ds90ux9xx_get_link_status() function to core
> >>>>>>>> driver,
> >>>>>>>> * added fpd_link_show device attribute.
> >>>>>>>> 
> >>>>>>>> Sandeep Jain added support of pixel clock edge configuration.
> >>>>>>>> 
> >>>>>>>> Signed-off-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
> >>>>>>>> ---
> >>>>>>>> 
> >>>>>>>>  drivers/mfd/Kconfig           |  14 +
> >>>>>>>>  drivers/mfd/Makefile          |   1 +
> >>>>>>>>  drivers/mfd/ds90ux9xx-core.c  | 879
> >>>>>>>>  ++++++++++++++++++++++++++++++++
> >>>>>>>>  include/linux/mfd/ds90ux9xx.h |  42 ++
> >>>>>>>>  4 files changed, 936 insertions(+)
> >>>>>>>>  create mode 100644 drivers/mfd/ds90ux9xx-core.c
> >>>>>>>>  create mode 100644 include/linux/mfd/ds90ux9xx.h
> >>>>>>>> 
> >>>>>>>> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> >>>>>>>> index 8c5dfdce4326..a969fa123f64 100644
> >>>>>>>> --- a/drivers/mfd/Kconfig
> >>>>>>>> +++ b/drivers/mfd/Kconfig
> >>>>>>>> @@ -1280,6 +1280,20 @@ config MFD_DM355EVM_MSP
> >>>>>>>> 
> >>>>>>>>  	  boards.  MSP430 firmware manages resets and power sequencing,
> >>>>>>>>  	  inputs from buttons and the IR remote, LEDs, an RTC, and more.
> >>>>>>>> 
> >>>>>>>> +config MFD_DS90UX9XX
> >>>>>>>> +	tristate "TI DS90Ux9xx FPD-Link de-/serializer driver"
> >>>>>>>> +	depends on I2C && OF
> >>>>>>>> +	select MFD_CORE
> >>>>>>>> +	select REGMAP_I2C
> >>>>>>>> +	help
> >>>>>>>> +	  Say yes here to enable support for TI DS90UX9XX de-/serializer
> >>>>>>>> ICs.
> >>>>>>>> +
> >>>>>>>> +	  This driver provides basic support for setting up the
> >>>>>>>> de-/serializer
> >>>>>>>> +	  chips. Additional functionalities like connection handling to
> >>>>>>>> +	  remote de-/serializers, I2C bridging, pin multiplexing, GPIO
> >>>>>>>> +	  controller and so on are provided by separate drivers and
> >>>>>>>> should
> >>>>>>>> +	  enabled individually.
> >>>>>>> 
> >>>>>>> This is not an MFD driver.
> >>>>>> 
> >>>>>> Why do you think so? The representation of the ICs into device tree
> >>>>>> format of hardware description shows that this is a truly MFD driver
> >>>>>> with multiple IP subcomponents naturally mapped into MFD cells.
> >>>>> 
> >>>>> This driver does too much real work ('stuff') to be an MFD driver.
> >>>>> MFD drivers should not need to care of; links, gates, modes, pixels,
> >>>>> frequencies maps or properties.  Nor should they contain elaborate
> >>>>> sysfs structures to control the aforementioned 'stuff'.
> >>>>> 
> >>>>> Granted, there may be some code in there which could be appropriate
> >>>>> for an MFD driver.  However most of it needs moving out into a
> >>>>> function driver (or two).
> >>>>> 
> >>>>>> Basically it is possible to replace explicit of_platform_populate()
> >>>>>> by adding a "simple-mfd" compatible, if it is desired.
> >>>>>> 
> >>>>>>> After a 30 second Google of what this device actually does, perhaps
> >>>>>>> drivers/media might be a better fit?
> >>>>>> 
> >>>>>> I assume it would be quite unusual to add a driver with NO media
> >>>>>> functions and controls into drivers/media.
> >>>>> 
> >>>>> drivers/media may very well not be the correct place for this.  In my
> >>>>> 30 second Google, I saw that this device has a lot to do with cameras,
> >>>>> hence my media association.
> >>>>> 
> >>>>> If *all* else fails, there is always drivers/misc, but this should be
> >>>>> avoided if at all possible.
> >>>> 
> >>>> The device as a whole is FPD Link for camera devices I believe, but it
> >>> 
> >>> I still don't understand (I could be biased though) why there is such
> >>> a strong emphasis on cameras and media stuff in the discussion.
> >>> 
> >>> No, "the device as a whole is FPD Link for camera devices" is a wrong
> >>> statement. On hand I have a number of boards with
> >>> serializers/deserializers from the TI DS90Ux9xx IC series and sensors
> >>> are NOT connected to them.
> > 
> > I understand what is not connected to them, but could you tell us what is
> > connected then ? :-)
> 
> You got it right, the most two common ways of using the ICs:
> 
> 1) SoC -> serializer ("local") -> deserializer ("remote") -> panel,
> 2) sensor -> serializer ("remote") -> deserializer ("local") -> SoC.
> 
> The point is that the published drivers naturally support both data chains
> and even more of them, e.g. transferring audio data only or just setting
> GPIO line signals on a "remote" PCB.

At the cost of code being added where it doesn't belong (as pointed out by 
Lee) and DT bindings not following the standard models (data connections 
described by OF graph and control buses described by parent-child 
relationships). Let's focus on fixing the DT bindings first, and we'll then 
see how we can handle the driver side.

> >> Yes - My apologies, this is a good point.
> >> 
> >> Especially as the clue is in the name "Flat Panel Display".
> >> I have been stuck with my GMSL hat on for too long.
> >> 
> >> Even GMSL is in the same boat. It's just that 'we' are using GMSL for
> >> cameras, but it can be used equally for displays and data.
> >> 
> >> These devices are serialiser-deserialiser pairs with power and control
> >> paths.
> > 
> > And data paths, that are designed to transport video (and audio in this
> > case). The devices are thus media-focussed, although in a broader sense
> > than drivers/ media/
> 
> The devices are media-focused only in the sense that media functionality
> casts a shadow onto inalienable GPIO or I2C bridging functionality.

Seriously, do you really expect that they will be used for the sole purpose of 
transporting a few GPIOs ?

> Anyway MFD driver representation of the ICs allows to keep pinmuxing, V4L2,
> DRM, audio bridging, interrupt controller and all other subcontroller
> functions separately, configure them separately, store under separate
> driver frameworks etc. That's a perfect flexibility on drivers level
> as I can see it.

The resulting complexity is still overkill. As mentioned above, let's focus on 
the DT bindings first.

> >> Essentially they are multi purpose buses - which do not yet have a home.
> >> We have used media as a home because of our use case.
> >> 
> >> The use case whether they transfer frames from a camera or to a display
> >> are of course closely related, but ultimately covered by two separate
> >> subsystems at the pixel level (DRM vs V4L, or other for other data)
> >> 
> >> Perhaps as they are buses - on a level with USB or I2C (except they can
> >> of course carry I2C or Serial as well as 'bi-directional video' etc ),
> >> they are looking for their own subsystem.
> >> 
> >> Except I don't think we don't want to add a new subsystem for just one
> >> (or two) devices...
> > 
> > I'm not sure a new subsystem is needed. As you've noted there's an overlap
> > between drivers/media/ and drivers/gpu/drm/ in terms of supported
> > hardware. We even have a devices supported by two drivers, one in
> > drivers/media/ and one in drivers/gpu/drm/ (I'm thinking about the
> > adv7511 in particular). This is a well known issue, and so far nothing
> > has been done in mainline to try and solve it.
> 
> Right, presumably this IC series would have *cell* drivers in both
> drivers/media and drivers/gpu/drm/ and other folders like drivers/pinctrl/
> or sound/.

Even with cell drivers you'll have the problem of DRM vs. V4L2. My advice is 
to go for DRM only for now.

> The interesting thing is that the published drivers do NOT require any new
> cell drivers (at least non-trivial ones with >200 LoC) in drivers/media/
> or drivers/gpu/drm/ to get the expected operation of DS90Ux925/926/927/928
> ICs (any ser-des connection combination), and we have a DS90Ux940 cell
> driver targeted to drivers/media/

That's because you abuse the rest of the APIs to cover up for what's lacking 
in media/ and gpu/drm/ :-)

> > Trying to find another home in drivers/mfd/ to escape from the problem
> > isn't a good solution in my opinion. The best option from a Linux point
> > of view would be to unify V4L2 and DRM/KMS when it comes to bridge
> > support, but that's a long way down the road (I won't complain if you
> > want to give it a go though :-)). As your use cases are display, focused,
> > I would propose to start with drivers/gpu/drm/bridge/, and leave the
> > problem of camera support for first person who will have such a use case.
> 
> Well, what should I do with pinctrl or audio bridging device drivers?

I'll defer the audio problems to people more knowledgeable about audio. For 
pinctrl I believe you're making it way more complicated than it should be. 
Again, DT bindings first, drivers second. And please provide DT examples for 
real use cases, I think that will be key to proper DT bindings design.

> Stick all drivers together into an unmaintainable clod of tangled code?

You know this isn't what I proposed, let's stay fair in this discussion. Your 
proposal is too complex in my opinion, I want to simplify it, which will 
result in easier to maintain code.

> Let's better exploit the excellent opportunity for code modularity given
> by the MFD framework.
> 
> >>>> certainly has different functions which are broken out in this
> >>>> implementation.
> >>> 
> >>> No, there is absolutely nothing broken out from the presented MFD
> >>> drivers, the drivers are completely integral and basically I don't
> >>> expect any.
> >>> 
> >>> If you are concerned about media functionality, the correspondent MFD
> >>> *cell* drivers will be added into drivers/media, drivers/gpu/drm or
> >>> whatever is to be a proper place.
> >>> 
> >>>> I think it might be quite awkward having the i2c components in
> >>>> drivers/i2c and the media components in drivers/media/i2c, so what
> >>>> about creating drivers/media/i2c/fpd-link (or such) as a container?
> >>> 
> >>> I open drivers/media/i2c/Kconfig and all entries with no exception are
> >>> under from 'if VIDEO_V4L2'. The MFD drivers do NOT require on depend on
> >>> VIDEO_V4L2 or any other multimedia frameworks, nor the MFD drivers
> >>> export any multimedia controls.
> >>> 
> >>>> Our GMSL implementation is also a complex camera(s) device - but does
> >>>> not yet use the MFD framework, perhaps that's something to add to my
> >>>> todo list.
> > 
> > Nope, please don't :-) The GMSL (de)serializers are no MFD devices either.
> > 
> >>> Okay, but the TI DS90Ux9xx is NOT a camera device, and it is NOT a
> >>> multimedia device, but it is a pure MFD device so the argument is not
> >>> applicable.
> > 
> > For the reasons pointed out in the review of other patches, and also
> > pointed out by Lee in his review of this patch, I disagree with that.
> > This isn't an MFD device.
> 
> Eh, it is an MFD device. Just probably drivers/mfd is really not the best
> place to store this particular MFD device driver...

We still disagree. Those chips are video serializers and deserializers with a 
few additional features to support those use cases. The fact that additional 
support features are available don't automatically make them a true MFD. To 
give you another example, my camera ISP that happens to be able to output a 
clock for the camera sensor is also not an MFD, and I can still support clock 
control through CCF without requiring the MFD framework.

> >>>> We currently keep all of the complexity within the max9286.c driver,
> >>>> but I could foresee that being split further if more devices add to the
> >>>> complexity of managing the bus. At which point we might want an
> >>>> equivalent drivers/media/i2c/gmsl/ perhaps?
> >>>> 
> >>>>>> Laurent, can you please share your opinion?
> > 
> > Done :-)
> > 
> > I'd like to mention that I would prefer focusing on the DT bindings first,
> > and
> 
> Sure, thank you for your comments :)
> 
> > then move to the driver side. In that area I would like to have a full
> > example of a system using these chips, as the "initial support" is too
> > limited for a proper review. This won't come as a surprise, but I will
> > expect the OF graph bindings to be used to model data connections.
> 
> The leverage of "the initial support" to "the complete support" requires:
> * audio bridge cell driver -- trivial, just one mute/unmute control,
> * interrupt controller cell driver -- trivial, but for sake of perfection
>   it requires some minimal changes in drivers/base/regmap/regmap-irq.c

This is a topic we haven't discussed yet, don't jump to conclusions and 
consider that an interrupt controller driver is needed. Could you please 
explain the use cases and point to the right documentation ?

> * DS90Ux940 MIPI CSI-2 -- non-trivial one, but we have it ready, I just
>   don't want to add it to the pile at the moment, otherwise we'll continue
>   discussing cameras, and I'd like to postpone it :)

I think it plays a crucial role in the architecture design. I don't want to 
reach an agreement on an architecture that wouldn't include CSI-2 support and 
then find out that it was the wrong path to add CSI-2 support.

> No more than that is needed to get absolutely complete support of 5 claimed
> DS90UB9xx ICs, really. 5 other DS90UH9xx will require HDCP support in
> addition.

I'm not too concern by HDCP, as long as you have a DRM bridge driver, it 
shouldn't be a big issue.

> I'll try to roll out an example of DTS snippet soon.

-- 
Regards,

Laurent Pinchart
