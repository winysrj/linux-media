Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:52569 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751507AbdEJKb3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 10 May 2017 06:31:29 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
Message-id: <5912EBFD.1020104@samsung.com>
Date: Wed, 10 May 2017 19:31:25 +0900
From: Inki Dae <inki.dae@samsung.com>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Tomasz Figa <tfiga@chromium.org>, linux-media@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Tobias Jakobi <tjakobi@math.uni-bielefeld.de>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@intel.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFC 0/4] Exynos DRM: add Picture Processor extension
In-reply-to: <20170510075508.kqg6t35qccwpzxwn@phenom.ffwll.local>
References: <CGME20170420091406eucas1p24c50a0015545105081257d880727386c@eucas1p2.samsung.com>
 <1492679620-12792-1-git-send-email-m.szyprowski@samsung.com>
 <2541347.TzHdYYQVhG@avalon> <711bf4a5-7e57-6720-d00b-66e97a81e5ec@samsung.com>
 <20170425222124.GA7456@valkosipuli.retiisi.org.uk>
 <59126BB4.6050309@samsung.com>
 <CAAFQd5CPNQ5hDDXPwo2v54VcoOMeDszuvoHZPYQYNJsMJk41Ww@mail.gmail.com>
 <5912B2B6.4050605@samsung.com>
 <20170510075508.kqg6t35qccwpzxwn@phenom.ffwll.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



