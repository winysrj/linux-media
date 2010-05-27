Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46674 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758144Ab0E0Tzj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 May 2010 15:55:39 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1005270809110.2293@axis700.grange>
References: <Pine.LNX.4.64.1005261559390.22516@axis700.grange>
	<AANLkTilnb20a4KO1NmK_y148HE_4b6ka14hUJY5o93QT@mail.gmail.com>
	<Pine.LNX.4.64.1005270809110.2293@axis700.grange>
Date: Thu, 27 May 2010 15:55:35 -0400
Message-ID: <AANLkTin_ia3Ym3z7FOu40voZkjCeMqSDZjuE_1aBjwOW@mail.gmail.com>
Subject: Re: Idea of a v4l -> fb interface driver
From: Alex Deucher <alexdeucher@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>, linux-fbdev@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 27, 2010 at 2:56 AM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> (adding V4L ML to CC and preserving the complete reply for V4L readers)
>
> On Thu, 27 May 2010, Jaya Kumar wrote:
>
>> On Wed, May 26, 2010 at 10:09 PM, Guennadi Liakhovetski
>> <g.liakhovetski@gmx.de> wrote:
>> > Problem: Currently the standard way to provide graphical output on various
>> > (embedded) displays like LCDs is to use a framebuffer driver. The
>> > interface is well supported and widely adopted in the user-space, many
>> > applications, including the X-server, various libraries like directfb,
>> > gstreamer, mplayer, etc. In the kernel space, however, the subsystem has a
>> > number of problems. It is unmaintained. The infrastructure is not being
>> > further developed, every specific hardware driver is being supported by
>> > the respective architecture community. But as video output hardware
>>
>> I understand the issue you are raising, but to be clear there are
>> several developers, Geert, Krzysztof, and others who are helping with
>> the role of fbdev maintainer while Tony is away. If you meant that it
>> has no specific currently active maintainer person, when you wrote
>> "unmaintained", then I agree that is correct.
>
> Exactly, I just interpreted this excerpt from MAINTAINERS:
>
> FRAMEBUFFER LAYER
> L:      linux-fbdev@vger.kernel.org
> W:      http://linux-fbdev.sourceforge.net/
> S:      Orphan
>
>> We're not sure where
>> Tony is and we hope he's okay and that he'll be back soon. But if you
>> meant that it is not maintained as in bugs aren't being fixed, then
>> I'd have to slightly disagree. Maybe not as fast as commercial
>> organizations seem to think should come for free, but still they are
>> being worked on.
>>
>> > evolves, more complex displays and buses appear and have to be supported,
>> > the subsystem shows its aging. For example, there is currently no way to
>> > write reusable across multiple platforms display drivers.
>>
>> At first I misread your point as talking about multi-headed displays
>> which you're correct is not so great in fbdev. But "write reusable
>> across multi-platform display driver", I did not understand fully. I
>> maintain a fbdev driver, broadsheetfb, that we're using on arm and x86
>> without problems and my presumption is other fbdev drivers are also
>> capable of this unless the author made it explicitly platform
>> specific.
>
> Ok, let me explain what exactly I meant. Above I referred to "display
> drivers," which is not the same as a "framebuffer controller driver" or
> whatever you would call it. By framebuffer controller driver I mean a
> driver for the actual graphics engine on a certain graphics card or an
> SoC. This is the part, that reads data from the actual framebuffer and
> outputs it to some hardware interface to a display device. Now this
> interface can be a VGA or a DVI connector, it can be one of several bus
> types, used with various LCD displays. In many cases this is all you have
> to do to get the output to your display. But in some cases the actual
> display on the other side of this bus also requires a driver. That can be
> some kind of a smart display, it can be a panel with an attached display
> controller, that must be at least configured, say, over SPI, it can be a
> display, attached to the host over the MIPI DSI bus, and implementing some
> proprietary commands. In each of these cases you will have to write a
> display driver for this specific display or controller type, and your
> framebuffer driver will have to interface with that display driver. Now,
> obviously, those displays can be connected to a variety of host systems,
> in which case you will want to reuse that display driver. This means,
> there has to be a standard fb-driver - display-driver API. AFAICS, this is
> currently not implemented in fbdev, please, correct me if I am wrong.


Another API to consider in the drm kms (kernel modesetting) interface.
 The kms API deals properly with advanced display hardware and
properly handles crtcs, encoders, and connectors.  It also provides
fbdev api emulation.

Alex


>
>> In my experience with adding defio to the fbdev infra, the
>> fbdev community seemed quite good and I did not notice any aging
>> problems. I realize there's probably issues that you're encountering
>> where fbdev might be weak, this is good, and if you raise them
>> specifically, I think the community can work together to address the
>> issues.
>>
>> >
>> > OTOH V4L2 has a standard video output driver support, it is not very
>> > widely used, in the userspace I know only of gstreamer, that somehow
>> > supports video-output v4l2 devices in latest versions. But, being a part
>> > of the v4l2 subsystem, these drivers already now can take a full advantage
>> > of all v4l2 APIs, including the v4l2-subdev API for the driver reuse.
>> >
>> > So, how can we help graphics driver developers on the one hand by
>> > providing them with a capable driver framework (v4l2) and on the other
>> > hand by simplifying the task of interfacing to the user-space?
>>
>> I think it would help if there were more specific elaborations on the
>> functionality that you'd want the fbdev community to improve and how
>> it could reuse v4l2 for this.
>
> Since some time the V4L2 kernel driver API includes a v4l2-subdev API,
> which is used to interface between drivers for various single components.
> Typical examples are USB camera bridges and camera sensors in webcams,
> TV-decoders and PCI framegrabber controllers, any of the above video
> signal sources (sensors or decoders) and a camera interface controller on
> a SoC. In all of the above cases the v4l2-subdev API is used, which allows
> you to use the same video sensor driver in a webcam configuration or with
> an SoC.
>
>> > How about a v4l2-output - fbdev translation layer? You write a v4l2-output
>> > driver and get a framebuffer device free of charge... TBH, I haven't given
>> > this too much of a thought, but so far I don't see anything that would
>> > make this impossible in principle. The video buffer management is quite
>> > different between the two systems, but maybe we can teach video-output
>> > drivers to work with just one buffer too? Anyway, feel free to tell me why
>> > this is an absolutely impossible / impractical idea;)
>>
>> Sounds interesting. I think that idea seems viable but I'm not sure
>> we'd want every usb webcam to register an fbdev interface if that is
>> part of the thoughts you're having. If you could elaborate on the
>> benefits, that'd be great.
>
> No, sorry, webcam is a video-input (capture) device, whereas I am talking
> about video output devices like TV encoders. My example is the sh-mobile
> Video Output Unit (VOU) driver, that I've written recently. For it first
> of all we had to decide which subsystem to select - V4L2 output or fbdev.
> On the one hand, if we used fbdev, using the driver would be dead simple -
> just put a console on it, or the X-server or any other user-space
> software, capable of talking to an fbdev. OTOH we would have to come up
> with some (proprietary) API to interface to tv-encoders. So, we chose to
> use v4l2, which gave us a standard API, but the only user-space solution
> we found to interface to v4l2 output drivers was gstreamer, which also
> just recently acquired this capability and is not yet very well developed
> in that respect. That's why we thought about a v4l2-output - fbdev
> interface driver.
>
>> Thanks,
>> jaya
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
