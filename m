Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:60843 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726744AbeHDMT1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 4 Aug 2018 08:19:27 -0400
Subject: Re: [PATCHv16 01/34] Documentation: v4l: document request API
To: Tomasz Figa <tfiga@chromium.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20180705160337.54379-1-hverkuil@xs4all.nl>
 <20180705160337.54379-2-hverkuil@xs4all.nl>
 <CAAFQd5C56H3eHoceh9FRM7YqyTfazvbZQv6aifz8nZE4kTu8nw@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <b61e3748-7cd9-4d87-1a57-00ec9b704b82@xs4all.nl>
Date: Sat, 4 Aug 2018 12:19:09 +0200
MIME-Version: 1.0
In-Reply-To: <CAAFQd5C56H3eHoceh9FRM7YqyTfazvbZQv6aifz8nZE4kTu8nw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

Thank you for your review. Unless stated otherwise I have incorporated your
suggestions.

On 08/03/2018 05:00 PM, Tomasz Figa wrote:
> Hi Hans,
> 
> On Fri, Jul 6, 2018 at 1:04 AM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>
>> From: Alexandre Courbot <acourbot@chromium.org>
>>
>> Document the request API for V4L2 devices, and amend the documentation
>> of system calls influenced by it.
>>
>> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  .../media/uapi/mediactl/media-controller.rst  |   1 +
>>  .../media/uapi/mediactl/media-funcs.rst       |   6 +
>>  .../uapi/mediactl/media-ioc-request-alloc.rst |  77 ++++++
>>  .../uapi/mediactl/media-request-ioc-queue.rst |  81 ++++++
>>  .../mediactl/media-request-ioc-reinit.rst     |  51 ++++
>>  .../media/uapi/mediactl/request-api.rst       | 247 ++++++++++++++++++
>>  .../uapi/mediactl/request-func-close.rst      |  49 ++++
>>  .../uapi/mediactl/request-func-ioctl.rst      |  68 +++++
>>  .../media/uapi/mediactl/request-func-poll.rst |  74 ++++++
>>  Documentation/media/uapi/v4l/buffer.rst       |  21 +-
>>  .../media/uapi/v4l/vidioc-g-ext-ctrls.rst     |  94 ++++---
>>  Documentation/media/uapi/v4l/vidioc-qbuf.rst  |  32 ++-
>>  .../media/videodev2.h.rst.exceptions          |   1 +
>>  13 files changed, 766 insertions(+), 36 deletions(-)
>>  create mode 100644 Documentation/media/uapi/mediactl/media-ioc-request-alloc.rst
>>  create mode 100644 Documentation/media/uapi/mediactl/media-request-ioc-queue.rst
>>  create mode 100644 Documentation/media/uapi/mediactl/media-request-ioc-reinit.rst
>>  create mode 100644 Documentation/media/uapi/mediactl/request-api.rst
>>  create mode 100644 Documentation/media/uapi/mediactl/request-func-close.rst
>>  create mode 100644 Documentation/media/uapi/mediactl/request-func-ioctl.rst
>>  create mode 100644 Documentation/media/uapi/mediactl/request-func-poll.rst
>>
> 
> Thanks a lot for working on this and sorry for being late to the
> party. Please see some comments inline. (Mostly wording nits, though.)
> 

<snip>

>> diff --git a/Documentation/media/uapi/mediactl/request-api.rst b/Documentation/media/uapi/mediactl/request-api.rst
>> new file mode 100644
>> index 000000000000..3c49627acb72
>> --- /dev/null
>> +++ b/Documentation/media/uapi/mediactl/request-api.rst
>> @@ -0,0 +1,247 @@
>> +.. -*- coding: utf-8; mode: rst -*-
>> +
>> +.. _media-request-api:
>> +
>> +Request API
>> +===========
>> +
>> +The Request API has been designed to allow V4L2 to deal with requirements of
>> +modern devices (stateless codecs, complex camera pipelines, ...) and APIs
>> +(Android Codec v2). One such requirement is the ability for devices belonging to
>> +the same pipeline to reconfigure and collaborate closely on a per-frame basis.
>> +Another is efficient support of stateless codecs, which need per-frame controls
>> +to be set synchronously in order to be used efficiently.
> 
> I think "synchronously" would match what we could do without Request
> API (wait for 1 frame to be dequeued, set control, queue next frame,
> etc.) and it would be inefficient. Perhaps "Another is efficient
> support of stateless codecs, which need controls to be set for exact
> frames beforehand to be used efficiently."?

I went with this:

"Another is support of stateless codecs, which require controls to be applied
to specific frames (aka 'per-frame controls') in order to be used efficiently."

