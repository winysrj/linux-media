Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:52586 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754845AbeDWMvz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 08:51:55 -0400
Subject: Re: [RFCv11 PATCH 22/29] videobuf2-v4l2: add vb2_request_queue helper
To: Tomasz Figa <tfiga@google.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
 <20180409142026.19369-23-hverkuil@xs4all.nl>
 <CAAFQd5Ckqhb2qEBdsBfG2iKTE4G76PFPep5KhEDJA=1m4wFA5Q@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <0c57a039-a732-b70f-7e10-1dfaf697a20d@xs4all.nl>
Date: Mon, 23 Apr 2018 14:51:50 +0200
MIME-Version: 1.0
In-Reply-To: <CAAFQd5Ckqhb2qEBdsBfG2iKTE4G76PFPep5KhEDJA=1m4wFA5Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/12/2018 10:29 AM, Tomasz Figa wrote:
> On Mon, Apr 9, 2018 at 11:20 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
> 
>> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
>> Generic helper function that checks if there are buffers in
>> the request and if so, prepares and queues all objects in the
>> request.
> 
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>   drivers/media/common/videobuf2/videobuf2-v4l2.c | 39
> +++++++++++++++++++++++++
>>   include/media/videobuf2-v4l2.h                  |  3 ++
>>   2 files changed, 42 insertions(+)
> 
>> diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c
> b/drivers/media/common/videobuf2/videobuf2-v4l2.c
>> index 73c1fd4da58a..3d0c74bb4220 100644
>> --- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
>> +++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
>> @@ -1061,6 +1061,45 @@ void vb2_ops_wait_finish(struct vb2_queue *vq)
>>   }
>>   EXPORT_SYMBOL_GPL(vb2_ops_wait_finish);
> 
>> +int vb2_request_queue(struct media_request *req)
>> +{
>> +       struct media_request_object *obj;
>> +       struct media_request_object *failed_obj = NULL;
>> +       int ret = 0;
>> +
>> +       if (!vb2_core_request_has_buffers(req))
>> +               return -ENOENT;
>> +
>> +       list_for_each_entry(obj, &req->objects, list) {
>> +               if (!obj->ops->prepare)
>> +                       continue;
>> +
>> +               ret = obj->ops->prepare(obj);
>> +
>> +               if (ret) {
>> +                       failed_obj = obj;
>> +                       break;
>> +               }
>> +       }
>> +
>> +       if (ret) {
>> +               list_for_each_entry(obj, &req->objects, list) {
>> +                       if (obj == failed_obj)
>> +                               break;
> 
> nit: If we use list_for_each_entry_continue_reverse() here, we wouldn't
> need failed_obj.

True. Done.

	Hans

> 
> Best regards,
> Tomasz
> 
