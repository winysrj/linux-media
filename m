Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:45960 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab1GTDlk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2011 23:41:40 -0400
Received: by qyk9 with SMTP id 9so2783932qyk.19
        for <linux-media@vger.kernel.org>; Tue, 19 Jul 2011 20:41:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <00c901cc4514$26629880$7327c980$%szyprowski@samsung.com>
References: <1310549944-23756-1-git-send-email-hverkuil@xs4all.nl>
 <7fc8ed81f08a0ac8092c5b6a8badc3427df9bc1e.1310549521.git.hans.verkuil@cisco.com>
 <00c901cc4514$26629880$7327c980$%szyprowski@samsung.com>
From: Pawel Osciak <pawel@osciak.com>
Date: Tue, 19 Jul 2011 20:41:19 -0700
Message-ID: <CAMm-=zBWGqONGY=nv=W25=Y-Cu_Ls49gnRbfvxTUigkwCXDQCw@mail.gmail.com>
Subject: Re: [RFCv1 PATCH 3/6] videobuf2: only start streaming in poll() if so
 requested by the poll mask.
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Sun, Jul 17, 2011 at 23:30, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
> Hello,
>
> On Wednesday, July 13, 2011 11:39 AM Hans Verkuil wrote:
>
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>
> Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
>

Acked-by: Pawel Osciak <pawel@osciak.com>

I have to say, this is cool stuff!
Pawel

>> ---
>>  drivers/media/video/videobuf2-core.c |    7 +++++--
>>  1 files changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/media/video/videobuf2-core.c
>> b/drivers/media/video/videobuf2-core.c
>> index 3015e60..1892bb8 100644
>> --- a/drivers/media/video/videobuf2-core.c
>> +++ b/drivers/media/video/videobuf2-core.c
>> @@ -1365,6 +1365,7 @@ static int __vb2_cleanup_fileio(struct vb2_queue *q);
>>   */
>>  unsigned int vb2_poll(struct vb2_queue *q, struct file *file, poll_table
>> *wait)
>>  {
>> +     unsigned long req_events = poll_requested_events(wait);
>>       unsigned long flags;
>>       unsigned int ret;
>>       struct vb2_buffer *vb = NULL;
>> @@ -1373,12 +1374,14 @@ unsigned int vb2_poll(struct vb2_queue *q, struct
>> file *file, poll_table *wait)
>>        * Start file I/O emulator only if streaming API has not been used
>> yet.
>>        */
>>       if (q->num_buffers == 0 && q->fileio == NULL) {
>> -             if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ))
>> {
>> +             if (!V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_READ)
>> &&
>> +                             (req_events & (POLLIN | POLLRDNORM))) {
>>                       ret = __vb2_init_fileio(q, 1);
>>                       if (ret)
>>                               return POLLERR;
>>               }
>> -             if (V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_WRITE))
>> {
>> +             if (V4L2_TYPE_IS_OUTPUT(q->type) && (q->io_modes & VB2_WRITE)
>> &&
>> +                             (req_events & (POLLOUT | POLLWRNORM))) {
>>                       ret = __vb2_init_fileio(q, 0);
>>                       if (ret)
>>                               return POLLERR;
>> --
>
> Best regards
> --
> Marek Szyprowski
> Samsung Poland R&D Center
>
>
>
>



-- 
Best regards,
Pawel Osciak
