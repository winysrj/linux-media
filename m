Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:52408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752399AbdFRVZr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 18 Jun 2017 17:25:47 -0400
Subject: Re: [RFC PATCH 2/2] media/uapi/v4l: clarify cropcap/crop/selection
 behavior
To: Sakari Ailus <sakari.ailus@iki.fi>,
        Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
References: <20170508143506.16448-1-hverkuil@xs4all.nl>
 <20170508143506.16448-2-hverkuil@xs4all.nl>
 <20170616130855.GR12407@valkosipuli.retiisi.org.uk>
From: Sylwester Nawrocki <snawrocki@kernel.org>
Message-ID: <a79db959-b229-0f31-5866-c7bf6cd6f33d@kernel.org>
Date: Sun, 18 Jun 2017 23:25:43 +0200
MIME-Version: 1.0
In-Reply-To: <20170616130855.GR12407@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/16/2017 03:08 PM, Sakari Ailus wrote:
> On Mon, May 08, 2017 at 04:35:06PM +0200, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Unfortunately the use of 'type' was inconsistent for multiplanar
>> buffer types. Starting with 4.12 both the normal and _MPLANE variants
>> are allowed, thus making it possible to write sensible code.
>>
>> Yes, we messed up :-(
> 
> Things worse than this have happened. :-)
> 
> I don't think in general I would write about driver bugs that have already
> been fixed in developer documentation. That said, I'm not sure how otherwise
> developers would learn about this, but OTOH has it been reported to us as a
> bug?
> 
> Marek, Sylwester: any idea how widely the drivers in question are in use? If
> there's a real chance of hitting this, then it does make sense to mention it
> in the documentation.

I'm not sure how widely are used those drivers, I think we should just assume 
they are deployed and whatever we do should be backwards compatible. I don't 
think it is much helpful for Exynos to add notes like this in the documentation, 
so far I didn't receive any related bug report.

And even though now there is some confusion because drivers see "regular" 
buffer type while user space uses _MPLANE I like the $subject patch set
as it makes the API clearer from user perspective.

--
Regards,
Sylwester
































 
