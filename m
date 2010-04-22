Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:21714 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab0DVJf4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Apr 2010 05:35:56 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Received: from eu_spt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0L19001MVUNTFR30@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 22 Apr 2010 10:35:53 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L1900JYJUNSX6@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 22 Apr 2010 10:35:53 +0100 (BST)
Date: Thu, 22 Apr 2010 11:35:35 +0200
From: Pawel Osciak <p.osciak@samsung.com>
Subject: RE: [PATCH v3 2/3] v4l: videobuf: Add support for V4L2_BUF_FLAG_ERROR
In-reply-to: <201004221112.30988.laurent.pinchart@ideasonboard.com>
To: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	kyungmin.park@samsung.com, 'Hans Verkuil' <hverkuil@xs4all.nl>
Message-id: <001601cae1ff$2955f650$7c01e2f0$%osciak@samsung.com>
Content-language: pl
References: <1271849985-368-1-git-send-email-p.osciak@samsung.com>
 <1271849985-368-3-git-send-email-p.osciak@samsung.com>
 <201004221112.30988.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

>Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>On Wednesday 21 April 2010 13:39:44 Pawel Osciak wrote:
>> @@ -679,23 +682,20 @@ int videobuf_dqbuf(struct videobuf_queue *q,
>>  	switch (buf->state) {
>>  	case VIDEOBUF_ERROR:
>>  		dprintk(1, "dqbuf: state is error\n");
>> -		retval = -EIO;
>> -		CALL(q, sync, q, buf);
>> -		buf->state = VIDEOBUF_IDLE;
>>  		break;
>>  	case VIDEOBUF_DONE:
>>  		dprintk(1, "dqbuf: state is done\n");
>> -		CALL(q, sync, q, buf);
>> -		buf->state = VIDEOBUF_IDLE;
>>  		break;
>>  	default:
>>  		dprintk(1, "dqbuf: state invalid\n");
>>  		retval = -EINVAL;
>>  		goto done;
>>  	}
>> -	list_del(&buf->stream);
>> -	memset(b, 0, sizeof(*b));
>> +	CALL(q, sync, q, buf);
>>  	videobuf_status(q, b, buf, q->type);
>> +	list_del(&buf->stream);
>> +	buf->state = VIDEOBUF_IDLE;
>> +	b->flags &= ~V4L2_BUF_FLAG_DONE;
>
>We do you clear the done flag here ?
>

The DONE flag is supposed to be cleared when dequeuing, but should
be set when querying:
 
"When this flag is set, the buffer is currently on the outgoing queue,
ready to be dequeued from the driver. Drivers set or clear this flag
when the VIDIOC_QUERYBUF  ioctl is called. After calling the VIDIOC_QBUF
or VIDIOC_DQBUF it is always cleared."

videobuf_status() is used for both QUERYBUF and DQBUF and making both
work properly is not very straightforward without losing
VIDEOBUF_DONE/VIDEOBUF_ERROR distinction (it becomes more clear when you
analyze both cases).

My previous patch was doing it the other way around, but Hans' version
seemed shorter and cleaner.

Best regards
--
Pawel Osciak
Linux Platform Group
Samsung Poland R&D Center



