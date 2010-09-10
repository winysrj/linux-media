Return-path: <mchehab@pedra>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:36125 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297Ab0IJHjH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Sep 2010 03:39:07 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Received: from eu_spt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0L8I005M8T94D030@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 10 Sep 2010 08:39:04 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0L8I005PUT930W@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 10 Sep 2010 08:39:04 +0100 (BST)
Date: Fri, 10 Sep 2010 16:38:44 +0900
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH/RFC v1 0/7] Videobuf2 framework
In-reply-to: <4C89B3AD.1010404@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Pawel Osciak <p.osciak@samsung.com>, linux-media@vger.kernel.org,
	kyungmin.park@samsung.com, t.fujak@samsung.com
Message-id: <4C89E084.6090203@samsung.com>
References: <1284023988-23351-1-git-send-email-p.osciak@samsung.com>
 <4C891F0D.2060103@redhat.com> <4C89A3EE.8040503@samsung.com>
 <4C89B3AD.1010404@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Hello,

On 2010-09-10 13:27, Mauro Carvalho Chehab wrote:

>>> 1) it lacks implementation of read() method. This means that vivi driver
>>> has a regression, as it currently supports it.
>>
>> Yes, read() is not yet implemented. I guess it is not a feature that would
>> be deprecated, right?
>
> Yes, there are no plans to deprecate it. Also, some devices like cx88 and bttv
> allows receiving simultaneous streams, one via mmap, and another via read().
> This is used by some applications to allow recording video via ffmpeg/mencoder
> using read(), while the main application is displaying video using mmap.

Well, in my opinion such devices should provide two separate /dev/videoX 
nodes rather than hacking with mmap and read access types.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center
