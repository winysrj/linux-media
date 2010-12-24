Return-path: <mchehab@gaivota>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:1352 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab0LXXc0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Dec 2010 18:32:26 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Rob Clark <robdclark@gmail.com>
Subject: Re: opinions about non-page-aligned buffers?
Date: Sat, 25 Dec 2010 00:32:17 +0100
Cc: linux-media@vger.kernel.org
References: <AANLkTimMMzxbnXT8nRJYWHmgjX_RJ2goj+j083JB5eLz@mail.gmail.com>
In-Reply-To: <AANLkTimMMzxbnXT8nRJYWHmgjX_RJ2goj+j083JB5eLz@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012250032.18082.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Friday, December 24, 2010 22:29:37 Rob Clark wrote:
> Hi all,
> 
> The request has come up on OMAP4 to support non-page-aligned v4l2
> buffers.  (This is in context of v4l2 display, but the same reasons
> would apply for a camera.)  For most common resolutions, this would
> help us get much better memory utilization for a range of memory (or
> rather address space) used for YUV buffers.

Can you explain this in more detail? I don't really see how non-page
aligned buffers would lead to 'much better' memory usage. I would expect
that the best savings you could achieve would be PAGE_SIZE-1 per buffer.

Regards,

	Hans

> However it would require
> a small change in the client application, since most (all) v4l2 apps
> that I have seen are assuming the offsets they are given to mmap are
> page aligned.
> 
> I am curious if anyone has any suggestions about how to enable this.
> Ideally it would be some sort of opt-in feature to avoid breaking apps
> that are not aware the the offsets to mmap may not be page aligned.
> 
> BR,
> -R
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