<snip>

>> +Once the request is fully prepared, it can be queued to the driver:
>> +
>> +.. code-block:: c
>> +
>> +       if (ioctl(req_fd, MEDIA_REQUEST_IOC_QUEUE))
>> +               return some_error;
> 
> This may suggest that it's okay to ignore the error code and just
> handle all the errors the same way. Perhaps "return some_error; /*
> check errno for exact error code */"?

I've just renamed 'some_error' to 'errno'. That makes much more sense.

<snip>

>> diff --git a/Documentation/media/uapi/mediactl/request-func-close.rst b/Documentation/media/uapi/mediactl/request-func-close.rst
>> new file mode 100644
>> index 000000000000..1195f493bf05
>> --- /dev/null
>> +++ b/Documentation/media/uapi/mediactl/request-func-close.rst
>> @@ -0,0 +1,49 @@
>> +.. SPDX-License-Identifier: GPL-2.0
>> +.. -*- coding: utf-8; mode: rst -*-
>> +
>> +.. _request-func-close:
>> +
>> +***************
>> +request close()
>> +***************
>> +
>> +Name
>> +====
>> +
>> +request-close - Close a request file descriptor
>> +
>> +
>> +Synopsis
>> +========
>> +
>> +.. code-block:: c
>> +
>> +    #include <unistd.h>
>> +
>> +
>> +.. c:function:: int close( int fd )
>> +    :name: req-close
>> +
>> +Arguments
>> +=========
>> +
>> +``fd``
>> +    File descriptor returned by :ref:`MEDIA_IOC_REQUEST_ALLOC`.
>> +
> 
> I guess for now we're not considering exchanging those between
> processes, but even then, this could be a dup()ed descriptor too.

I've kept this as-is. We never mention dup() specifically for other
APIs either and I think it is overkill to do so.

> 
>> +
>> +Description
>> +===========
>> +
>> +Closes the request file descriptor. Resources associated with the file descriptor
>> +are freed once the driver has completed the request and no longer needs to
>> +reference it.
> 
> and any other dup()s of that descriptor are closed too.

I went with this text:

"Closes the request file descriptor. Resources associated with the request
are freed once all file descriptors associated with the request are closed
and the driver has completed the request."

<snip>

>> diff --git a/Documentation/media/uapi/mediactl/request-func-poll.rst b/Documentation/media/uapi/mediactl/request-func-poll.rst
>> new file mode 100644
>> index 000000000000..930862b702ff
>> --- /dev/null
>> +++ b/Documentation/media/uapi/mediactl/request-func-poll.rst
>> @@ -0,0 +1,74 @@
>> +.. SPDX-License-Identifier: GPL-2.0
>> +.. -*- coding: utf-8; mode: rst -*-
>> +
>> +.. _request-func-poll:
>> +
>> +**************
>> +request poll()
>> +**************
>> +
>> +Name
>> +====
>> +
>> +request-poll - Wait for some event on a file descriptor
>> +
>> +
>> +Synopsis
>> +========
>> +
>> +.. code-block:: c
>> +
>> +    #include <sys/poll.h>
>> +
>> +
>> +.. c:function:: int poll( struct pollfd *ufds, unsigned int nfds, int timeout )
>> +   :name: request-poll
>> +
>> +Arguments
>> +=========
>> +
>> +``ufds``
>> +   List of FD events to be watched
>> +
>> +``nfds``
>> +   Number of FD events at the \*ufds array
>> +
>> +``timeout``
>> +   Timeout to wait for events
>> +
>> +
>> +Description
>> +===========
>> +
>> +With the :c:func:`poll() <request-func-poll>` function applications can wait
>> +for a request to complete.
>> +
>> +On success :c:func:`poll() <request-func-poll>` returns the number of file
>> +descriptors that have been selected (that is, file descriptors for which the
>> +``revents`` field of the respective struct :c:type:`pollfd`
>> +is non-zero). Request file descriptor set the ``POLLPRI`` flag in ``revents``
>> +when the request was completed.  When the function times out it returns
>> +a value of zero, on failure it returns -1 and the ``errno`` variable is
>> +set appropriately.
> 
> Should we also reserve POLLERR for error signaling purposes? Given the
> drivers being expected to apply the state gracefully and also that we
> could have a failure reported by respective buffer anyway, maybe no
> need.

Actually, POLLERR is already used. I added this paragraph:

"Attempting to poll for a request that is completed or not yet queued will
set the ``POLLERR`` flag in ``revents``."

Thanks for all your comments!

Regards,

	Hans
