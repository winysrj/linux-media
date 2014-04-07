Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:1784 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaDGJD3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Apr 2014 05:03:29 -0400
Message-ID: <534269B8.7030401@xs4all.nl>
Date: Mon, 07 Apr 2014 11:02:48 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Pawel Osciak <pawel@osciak.com>
CC: LMML <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEW PATCH 06/11] vb2: set timestamp when using write()
References: <1394486458-9836-1-git-send-email-hverkuil@xs4all.nl> <1394486458-9836-7-git-send-email-hverkuil@xs4all.nl> <CAMm-=zDr63ywzqhTPTen=8zFZamxtGOSp+jiP1Rkag0pFqE5_g@mail.gmail.com>
In-Reply-To: <CAMm-=zDr63ywzqhTPTen=8zFZamxtGOSp+jiP1Rkag0pFqE5_g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/07/2014 10:32 AM, Pawel Osciak wrote:
> On Tue, Mar 11, 2014 at 6:20 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> When using write() to write data to an output video node the vb2 core
>> should set timestamps if V4L2_BUF_FLAG_TIMESTAMP_COPY is set. Nobody
> 
> I'm confused. Shouldn't we be saving the existing timestamp from the buffer if
> V4L2_BUF_FLAG_TIMESTAMP_COPY is true, instead of getting it from
> v4l2_get_timestamp()?

When using the write() file operation the application has no way of setting the
timestamp. So it is uninitialized and the reader on the other side receives an
uninitialized (or 0, I'm not sure) timestamp. So __vb2_perform_fileio() has to
fill in a valid timestamp instead.

It's a corner case.

Regards,

	Hans

> 
>> else is able to provide this information with the write() operation.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/v4l2-core/videobuf2-core.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
>> index e38b45e..afd1268 100644
>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>> @@ -22,6 +22,7 @@
>>  #include <media/v4l2-dev.h>
>>  #include <media/v4l2-fh.h>
>>  #include <media/v4l2-event.h>
>> +#include <media/v4l2-common.h>
>>  #include <media/videobuf2-core.h>
>>
>>  static int debug;
>> @@ -2767,6 +2768,9 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
>>  {
>>         struct vb2_fileio_data *fileio;
>>         struct vb2_fileio_buf *buf;
>> +       bool set_timestamp = !read &&
>> +               (q->timestamp_flags & V4L2_BUF_FLAG_TIMESTAMP_MASK) ==
>> +               V4L2_BUF_FLAG_TIMESTAMP_COPY;
>>         int ret, index;
>>
>>         dprintk(3, "file io: mode %s, offset %ld, count %zd, %sblocking\n",
>> @@ -2868,6 +2872,8 @@ static size_t __vb2_perform_fileio(struct vb2_queue *q, char __user *data, size_
>>                 fileio->b.memory = q->memory;
>>                 fileio->b.index = index;
>>                 fileio->b.bytesused = buf->pos;
>> +               if (set_timestamp)
>> +                       v4l2_get_timestamp(&fileio->b.timestamp);
>>                 ret = vb2_internal_qbuf(q, &fileio->b);
>>                 dprintk(5, "file io: vb2_internal_qbuf result: %d\n", ret);
>>                 if (ret)
>> --
>> 1.9.0
>>
> 
> 
> 

