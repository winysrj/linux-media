Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51459 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab1HPI5t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2011 04:57:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PATCHES FOR 3.1] s5p-fimc and noon010pc30 driver updates
Date: Tue, 16 Aug 2011 10:57:57 +0200
Cc: Sylwester Nawrocki <snjw23@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Sakari Ailus <sakari.ailus@iki.fi>
References: <4E303E5B.9050701@samsung.com> <201108151430.42722.laurent.pinchart@ideasonboard.com> <4E49B60C.4060506@redhat.com>
In-Reply-To: <4E49B60C.4060506@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201108161057.57875.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Tuesday 16 August 2011 02:13:00 Mauro Carvalho Chehab wrote:
> Em 15-08-2011 09:30, Laurent Pinchart escreveu:
> > On Tuesday 09 August 2011 22:05:47 Mauro Carvalho Chehab wrote:
> >> Em 29-07-2011 05:36, Laurent Pinchart escreveu:
> >>> On Friday 29 July 2011 06:02:54 Mauro Carvalho Chehab wrote:
> >>>> Em 28-07-2011 19:57, Sylwester Nawrocki escreveu:
> >>>>> On 07/28/2011 03:20 PM, Mauro Carvalho Chehab wrote:
> >>>>>> Accumulating sub-dev controls at the video node is the right thing
> >>>>>> to do.
> >>>>>> 
> >>>>>> An MC-aware application will need to handle with that, but that
> >>>>>> doesn't sound to be hard. All such application would need to do is
> >>>>>> to first probe the subdev controls, and, when parsing the videodev
> >>>>>> controls, not register controls with duplicated ID's, or to mark
> >>>>>> them with some special attribute.
> >>>>> 
> >>>>> IMHO it's not a big issue in general. Still, both subdev and the host
> >>>>> device may support same control id. And then even though the control
> >>>>> ids are same on the subdev and the host they could mean physically
> >>>>> different controls (since when registering a subdev at the host
> >>>>> driver the host's controls take precedence and doubling subdev
> >>>>> controls are skipped).
> >>>> 
> >>>> True, but, except for specific usecases, the host control is enough.
> >>> 
> >>> Not for embedded devices. In many case the control won't even be
> >>> implemented by the host. If your system has two sensors connected to
> >>> the same host, they will both expose an exposure time control. Which
> >>> one do you configure through the video node ? The two sensors will
> >>> likely have different bounds for the same control, how do you report
> >>> that ?
> >> 
> >> If the device has two sensors that are mutually exclusive, they should
> >> be mapped as two different inputs. The showed control should be the one
> >> used by the currently active input.
> >> 
> >> If the sensors aren't mutually exclusive, then two different video nodes
> >> will be shown in userspace.
> > 
> > It's more complex than that. The OMAP3 ISP driver exposes 7 video nodes
> > regardless of the number of sensors. Sensors can be mutually exclusive or
> > not, depending on the board. S_INPUT has its use cases, but is less
> > useful on embedded hardware.
> 
> Sorry, but exposing a video node that can't be used doesn't make sense.

All those 7 video nodes can be used, depending on userspace's needs.

