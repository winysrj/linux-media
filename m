Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:37859 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751974AbaKRJpT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Nov 2014 04:45:19 -0500
Message-ID: <546B1506.9030701@xs4all.nl>
Date: Tue, 18 Nov 2014 10:44:38 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Pawel Osciak <pawel@osciak.com>
CC: LMML <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hansverk@cisco.com>
Subject: Re: [RFCv6 PATCH 08/16] vb2-vmalloc: add support for dmabuf exports
References: <1415623771-29634-1-git-send-email-hverkuil@xs4all.nl> <1415623771-29634-9-git-send-email-hverkuil@xs4all.nl> <CAMm-=zC2OSgJoLiELtyqEGzt+LwOLfirvkk9GgE3Q24y2WXafg@mail.gmail.com>
In-Reply-To: <CAMm-=zC2OSgJoLiELtyqEGzt+LwOLfirvkk9GgE3Q24y2WXafg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/18/14 10:34, Pawel Osciak wrote:
> On Mon, Nov 10, 2014 at 8:49 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> From: Hans Verkuil <hansverk@cisco.com>
>>
>> Add support for DMABUF exporting to the vb2-vmalloc implementation.
>>
>> All memory models now have support for both importing and exporting of DMABUFs.
>> Signed-off-by: Hans Verkuil <hansverk@cisco.com>
>> ---
>>  drivers/media/v4l2-core/videobuf2-vmalloc.c | 174 ++++++++++++++++++++++++++++
>>  1 file changed, 174 insertions(+)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-vmalloc.c b/drivers/media/v4l2-core/videobuf2-vmalloc.c
>> index bba2460..dfbb6d5 100644
>> --- a/drivers/media/v4l2-core/videobuf2-vmalloc.c
>> +++ b/drivers/media/v4l2-core/videobuf2-vmalloc.c
>> @@ -31,6 +31,9 @@ struct vb2_vmalloc_buf {
>>         atomic_t                        refcount;
>>         struct vb2_vmarea_handler       handler;
>>         struct dma_buf                  *dbuf;
>> +
>> +       /* DMABUF related */
>> +       struct dma_buf_attachment       *db_attach;
> 
> Unused?
> 

Indeed. There is no device to be attached to this buffer, so this
copy-and-paste field can be removed.

Regards,

	Hans