2017년 05월 10일 16:55에 Daniel Vetter 이(가) 쓴 글:
> On Wed, May 10, 2017 at 03:27:02PM +0900, Inki Dae wrote:
>> Hi Tomasz,
>>
>> 2017년 05월 10일 14:38에 Tomasz Figa 이(가) 쓴 글:
>>> Hi Everyone,
>>>
>>> On Wed, May 10, 2017 at 9:24 AM, Inki Dae <inki.dae@samsung.com> wrote:
>>>>
>>>>
>>>> 2017년 04월 26일 07:21에 Sakari Ailus 이(가) 쓴 글:
>>>>> Hi Marek,
>>>>>
>>>>> On Thu, Apr 20, 2017 at 01:23:09PM +0200, Marek Szyprowski wrote:
>>>>>> Hi Laurent,
>>>>>>
>>>>>> On 2017-04-20 12:25, Laurent Pinchart wrote:
>>>>>>> Hi Marek,
>>>>>>>
>>>>>>> (CC'ing Sakari Ailus)
>>>>>>>
>>>>>>> Thank you for the patches.
>>>>>>>
>>>>>>> On Thursday 20 Apr 2017 11:13:36 Marek Szyprowski wrote:
>>>>>>>> Dear all,
>>>>>>>>
>>>>>>>> This is an updated proposal for extending EXYNOS DRM API with generic
>>>>>>>> support for hardware modules, which can be used for processing image data
>>>>>>> >from the one memory buffer to another. Typical memory-to-memory operations
>>>>>>>> are: rotation, scaling, colour space conversion or mix of them. This is a
>>>>>>>> follow-up of my previous proposal "[RFC 0/2] New feature: Framebuffer
>>>>>>>> processors", which has been rejected as "not really needed in the DRM
>>>>>>>> core":
>>>>>>>> http://www.mail-archive.com/dri-devel@lists.freedesktop.org/msg146286.html
>>>>>>>>
>>>>>>>> In this proposal I moved all the code to Exynos DRM driver, so now this
>>>>>>>> will be specific only to Exynos DRM. I've also changed the name from
>>>>>>>> framebuffer processor (fbproc) to picture processor (pp) to avoid confusion
>>>>>>>> with fbdev API.
>>>>>>>>
>>>>>>>> Here is a bit more information what picture processors are:
>>>>>>>>
>>>>>>>> Embedded SoCs are known to have a number of hardware blocks, which perform
>>>>>>>> such operations. They can be used in paralel to the main GPU module to
>>>>>>>> offload CPU from processing grapics or video data. One of example use of
>>>>>>>> such modules is implementing video overlay, which usually requires color
>>>>>>>> space conversion from NV12 (or similar) to RGB32 color space and scaling to
>>>>>>>> target window size.
>>>>>>>>
>>>>>>>> The proposed API is heavily inspired by atomic KMS approach - it is also
>>>>>>>> based on DRM objects and their properties. A new DRM object is introduced:
>>>>>>>> picture processor (called pp for convenience). Such objects have a set of
>>>>>>>> standard DRM properties, which describes the operation to be performed by
>>>>>>>> respective hardware module. In typical case those properties are a source
>>>>>>>> fb id and rectangle (x, y, width, height) and destination fb id and
>>>>>>>> rectangle. Optionally a rotation property can be also specified if
>>>>>>>> supported by the given hardware. To perform an operation on image data,
>>>>>>>> userspace provides a set of properties and their values for given fbproc
>>>>>>>> object in a similar way as object and properties are provided for
>>>>>>>> performing atomic page flip / mode setting.
>>>>>>>>
>>>>>>>> The proposed API consists of the 3 new ioctls:
>>>>>>>> - DRM_IOCTL_EXYNOS_PP_GET_RESOURCES: to enumerate all available picture
>>>>>>>>   processors,
>>>>>>>> - DRM_IOCTL_EXYNOS_PP_GET: to query capabilities of given picture
>>>>>>>>   processor,
>>>>>>>> - DRM_IOCTL_EXYNOS_PP_COMMIT: to perform operation described by given
>>>>>>>>   property set.
>>>>>>>>
>>>>>>>> The proposed API is extensible. Drivers can attach their own, custom
>>>>>>>> properties to add support for more advanced picture processing (for example
>>>>>>>> blending).
>>>>>>>>
>>>>>>>> This proposal aims to replace Exynos DRM IPP (Image Post Processing)
>>>>>>>> subsystem. IPP API is over-engineered in general, but not really extensible
>>>>>>>> on the other side. It is also buggy, with significant design flaws - the
>>>>>>>> biggest issue is the fact that the API covers memory-2-memory picture
>>>>>>>> operations together with CRTC writeback and duplicating features, which
>>>>>>>> belongs to video plane. Comparing with IPP subsystem, the PP framework is
>>>>>>>> smaller (1807 vs 778 lines) and allows driver simplification (Exynos
>>>>>>>> rotator driver smaller by over 200 lines).
>>>>>>> This seems to be the kind of hardware that is typically supported by V4L2.
>>>>>>> Stupid question, why DRM ?
>>>>>>
>>>>>> Let me elaborate a bit on the reasons for implementing it in Exynos DRM:
>>>>>>
>>>>>> 1. we want to replace existing Exynos IPP subsystem:
>>>>>>  - it is used only in some internal/vendor trees, not in open-source
>>>>>>  - we want it to have sane and potentially extensible userspace API
>>>>>>  - but we don't want to loose its functionality
>>>>>>
>>>>>> 2. we want to have simple API for performing single image processing
>>>>>> operation:
>>>>>>  - typically it will be used by compositing window manager, this means that
>>>>>>    some parameters of the processing might change on each vblank (like
>>>>>>    destination rectangle for example). This api allows such change on each
>>>>>>    operation without any additional cost. V4L2 requires to reinitialize
>>>>>>    queues with new configuration on such change, what means that a bunch of
>>>>>>    ioctls has to be called.
>>>>>
>>>>> What do you mean by re-initialising the queue? Format, buffers or something
>>>>> else?
>>>>>
>>>>> If you need a larger buffer than what you have already allocated, you'll
>>>>> need to re-allocate, V4L2 or not.
>>>>>
>>>>> We also do lack a way to destroy individual buffers in V4L2. It'd be up to
>>>>> implementing that and some work in videobuf2.
>>>>>
>>>>> Another thing is that V4L2 is very stream oriented. For most devices that's
>>>>> fine as a lot of the parameters are not changeable during streaming,
>>>>> especially if the pipeline is handled by multiple drivers. That said, for
>>>>> devices that process data from memory to memory performing changes in the
>>>>> media bus formats and pipeline configuration is not very efficient
>>>>> currently, largely for the same reason.
>>>>>
>>>>> The request API that people have been working for a bit different use cases
>>>>> isn't in mainline yet. It would allow more efficient per-request
>>>>> configuration than what is currently possible, but it has turned out to be
>>>>> far from trivial to implement.
>>>>>
>>>>>>  - validating processing parameters in V4l2 API is really complicated,
>>>>>>    because the parameters (format, src&dest rectangles, rotation) are being
>>>>>>    set incrementally, so we have to either allow some impossible,
>>>>>> transitional
>>>>>>    configurations or complicate the configuration steps even more (like
>>>>>>    calling some ioctls multiple times for both input and output). In the end
>>>>>>    all parameters have to be again validated just before performing the
>>>>>>    operation.
>>>>>
>>>>> You have to validate the parameters in any case. In a MC pipeline this takes
>>>>> place when the stream is started.
>>>>>
>>>>>>
>>>>>> 3. generic approach (to add it to DRM core) has been rejected:
>>>>>> http://www.mail-archive.com/dri-devel@lists.freedesktop.org/msg146286.html
>>>>>
>>>>> For GPUs I generally understand the reasoning: there's a very limited number
>>>>> of users of this API --- primarily because it's not an application
>>>>> interface.
>>>>>
>>>>> If you have a device that however falls under the scope of V4L2 (at least
>>>>> API-wise), does this continue to be the case? Will there be only one or two
>>>>> (or so) users for this API? Is it the case here?
>>>>>
>>>>> Using a device specific interface definitely has some benefits: there's no
>>>>> need to think how would you generalise the interface for other similar
>>>>> devices. There's no need to consider backwards compatibility as it's not a
>>>>> requirement. The drawback is that the applications that need to support
>>>>> similar devices will bear the burden of having to support different APIs.
>>>>>
>>>>> I don't mean to say that you should ram whatever under V4L2 / MC
>>>>> independently of how unworkable that might be, but there are also clear
>>>>> advantages in using a standardised interface such as V4L2.
>>>>>
>>>>> V4L2 has a long history behind it and if it was designed today, I bet it
>>>>> would look quite different from what it is now.
>>>>
>>>> It's true. There is definitely a benefit with V4L2 because V4L2 provides Linux standard ABI - for DRM as of now not.
>>>>
>>>> However, I think that is a only benefit we could get through V4L2. Using V4L2 makes software stack of Platform to be complicated - We have to open video device node and card device node to display a image on the screen scaling or converting color space of the image and also we need to export DMA buffer from one side and import it to other side using DMABUF.
>>>>
>>>> It may not related to this but even V4L2 has performance problem - every QBUF/DQBUF requests performs mapping/unmapping DMA buffer you already know this. :)
>>>>
>>>> In addition, recently Display subsystems on ARM SoC tend to include pre/post processing hardware in Display controller - OMAP, Exynos8895 and MSM as long as I know.
>>>>
>>>
>>> I agree with many of the arguments given by Inki above and earlier by
>>> Marek. However, they apply to already existing V4L2 implementation,
>>> not V4L2 as the idea in general, and I believe a comparison against a
>>> complete new API that doesn't even exist in the kernel tree and
>>> userspace yet (only in terms of patches on the list) is not fair.
>>
>> Below is a user space who uses Exynos DRM post processor driver, IPP driver.
>> https://review.tizen.org/git/?p=platform/adaptation/samsung_exynos/libtdm-exynos.git;a=blob;f=src/tdm_exynos_pp.c;h=db20e6f226d313672d1d468e06d80526ea30121c;hb=refs/heads/tizen
>>
>> Marek patch series is just a new version of this driver which is specific to Exynos DRM. Marek is trying to enhance this driver.
>> Ps. other DRM drivers in mainline already have such or similar API.
>>
>> We will also open the user space who uses new API later.
> 
> Those drivers are different, because they just expose a hw-specific abi.
> Like the current IPP interfaces exposed by drm/exynos.
> 
> I think you have 2 options:
> - Extend the current IPP interface in drm/exynos with whatever new pixel
>   processor modes you want. Of course this still means you need to have

Yes, this is only thing we could select as of now.


Thanks,
Inki Dae


>   the userspace side open-source, but otherwise it's all private to exynos
>   hardware and software.
> 
> - If you want something standardized otoh, go with v4l2. And the issues
>   you point out in v4l2 aren't uapi issues, but implementation details of
>   the current vbuf helpers, which can be fixed. At least that's my
>   understanding. And it should be fairly easy to fix that, simply switch
>   from doing a map/unmap for every q/deqbuf to caching the mappings and
>   use the stream dma-api interfaces to only do the flush (if needed at
>   all, should turn into a no-op) on q/deqbuf.
> 
> Trying to come up with a generic drm api has imo not much chance of
> getting accepted anytime soon (since for the simple pixel processor
> pipeline it's just duplicating v4l, and for something more generic/faster
> a generic interfaces is alwas too slow).
> -Daniel
> 
