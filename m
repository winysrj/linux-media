Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud9.xs4all.net ([194.109.24.30]:42006 "EHLO
        lb3-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726108AbeIDOBA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 4 Sep 2018 10:01:00 -0400
Subject: Re: [PATCHv4 09/10] media-request: EPERM -> EACCES/EBUSY
To: Tomasz Figa <tfiga@chromium.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20180904075850.2406-1-hverkuil@xs4all.nl>
 <20180904075850.2406-10-hverkuil@xs4all.nl>
 <CAAFQd5BZ_OVXGyNS7+0h07f7uun45NSitnWegKj20QcdcoqyNg@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <6d1572b8-bcc6-f89b-3cf5-2c29f22b6832@xs4all.nl>
Date: Tue, 4 Sep 2018 11:36:37 +0200
MIME-Version: 1.0
In-Reply-To: <CAAFQd5BZ_OVXGyNS7+0h07f7uun45NSitnWegKj20QcdcoqyNg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/04/18 10:21, Tomasz Figa wrote:
> On Tue, Sep 4, 2018 at 4:59 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> If requests are not supported by the driver, then return EACCES, not
>> EPERM.
>>
>> If you attempt to mix queueing buffers directly and using requests,
>> then EBUSY is returned instead of EPERM: once a specific queueing mode
>> has been chosen the queue is 'busy' if you attempt the other mode
>> (i.e. direct queueing vs via a request).
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  .../uapi/mediactl/media-request-ioc-queue.rst  |  9 ++++-----
>>  .../media/uapi/mediactl/request-api.rst        |  4 ++--
>>  Documentation/media/uapi/v4l/buffer.rst        |  2 +-
>>  .../media/uapi/v4l/vidioc-g-ext-ctrls.rst      |  9 ++++-----
>>  Documentation/media/uapi/v4l/vidioc-qbuf.rst   | 18 ++++++++++--------
>>  .../media/common/videobuf2/videobuf2-core.c    |  2 +-
>>  .../media/common/videobuf2/videobuf2-v4l2.c    |  9 ++++++---
>>  drivers/media/media-request.c                  |  4 ++--
>>  include/media/media-request.h                  |  6 +++---
>>  9 files changed, 33 insertions(+), 30 deletions(-)
> [snip]
>> diff --git a/include/media/media-request.h b/include/media/media-request.h
>> index d8c8db89dbde..0ce75c35131f 100644
>> --- a/include/media/media-request.h
>> +++ b/include/media/media-request.h
>> @@ -198,8 +198,8 @@ void media_request_put(struct media_request *req);
>>   * Get the request represented by @request_fd that is owned
>>   * by the media device.
>>   *
>> - * Return a -EPERM error pointer if requests are not supported
>> - * by this driver. Return -ENOENT if the request was not found.
>> + * Return a -EACCES error pointer if requests are not supported
>> + * by this driver. Return -EINVAL if the request was not found.
> 
> I think the bottom-most line belongs to patch 1/10. With that fixed
> (possibly when applying):

Correct, I moved that to patch 1.

> 
> Reviewed-by: Tomasz Figa <tfiga@chromium.org>

Thanks!

	Hans

> 
> Best regards,
> Tomasz
> 
