Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4606 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbaDJGlE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Apr 2014 02:41:04 -0400
Message-ID: <53463CC9.2080502@xs4all.nl>
Date: Thu, 10 Apr 2014 08:40:09 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Pawel Osciak <pawel@osciak.com>
CC: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv2 PATCH 02/13] vb2: fix handling of data_offset and v4l2_plane.reserved[]
References: <1396876272-18222-1-git-send-email-hverkuil@xs4all.nl> <1396876272-18222-3-git-send-email-hverkuil@xs4all.nl> <CAMm-=zC=k_Cx-tmd_iPsiFmv1YXpYXKwfaR12mU9UeYHGddfLg@mail.gmail.com>
In-Reply-To: <CAMm-=zC=k_Cx-tmd_iPsiFmv1YXpYXKwfaR12mU9UeYHGddfLg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/10/2014 02:46 AM, Pawel Osciak wrote:
> Looks good to me, just a small nit below.
> 
> 
> On Mon, Apr 7, 2014 at 10:11 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> The videobuf2-core did not zero the 'planes' array in __qbuf_userptr()
>> and __qbuf_dmabuf(). That's now memset to 0. Without this the reserved
>> array in struct v4l2_plane would be non-zero, causing v4l2-compliance
>> errors.
>>
>> More serious is the fact that data_offset was not handled correctly:
>>
>> - for capture devices it was never zeroed, which meant that it was
>>   uninitialized. Unless the driver sets it it was a completely random
>>   number. With the memset above this is now fixed.
>>
>> - __qbuf_dmabuf had a completely incorrect length check that included
>>   data_offset.
>>
>> - in __fill_vb2_buffer in the DMABUF case the data_offset field was
>>   unconditionally copied from v4l2_buffer to v4l2_plane when this
>>   should only happen in the output case.
>>
>> - in the single-planar case data_offset was never correctly set to 0.
>>   The single-planar API doesn't support data_offset, so setting it
>>   to 0 is the right thing to do. This too is now solved by the memset.
>>
>> All these issues were found with v4l2-compliance.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Acked-by: Pawel Osciak <pawel@osciak.com>
> 
>> ---
>>  drivers/media/v4l2-core/videobuf2-core.c | 13 ++++---------
>>  1 file changed, 4 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
>> index f9059bb..596998e 100644
>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>> @@ -1169,8 +1169,6 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
>>                                         b->m.planes[plane].m.fd;
>>                                 v4l2_planes[plane].length =
>>                                         b->m.planes[plane].length;
>> -                               v4l2_planes[plane].data_offset =
>> -                                       b->m.planes[plane].data_offset;
>>                         }
>>                 }
>>         } else {
>> @@ -1180,10 +1178,8 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
>>                  * In videobuf we use our internal V4l2_planes struct for
>>                  * single-planar buffers as well, for simplicity.
>>                  */
>> -               if (V4L2_TYPE_IS_OUTPUT(b->type)) {
>> +               if (V4L2_TYPE_IS_OUTPUT(b->type))
>>                         v4l2_planes[0].bytesused = b->bytesused;
>> -                       v4l2_planes[0].data_offset = 0;
>> -               }
>>
>>                 if (b->memory == V4L2_MEMORY_USERPTR) {
>>                         v4l2_planes[0].m.userptr = b->m.userptr;
>> @@ -1193,9 +1189,7 @@ static void __fill_vb2_buffer(struct vb2_buffer *vb, const struct v4l2_buffer *b
>>                 if (b->memory == V4L2_MEMORY_DMABUF) {
>>                         v4l2_planes[0].m.fd = b->m.fd;
>>                         v4l2_planes[0].length = b->length;
>> -                       v4l2_planes[0].data_offset = 0;
>>                 }
>> -
>>         }
>>
>>         /* Zero flags that the vb2 core handles */
>> @@ -1238,6 +1232,7 @@ static int __qbuf_userptr(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>>         int write = !V4L2_TYPE_IS_OUTPUT(q->type);
>>         bool reacquired = vb->planes[0].mem_priv == NULL;
>>
>> +       memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
> 
> memset(planes, 0, sizeof(planes));

Should we really do this? This array is for 8 planes, whereas today we do not
have more than 2 planes worst case. So zeroing all planes for every qbuf seems
excessive to me.

I fact, looking at the code only the actual planes are copied back anyway:

        /*
         * Now that everything is in order, copy relevant information
         * provided by userspace.
         */
        for (plane = 0; plane < vb->num_planes; ++plane)
                vb->v4l2_planes[plane] = planes[plane];

so memsetting more than the actual number of planes is pointless.

Unless I am missing something?

Regards,

	Hans

> 
>>         /* Copy relevant information provided by the userspace */
>>         __fill_vb2_buffer(vb, b, planes);
>>
>> @@ -1357,6 +1352,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>>         int write = !V4L2_TYPE_IS_OUTPUT(q->type);
>>         bool reacquired = vb->planes[0].mem_priv == NULL;
>>
>> +       memset(planes, 0, sizeof(planes[0]) * vb->num_planes);
> 
> memset(planes, 0, sizeof(planes));
> 
>>         /* Copy relevant information provided by the userspace */
>>         __fill_vb2_buffer(vb, b, planes);
>>
>> @@ -1374,8 +1370,7 @@ static int __qbuf_dmabuf(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>>                 if (planes[plane].length == 0)
>>                         planes[plane].length = dbuf->size;
>>
>> -               if (planes[plane].length < planes[plane].data_offset +
>> -                   q->plane_sizes[plane]) {
>> +               if (planes[plane].length < q->plane_sizes[plane]) {
>>                         dprintk(1, "qbuf: invalid dmabuf length for plane %d\n",
>>                                 plane);
>>                         ret = -EINVAL;
>> --
>> 1.9.1
>>
> 
> 
> 

