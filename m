Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675Ab2AWOoA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jan 2012 09:44:00 -0500
Message-ID: <4F1D7221.6000308@redhat.com>
Date: Mon, 23 Jan 2012 12:43:45 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Tomasz Stanislawski <t.stanislaws@samsung.com>
CC: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	sumit.semwal@ti.com, jesse.barker@linaro.org, rob@ti.com,
	daniel@ffwll.ch, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, pawel@osciak.com,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [PATCH 08/10] v4l: vb2-dma-contig: code refactoring, support
 for DMABUF exporting
References: <1327326675-8431-1-git-send-email-t.stanislaws@samsung.com> <1327326675-8431-9-git-send-email-t.stanislaws@samsung.com> <4F1D6E06.7000409@redhat.com> <4F1D7024.10600@samsung.com>
In-Reply-To: <4F1D7024.10600@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 23-01-2012 12:35, Tomasz Stanislawski escreveu:
> Hi,
> 
> On 01/23/2012 03:26 PM, Mauro Carvalho Chehab wrote:
>> Em 23-01-2012 11:51, Tomasz Stanislawski escreveu:
>>> Signed-off-by: Pawel Osciak<pawel@osciak.com>
>>>     [author of the original file]
>>> Signed-off-by: Marek Szyprowski<m.szyprowski@samsung.com>
>>>     [implemetation of mmap, finish/prepare]
>>> Signed-off-by: Andrzej Pietrasiewicz<andrzej.p@samsung.com>
>>>     [implementation of userprt handling]
>>> Signed-off-by: Sumit Semwal<sumit.semwal@ti.com>
>>> Signed-off-by: Sumit Semwal<sumit.semwal@linaro.org>
>>>     [PoC for importing dmabuf buffer]
>>> Signed-off-by: Tomasz Stanislawski<t.stanislaws@samsung.com>
>>>         [buffer exporting using dmabuf, code refactoring]
>>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>>
>> Please provide a diff against the existing driver, in order to allow reviewing
>> what has changed.
> 
> There is no difference patch due to the reasons described in the cover letter. This is a PoC patch and it is dedicated for easy reading.

There's no way for a reviewer to check if some regressions were added by it,
as there's no diff. Those interested on doing an "easy reading" of the patch
changes could just apply the patch and see the results of it, but removing
and re-adding really sucks, as the ones interested on see what changed will
be a very bad time, especially if you moved functions inside the code.

> 
> Regards
> Tomasz Stanislawski
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

