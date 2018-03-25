Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:33713 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753400AbeCYPMS (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Mar 2018 11:12:18 -0400
Subject: Re: [RFC v2 00/10] Preparing the request API
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: acourbot@chromium.org
References: <1521839864-10146-1-git-send-email-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <bc453725-e35d-77d4-c92f-27c37e9b3b5d@xs4all.nl>
Date: Sun, 25 Mar 2018 17:12:11 +0200
MIME-Version: 1.0
In-Reply-To: <1521839864-10146-1-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

On 03/23/2018 10:17 PM, Sakari Ailus wrote:
> Hi folks,
> 
> This preliminary RFC patchset prepares for the request API. What's new
> here is support for binding arbitrary configuration or resources to
> requests.
> 
> There are a few new concepts here:
> 
> Class --- a type of configuration or resource a driver (or e.g. the V4L2
> framework) can attach to a resource. E.g. a video buffer queue would be a
> class.
> 
> Object --- an instance of the class. This may be either configuration (in
> which case the setting will stay until changed, e.g. V4L2 format on a
> video node) or a resource (such as a video buffer).
> 
> Reference --- a reference to an object. If a configuration is not changed
> in a request, instead of allocating a new object, a reference to an
> existing object is used. This saves time and memory.
> 
> I expect Laurent to comment on aligning the concept names between the
> request API and DRM. As far as I understand, the respective DRM names for
> "class" and "object" used in this set would be "object" and "state".
> 
> The drivers will need to interact with the requests in three ways:
> 
> - Allocate new configurations or resources. Drivers are free to store
>   their own data into request objects as well. These callbacks are
>   specific to classes.
> 
> - Validate and queue callbacks. These callbacks are used to try requests
>   (validate only) as well as queue them (validate and queue). These
>   callbacks are media device wide, at least for now.
> 
> The lifetime of the objects related to requests is based on refcounting
> both requests and request objects. This fits well for existing use cases
> whether or not based on refcounting; what still needs most of the
> attention is likely that the number of gets and puts matches once the
> object is no longer needed.
> 
> Configuration can be bound to the request the usual way (V4L2 IOCTLs with
> the request_fd field set to the request). Once queued, request completion
> is signalled through polling the request file handle (POLLPRI).
> 
> I'm posting this as an RFC because it's not complete yet. The code
> compiles but no testing has been done yet.

Thank you for this patch series. There are some good ideas here, but it is
quite far from being useful with Alexandre's RFCv4 series.

So this weekend I worked on a merger of this work and the RFCv4 Request API
patch series, taking what I think are the best bits of both.

It is available here:

https://git.linuxtv.org/hverkuil/media_tree.git/log/?h=reqv6

It compiles (although it expects that the media controller is selected in the
kernel config) and tomorrow I will start testing.

The goal of this series is to make the actual driver changes for existing drivers
as simple as possible and do almost all of the work in vb2 and the control framework.

See e.g. the patch adding support for requests to vim2m:

https://git.linuxtv.org/hverkuil/media_tree.git/commit/?h=reqv6&id=0703c330bb53068cdf92e485437c820a018766bc

Of course, this assumes that it actually works, which I'm sure it won't :-)
Hopefully by the end of the day tomorrow I have something that is actually
working.

The concept of media request objects was very useful and very easy to integrate.

Integrating vb2 was harder, esp. since the fence support has not been merged yet
and since that conflicts big time with the request API it is pretty certain that
that code will change.

The control handling of requests is still at the same level of RFCv4: it basically
just copies the current device state when controls are get/set/tried for the first
time for a request. It's good enough for now, but this needs more work to conform
to the Request API RFC.

Note that I didn't copy the 'sticky' concept. When you mark a request object as
'completed', then it just 'sticks around' until the request is freed.

If the request object is a resource (vb2 buffer), then you don't mark it as
completed, instead you just remove it from the request once you're finished
using it.

