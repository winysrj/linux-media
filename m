Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48226 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728597AbeHOKib (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Aug 2018 06:38:31 -0400
Date: Tue, 7 Aug 2018 01:44:36 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
        Alexandre Courbot <acourbot@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv17 01/34] Documentation: v4l: document request API
Message-ID: <20180806234436.GA28093@xo-6d-61-c0.localdomain>
References: <20180804124526.46206-1-hverkuil@xs4all.nl>
 <20180804124526.46206-2-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180804124526.46206-2-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

> Document the request API for V4L2 devices, and amend the documentation
> of system calls influenced by it.
> 
> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Cc documentation people?

> +Synopsis
> +========
> +
> +.. c:function:: int ioctl( int request_fd, MEDIA_REQUEST_IOC_QUEUE )
> +    :name: MEDIA_REQUEST_IOC_QUEUE
> +
> +
> +Arguments
> +=========
> +
> +``request_fd``
> +    File descriptor returned by :ref:`MEDIA_IOC_REQUEST_ALLOC`.
> +
> +
> +Description
> +===========
> +
> +If the media device supports :ref:`requests <media-request-api>`, then
> +this request ioctl can be used to queue a previously allocated request.
> +
> +If the request was successfully queued, then the file descriptor can be
> +:ref:`polled <request-func-poll>` to wait for the request to complete.

> +
> +If the request was already queued before, then ``EBUSY`` is returned.

I'd expect -1 to be returned and errno set to EBUSY?

> +============
> +
> +On success 0 is returned, on error -1 and the ``errno`` variable is set
> +appropriately. The generic error codes are described at the
> +:ref:`Generic Error Codes <gen-errors>` chapter.
> +
> +EBUSY
> +    The request was already queued.
> +EPERM
> +    The application queued the first buffer directly, but later attempted
> +    to use a request. It is not permitted to mix the two APIs.
> +ENOENT
> +    The request did not contain any buffers. All requests are required
> +    to have at least one buffer. This can also be returned if required
> +    controls are missing.
> +ENOMEM
> +    Out of memory when allocating internal data structures for this
> +    request.
> +EINVAL
> +    The request has invalid data.
> +EIO
> +    The hardware is in a bad state. To recover, the application needs to
> +    stop streaming to reset the hardware state and then try to restart
> +    streaming.

										Pavel
