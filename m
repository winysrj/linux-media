Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:57383 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753646AbaKRKLw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Nov 2014 05:11:52 -0500
Message-ID: <546B1B41.8060000@xs4all.nl>
Date: Tue, 18 Nov 2014 11:11:13 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Pawel Osciak <pawel@osciak.com>
CC: LMML <linux-media@vger.kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv6 PATCH 11/16] vb2: use dma_map_sg_attrs to prevent unnecessary
 sync
References: <1415623771-29634-1-git-send-email-hverkuil@xs4all.nl> <1415623771-29634-12-git-send-email-hverkuil@xs4all.nl> <CAMm-=zBDdqKGzKZOLNGOOYbP4bh14GG1C6tCm_pSrqoWrRtOvw@mail.gmail.com>
In-Reply-To: <CAMm-=zBDdqKGzKZOLNGOOYbP4bh14GG1C6tCm_pSrqoWrRtOvw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/18/14 10:55, Pawel Osciak wrote:
> On Mon, Nov 10, 2014 at 8:49 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> By default dma_map_sg syncs the mapped buffer to the device. But
>> buf_prepare expects a buffer syncs for the cpu and the buffer
>> will be synced to the device in the prepare memop.
>>
>> The reverse is true for dma_unmap_sg, buf_finish and the finish
>> memop.
>>
>> To prevent unnecessary syncs we ask dma_(un)map_sg to skip the
>> sync.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/v4l2-core/videobuf2-dma-contig.c | 29 +++++++++++++++++-----
>>  drivers/media/v4l2-core/videobuf2-dma-sg.c     | 33 +++++++++++++++++++++-----
>>  2 files changed, 50 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
>> index c4305bf..27f5926 100644
>> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
>> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
>> @@ -317,8 +317,9 @@ static struct sg_table *vb2_dc_dmabuf_ops_map(
>>                 attach->dma_dir = DMA_NONE;
>>         }
>>
>> -       /* mapping to the client with new direction */
>> -       ret = dma_map_sg(db_attach->dev, sgt->sgl, sgt->orig_nents, dma_dir);
>> +       /* Mapping to the client with new direction */
>> +       ret = dma_map_sg(db_attach->dev, sgt->sgl, sgt->orig_nents,
>> +                        dma_dir);
> 
> Do we need this chunk?
> 

I'll drop it.

Regards,

	Hans
