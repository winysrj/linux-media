Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:19422 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab1HJIlN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Aug 2011 04:41:13 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8
Received: from eu_spt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LPP00HAHESNFX50@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 10 Aug 2011 09:41:11 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LPP007ZJESMNK@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 10 Aug 2011 09:41:10 +0100 (BST)
Date: Wed, 10 Aug 2011 10:41:10 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [GIT PATCHES FOR 3.1] s5p-fimc and noon010pc30 driver updates
In-reply-to: <4E41CF28.9050406@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <snjw23@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	hverkuil@xs4all.nl
Message-id: <4E424426.6080303@samsung.com>
References: <4E303E5B.9050701@samsung.com> <4E31E960.1080008@gmail.com>
 <4E3230EE.7040602@redhat.com>
 <201107291036.44660.laurent.pinchart@ideasonboard.com>
 <4E41931B.5030901@redhat.com> <20110809231806.GA5926@valkosipuli.localdomain>
 <4E41CF28.9050406@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/10/2011 02:22 AM, Mauro Carvalho Chehab wrote:
> Em 09-08-2011 20:18, Sakari Ailus escreveu:
>> Hi Mauro,
>>
>> On Tue, Aug 09, 2011 at 05:05:47PM -0300, Mauro Carvalho Chehab wrote:
>>> Em 29-07-2011 05:36, Laurent Pinchart escreveu:
>>>> Hi Mauro,
>>>>
>>>> On Friday 29 July 2011 06:02:54 Mauro Carvalho Chehab wrote:
>>>>> Em 28-07-2011 19:57, Sylwester Nawrocki escreveu:
>>>>>> On 07/28/2011 03:20 PM, Mauro Carvalho Chehab wrote:
>>>>>>> Accumulating sub-dev controls at the video node is the right thing to
>>>>>>> do.
>>>>>>>
>>>>>>> An MC-aware application will need to handle with that, but that doesn't
>>>>>>> sound to be hard. All such application would need to do is to first
>>>>>>> probe the subdev controls, and, when parsing the videodev controls, not
>>>>>>> register controls with duplicated ID's, or to mark them with some
>>>>>>> special attribute.
>>>>>>
>>>>>> IMHO it's not a big issue in general. Still, both subdev and the host
>>>>>> device may support same control id. And then even though the control ids
>>>>>> are same on the subdev and the host they could mean physically different
>>>>>> controls (since when registering a subdev at the host driver the host's
>>>>>> controls take precedence and doubling subdev controls are skipped).
>>>>>
>>>>> True, but, except for specific usecases, the host control is enough.
>>>>
>>>> Not for embedded devices. In many case the control won't even be implemented 
>>>> by the host. If your system has two sensors connected to the same host, they 
>>>> will both expose an exposure time control. Which one do you configure through 
>>>> the video node ? The two sensors will likely have different bounds for the 
>>>> same control, how do you report that ?
>>>
>>> If the device has two sensors that are mutually exclusive, they should be
>>> mapped as two different inputs. The showed control should be the one used
>>> by the currently active input.
>>
>> Video nodes should represent a dma engine rather than an image source.
> 
> True. Image sources are represented, on V4L2, by inputs.
> 
>> You
>> could use the same hardware to process data from memory to memory while
>> streaming video from a sensor to memory at the same time. This is a quite
>> typical use in embedded systems.
>>
>> Usually boards where two sensors are connected to an isp the dependencies
>> are not as straightforward as the sensors being fully independent or require
>> exclusive access. Typically some of the hardware blocks are shared between
>> the two and can be used by only one sensor at a time, so instead you may not
>> get full functionality from both at the same time. And you need to be able
>> to choose which one uses that hardware block. This is exactly what Media
>> controller interface models perfectly.
> 
> I see.
> 
>> See FIMC Media controller graph AND Sylwester's explanation on it; a few
>> links are actually missing from the grapg.
>>
>> <URL:http://www.spinics.net/lists/linux-media/msg35504.html>
>> <URL:http://wstaw.org/m/2011/05/26/fimc_graph__.png>
>>
>> Cc Hans.
>>
>>> If the sensors aren't mutually exclusive, then two different video nodes will
>>> be shown in userspace.
>>>
>>>> Those controls are also quite useless for generic V4L2 applications, which 
>>>> will want auto-exposure anyway. This needs to be implemented in userspace in 
>>>> libv4l.
>>>
>>> Several webcams export exposure controls. Why shouldn't those controls be exposed
>>> to userspace anymore?
>>
>> This is not a webcam,
> 
> I know, but the analogy is still valid.
> 
>> it is a software controlled high end digital camera on
>> a mobile device. The difference is that the functionality offered by the
>> hardware is at much lower level compared to a webcam; the result is that
>> more detailed control ia required but also much flexibility and performance
>> is gained.
> 
> I see. What I failed to see is why to remove control from userspace. If the
> hardware is more powerful, I expect to see more controls exported, and not
> removing the V4L2 functionality from the driver.
> 
>>> Ok, if the hardware won't support 3A algorithm, libv4l will implement it, 
>>> eventually using an extra hardware-aware code to get the best performance 
>>> for that specific device, but this doesn't mean that the user should always 
>>> use it.
>>
>> Why not? What would be the alternative?
> 
> User may want or need to disable the 3A algo and control some hardware parameters
> hardware directly, for example, to take an over-exposed picture, to create some
> neat effects, or to get some image whose exposure aperture/time is out of the
> 3A range.
> 
>>> Btw, the 3A algorithm is one of the things I don't like on my cell phone: while
>>> it works most of the time, sometimes I want to disable it and manually adjust,
>>> as it produces dark images, when there's a very bright light somewhere on the
>>> image background. Manually adjusting the exposure time and aperture is
>>> something relevant for some users.
>>
>> You do want the 3A algorithms even if you use manual white balance. What the
>> automatic white balance algorithm produces is (among other things) gamma
>> tables, rgb-to-rgb conversion matrices and lens shading correction tables. I
>> doubt any end user, even if it was you, would like to fiddle with such large
>> tables directly when capturing photos. 
> 
> There are some hacks for several professional and amateur cameras that replace the
> existing 3A algorithms by... NONE. The idea is to get the raw data directly from 
> the sensor, and use some software like Gimp or Photoshop to do lens correction, 
> temperature correction, whitespace ballance, etc, at post-processing.
> The advantage of such type of usage is that the photographer can fine-tune the
> generated image to produce what he wants, using more sophisticated (and not
> real-time) algorithms.
> 
> [1] for example, one of such firmwares, that I use on my Canon Digital Camera
> is available at:
>     http://chdk.wikia.com/wiki/CHDK
> 
>> The size of this configuration could
>> easily be around 10 kB. A higher level control is required; colour
>> temperature, for instance. And its implementation involves the same
>> automatic white balance algorithm.
>>
>> You must know your hardware very, very well to use the aforementioned low
>> level controls and in such a case you have no reason not to use the MC
>> interface to configure the device either. Configuring the device image pipe
>> using MC is actually a number of magnitudes less complex, and I say it's
>> been quite an achievement that we have such an interface which makes it
>> so effortless to do.
> 
> For sure, such kind of controls that exposes the 3A correction algorithm at the
> DSP level shouldn't be exposed via V4L2 interface, but things like disabling 3A
> and manually controlling the sensor, like aperture, exposure, analog zoom, etc, 
> makes sense to be exported.
> 
>>>>>> Also there might be some preference at user space, at which stage of the
>>>>>> pipeline to apply some controls. This is where the subdev API helps, and
>>>>>> plain video node API does not.
>>>>>
>>>>> Again, this is for specific usecases. On such cases, what is expected is
>>>>> that the more generic control will be exported via V4L2 API.
>>>>>
>>>>>>>> Thus it's a bit hard to imagine that we could do something like
>>>>>>>> "optionally not to inherit controls" as the subdev/MC API is optional.
>>>>>>>> :)
>>>>>>>
>>>>>>> This was actually implemented. There are some cases at ivtv/cx18 driver
>>>>>>> where both the bridge and a subdev provides the same control (audio
>>>>>>> volume, for example). The idea is to allow the bridge driver to touch
>>>>>>> at the subdev control without exposing it to userspace, since the
>>>>>>> desire was that the bridge driver itself would expose such control,
>>>>>>> using a logic that combines changing the subdev and the bridge
>>>>>>> registers for volume.
>>>>>>
>>>>>> This seem like hard coding a policy in the driver;) Then there is no way
>>>>>> (it might not be worth the effort though) to play with volume level at
>>>>>> both devices, e.g. to obtain optimal S/N ratio.
>>>>>
>>>>> In general, playing with just one control is enough. Andy had a different
>>>>> opinion when this issue were discussed, and he thinks that playing with
>>>>> both is better. At the end, this is a developers decision, depending on
>>>>> how much information (and bug reports) he had.
>>>>
>>>> ivtv/cx18 is a completely different use case, where hardware configurations 
>>>> are known, and experiments possible to find out which control(s) to use and 
>>>> how. In this case you can't know in advance what the sensor and host drivers 
>>>> will be used for.
>>>
>>> Why not? I never saw an embedded hardware that allows physically changing the
>>> sensor.