> >>> Those controls are also quite useless for generic V4L2 applications,
> >>> which will want auto-exposure anyway. This needs to be implemented in
> >>> userspace in libv4l.
> >> 
> >> Several webcams export exposure controls. Why shouldn't those controls
> >> be exposed to userspace anymore?
> >> 
> >> Ok, if the hardware won't support 3A algorithm, libv4l will implement
> >> it, eventually using an extra hardware-aware code to get the best
> >> performance for that specific device, but this doesn't mean that the
> >> user should always use it.
> >> 
> >> Btw, the 3A algorithm is one of the things I don't like on my cell
> >> phone: while it works most of the time, sometimes I want to disable it
> >> and manually adjust, as it produces dark images, when there's a very
> >> bright light somewhere on the image background. Manually adjusting the
> >> exposure time and aperture is something relevant for some users.
> > 
> > It is, but on embedded devices that usually requires the application to
> > be hardware-aware. Exposure time limits depend on blanking, which in
> > turn influences the frame rate along with the pixel clock (often
> > configurable as well). Programming those settings wrong can exceed the
> > ISP available bandwidth.
> > 
> > The world unfortunately stopped being simple some time ago :-)
> > 
> >>>>> Also there might be some preference at user space, at which stage of
> >>>>> the pipeline to apply some controls. This is where the subdev API
> >>>>> helps, and plain video node API does not.
> >>>> 
> >>>> Again, this is for specific usecases. On such cases, what is expected
> >>>> is that the more generic control will be exported via V4L2 API.
> >>>> 
> >>>>>>> Thus it's a bit hard to imagine that we could do something like
> >>>>>>> "optionally not to inherit controls" as the subdev/MC API is
> >>>>>>> optional.
> >>>>>>> 
> >>>>>>> :)
> >>>>>> 
> >>>>>> This was actually implemented. There are some cases at ivtv/cx18
> >>>>>> driver where both the bridge and a subdev provides the same control
> >>>>>> (audio volume, for example). The idea is to allow the bridge driver
> >>>>>> to touch at the subdev control without exposing it to userspace,
> >>>>>> since the desire was that the bridge driver itself would expose such
> >>>>>> control, using a logic that combines changing the subdev and the
> >>>>>> bridge registers for volume.
> >>>>> 
> >>>>> This seem like hard coding a policy in the driver;) Then there is no
> >>>>> way (it might not be worth the effort though) to play with volume
> >>>>> level at both devices, e.g. to obtain optimal S/N ratio.
> >>>> 
> >>>> In general, playing with just one control is enough. Andy had a
> >>>> different opinion when this issue were discussed, and he thinks that
> >>>> playing with both is better. At the end, this is a developers
> >>>> decision, depending on how much information (and bug reports) he had.
> >>> 
> >>> ivtv/cx18 is a completely different use case, where hardware
> >>> configurations are known, and experiments possible to find out which
> >>> control(s) to use and how. In this case you can't know in advance what
> >>> the sensor and host drivers will be used for.
> >> 
> >> Why not?
> > 
> > My point is that the ISP driver developer can't know in advance which
> > sensor will be used systems that don't exist yet.
> 
> As far as such hardware is projected, someone will know. It is a simple
> trivial patch to associate a new hardware with a hardware profile at the
> platform data.

Platform data must contain hardware descriptions only, not policies. This is 
even clearer now that ARM is moving away from board code to the Device Tree.

> Also, on most cases, probing a sensor is as trivial as reading a sensor
> ID during device probe. This applies, for example, for all Omnivision
> sensors.
> 
> We do things like that all the times for PC world, as nobody knows what
> webcam someone would plug on his PC.

Sorry, but that's not related. You simply can't decide in an embedded ISP 
driver how to deal with sensor controls, as the system will be used in a too 
wide variety of applications and hardware configurations. All controls need to 
be exposed, period.

> >> I never saw an embedded hardware that allows physically changing the
> >> sensor.
> > 
> > Beagleboard + pluggable sensor board.
> 
> Development systems like beagleboard, pandaboard, Exynos SMDK, etc, aren't
> embeeded hardware. They're development kits.

People create end-user products based on those kits. That make them first-
class embedded hardware like any other.

> I don't mind if, for those kits the developer that is playing with it has to
> pass a mode parameter and/or run some open harware-aware small application
> that makes the driver to select the sensor type he is using, but, if the
> hardware is, instead, a N9 or a Galaxy Tab (or whatever embedded hardware),
> the driver should expose just the sensors that exists on such hardware. It
> shouldn't be ever allowed to change it on userspace, using whatever API on
> those hardware.

Who talked about changing sensors from userspace on those systems ? Platform 
data (regardless of whether it comes from board code, device tree, or 
something else) will contain a hardware description, and the kernel will 
create the right devices and load the right drivers. The issue we're 
discussing is how to expose controls for those devices to userspace, and that 
needs to be done through subdev nodes.

