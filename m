Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1890 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754315AbaDKHnA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Apr 2014 03:43:00 -0400
Message-ID: <53479CD6.4040502@xs4all.nl>
Date: Fri, 11 Apr 2014 09:42:14 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, pawel@osciak.com,
	s.nawrocki@samsung.com, m.szyprowski@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEW PATCH 10/11] vb2: set v4l2_buffer.bytesused to 0 for
 mp buffers
References: <1394486458-9836-1-git-send-email-hverkuil@xs4all.nl> <1394486458-9836-11-git-send-email-hverkuil@xs4all.nl> <20140409172128.GA7530@valkosipuli.retiisi.org.uk>
In-Reply-To: <20140409172128.GA7530@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/09/2014 07:21 PM, Sakari Ailus wrote:
> Hi Hans,
> 
> Thanks for the set.
> 
> On Mon, Mar 10, 2014 at 10:20:57PM +0100, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> The bytesused field of struct v4l2_buffer is not used for multiplanar
>> formats, so just zero it to prevent it from having some random value.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/v4l2-core/videobuf2-core.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
>> index f68a60f..54a4150 100644
>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>> @@ -583,6 +583,7 @@ static void __fill_v4l2_buffer(struct vb2_buffer *vb, struct v4l2_buffer *b)
>>  		 * for it. The caller has already verified memory and size.
>>  		 */
>>  		b->length = vb->num_planes;
>> +		b->bytesused = 0;
> 
> I wonder if I'm missing something, but doesn't the value of the field come
> from the v4l2_buf field of the vb2_buffer which is allocated using kzalloc()
> in __vb2_queue_alloc(), and never changed afterwards?

You are right, this isn't necessary. I've dropped this patch.

Thanks!

	Hans

> 
>>  		memcpy(b->m.planes, vb->v4l2_planes,
>>  			b->length * sizeof(struct v4l2_plane));
>>  	} else {
> 