BTW, I think we seriously need to consider always enabling MEDIA_CONTROLLER
for V4L2. It really doesn't add much to the internal data structures and
having to do #ifdef CONFIG_MEDIA_CONTROLLER all the time is a pain (which
is why I ignored that in my code for now).

Regards,

	Hans

> 
> Todo list:
> 
> - Testing! (And fixing the bugs.)
> 
> - Request support in a few drivers as well as the control framework.
> 
> - Request support for V4L2 formats?
> 
> In the future, support for changing e.g. Media controller link state or
> V4L2 sub-device formats will need to be added. Those should receive more
> attention when the core is in a good shape and the more simple use cases
> are already functional.
> 
> Comments and questions are welcome.
> 
> since v1:
> 
> - Provide an iterator helper for request objects in a request.
> 
> - Remove the request lists in the media device (they were not used)
> 
> - Move request queing to request fd and add reinit (Alexandre's patchset);
>   this roughly corresponds to Request API RFC v2 from Hans.
>   (MEDIA_IOC_REQUEST_ALLOC argument is a struct pointer instead of an
>   __s32 pointer.)
> 
> - Provide a way to unbind request objects from an unqueued request
>   (reinit, closing request fd).
> 
> - v4l2-mem2mem + vivid implementation without control support.
> 
> - More states for requests. In order to take a spinlock (or a mutex) for
>   an extended period of time, add a "QUEUEING" and "REINIT" states.
> 
> - Move non-IOCTL code to media-request.c, remove extra filp argument that
>   was added in v1.
> 
> - SPDX license header, other small changes.
> 
> Open questions:
> 
> - How to tell at complete time whether a request failed? Return error code
>   on release? What's the behaviour with reinit then --- fail on error? Add
>   another IOCTL to ask for completion status?
> 
> 
> Alexandre Courbot (1):
>   videodev2.h: add request_fd field to v4l2_ext_controls
> 
> Hans Verkuil (1):
>   videodev2.h: Add request_fd field to v4l2_buffer
> 
> Laurent Pinchart (1):
>   media: Add request API
> 
> Sakari Ailus (7):
>   media: Support variable size IOCTL arguments
>   staging: media: atomisp: Remove v4l2_buffer.reserved2 field hack
>   vb2: Add support for requests
>   v4l: m2m: Simplify exiting the function in v4l2_m2m_try_schedule
>   v4l: m2m: Support requests with video buffers
>   vim2m: Register V4L2 video device after V4L2 mem2mem init
>   vim2m: Request support
> 
>  drivers/media/Makefile                             |   3 +-
>  drivers/media/common/videobuf2/videobuf2-core.c    |  43 +-
>  drivers/media/common/videobuf2/videobuf2-v4l2.c    |  40 +-
>  drivers/media/media-device.c                       |  80 ++-
>  drivers/media/media-request.c                      | 650 +++++++++++++++++++++
>  drivers/media/platform/vim2m.c                     |  76 ++-
>  drivers/media/usb/cpia2/cpia2_v4l.c                |   2 +-
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c      |  16 +-
>  drivers/media/v4l2-core/v4l2-ioctl.c               |   6 +-
>  drivers/media/v4l2-core/v4l2-mem2mem.c             | 131 ++++-
>  .../media/atomisp/pci/atomisp2/atomisp_ioctl.c     |  17 +-
>  include/media/media-device.h                       |  19 +-
>  include/media/media-request.h                      | 301 ++++++++++
>  include/media/v4l2-mem2mem.h                       |  28 +
>  include/media/videobuf2-core.h                     |  19 +
>  include/media/videobuf2-v4l2.h                     |  28 +
>  include/uapi/linux/media.h                         |   8 +
>  include/uapi/linux/videodev2.h                     |   6 +-
>  18 files changed, 1408 insertions(+), 65 deletions(-)
>  create mode 100644 drivers/media/media-request.c
>  create mode 100644 include/media/media-request.h
> 