> >>> Even if you did, fine image quality tuning requires accessing pretty
> >>> much all controls individually anyway.
> >> 
> >> The same is also true for non-embedded hardware. The only situation
> >> where V4L2 API is not enough is when there are two controls of the same
> >> type active. For example, 2 active volume controls, one at the audio
> >> demod, and another at the bridge. There may have some cases where you
> >> can do the same thing at the sensor or at a DSP block. This is where MC
> >> API gives an improvement, by allowing changing both, instead of just
> >> one of the controls.
> > 
> > To be precise it's the V4L2 subdev userspace API that allows that, not
> > the MC API.
> > 
> >>>>> This is a hack...sorry, just joking ;-) Seriously, I think the
> >>>>> situation with the userspace subdevs is a bit different. Because with
> >>>>> one API we directly expose some functionality for applications, with
> >>>>> other we code it in the kernel, to make the devices appear uniform at
> >>>>> user space.
> >>>> 
> >>>> Not sure if I understood you. V4L2 export drivers functionality to
> >>>> userspace in an uniform way. MC api is for special applications that
> >>>> might need to access some internal functions on embedded devices.
> >>>> 
> >>>> Of course, there are some cases where it doesn't make sense to export
> >>>> a subdev control via V4L2 API.
> >>>> 
> >>>>>>> Also, the sensor subdev can be configured in the video node driver
> >>>>>>> as well as through the subdev device node. Both APIs can do the
> >>>>>>> same thing but in order to let the subdev API work as expected the
> >>>>>>> video node driver must be forbidden to configure the subdev.
> >>>>>> 
> >>>>>> Why? For the sensor, a V4L2 API call will look just like a bridge
> >>>>>> driver call. The subdev will need a mutex anyway, as two MC
> >>>>>> applications may be opening it simultaneously. I can't see why it
> >>>>>> should forbid changing the control from the bridge driver call.
> >>>>> 
> >>>>> Please do not forget there might be more than one subdev to configure
> >>>>> and that the bridge itself is also a subdev (which exposes a scaler
> >>>>> interface, for instance). A situation pretty much like in Figure 4.4
> >>>>> [1] (after the scaler there is also a video node to configure, but we
> >>>>> may assume that pixel resolution at the scaler pad 1 is same as at
> >>>>> the video node). Assuming the format and crop configuration flow is
> >>>>> from sensor to host scaler direction, if we have tried to configure
> >>>>> _all_ subdevs when the last stage of the pipeline is configured
> >>>>> (i.e. video node) the whole scaler and crop/composition
> >>>>> configuration we have been destroyed at that time. And there is more
> >>>>> to configure than
> >>>>> VIDIOC_S_FMT can do.
> >>>> 
> >>>> Think from users perspective: all user wants is to see a video of a
> >>>> given resolution. S_FMT (and a few other VIDIOC_* calls) have
> >>>> everything that the user wants: the desired resolution, framerate and
> >>>> format.
> >>>> 
> >>>> Specialized applications indeed need more, in order to get the best
> >>>> images for certain types of usages. So, MC is there.
> >>>> 
> >>>> Such applications will probably need to know exactly what's the
> >>>> sensor, what are their bugs, how it is connected, what are the DSP
> >>>> blocks in the patch, how the DSP algorithms are implemented, etc, in
> >>>> order to obtain the the perfect image.
> >>>> 
> >>>> Even on embedded devices like smartphones and tablets, I predict that
> >>>> both types of applications will be developed and used: people may use
> >>>> a generic application like flash player, and an specialized
> >>>> application provided by the manufacturer. Users can even develop
> >>>> their own applications generic apps using V4L2 directly, at the
> >>>> devices that allow that.
> >>>> 
> >>>> As I said before: both application types are welcome. We just need to
> >>>> warrant that a pure V4L application will work reasonably well.
> >>> 
> >>> That's why we have libv4l. The driver simply doesn't receive enough
> >>> information to configure the hardware correctly from the VIDIOC_*
> >>> calls. And as mentioned above, 3A algorithms, required by "simple"
> >>> V4L2 applications, need to be implemented in userspace anyway.
> >> 
> >> It is OK to improve users experience via libv4l. What I'm saying is that
> >> it is NOT OK to remove V4L2 API support from the driver, forcing users
> >> to use some hardware plugin at libv4l.
> > 
> > Let me be clear on this. I'm *NOT* advocating removing V4L2 API support
> > from any driver (well, on the drivers I can currently think of, if you
> > show me a wifi driver that implements a V4L2 interface I might change my
> > mind :-)).
> 
> This thread is all about a patch series partially removing V4L2 API
> support.

