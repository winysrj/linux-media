Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:52335 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750735AbeBBGCy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Feb 2018 01:02:54 -0500
Received: by mail-it0-f65.google.com with SMTP id u62so7192242ita.2
        for <linux-media@vger.kernel.org>; Thu, 01 Feb 2018 22:02:54 -0800 (PST)
Received: from mail-io0-f174.google.com (mail-io0-f174.google.com. [209.85.223.174])
        by smtp.gmail.com with ESMTPSA id c9sm811571iod.5.2018.02.01.22.02.52
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Feb 2018 22:02:53 -0800 (PST)
Received: by mail-io0-f174.google.com with SMTP id l17so21806050ioc.3
        for <linux-media@vger.kernel.org>; Thu, 01 Feb 2018 22:02:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <d23317ee-af0d-3fe8-cbfb-cff01f9d82b8@infradead.org>
References: <20180131102427.207721-1-acourbot@chromium.org>
 <20180131102427.207721-6-acourbot@chromium.org> <d23317ee-af0d-3fe8-cbfb-cff01f9d82b8@infradead.org>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Fri, 2 Feb 2018 15:02:31 +0900
Message-ID: <CAPBb6MVpHLeJneBfS0LLYTO3iSk5cOXZYjGySXzab5xYDjgMNA@mail.gmail.com>
Subject: Re: [RFCv2 05/17] media: Document the media request API
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Randy,

