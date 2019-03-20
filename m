Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49124C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 10:39:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E6FD21850
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 10:39:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727738AbfCTKjv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 06:39:51 -0400
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:40595 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727647AbfCTKjv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 06:39:51 -0400
Received: from [IPv6:2001:983:e9a7:1:f1c5:c100:28a:d83e] ([IPv6:2001:983:e9a7:1:f1c5:c100:28a:d83e])
        by smtp-cloud8.xs4all.net with ESMTPA
        id 6YdPhA0UV4HFn6YdQhy06S; Wed, 20 Mar 2019 11:39:49 +0100
Subject: Re: [PATCH v5 02/23] videodev2.h: add V4L2_BUF_CAP_REQUIRES_REQUESTS
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Dafna Hirschfeld <dafna3@gmail.com>
Cc:     linux-media@vger.kernel.org, helen.koike@collabora.com,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>
References: <20190306211343.15302-1-dafna3@gmail.com>
 <20190306211343.15302-3-dafna3@gmail.com> <20190320071112.4ed71c54@coco.lan>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ca97c48b-3b7f-3c97-ec19-54469604fe79@xs4all.nl>
Date:   Wed, 20 Mar 2019 11:39:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190320071112.4ed71c54@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4wfP7DyruZLNiNS0nFW2iFf9lu5aeDTk6i7C1d2UqqQaWfFb3T2NxDSeyua2+2sCBxeTFvkXdhYyTn2MdYNKKjGQhVmsL9P5HWfgd+0cWfmeQqqR5oMqWa
 gCtbYaZ5qjbBHHjpPnTrNKKppBX+D6DV4oqoEhVxnmuX5C6NOnF6PDk6i5aXEvMfdaXbh2x8v2jkBS+CDjbmgYSBEL9wC/8w7TVBWYbjgzF2j0zXeQLR58EP
 hYD0YIGx2RlK+F79amxT7D60TPkwZYOCF6ieo0LdPseua00It3yWcHi00hDQvNImQOP7Bvpqf9C23wacz39WhFS4RInIV/OSk098JxE6k2RLWFV04hgISZgY
 vhx3Plt/GRjQ1zUg8MruCXQ1erpAOsvSwxCj0rmXh2XwovEc9FWESOZeDVoQyALcPFey5WUn
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 3/20/19 11:11 AM, Mauro Carvalho Chehab wrote:
> Em Wed,  6 Mar 2019 13:13:22 -0800
> Dafna Hirschfeld <dafna3@gmail.com> escreveu:
> 
>> From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>>
>> Add capability to indicate that requests are required instead of
>> merely supported.
> 
> Not sure if I liked this patch, and for sure it lacks a lot of documentation:
> 
> First of all, the patch description doesn't help. For example, it doesn't
> explain or mention any use case example that would require (instead of
> merely support) a request.

Stateless codecs require the use of requests (i.e. they can't function without
this).

However, right now every driver has to check for this and return an error when
an attempt is made to stream without requests.

And userspace has no way of knowing whether requests are required by the driver
as opposed to being optional.

That's what this attempts to do: show to userspace that requests are required,
and add a vb2 flag that will force the core to check this so drivers do not need
to test for it.

Currently the only drivers that would need this are cedrus and vicodec.

> 
>>
>> Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
>> ---
>>  Documentation/media/uapi/v4l/vidioc-reqbufs.rst | 4 ++++
>>  include/uapi/linux/videodev2.h                  | 1 +
>>  2 files changed, 5 insertions(+)
>>
>> diff --git a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
>> index d7faef10e39b..d42a3d9a7db3 100644
>> --- a/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
>> +++ b/Documentation/media/uapi/v4l/vidioc-reqbufs.rst
>> @@ -125,6 +125,7 @@ aborting or finishing any DMA in progress, an implicit
>>  .. _V4L2-BUF-CAP-SUPPORTS-DMABUF:
>>  .. _V4L2-BUF-CAP-SUPPORTS-REQUESTS:
>>  .. _V4L2-BUF-CAP-SUPPORTS-ORPHANED-BUFS:
>> +.. _V4L2-BUF-CAP-REQUIRES-REQUESTS:
>>  
>>  .. cssclass:: longtable
>>  
>> @@ -150,6 +151,9 @@ aborting or finishing any DMA in progress, an implicit
>>        - The kernel allows calling :ref:`VIDIOC_REQBUFS` while buffers are still
>>          mapped or exported via DMABUF. These orphaned buffers will be freed
>>          when they are unmapped or when the exported DMABUF fds are closed.
>> +    * - ``V4L2_BUF_CAP_REQUIRES_REQUESTS``
>> +      - 0x00000020
>> +      - This buffer type requires the use of :ref:`requests <media-request-api>`.
> 
> And the documentation here is really poor, as it doesn't explain what's
> the API and drivers expected behavior with regards to this flag.
> 
> I mean, if, on a new driver, requests are mandatory, what happens if a
> non-request-API aware application tries to use it? 

An error will be returned. And that error needs to be documented, I agree.

All this does is shift the check from the driver to the v4l2 core. It doesn't
change anything for userspace, except that with this capability flag userspace
can detect beforehand that requests are required.

> 
> Another thing that concerns me a lot is that people might want to add it
> to existing drivers. Well, if an application was written before the
> addition of this driver, and request API become mandatory, such app
> will stop working, if it doesn't use request API.
> At very least, it should be mentioned somewhere that existing drivers
> should never set this flag, as this would break it for existing
> userspace apps.
> 
> Still, I would prefer to not have to add something like that.

The only affected driver is the staging cedrus driver. And that will
actually crash if you try to use it without requests.

If you look at patch 3 you'll see that it just sets the flag and doesn't
remove any code that was supposed to check for use-without-requests.
That's because there never was a check and the driver would just crash.

So we're safe here.

I believe patches 1-3 make sense, but I also agree that the documentation
and commit logs can be improved.

I can either respin with updated patches 1-3, or, if you still have concerns,
drop 1-3 and repost the remainder of the series. But then I'll need to add
checks against the use of the stateless vicodec decoder without requests in
patch 21/23.

But this really doesn't belong in a driver. These checks should be done in the
vb2 core.

Regards,

	Hans

> 
> 
>>  
>>  Return Value
>>  ============
>> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
>> index 1db220da3bcc..97e6a6a968ba 100644
>> --- a/include/uapi/linux/videodev2.h
>> +++ b/include/uapi/linux/videodev2.h
>> @@ -895,6 +895,7 @@ struct v4l2_requestbuffers {
>>  #define V4L2_BUF_CAP_SUPPORTS_DMABUF	(1 << 2)
>>  #define V4L2_BUF_CAP_SUPPORTS_REQUESTS	(1 << 3)
>>  #define V4L2_BUF_CAP_SUPPORTS_ORPHANED_BUFS (1 << 4)
>> +#define V4L2_BUF_CAP_REQUIRES_REQUESTS	(1 << 5)
>>  
>>  /**
>>   * struct v4l2_plane - plane info for multi-planar buffers
> 
> 
> 
> Thanks,
> Mauro
> 

