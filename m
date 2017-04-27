Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:44567 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034328AbdD0NxD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Apr 2017 09:53:03 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed
Subject: Re: [RFC 0/4] Exynos DRM: add Picture Processor extension
To: Tobias Jakobi <tjakobi@math.uni-bielefeld.de>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dri-devel@lists.freedesktop.org, linux-samsung-soc@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Sakari Ailus <sakari.ailus@intel.com>,
        linux-media@vger.kernel.org
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <99ca2bfd-32f5-c794-5773-15ad72a2419e@samsung.com>
Date: Thu, 27 Apr 2017 15:52:52 +0200
In-reply-to: <598f2a2e-ef59-1174-08ad-54eea72ff1cf@math.uni-bielefeld.de>
Content-transfer-encoding: 8bit
References: <CGME20170420091406eucas1p24c50a0015545105081257d880727386c@eucas1p2.samsung.com>
 <1492679620-12792-1-git-send-email-m.szyprowski@samsung.com>
 <2541347.TzHdYYQVhG@avalon> <711bf4a5-7e57-6720-d00b-66e97a81e5ec@samsung.com>
 <20170425222124.GA7456@valkosipuli.retiisi.org.uk>
 <1493218407.29587.9.camel@ndufresne.ca>
 <598f2a2e-ef59-1174-08ad-54eea72ff1cf@math.uni-bielefeld.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tobias and Nicolas,

On 2017-04-26 17:16, Tobias Jakobi wrote:
> Nicolas Dufresne wrote:
>> Le mercredi 26 avril 2017 à 01:21 +0300, Sakari Ailus a écrit :
>>> Hi Marek,
>>>
>>> On Thu, Apr 20, 2017 at 01:23:09PM +0200, Marek Szyprowski wrote:
>>>> Hi Laurent,
>>>>
>>>> On 2017-04-20 12:25, Laurent Pinchart wrote:
>>>>> Hi Marek,
>>>>>
>>>>> (CC'ing Sakari Ailus)
>>>>>
>>>>> Thank you for the patches.
>>>>>
>>>>> On Thursday 20 Apr 2017 11:13:36 Marek Szyprowski wrote:
>>>>>> Dear all,
>>>>>>
>>>>>> This is an updated proposal for extending EXYNOS DRM API with generic
>>>>>> support for hardware modules, which can be used for processing image data
>>>>>> from the one memory buffer to another. Typical memory-to-memory operations
>>>>>> are: rotation, scaling, colour space conversion or mix of them. This is a
>>>>>> follow-up of my previous proposal "[RFC 0/2] New feature: Framebuffer
>>>>>> processors", which has been rejected as "not really needed in the DRM
>>>>>> core":
>>>>>> http://www.mail-archive.com/dri-devel@lists.freedesktop.org/msg146286.html
>>>>>>
>>>>>> In this proposal I moved all the code to Exynos DRM driver, so now this
>>>>>> will be specific only to Exynos DRM. I've also changed the name from
>>>>>> framebuffer processor (fbproc) to picture processor (pp) to avoid confusion
>>>>>> with fbdev API.
>>>>>>
>>>>>> Here is a bit more information what picture processors are:
>>>>>>
>>>>>> Embedded SoCs are known to have a number of hardware blocks, which perform
>>>>>> such operations. They can be used in paralel to the main GPU module to
>>>>>> offload CPU from processing grapics or video data. One of example use of
>>>>>> such modules is implementing video overlay, which usually requires color
>>>>>> space conversion from NV12 (or similar) to RGB32 color space and scaling to
>>>>>> target window size.
>>>>>>
>>>>>> The proposed API is heavily inspired by atomic KMS approach - it is also
>>>>>> based on DRM objects and their properties. A new DRM object is introduced:
>>>>>> picture processor (called pp for convenience). Such objects have a set of
>>>>>> standard DRM properties, which describes the operation to be performed by
>>>>>> respective hardware module. In typical case those properties are a source
>>>>>> fb id and rectangle (x, y, width, height) and destination fb id and
>>>>>> rectangle. Optionally a rotation property can be also specified if
>>>>>> supported by the given hardware. To perform an operation on image data,
>>>>>> userspace provides a set of properties and their values for given fbproc
>>>>>> object in a similar way as object and properties are provided for
>>>>>> performing atomic page flip / mode setting.
>>>>>>
>>>>>> The proposed API consists of the 3 new ioctls:
>>>>>> - DRM_IOCTL_EXYNOS_PP_GET_RESOURCES: to enumerate all available picture
>>>>>>    processors,
>>>>>> - DRM_IOCTL_EXYNOS_PP_GET: to query capabilities of given picture
>>>>>>    processor,
>>>>>> - DRM_IOCTL_EXYNOS_PP_COMMIT: to perform operation described by given
>>>>>>    property set.
>>>>>>
>>>>>> The proposed API is extensible. Drivers can attach their own, custom
>>>>>> properties to add support for more advanced picture processing (for example
>>>>>> blending).
>>>>>>
>>>>>> This proposal aims to replace Exynos DRM IPP (Image Post Processing)
>>>>>> subsystem. IPP API is over-engineered in general, but not really extensible
>>>>>> on the other side. It is also buggy, with significant design flaws - the
>>>>>> biggest issue is the fact that the API covers memory-2-memory picture
>>>>>> operations together with CRTC writeback and duplicating features, which
>>>>>> belongs to video plane. Comparing with IPP subsystem, the PP framework is
>>>>>> smaller (1807 vs 778 lines) and allows driver simplification (Exynos
>>>>>> rotator driver smaller by over 200 lines).
>> Just a side note, we have written code in GStreamer using the Exnynos 4
>> FIMC IPP driver. I don't know how many, if any, deployment still exist
>> (Exynos 4 is relatively old now), but there exist userspace for the
>> FIMC driver. We use this for color transformation (from tiled to
>> linear) and scaling. The FIMC driver is in fact quite stable in
>> upstream kernel today. The GScaler V4L2 M2M driver on Exynos 5 is
>> largely based on it and has received some maintenance to properly work
>> in GStreamer. unlike this DRM API, you can reuse the same userspace
>> code across multiple platforms (which we do already). We have also
>> integrated this driver in Chromium in the past (not upstream though).
>>
>> I am well aware that the blitter driver has not got much attention
>> though. But again, V4L2 offers a generic interface to userspace
>> application. Fixing this driver could enable some work like this one:
>>
>> https://bugzilla.gnome.org/show_bug.cgi?id=772766
>>
>> This work in progress feature is a generic hardware accelerated video
>> mixer. It has been tested with IMX.6 v4l2 m2m blitter driver (which I
>> believe is in staging right now). Again, unlike the exynos/drm, this
>> code could be reused between platforms.
>>
>> In general, the problem with the DRM approach is that it only targets
>> displays. We often need to use these IP block for stream pre/post
>> processing outside a "playback" use case.
> just a short note that this is not true. You can use all this
> functionality e.g. through render nodes, without needing to have a
> display attached to your system.

Yes. As an alternative I also plan to provide generic V4L2-style mem2mem
device on top of this Exynos DRM interface. This will also help on the newer
Exynos SoCs, which even don't have GScaller. This way we can also easily get
rid of two drivers for GScaller hw. FIMC will probably stay in V4L2 because
of its camera related functions.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland
