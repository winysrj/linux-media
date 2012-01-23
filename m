Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:8922 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab2AWOfU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jan 2012 09:35:20 -0500
Received: from euspt1 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0LY90080K9UV8P@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 23 Jan 2012 14:35:19 +0000 (GMT)
Received: from [106.116.48.223] by spt1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LY900F1R9UUV0@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 23 Jan 2012 14:35:19 +0000 (GMT)
Date: Mon, 23 Jan 2012 15:35:16 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH 08/10] v4l: vb2-dma-contig: code refactoring,
 support for DMABUF exporting
In-reply-to: <4F1D6E06.7000409@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	sumit.semwal@ti.com, jesse.barker@linaro.org, rob@ti.com,
	daniel@ffwll.ch, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, hverkuil@xs4all.nl,
	laurent.pinchart@ideasonboard.com, pawel@osciak.com,
	Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
	Sumit Semwal <sumit.semwal@linaro.org>
Message-id: <4F1D7024.10600@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <1327326675-8431-1-git-send-email-t.stanislaws@samsung.com>
 <1327326675-8431-9-git-send-email-t.stanislaws@samsung.com>
 <4F1D6E06.7000409@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 01/23/2012 03:26 PM, Mauro Carvalho Chehab wrote:
> Em 23-01-2012 11:51, Tomasz Stanislawski escreveu:
>> Signed-off-by: Pawel Osciak<pawel@osciak.com>
>> 	[author of the original file]
>> Signed-off-by: Marek Szyprowski<m.szyprowski@samsung.com>
>> 	[implemetation of mmap, finish/prepare]
>> Signed-off-by: Andrzej Pietrasiewicz<andrzej.p@samsung.com>
>> 	[implementation of userprt handling]
>> Signed-off-by: Sumit Semwal<sumit.semwal@ti.com>
>> Signed-off-by: Sumit Semwal<sumit.semwal@linaro.org>
>> 	[PoC for importing dmabuf buffer]
>> Signed-off-by: Tomasz Stanislawski<t.stanislaws@samsung.com>
>>         [buffer exporting using dmabuf, code refactoring]
>> Signed-off-by: Kyungmin Park<kyungmin.park@samsung.com>
>
> Please provide a diff against the existing driver, in order to allow reviewing
> what has changed.

There is no difference patch due to the reasons described in the cover 
letter. This is a PoC patch and it is dedicated for easy reading.

Regards
Tomasz Stanislawski
