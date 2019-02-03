Return-Path: <SRS0=0n2Q=QK=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A9A1C169C4
	for <linux-media@archiver.kernel.org>; Sun,  3 Feb 2019 08:23:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 294712082F
	for <linux-media@archiver.kernel.org>; Sun,  3 Feb 2019 08:23:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbfBCIXx (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 3 Feb 2019 03:23:53 -0500
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:41853 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726475AbfBCIXx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 3 Feb 2019 03:23:53 -0500
Received: from [IPv6:2001:67c:1810:f051:a2c6:c81d:4091:548b] ([IPv6:2001:67c:1810:f051:a2c6:c81d:4091:548b])
        by smtp-cloud9.xs4all.net with ESMTPA
        id qD46ghRBkRO5ZqD49gdKut; Sun, 03 Feb 2019 09:23:50 +0100
Subject: Re: [PATCH] vb2: clear timestamp if buffer mem is reacquired
To:     Nicolas Dufresne <nicolas@ndufresne.ca>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Tomasz Figa <tfiga@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>
References: <59fc9777-41f3-5f87-2d84-f9375d8a2895@xs4all.nl>
 <ea67d53e4acce742f916021c4f2ff918938608fe.camel@ndufresne.ca>
From:   Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <82faf8fa-de44-cf60-2552-b909c602da6e@xs4all.nl>
Date:   Sun, 3 Feb 2019 09:23:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <ea67d53e4acce742f916021c4f2ff918938608fe.camel@ndufresne.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfGKk0widch4nkFhjq8142PMw/WBDmnF8e8GbrJPGfED+1/TLD4daTHLvjK4I+TbH6tS5iK4tCDqI/eXyRmJqQ2nFmbgjC/bRLNTRCPIyJl2mpkBO89Kg
 N/UyBD+VRdumXplH4yggLsc3LPuo1gsyfNpgewfZvnm5I2F8888ojyDC855G9tKNRpOuRT8yPy5aByrOcdEtpS225XDKkI2pRahXkhZAF7t4cEeQ0zYQx2FW
 /+oAIbzH5JrwuMV+EIkL/Qlx9x+sglPMhKJPVX0IkSs3sfUorkRNQHBXCPJJcm/aYcWy0gw4Vuw6b/SwKknrOtL5dukQW+RTsWV8SMUeyt3Heu5TFMDsFTLk
 GR3phyBn03NyRfm0NtkL6z4nG3lXhOd54gWlytzTvl/74tUBnbbzWJ6v/RhPvk7dOs/1U0BY
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On 02/02/2019 09:59 PM, Nicolas Dufresne wrote:
> Le samedi 02 février 2019 à 18:03 +0100, Hans Verkuil a écrit :
>> Stateless codecs have to find buffers based on a timestamp (vb2_find_timestamp).
>> The timestamp is set to 0 initially, so prohibit finding timestamp 0 since it
>> could find unused buffers without associated memory (userptr or dmabuf).
>>
>> The memory associated with a buffer will also disappear if the same buffer was
>> requeued with a different userptr address or dmabuf fd. Detect this and set the
>> timestamp of that buffer to 0 if this happens.
> 
> Just a small concern, does it mean 0 is considered an invalid timestamp
> ? In streaming it would be quite normal for a first picture to have PTS
> 0.

Good point. Perhaps I should make ~0ULL the invalid timestamp instead.
I'll look at that tomorrow.

Regards,

	Hans

> 
> Nicolas
> 
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>> Note: I think it is still necessary to lock a buffer when it is in use as
>> a reference frame, otherwise a userspace application can queue it again with
>> a different dmabuf fd, which could free the memory of the old dmabuf.
>>
>> vb2_find_buffer should probably do that.
>> ---
>> diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
>> index e07b6bdb6982..b664d9790330 100644
>> --- a/drivers/media/common/videobuf2/videobuf2-core.c
>> +++ b/drivers/media/common/videobuf2/videobuf2-core.c
>> @@ -1043,6 +1043,8 @@ static int __prepare_userptr(struct vb2_buffer *vb)
>>  				reacquired = true;
>>  				call_void_vb_qop(vb, buf_cleanup, vb);
>>  			}
>> +			if (!q->is_output)
>> +				vb->timestamp = 0;
>>  			call_void_memop(vb, put_userptr, vb->planes[plane].mem_priv);
>>  		}
>>
>> @@ -1157,6 +1159,8 @@ static int __prepare_dmabuf(struct vb2_buffer *vb)
>>  		/* Skip the plane if already verified */
>>  		if (dbuf == vb->planes[plane].dbuf &&
>>  			vb->planes[plane].length == planes[plane].length) {
>> +			if (!q->is_output)
>> +				vb->timestamp = 0;
>>  			dma_buf_put(dbuf);
>>  			continue;
>>  		}
>> diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
>> index 3aeaea3af42a..8e966fa81b7e 100644
>> --- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
>> +++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
>> @@ -603,6 +603,9 @@ int vb2_find_timestamp(const struct vb2_queue *q, u64 timestamp,
>>  {
>>  	unsigned int i;
>>
>> +	if (!timestamp)
>> +		return -1;
>> +
>>  	for (i = start_idx; i < q->num_buffers; i++)
>>  		if (q->bufs[i]->timestamp == timestamp)
>>  			return i;
>> diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
>> index 8a10889dc2fd..01bf4b2199c7 100644
>> --- a/include/media/videobuf2-v4l2.h
>> +++ b/include/media/videobuf2-v4l2.h
>> @@ -59,14 +59,14 @@ struct vb2_v4l2_buffer {
>>   * vb2_find_timestamp() - Find buffer with given timestamp in the queue
>>   *
>>   * @q:		pointer to &struct vb2_queue with videobuf2 queue.
>> - * @timestamp:	the timestamp to find.
>> + * @timestamp:	the timestamp to find. Must be > 0.
>>   * @start_idx:	the start index (usually 0) in the buffer array to start
>>   *		searching from. Note that there may be multiple buffers
>>   *		with the same timestamp value, so you can restart the search
>>   *		by setting @start_idx to the previously found index + 1.
>>   *
>>   * Returns the buffer index of the buffer with the given @timestamp, or
>> - * -1 if no buffer with @timestamp was found.
>> + * -1 if no buffer with @timestamp was found or if @timestamp was 0.
>>   */
>>  int vb2_find_timestamp(const struct vb2_queue *q, u64 timestamp,
>>  		       unsigned int start_idx);
> 

