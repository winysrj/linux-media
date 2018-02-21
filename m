Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:46621 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751649AbeBUGBx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Feb 2018 01:01:53 -0500
Received: by mail-io0-f196.google.com with SMTP id p78so889366iod.13
        for <linux-media@vger.kernel.org>; Tue, 20 Feb 2018 22:01:53 -0800 (PST)
Received: from mail-io0-f171.google.com (mail-io0-f171.google.com. [209.85.223.171])
        by smtp.gmail.com with ESMTPSA id f192sm5739299ioe.76.2018.02.20.22.01.52
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 20 Feb 2018 22:01:52 -0800 (PST)
Received: by mail-io0-f171.google.com with SMTP id m22so894197iob.12
        for <linux-media@vger.kernel.org>; Tue, 20 Feb 2018 22:01:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <eac9e222-b605-77b6-4428-66e20f3d1269@xs4all.nl>
References: <20180220044425.169493-1-acourbot@chromium.org>
 <20180220044425.169493-11-acourbot@chromium.org> <eac9e222-b605-77b6-4428-66e20f3d1269@xs4all.nl>
From: Alexandre Courbot <acourbot@chromium.org>
Date: Wed, 21 Feb 2018 15:01:31 +0900
Message-ID: <CAPBb6MXFTfG2zrK0eU0J6ibdmVqQJH8T6TN2uBhjTRagbzC+yA@mail.gmail.com>
Subject: Re: [RFCv4 10/21] videodev2.h: Add request_fd field to v4l2_buffer
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pawel Osciak <posciak@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Gustavo Padovan <gustavo.padovan@collabora.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 21, 2018 at 12:20 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On 02/20/18 05:44, Alexandre Courbot wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> When queuing buffers allow for passing the request that should
>> be associated with this buffer.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> [acourbot@chromium.org: make request ID 32-bit]
>> Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
>> ---
>>  drivers/media/common/videobuf2/videobuf2-v4l2.c | 2 +-
>>  drivers/media/usb/cpia2/cpia2_v4l.c             | 2 +-
>>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c   | 9 ++++++---
>>  drivers/media/v4l2-core/v4l2-ioctl.c            | 4 ++--
>>  include/uapi/linux/videodev2.h                  | 3 ++-
>>  5 files changed, 12 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
>> index 886a2d8d5c6c..6d4d184aa68e 100644
>> --- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
>> +++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
>> @@ -203,7 +203,7 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, void *pb)
>>       b->timestamp = ns_to_timeval(vb->timestamp);
>>       b->timecode = vbuf->timecode;
>>       b->sequence = vbuf->sequence;
>> -     b->reserved2 = 0;
>> +     b->request_fd = 0;
>>       b->reserved = 0;
>>
>>       if (q->is_multiplanar) {
>> diff --git a/drivers/media/usb/cpia2/cpia2_v4l.c b/drivers/media/usb/cpia2/cpia2_v4l.c
>> index 99f106b13280..af42ce3ceb48 100644
>> --- a/drivers/media/usb/cpia2/cpia2_v4l.c
>> +++ b/drivers/media/usb/cpia2/cpia2_v4l.c
>> @@ -948,7 +948,7 @@ static int cpia2_dqbuf(struct file *file, void *fh, struct v4l2_buffer *buf)
>>       buf->sequence = cam->buffers[buf->index].seq;
>>       buf->m.offset = cam->buffers[buf->index].data - cam->frame_buffer;
>>       buf->length = cam->frame_size;
>> -     buf->reserved2 = 0;
>> +     buf->request_fd = 0;
>>       buf->reserved = 0;
>>       memset(&buf->timecode, 0, sizeof(buf->timecode));
>>
>> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
>> index 5198c9eeb348..32bf47489a2e 100644
>> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
>> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
>> @@ -386,7 +386,7 @@ struct v4l2_buffer32 {
>>               __s32           fd;
>>       } m;
>>       __u32                   length;
>> -     __u32                   reserved2;
>> +     __s32                   request_fd;
>>       __u32                   reserved;
>>  };
>>
>> @@ -486,6 +486,7 @@ static int get_v4l2_buffer32(struct v4l2_buffer __user *kp,
>>  {
>>       u32 type;
>>       u32 length;
>> +     s32 request_fd;
>>       enum v4l2_memory memory;
>>       struct v4l2_plane32 __user *uplane32;
>>       struct v4l2_plane __user *uplane;
>> @@ -500,7 +501,9 @@ static int get_v4l2_buffer32(struct v4l2_buffer __user *kp,
>>           get_user(memory, &up->memory) ||
>>           put_user(memory, &kp->memory) ||
>>           get_user(length, &up->length) ||
>> -         put_user(length, &kp->length))
>> +         put_user(length, &kp->length) ||
>> +         get_user(request_fd, &up->request_fd) ||
>> +         put_user(request_fd, &kp->request_fd))
>>               return -EFAULT;
>>
>>       if (V4L2_TYPE_IS_OUTPUT(type))
>> @@ -604,7 +607,7 @@ static int put_v4l2_buffer32(struct v4l2_buffer __user *kp,
>>           assign_in_user(&up->timestamp.tv_usec, &kp->timestamp.tv_usec) ||
>>           copy_in_user(&up->timecode, &kp->timecode, sizeof(kp->timecode)) ||
>>           assign_in_user(&up->sequence, &kp->sequence) ||
>> -         assign_in_user(&up->reserved2, &kp->reserved2) ||
>> +         assign_in_user(&up->request_fd, &kp->request_fd) ||
>>           assign_in_user(&up->reserved, &kp->reserved) ||
>>           get_user(length, &kp->length) ||
>>           put_user(length, &up->length))
>> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
>> index 260288ca4f55..7bfeaf233d5a 100644
>> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
>> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
>> @@ -437,13 +437,13 @@ static void v4l_print_buffer(const void *arg, bool write_only)
>>       const struct v4l2_plane *plane;
>>       int i;
>>
>> -     pr_cont("%02ld:%02d:%02d.%08ld index=%d, type=%s, flags=0x%08x, field=%s, sequence=%d, memory=%s",
>> +     pr_cont("%02ld:%02d:%02d.%08ld index=%d, type=%s, request_fd=%u, flags=0x%08x, field=%s, sequence=%d, memory=%s",
>>                       p->timestamp.tv_sec / 3600,
>>                       (int)(p->timestamp.tv_sec / 60) % 60,
>>                       (int)(p->timestamp.tv_sec % 60),
>>                       (long)p->timestamp.tv_usec,
>>                       p->index,
>> -                     prt_names(p->type, v4l2_type_names),
>> +                     prt_names(p->type, v4l2_type_names), p->request_fd,
>>                       p->flags, prt_names(p->field, v4l2_field_names),
>>                       p->sequence, prt_names(p->memory, v4l2_memory_names));
>>
>> diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
>> index 982718965180..4fd46ae8fad5 100644
>> --- a/include/uapi/linux/videodev2.h
>> +++ b/include/uapi/linux/videodev2.h
>> @@ -909,6 +909,7 @@ struct v4l2_plane {
>>   * @length:  size in bytes of the buffer (NOT its payload) for single-plane
>>   *           buffers (when type != *_MPLANE); number of elements in the
>>   *           planes array for multi-plane buffers
>> + * @request_fd: fd of the request that this buffer should use
>>   *
>>   * Contains data exchanged by application and driver using one of the Streaming
>>   * I/O methods.
>> @@ -932,7 +933,7 @@ struct v4l2_buffer {
>>               __s32           fd;
>>       } m;
>>       __u32                   length;
>> -     __u32                   reserved2;
>> +     __s32                   request_fd;
>
> This should be:
>
>         union {
>                 __s32           request_fd;
>                 __u32           reserved2;
>         };
>
> Otherwise any existing application that sets 'reserved2 = 0;' would fail.
> I encountered this issue when compiling v4l-utils.

Fixed, thanks!
