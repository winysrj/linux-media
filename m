Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.math.uni-bielefeld.de ([129.70.45.10]:50465 "EHLO
        smtp.math.uni-bielefeld.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933405AbdDZPZp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Apr 2017 11:25:45 -0400
Subject: Re: [RFC 0/4] Exynos DRM: add Picture Processor extension
To: Nicolas Dufresne <nicolas@ndufresne.ca>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Sakari Ailus <sakari.ailus@intel.com>,
        linux-media@vger.kernel.org
References: <CGME20170420091406eucas1p24c50a0015545105081257d880727386c@eucas1p2.samsung.com>
 <1492679620-12792-1-git-send-email-m.szyprowski@samsung.com>
 <2541347.TzHdYYQVhG@avalon>
 <711bf4a5-7e57-6720-d00b-66e97a81e5ec@samsung.com>
 <20170425222124.GA7456@valkosipuli.retiisi.org.uk>
 <1493218407.29587.9.camel@ndufresne.ca>
From: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>
Message-ID: <598f2a2e-ef59-1174-08ad-54eea72ff1cf@math.uni-bielefeld.de>
Date: Wed, 26 Apr 2017 17:16:25 +0200
MIME-Version: 1.0
In-Reply-To: <1493218407.29587.9.camel@ndufresne.ca>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello everyone,


Nicolas Dufresne wrote:
> Le mercredi 26 avril 2017 à 01:21 +0300, Sakari Ailus a écrit :
>> Hi Marek,
>>
>> On Thu, Apr 20, 2017 at 01:23:09PM +0200, Marek Szyprowski wrote:
>>> Hi Laurent,
>>>
>>> On 2017-04-20 12:25, Laurent Pinchart wrote:
>>>> Hi Marek,
>>>>
>>>> (CC'ing Sakari Ailus)
>>>>
>>>> Thank you for the patches.
>>>>
>>>> On Thursday 20 Apr 2017 11:13:36 Marek Szyprowski wrote:
>>>>> Dear all,
>>>>>
>>>>> This is an updated proposal for extending EXYNOS DRM API with generic
>>>>> support for hardware modules, which can be used for processing image data
>>>>> from the one memory buffer to another. Typical memory-to-memory operations
>>>>> are: rotation, scaling, colour space conversion or mix of them. This is a
>>>>> follow-up of my previous proposal "[RFC 0/2] New feature: Framebuffer
>>>>> processors", which has been rejected as "not really needed in the DRM
>>>>> core":
>>>>> http://www.mail-archive.com/dri-devel@lists.freedesktop.org/msg146286.html
>>>>>
>>>>> In this proposal I moved all the code to Exynos DRM driver, so now this
>>>>> will be specific only to Exynos DRM. I've also changed the name from
>>>>> framebuffer processor (fbproc) to picture processor (pp) to avoid confusion
>>>>> with fbdev API.
>>>>>
>>>>> Here is a bit more information what picture processors are:
>>>>>
>>>>> Embedded SoCs are known to have a number of hardware blocks, which perform
>>>>> such operations. They can be used in paralel to the main GPU module to
>>>>> offload CPU from processing grapics or video data. One of example use of
>>>>> such modules is implementing video overlay, which usually requires color
>>>>> space conversion from NV12 (or similar) to RGB32 color space and scaling to
>>>>> target window size.
>>>>>
>>>>> The proposed API is heavily inspired by atomic KMS approach - it is also
>>>>> based on DRM objects and their properties. A new DRM object is introduced:
>>>>> picture processor (called pp for convenience). Such objects have a set of
>>>>> standard DRM properties, which describes the operation to be performed by
>>>>> respective hardware module. In typical case those properties are a source
>>>>> fb id and rectangle (x, y, width, height) and destination fb id and
>>>>> rectangle. Optionally a rotation property can be also specified if
>>>>> supported by the given hardware. To perform an operation on image data,
>>>>> userspace provides a set of properties and their values for given fbproc
>>>>> object in a similar way as object and properties are provided for
>>>>> performing atomic page flip / mode setting.
>>>>>
>>>>> The proposed API consists of the 3 new ioctls:
>>>>> - DRM_IOCTL_EXYNOS_PP_GET_RESOURCES: to enumerate all available picture
>>>>>   processors,
>>>>> - DRM_IOCTL_EXYNOS_PP_GET: to query capabilities of given picture
>>>>>   processor,
>>>>> - DRM_IOCTL_EXYNOS_PP_COMMIT: to perform operation described by given
>>>>>   property set.
>>>>>
>>>>> The proposed API is extensible. Drivers can attach their own, custom
>>>>> properties to add support for more advanced picture processing (for example
>>>>> blending).
>>>>>
>>>>> This proposal aims to replace Exynos DRM IPP (Image Post Processing)
>>>>> subsystem. IPP API is over-engineered in general, but not really extensible
>>>>> on the other side. It is also buggy, with significant design flaws - the
>>>>> biggest issue is the fact that the API covers memory-2-memory picture
>>>>> operations together with CRTC writeback and duplicating features, which
>>>>> belongs to video plane. Comparing with IPP subsystem, the PP framework is
>>>>> smaller (1807 vs 778 lines) and allows driver simplification (Exynos
>>>>> rotator driver smaller by over 200 lines).
> 
> Just a side note, we have written code in GStreamer using the Exnynos 4
> FIMC IPP driver. I don't know how many, if any, deployment still exist
> (Exynos 4 is relatively old now), but there exist userspace for the
> FIMC driver. We use this for color transformation (from tiled to
> linear) and scaling. The FIMC driver is in fact quite stable in
> upstream kernel today. The GScaler V4L2 M2M driver on Exynos 5 is
> largely based on it and has received some maintenance to properly work
> in GStreamer. unlike this DRM API, you can reuse the same userspace
> code across multiple platforms (which we do already). We have also
> integrated this driver in Chromium in the past (not upstream though).
> 
> I am well aware that the blitter driver has not got much attention
> though. But again, V4L2 offers a generic interface to userspace
> application. Fixing this driver could enable some work like this one:
> 
> https://bugzilla.gnome.org/show_bug.cgi?id=772766
> 
> This work in progress feature is a generic hardware accelerated video
> mixer. It has been tested with IMX.6 v4l2 m2m blitter driver (which I
> believe is in staging right now). Again, unlike the exynos/drm, this
> code could be reused between platforms.
> 
> In general, the problem with the DRM approach is that it only targets
> displays. We often need to use these IP block for stream pre/post
> processing outside a "playback" use case.
just a short note that this is not true. You can use all this
functionality e.g. through render nodes, without needing to have a
display attached to your system.

With best wishes,
Tobias


> What I'd like so see instead here, is an approach that helps both world
>  instead of trying to win the control over the IP block. Renesas
> development seems to lead toward the right direction by creating
> drivers that can be both interfaced in DRM and V4L2. For IPP and
> GScaler on Exynos, this would be a greater benefit and finally the code
> could be shared, having a single place to fix when we find bugs.
> 
>>>>
>>>> This seems to be the kind of hardware that is typically supported by V4L2.
>>>> Stupid question, why DRM ?
>>>
>>> Let me elaborate a bit on the reasons for implementing it in Exynos DRM:
>>>
>>> 1. we want to replace existing Exynos IPP subsystem:
>>>  - it is used only in some internal/vendor trees, not in open-source
>>>  - we want it to have sane and potentially extensible userspace API
>>>  - but we don't want to loose its functionality
>>>
>>> 2. we want to have simple API for performing single image processing
>>> operation:
>>>  - typically it will be used by compositing window manager, this means that
>>>    some parameters of the processing might change on each vblank (like
>>>    destination rectangle for example). This api allows such change on each
>>>    operation without any additional cost. V4L2 requires to reinitialize
>>>    queues with new configuration on such change, what means that a bunch of
>>>    ioctls has to be called.
>>
>> What do you mean by re-initialising the queue? Format, buffers or something
>> else?
>>
>> If you need a larger buffer than what you have already allocated, you'll
>> need to re-allocate, V4L2 or not.
>>
>> We also do lack a way to destroy individual buffers in V4L2. It'd be up to
>> implementing that and some work in videobuf2.
>>
>> Another thing is that V4L2 is very stream oriented. For most devices that's
>> fine as a lot of the parameters are not changeable during streaming,
>> especially if the pipeline is handled by multiple drivers. That said, for
>> devices that process data from memory to memory performing changes in the
>> media bus formats and pipeline configuration is not very efficient
>> currently, largely for the same reason.
>>
>> The request API that people have been working for a bit different use cases
>> isn't in mainline yet. It would allow more efficient per-request
>> configuration than what is currently possible, but it has turned out to be
>> far from trivial to implement.
>>
>>>  - validating processing parameters in V4l2 API is really complicated,
>>>    because the parameters (format, src&dest rectangles, rotation) are being
>>>    set incrementally, so we have to either allow some impossible,
>>> transitional
>>>    configurations or complicate the configuration steps even more (like
>>>    calling some ioctls multiple times for both input and output). In the end
>>>    all parameters have to be again validated just before performing the
>>>    operation.
>>
>> You have to validate the parameters in any case. In a MC pipeline this takes
>> place when the stream is started.
>>
>>>
>>> 3. generic approach (to add it to DRM core) has been rejected:
>>> http://www.mail-archive.com/dri-devel@lists.freedesktop.org/msg146286.html
>>
>> For GPUs I generally understand the reasoning: there's a very limited number
>> of users of this API --- primarily because it's not an application
>> interface.
>>
>> If you have a device that however falls under the scope of V4L2 (at least
>> API-wise), does this continue to be the case? Will there be only one or two
>> (or so) users for this API? Is it the case here?
>>
>> Using a device specific interface definitely has some benefits: there's no
>> need to think how would you generalise the interface for other similar
>> devices. There's no need to consider backwards compatibility as it's not a
>> requirement. The drawback is that the applications that need to support
>> similar devices will bear the burden of having to support different APIs.
>>
>> I don't mean to say that you should ram whatever under V4L2 / MC
>> independently of how unworkable that might be, but there are also clear
>> advantages in using a standardised interface such as V4L2.
>>
>> V4L2 has a long history behind it and if it was designed today, I bet it
>> would look quite different from what it is now.
>>
>>>
>>> 4. this api can be considered as extended 'blit' operation, other DRM
>>> drivers
>>>    (MGA, R128, VIA) already have ioctls for such operation, so there is also
>>>    place in DRM for it
> 
> Note that I am convince that using these custom IOCTL within a
> "compositor" implementation is much easier and uniform compared to
> using a v4l2 driver. It probably offers lower latency. But these are
> non-generic and are not a great fit for streaming purpose. Request API
> and probably explicit fence may mitigate this though. Meanwhile, there
> is some indication that even though complex, there is already some
> people that do think implementing a compositor combining V4L2 and DRM
> is feasible.
> 
> http://events.linuxfoundation.org/sites/events/files/slides/als2015_way
> land_weston_v2.pdf
> 
>>
>> Added LMML to cc.
> 
> Thanks.
> 
