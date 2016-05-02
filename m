Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:54660 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753759AbcEBLAe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 2 May 2016 07:00:34 -0400
Subject: Re: [PATCH 1/2] media: exynos4-is: fix deadlock on driver probe
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
References: <1461839104-29135-1-git-send-email-m.szyprowski@samsung.com>
 <57267C5C.2000403@linux.intel.com> <20160502075235.6772fc3a@recife.lan>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Jacek Anaszewski <j.anaszewski@samsung.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <57273345.7070104@xs4all.nl>
Date: Mon, 2 May 2016 13:00:21 +0200
MIME-Version: 1.0
In-Reply-To: <20160502075235.6772fc3a@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/02/16 12:52, Mauro Carvalho Chehab wrote:
> Em Mon, 2 May 2016 00:59:56 +0300
> Sakari Ailus <sakari.ailus@linux.intel.com> escreveu:
> 
>> Hi Marek,
>>
>> Marek Szyprowski wrote:
>>> Commit 0c426c472b5585ed6e59160359c979506d45ae49 ("[media] media: Always
>>> keep a graph walk large enough around") changed
>>> media_device_register_entity() function to take mdev->graph_mutex. This
>>> causes deadlock in driver probe, which calls (indirectly) this function
>>> with ->graph_mutex taken. This patch removes taking ->graph_mutex in
>>> driver probe to avoid deadlock. Other drivers don't take ->graph_mutex
>>> for entity registration, so this change should be safe.
>>>
>>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>  
>>
>> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
>>
>> You could also add:
>>
>> Fixes: 0c426c472b55 ("[media] media: Always keep a graph walk large 
>> enough around")
>>
>> I guess these should go to fixes, the patches in question are already 
>> heading for v4.6. Cc Mauro.
> 
> The patches from Sakari for v4.6 were merged already at -rc6. Just merged
> them back at the master branch.

I'm confused. The two patches from Marek fixing driver probe deadlock are not
in the master tree (just pulled from it, it's now rc6), so the deadlock still
happens in kernel 4.6.

Regards,

	Hans