Because that specific part of the API doesn't make sense for this use case. 
You wouldn't object to removing S_INPUT support from a video output driver, as 
it wouldn't make sense either.

> > The V4L2 API has been designed mostly for desktop hardware. Thanks to its
> > clean design we can use it for embedded hardware, even though it requires
> > extensions. What we need to do is to define which parts of the whole API
> > apply as-is to embedded hardware, and which should better be left
> > unused.
> 
> Agreed. I'm all in favor on discussing this topic. However, before he have
> such iscussions and come into a common understanding, I won't take any
> patch removing V4L2 API support, nor I'll accept any driver that won't
> allow it to be usable by a V4L2 userspace application.

A pure V4L2 userspace application, knowing about video device nodes only, can 
still use the driver. Not all advanced features will be available.

> >>>>> Allowing the bridge driver to configure subdevs at all times would
> >>>>> prevent the subdev/MC API to work.
> >>>> 
> >>>> Well, then we need to think on an alternative for that. It seems an
> >>>> interesting theme for the media workshop at the Kernel Summit/2011.
> >>>> 
> >>>>>>> There is a conflict there that in order to use
> >>>>>>> 'optional' API the 'main' API behaviour must be affected....
> >>>>>> 
> >>>>>> It is optional from userspace perspective. A V4L2-only application
> >>>>>> should be able to work with all drivers. However, a MC-aware
> >>>>>> application will likely be specific for some hardware, as it will
> >>>>>> need to know some device-specific stuff.
> >>>>>> 
> >>>>>> Both kinds of applications are welcome, but dropping support for
> >>>>>> V4L2-only applications is the wrong thing to do.
> >>>>>> 
> >>>>>>> And I really cant use V4L2 API only as is because it's too limited.
> >>>>>> 
> >>>>>> Why?
> >>>>> 
> >>>>> For instance there is really yet no support for scaler and
> >>>>> composition onto a target buffer in the Video Capture Interface (we
> >>>>> also use sensors with built in scalers). It's difficult to
> >>>>> efficiently manage capture/preview pipelines. It is impossible to
> >>>>> discover the system topology.
> >>>> 
> >>>> Scaler were always supported by V4L2: if the resolution specified by
> >>>> S_FMT is not what the sensor provides, then scale. All non-embedded
> >>>> drivers with sensor or bridge supports scale does that.
> >>>> 
> >>>> Composition is not properly supported yet. It could make sense to add
> >>>> it to V4L. How do you think MC API would help with composite?
> >>>> 
> >>>> Managing capture/preview pipelines will require some support at V4L2
> >>>> level. This is a problem that needs to be addressed there anyway, as
> >>>> buffers for preview/capture need to be allocated. There's an RFC about
> >>>> that, but I don't think it covers the pipelines for it.
> >>> 
> >>> Managing pipelines is a policy decision, and needs to be implemented in
> >>> userspace. Once again, the solution here is libv4l.
> >> 
> >> If V4L2 API is not enough, implementing it on libv4l won't solve, as
> >> userspace apps will use V4L2 API for requresting it.
> > 
> > We need to let userspace configure the pipeline. That's what the MC +
> > V4L2 APIs are for. The driver must no make policy decisions though, that
> > must be left to userspace.
> 
> Showing only the hardware that is supported by an embedded device is not a
> policy decision. It is hardware detection or platform data configuration.

I don't think that's what we disagree on.

-- 
Regards,

Laurent Pinchart
