Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f175.google.com ([209.85.217.175]:45498 "EHLO
        mail-ua0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751730AbeCVOu5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Mar 2018 10:50:57 -0400
Received: by mail-ua0-f175.google.com with SMTP id x17so5716074uaj.12
        for <linux-media@vger.kernel.org>; Thu, 22 Mar 2018 07:50:56 -0700 (PDT)
Received: from mail-ua0-f181.google.com (mail-ua0-f181.google.com. [209.85.217.181])
        by smtp.gmail.com with ESMTPSA id 66sm1952612vkn.55.2018.03.22.07.50.55
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Mar 2018 07:50:55 -0700 (PDT)
Received: by mail-ua0-f181.google.com with SMTP id w3so5731155uae.5
        for <linux-media@vger.kernel.org>; Thu, 22 Mar 2018 07:50:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAFQd5DQ1iH6XA1DvJ3vi4MZejqza1Yjcxxp_HDfu5eDD9f3jw@mail.gmail.com>
References: <aa5f4986-7cb3-ec85-203d-e1afa644d769@xs4all.nl> <CAAFQd5DQ1iH6XA1DvJ3vi4MZejqza1Yjcxxp_HDfu5eDD9f3jw@mail.gmail.com>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 22 Mar 2018 23:50:34 +0900
Message-ID: <CAAFQd5D-Xcpsqg5QjOLcJAgbip_VS31DPfLsZCyzhpJMdiyh0A@mail.gmail.com>
Subject: Re: [RFC] Request API
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Mar 22, 2018 at 11:47 PM, Tomasz Figa <tfiga@chromium.org> wrote:
> Hi Hans,
>
> On Thu, Mar 22, 2018 at 11:18 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> - If due to performance reasons we will have to allocate/queue/reinit multiple
>>   requests with a single ioctl, then we will have to add new ioctls to the
>>   media device. At this moment in time it is not clear that this is really
>>   needed and it certainly isn't needed for the stateless codec support that
>>   we are looking at now.
>
> An alternative, maybe a bit crazy, idea would be to allow adding
> MEDIA_REQUEST_IOC_QUEUE ioctl to the request itself. This would be
> similar to the idea of indirect command buffers in the graphics (GPU)
> land. It could for example look like this:
>
> // One time initialization
> bulk_fd = ioctl(..., MEDIA_IOC_REQUEST_ALLOC, ...);
> for (i = 0; i < N; ++i) {
>     fd[i] = ioctl(..., MEDIA_IOC_REQUEST_ALLOC, ...);
>     // Add some state
>     ioctl(fd[i], MEDIA_IOC_REQUEST_QUEUE, { .request = bulk_fd });
> }
>
> // Do some work
>
> ioctl(bulk_fd, MEDIA_IOC_REQUEST_QUEUE); // Queues all the requests at once

Forgot to mention that this could be easily added on top of the simple
UAPI, so the added advantage would be the ability to start with
something simple and then extend with this functionality, if it is
really necessary.

Best regards,
Tomasz