I understood Laurent's statement that you can have same ISP driver deployed on
multiple boards fitted with various sensors. Hence the multiple configurations
that cannot be known in advance,

>>>
>>>> Even if you did, fine image quality tuning requires 
>>>> accessing pretty much all controls individually anyway.
>>>
>>> The same is also true for non-embedded hardware. The only situation where
>>> V4L2 API is not enough is when there are two controls of the same type
>>> active. For example, 2 active volume controls, one at the audio demod, and
>>> another at the bridge. There may have some cases where you can do the same
>>> thing at the sensor or at a DSP block. This is where MC API gives an
>>> improvement, by allowing changing both, instead of just one of the
>>> controls.
>>
>> This may be true on non-embedded hardware. It's important to know which
>> hardware component implements a particular control; for example digital gain
>> typically would take longer to have an effect if it is set on sensor rather
>> than on the ISP. Also, is you set digital gain, you want to set it on the
>> same device where your analog gain is --- the sensor --- to avoid badly
>> exposed imagws.
> 
> I'd say that the driver should expose the hardware control, if 3A is disabled.
> 
>> When it comes to scaling, the scaling quality, power consumption and
>> performance may well be very different depending on where it is done. There
>> typically are data rate limitations at different parts of the pipeline. The
>> plain V4L2 has never been meant for this nor provides any support when doing
>> something like above, and these are just few examples.
> 
> I see your point.
> 
>>>>>> This is a hack...sorry, just joking ;-) Seriously, I think the
>>>>>> situation with the userspace subdevs is a bit different. Because with one
>>>>>> API we directly expose some functionality for applications, with other
>>>>>> we code it in the kernel, to make the devices appear uniform at user
>>>>>> space.
>>>>>
>>>>> Not sure if I understood you. V4L2 export drivers functionality to
>>>>> userspace in an uniform way. MC api is for special applications that might
>>>>> need to access some internal functions on embedded devices.
>>>>>
>>>>> Of course, there are some cases where it doesn't make sense to export a
>>>>> subdev control via V4L2 API.
>>>>>
>>>>>>>> Also, the sensor subdev can be configured in the video node driver as
>>>>>>>> well as through the subdev device node. Both APIs can do the same
>>>>>>>> thing but in order to let the subdev API work as expected the video
>>>>>>>> node driver must be forbidden to configure the subdev.
>>>>>>>
>>>>>>> Why? For the sensor, a V4L2 API call will look just like a bridge driver
>>>>>>> call. The subdev will need a mutex anyway, as two MC applications may
>>>>>>> be opening it simultaneously. I can't see why it should forbid changing
>>>>>>> the control from the bridge driver call.
>>>>>>
>>>>>> Please do not forget there might be more than one subdev to configure and
>>>>>> that the bridge itself is also a subdev (which exposes a scaler
>>>>>> interface, for instance). A situation pretty much like in Figure 4.4 [1]
>>>>>> (after the scaler there is also a video node to configure, but we may
>>>>>> assume that pixel resolution at the scaler pad 1 is same as at the video
>>>>>> node). Assuming the format and crop configuration flow is from sensor to
>>>>>> host scaler direction, if we have tried to configure _all_ subdevs when
>>>>>> the last stage of the pipeline is configured (i.e. video node) the whole
>>>>>> scaler and crop/composition configuration we have been destroyed at that
>>>>>> time. And there is more to configure than VIDIOC_S_FMT can do.
>>>>>
>>>>> Think from users perspective: all user wants is to see a video of a given
>>>>> resolution. S_FMT (and a few other VIDIOC_* calls) have everything that
>>>>> the user wants: the desired resolution, framerate and format.
>>>>>
>>>>> Specialized applications indeed need more, in order to get the best images
>>>>> for certain types of usages. So, MC is there.
>>>>>
>>>>> Such applications will probably need to know exactly what's the sensor,
>>>>> what are their bugs, how it is connected, what are the DSP blocks in the
>>>>> patch, how the DSP algorithms are implemented, etc, in order to obtain the
>>>>> the perfect image.
>>>>>
>>>>> Even on embedded devices like smartphones and tablets, I predict that both
>>>>> types of applications will be developed and used: people may use a generic
>>>>> application like flash player, and an specialized application provided by
>>>>> the manufacturer. Users can even develop their own applications generic
>>>>> apps using V4L2 directly, at the devices that allow that.
>>>>>
>>>>> As I said before: both application types are welcome. We just need to
>>>>> warrant that a pure V4L application will work reasonably well.
>>>>
>>>> That's why we have libv4l. The driver simply doesn't receive enough 
>>>> information to configure the hardware correctly from the VIDIOC_* calls. And 
>>>> as mentioned above, 3A algorithms, required by "simple" V4L2 applications, 
>>>> need to be implemented in userspace anyway.
>>>
>>> It is OK to improve users experience via libv4l. What I'm saying is that it is
>>> NOT OK to remove V4L2 API support from the driver, forcing users to use some
>>> hardware plugin at libv4l.
>>
>> Either do you know your hardware or do not know it. General purpose
>> applications can rely on functionality provided by libv4l, but if you do not
>> use it, then you need to configure the underlying device. Which is something
>> where the Media controller and v4l2_subdev interfaces are tremendously
>> useful.
> 
> Agreed, but while we don't actually have libv4l hw-specific plugins committed
> at the v4l-utils git tree, all we have to warrant that the hardware will work
> with a generic userspace application is the V4L2 API.
> 
>>>>>> Allowing the bridge driver to configure subdevs at all times would
>>>>>> prevent the subdev/MC API to work.
>>>>>
>>>>> Well, then we need to think on an alternative for that. It seems an
>>>>> interesting theme for the media workshop at the Kernel Summit/2011.
>>>>>
>>>>>>>> There is a conflict there that in order to use
>>>>>>>> 'optional' API the 'main' API behaviour must be affected....
>>>>>>>
>>>>>>> It is optional from userspace perspective. A V4L2-only application
>>>>>>> should be able to work with all drivers. However, a MC-aware
>>>>>>> application will likely be specific for some hardware, as it will need
>>>>>>> to know some device-specific stuff.
>>>>>>>
>>>>>>> Both kinds of applications are welcome, but dropping support for
>>>>>>> V4L2-only applications is the wrong thing to do.
>>>>>>>
>>>>>>>> And I really cant use V4L2 API only as is because it's too limited.
>>>>>>>
>>>>>>> Why?
>>>>>>
>>>>>> For instance there is really yet no support for scaler and composition
>>>>>> onto a target buffer in the Video Capture Interface (we also use sensors
>>>>>> with built in scalers). It's difficult to efficiently manage
>>>>>> capture/preview pipelines. It is impossible to discover the system
>>>>>> topology.
>>>>>
>>>>> Scaler were always supported by V4L2: if the resolution specified by S_FMT
>>>>> is not what the sensor provides, then scale. All non-embedded drivers with
>>>>> sensor or bridge supports scale does that.
>>>>>
>>>>> Composition is not properly supported yet. It could make sense to add it to
>>>>> V4L. How do you think MC API would help with composite?
>>>>>
>>>>> Managing capture/preview pipelines will require some support at V4L2 level.
>>>>> This is a problem that needs to be addressed there anyway, as buffers for
>>>>> preview/capture need to be allocated. There's an RFC about that, but I
>>>>> don't think it covers the pipelines for it.
>>>>
>>>> Managing pipelines is a policy decision, and needs to be implemented in 
>>>> userspace. Once again, the solution here is libv4l.
>>>
>>> If V4L2 API is not enough, implementing it on libv4l won't solve, as userspace
>>> apps will use V4L2 API for requresting it.
>>
>> There are two kind of applications: specialised and generic. The generic
>> ones may rely on restrictive policies put in place by a libv4l plugin
>> whereas the specialised applications need to access the device's features
>> directly to get the most out of it.
> 
> A submitted upstream driver should be capable of working with the existing
> tools/userspace.
> 
> Currently, there isn't such libv4l plugins (or, at least, I failed to see a
> merged plugin there for N9, S5P, etc). Let's not upstream new drivers or remove 
> functionalities from already existing drivers based on something that has yet 
> to be developed.
> 
> After having it there properly working and tested independently, we may consider
> patches removing V4L2 interfaces that were obsoleted in favor of using the libv4l
> implementation, of course using the Kernel way of deprecating interfaces. But
> doing it before having it, doesn't make any sense.
> 
> Let's not put the the cart before the horse.

That's a good point. My long term plan was to deprecate and remove duplicated ioctls
at the driver _once_ support for regular V4L2 interface on top of MC/subdev API
is added at the v4l2 libraries. But this will happen after I create an initial.. 
*cough* openmax IL for the driver. Which is not what the Tigers like best..

--
Regards,
Sylwester