On Fri, Feb 2, 2018 at 3:14 AM, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 01/31/2018 02:24 AM, Alexandre Courbot wrote:
>> From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
>>
>> The media request API is made of a new ioctl to implement request
>> management. Document it.
>>
>> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
>> [acourbot@chromium.org: adapt for newest API]
>> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
>> ---
>>  Documentation/media/uapi/mediactl/media-funcs.rst  |   1 +
>>  .../media/uapi/mediactl/media-ioc-request-cmd.rst  | 141 +++++++++++++++++++++
>>  2 files changed, 142 insertions(+)
>>  create mode 100644 Documentation/media/uapi/mediactl/media-ioc-request-cmd.rst
>>
>> diff --git a/Documentation/media/uapi/mediactl/media-funcs.rst b/Documentation/media/uapi/mediactl/media-funcs.rst
>> index 076856501cdb..e3a45d82ffcb 100644
>> --- a/Documentation/media/uapi/mediactl/media-funcs.rst
>> +++ b/Documentation/media/uapi/mediactl/media-funcs.rst
>> @@ -15,4 +15,5 @@ Function Reference
>>      media-ioc-g-topology
>>      media-ioc-enum-entities
>>      media-ioc-enum-links
>> +    media-ioc-request-cmd
>>      media-ioc-setup-link
>> diff --git a/Documentation/media/uapi/mediactl/media-ioc-request-cmd.rst b/Documentation/media/uapi/mediactl/media-ioc-request-cmd.rst
>> new file mode 100644
>> index 000000000000..723b422afcce
>> --- /dev/null
>> +++ b/Documentation/media/uapi/mediactl/media-ioc-request-cmd.rst
>> @@ -0,0 +1,141 @@
>> +.. -*- coding: utf-8; mode: rst -*-
>> +
>> +.. _media_ioc_request_cmd:
>> +
>> +***************************
>> +ioctl MEDIA_IOC_REQUEST_CMD
>> +***************************
>> +
>> +Name
>> +====
>> +
>> +MEDIA_IOC_REQUEST_CMD - Manage media device requests
>> +
>> +
>> +Synopsis
>> +========
>> +
>> +.. c:function:: int ioctl( int fd, MEDIA_IOC_REQUEST_CMD, struct media_request_cmd *argp )
>> +    :name: MEDIA_IOC_REQUEST_CMD
>> +
>> +
>> +Arguments
>> +=========
>> +
>> +``fd``
>> +    File descriptor returned by :ref:`open() <media-func-open>`.
>> +
>> +``argp``
>> +
>> +
>> +Description
>> +===========
>> +
>> +The MEDIA_IOC_REQUEST_CMD ioctl allow applications to manage media device
>
>                                    allows
>
>> +requests. A request is an object that can group media device configuration
>> +parameters, including subsystem-specific parameters, in order to apply all the
>> +parameters atomically. Applications are responsible for allocating and
>> +deleting requests, filling them with configuration parameters submitting them.
>
>                                                                 and submitting them.
>
>> +
>> +Request operations are performed by calling the MEDIA_IOC_REQUEST_CMD ioctl
>> +with a pointer to a struct :c:type:`media_request_cmd` with the cmd field set
>> +to the appropriate command. :ref:`media-request-command` lists the commands
>> +supported by the ioctl.
>> +
>> +The struct :c:type:`media_request_cmd` request field contains the file
>> +descriptorof the request on which the command operates. For the
>
>    descriptor of
>
>> +``MEDIA_REQ_CMD_ALLOC`` command the field is set to zero by applications and
>> +filled by the driver. For all other commands the field is set by applications
>> +and left untouched by the driver.
>> +
>> +To allocate a new request applications use the ``MEDIA_REQ_CMD_ALLOC``
>> +command. The driver will allocate a new request and return its FD in the
>> +request field. After allocation, the request is "empty", which means that it
>> +does not hold any state of its own, and that the hardware's state will not be
>> +affected by it unless it is passed as argument to V4L2 or media controller
>> +commands.
>> +
>> +Requests are reference-counted. A newly allocated request is referenced
>> +by the returned file descriptor, and can be later referenced by
>> +subsystem-specific operations. Requests will thus be automatically deleted
>> +when they're not longer used after the returned file descriptor is closed.
>
>                  no longer
>
>> +
>> +If a request isn't needed applications can delete it by calling ``close()``
>> +on it. The driver will drop the file handle reference. The request will not
>> +be usable through the MEDIA_IOC_REQUEST_CMD ioctl anymore, but will only be
>> +deleted when the last reference is released. If no other reference exists when
>> +``close()`` is invoked the request will be deleted immediately.
>> +
>> +After creating a request applications should fill it with configuration
>> +parameters. This is performed through subsystem-specific request APIs outside
>> +the scope of the media controller API. See the appropriate subsystem APIs for
>> +more information, including how they interact with the MEDIA_IOC_REQUEST_CMD
>> +ioctl.
>> +
>> +Once a request contains all the desired configuration parameters it can be
>> +submitted using the ``MEDIA_REQ_CMD_SUBMIT`` command. This will let the
>> +buffers queued for the request be passed to their respective drivers, which
>> +will then apply the request's parameters before processing them.
>> +
>> +Once a request has been queued applications are not allowed to modify its
>> +configuration parameters until the request has been fully processed. Any
>> +attempt to do so will result in the related subsystem API returning an error.
>> +The application that submitted the request can wait for its completion by
>> +polling on the request's file descriptor.
>> +
>> +Once a request has completed, it can be reused. The ``MEDIA_REQ_CMD_REINIT``
>> +command will bring it back to its initial state, so it can be prepared and
>> +submitted again.
>> +
>> +.. c:type:: media_request_cmd
>> +
>> +.. flat-table:: struct media_request_cmd
>> +    :header-rows:  0
>> +    :stub-columns: 0
>> +    :widths: 1 2 8
>> +
>> +    * - __u32
>> +      - ``cmd``
>> +      - Command, set by the application. See below for the list of supported
>> +        commands.
>> +    * - __u32
>> +      - ``fd``
>> +      - Request FD, set by the driver for the MEDIA_REQ_CMD_ALLOC command and
>> +        by the application for all other commands.
>> +
>> +
>> +.. _media-request-command:
>> +
>> +.. cssclass:: longtable
>> +
>> +.. flat-table:: Media request commands
>> +    :header-rows:  0
>> +    :stub-columns: 0
>> +
>> +    * .. _MEDIA-REQ-CMD-ALLOC:
>> +
>> +      - ``MEDIA_REQ_CMD_ALLOC``
>> +      - Allocate a new request.
>> +    * .. _MEDIA-REQ-CMD-SUBMIT:
>> +
>> +      - ``MEDIA_REQ_CMD_SUBMIT``
>> +      - Submit a request to be processed.
>> +    * .. _MEDIA-REQ-CMD-QUEUE:
>> +
>> +      - ``MEDIA_REQ_CMD_REINIT``
>> +      - Reinitializes a completed request.
>
>            Reinitialize
> to be consistent with other entries above.

Applied all these fixes, thanks!
