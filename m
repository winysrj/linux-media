Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f193.google.com ([209.85.213.193]:41122 "EHLO
        mail-yb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753229AbeGBK5Q (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Jul 2018 06:57:16 -0400
Received: by mail-yb0-f193.google.com with SMTP id s8-v6so1322891ybe.8
        for <linux-media@vger.kernel.org>; Mon, 02 Jul 2018 03:57:16 -0700 (PDT)
Received: from mail-yw0-f181.google.com (mail-yw0-f181.google.com. [209.85.161.181])
        by smtp.gmail.com with ESMTPSA id j187-v6sm5786159ywd.51.2018.07.02.03.57.15
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Jul 2018 03:57:15 -0700 (PDT)
Received: by mail-yw0-f181.google.com with SMTP id y203-v6so4765212ywd.9
        for <linux-media@vger.kernel.org>; Mon, 02 Jul 2018 03:57:15 -0700 (PDT)
MIME-Version: 1.0
References: <20180604114648.26159-1-hverkuil@xs4all.nl> <20180604114648.26159-3-hverkuil@xs4all.nl>
 <d394794c-3db3-6748-e5d3-605a3c028917@xs4all.nl> <CAAFQd5BeJ9T183qHfBO_0rDmF5GEuB3PSkE4MjdJ0r93rVG8aA@mail.gmail.com>
 <2375df0f-0cd7-236f-18ba-218dbd62b6e1@xs4all.nl>
In-Reply-To: <2375df0f-0cd7-236f-18ba-218dbd62b6e1@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Mon, 2 Jul 2018 19:57:03 +0900
Message-ID: <CAAFQd5AvqW3s_JZL21mEnp-g3VPamjutidp7gHnOMdHSOv20DA@mail.gmail.com>
Subject: Re: [PATCHv15 02/35] media-request: implement media requests
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jul 2, 2018 at 6:11 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 02/07/18 10:58, Tomasz Figa wrote:
> > Hi Hans,
> >
> > On Fri, Jun 15, 2018 at 4:09 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >>
> >> On 04/06/18 13:46, Hans Verkuil wrote:
> >>> From: Hans Verkuil <hans.verkuil@cisco.com>
> >>>
> >>> Add initial media request support:
> >>>
> >>> 1) Add MEDIA_IOC_REQUEST_ALLOC ioctl support to media-device.c
> >>> 2) Add struct media_request to store request objects.
> >>> 3) Add struct media_request_object to represent a request object.
> >>> 4) Add MEDIA_REQUEST_IOC_QUEUE/REINIT ioctl support.
> >>>
> >>> Basic lifecycle: the application allocates a request, adds
> >>> objects to it, queues the request, polls until it is completed
> >>> and can then read the final values of the objects at the time
> >>> of completion. When it closes the file descriptor the request
> >>> memory will be freed (actually, when the last user of that request
> >>> releases the request).
> >>>
> >>> Drivers will bind an object to a request (the 'adds objects to it'
> >>> phase), when MEDIA_REQUEST_IOC_QUEUE is called the request is
> >>> validated (req_validate op), then queued (the req_queue op).
> >>>
> >>> When done with an object it can either be unbound from the request
> >>> (e.g. when the driver has finished with a vb2 buffer) or marked as
> >>> completed (e.g. for controls associated with a buffer). When all
> >>> objects in the request are completed (or unbound), then the request
> >>> fd will signal an exception (poll).
> >>>
> >>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> >>> Co-developed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> >>> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> >>> Co-developed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> >>> Co-developed-by: Alexandre Courbot <acourbot@chromium.org>
> >>> ---
> >>>  drivers/media/Makefile        |   3 +-
> >>>  drivers/media/media-device.c  |  14 ++
> >>>  drivers/media/media-request.c | 421 ++++++++++++++++++++++++++++++++++
> >>>  include/media/media-device.h  |  24 ++
> >>>  include/media/media-request.h | 326 ++++++++++++++++++++++++++
> >>>  5 files changed, 787 insertions(+), 1 deletion(-)
> >>>  create mode 100644 drivers/media/media-request.c
> >>>  create mode 100644 include/media/media-request.h
> >>>
> >>
> >> <snip>
> >>
> >>> diff --git a/include/media/media-request.h b/include/media/media-request.h
> >>> new file mode 100644
> >>> index 000000000000..8acd2627835c
> >>> --- /dev/null
> >>> +++ b/include/media/media-request.h
> >>> @@ -0,0 +1,326 @@
> >>
> >> <snip>
> >>
> >>> +/**
> >>> + * struct media_request - Media device request
> >>> + * @mdev: Media device this request belongs to
> >>> + * @kref: Reference count
> >>> + * @debug_str: Prefix for debug messages (process name:fd)
> >>> + * @state: The state of the request
> >>> + * @updating_count: count the number of request updates that are in progress
> >>> + * @objects: List of @struct media_request_object request objects
> >>> + * @num_incomplete_objects: The number of incomplete objects in the request
> >>> + * @poll_wait: Wait queue for poll
> >>> + * @lock: Serializes access to this struct
> >>> + */
> >>> +struct media_request {
> >>> +     struct media_device *mdev;
> >>> +     struct kref kref;
> >>> +     char debug_str[TASK_COMM_LEN + 11];
> >>> +     enum media_request_state state;
> >>> +     refcount_t updating_count;
> >>
> >> This will be replaced by unsigned int: it turns out that if CONFIG_REFCOUNT_FULL is set,
> >> the refcount implementation will complain when you increase the refcount from 0 to 1
> >> since it expects that refcount_t it used as it is in kref. Since updating_count is
> >> protected by the spinlock anyway there is no need to use refcount_t, a simple
> >> unsigned int works just as well.
> >
> > It seems to be read in media_request_clean(), which can be called by
> > media_request_release() or media_request_ioctl_reinit() and neither
> > acquires the spinlock for the time of the call.
>
> The request object is in state CLEANING at that time, and that guarantees
> that nobody else will make changes to the request.

Makes sense. Thanks for clarification.

Best regards,
Tomasz
