Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f180.google.com ([209.85.223.180]:34970 "EHLO
        mail-io0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750839AbeCZDam (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Mar 2018 23:30:42 -0400
Received: by mail-io0-f180.google.com with SMTP id e7so21468795iof.2
        for <linux-media@vger.kernel.org>; Sun, 25 Mar 2018 20:30:41 -0700 (PDT)
Received: from mail-io0-f173.google.com (mail-io0-f173.google.com. [209.85.223.173])
        by smtp.gmail.com with ESMTPSA id l201sm9014059iol.6.2018.03.25.20.30.40
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Mar 2018 20:30:40 -0700 (PDT)
Received: by mail-io0-f173.google.com with SMTP id d7so6077662ioc.11
        for <linux-media@vger.kernel.org>; Sun, 25 Mar 2018 20:30:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1521839864-10146-1-git-send-email-sakari.ailus@linux.intel.com>
References: <1521839864-10146-1-git-send-email-sakari.ailus@linux.intel.com>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Mon, 26 Mar 2018 12:30:19 +0900
Message-ID: <CAPBb6MWSD8TNAbMb+g21gxMURw4bz0WvqptyVydmJdmb0SAv9Q@mail.gmail.com>
Subject: Re: [RFC v2 00/10] Preparing the request API
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Mar 24, 2018 at 6:17 AM, Sakari Ailus
<sakari.ailus@linux.intel.com> wrote:
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
>
> Todo list:
>
> - Testing! (And fixing the bugs.)
>
> - Request support in a few drivers as well as the control framework.
>
> - Request support for V4L2 formats?

Also, conformance tests in v4l2-compliance.

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

Looks like vivid is not here yet, although it doesn't really matter for now.

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

We could look for POLLERR when polling the request in order to know
that something went wrong. When this happens, an extra ioctl on the
request fd (e.g. REQUEST_GET_ERROR) could be used to get more
information about what has failed. Due to the extensible nature of
requests, we should be careful to make this ioctl widely extensible as
well. Anything that is performed in a deferred way can fail (for now,
S_EXT_CTRLS and QBUF), so maybe this ioctl should return errors in the
same format as these calls. The request would be interrupted upon
first error, so we could just return the code of the ioctl that would
have failed + its relevant user-readable state).

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

I don't think this patch is needed anymore?

I had other comments but saw that Hans respinned the series, so I will
wait for the next iteration. Also for something that has undergone
some testing with controls working.
