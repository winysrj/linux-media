Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:35328 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751679AbeBUGB6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 01:01:58 -0500
Received: by mail-it0-f67.google.com with SMTP id v194so980660itb.0
        for <linux-media@vger.kernel.org>; Tue, 20 Feb 2018 22:01:58 -0800 (PST)
Received: from mail-io0-f181.google.com (mail-io0-f181.google.com. [209.85.223.181])
        by smtp.gmail.com with ESMTPSA id f193sm5770477ita.27.2018.02.20.22.01.57
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Feb 2018 22:01:57 -0800 (PST)
Received: by mail-io0-f181.google.com with SMTP id t22so920276iob.3
        for <linux-media@vger.kernel.org>; Tue, 20 Feb 2018 22:01:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5b0fcac9-18e1-433f-7977-2a90f3d961f8@xs4all.nl>
References: <20180220044425.169493-1-acourbot@chromium.org>
 <20180220044425.169493-12-acourbot@chromium.org> <5b0fcac9-18e1-433f-7977-2a90f3d961f8@xs4all.nl>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Wed, 21 Feb 2018 15:01:36 +0900
Message-ID: <CAPBb6MVAKKjStJoaa7QJJc+Ay7kgYRbYsgchf5Sr+HrY7rOAsA@mail.gmail.com>
Subject: Re: [RFCv4 11/21] media: v4l2_fh: add request entity field
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 21, 2018 at 12:24 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 02/20/18 05:44, Alexandre Courbot wrote:
>> Allow drivers to assign a request entity to v4l2_fh. This will be useful
>> for request-aware ioctls to find out which request entity to use.
>>
>> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
>> ---
>>  include/media/v4l2-fh.h | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/include/media/v4l2-fh.h b/include/media/v4l2-fh.h
>> index ea73fef8bdc0..f54cb319dd64 100644
>> --- a/include/media/v4l2-fh.h
>> +++ b/include/media/v4l2-fh.h
>> @@ -28,6 +28,7 @@
>>
>>  struct video_device;
>>  struct v4l2_ctrl_handler;
>> +struct media_request_entity;
>>
>>  /**
>>   * struct v4l2_fh - Describes a V4L2 file handler
>> @@ -43,6 +44,7 @@ struct v4l2_ctrl_handler;
>>   * @navailable: number of available events at @available list
>>   * @sequence: event sequence number
>>   * @m2m_ctx: pointer to &struct v4l2_m2m_ctx
>> + * @entity: the request entity this fh operates on behalf of
>>   */
>>  struct v4l2_fh {
>>       struct list_head        list;
>> @@ -60,6 +62,7 @@ struct v4l2_fh {
>>  #if IS_ENABLED(CONFIG_V4L2_MEM2MEM_DEV)
>>       struct v4l2_m2m_ctx     *m2m_ctx;
>>  #endif
>> +     struct media_request_entity *entity;
>
> The name 'media_request_entity' is very confusing.
>
> In the media controller API terminology an entity represents a piece
> of hardware with inputs and outputs (very rough description), but a
> request is not an entity. It may be associated with an entity, though.
>
> So calling this field 'entity' is also very misleading.

Note that this field is not a request though, it is a pointer to a
piece of hardware referenced by a request, which is closer to the MC
terminology. Or do you mean this should just be renamed
"request_entity"?

If we go all the way, the media_ prefix is also misleading - it
implies a dependency to the media controller framework, while there is
none (in this patchset at least).

However I thought that 'request' alone (instead of media_request) may
name-conflict with something else, and since 'media' is also the
umbrella term for anything under drivers/media it sounds fitting on
the other hand. Suggestions are welcome though.

>
> As with previous patches, I'll have to think about this and try and
> come up with better, less confusing names.

I will gladly take suggestions, have been trying to come with a better
name to reply to your comment above but could not find any. :)
