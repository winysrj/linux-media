Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:39848 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754374AbeDWJxn (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 23 Apr 2018 05:53:43 -0400
Subject: Re: [RFCv11 PATCH 17/29] vb2: store userspace data in vb2_v4l2_buffer
To: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
 <20180409142026.19369-18-hverkuil@xs4all.nl>
 <4f390d7d-c185-9775-b5f4-dedf40cdf92c@ideasonboard.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <94b55991-5a29-42dc-db14-f8809418a389@xs4all.nl>
Date: Mon, 23 Apr 2018 11:53:38 +0200
MIME-Version: 1.0
In-Reply-To: <4f390d7d-c185-9775-b5f4-dedf40cdf92c@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/09/2018 05:11 PM, Kieran Bingham wrote:
> Hi Hans,
> 
> Thank you for the patch series !
> 
> I'm looking forwards to finding some time to try out this work.
> 
> Just briefly scanning through the series, and I saw the minor issue below.
> 
> Regards
> 
> Kieran
> 
> 
> On 09/04/18 15:20, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> The userspace-provided plane data needs to be stored in
>> vb2_v4l2_buffer. Currently this information is applied by
>> __fill_vb2_buffer() which is called by the core prepare_buf
>> and qbuf functions, but when using requests these functions
>> aren't called yet since the buffer won't be prepared until
>> the media request is actually queued.
>>
>> In the meantime this information has to be stored somewhere
>> and vb2_v4l2_buffer is a good place for it.
>>
>> The __fill_vb2_buffer callback now just copies the relevant
>> information from vb2_v4l2_buffer into the planes array.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/common/videobuf2/videobuf2-core.c |  25 +-
>>  drivers/media/common/videobuf2/videobuf2-v4l2.c | 324 +++++++++++++-----------
>>  drivers/media/dvb-core/dvb_vb2.c                |   3 +-
>>  include/media/videobuf2-core.h                  |   3 +-
>>  include/media/videobuf2-v4l2.h                  |   2 +
>>  5 files changed, 197 insertions(+), 160 deletions(-)
>>
>> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
>> index d3f7bb33a54d..3d436ccb61f8 100644
>> --- a/drivers/media/common/videobuf2/videobuf2-core.c
>> +++ b/drivers/media/common/videobuf2/videobuf2-core.c
>> @@ -968,9 +968,8 @@ static int __prepare_mmap(struct vb2_buffer *vb, const void *pb)
> 
> Now that pb is unused here, should it be removed from the function arguments ?

Correct. Dropped here and elsewhere.

Regards,

	Hans
