Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3826 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308AbaHVXZT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Aug 2014 19:25:19 -0400
Message-ID: <53F7D149.9090604@xs4all.nl>
Date: Fri, 22 Aug 2014 23:24:57 +0000
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: LMML <linux-media@vger.kernel.org>, m.szyprowski@samsung.com,
	pawel@osciak.com,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH] videobuf2-core: take mmap_sem before calling __qbuf_userptr
References: <53F78565.5000502@xs4all.nl> <20140822193400.GB12839@quack.suse.cz>
In-Reply-To: <20140822193400.GB12839@quack.suse.cz>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/22/2014 07:34 PM, Jan Kara wrote:
> On Fri 22-08-14 18:01:09, Hans Verkuil wrote:
>> Commit f035eb4e976ef5a059e30bc91cfd310ff030a7d3 (videobuf2: fix lockdep warning)
>> unfortunately removed the mmap_sem lock that is needed around the call to
>> __qbuf_userptr. Amazingly nobody noticed this until Jan Kara pointed this out
>> to me.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> Reported-by: Jan Kara <jack@suse.cz>
> ...
>> @@ -1627,7 +1628,9 @@ static int __buf_prepare(struct vb2_buffer *vb, const struct v4l2_buffer *b)
>>  		ret = __qbuf_mmap(vb, b);
>>  		break;
>>  	case V4L2_MEMORY_USERPTR:
>   I guess you are missing something like:
> 
> mmap_sem = &current->mm->mmap_sem;

Insert <red face>.

Oops, I'll repost.

Regards,

	Hans

> 
> 								Honza
>> +		down_read(mmap_sem);
>>  		ret = __qbuf_userptr(vb, b);
>> +		up_read(mmap_sem);
>>  		break;
>>  	case V4L2_MEMORY_DMABUF:
>>  		ret = __qbuf_dmabuf(vb, b);
>> -- 
>> 2.0.1
>>

