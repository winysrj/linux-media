Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:64533 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030212Ab2HWOEi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Aug 2012 10:04:38 -0400
Received: from eusync4.samsung.com (mailout3.w1.samsung.com [210.118.77.13])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M970081COGLOO40@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 23 Aug 2012 15:05:09 +0100 (BST)
Received: from [106.116.147.32] by eusync4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTPA id <0M9700H6COFOV210@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 23 Aug 2012 15:04:37 +0100 (BST)
Message-id: <50363874.5030507@samsung.com>
Date: Thu, 23 Aug 2012 16:04:36 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 04/10] mem2mem_testdev: Remove unneeded struct vb2_queue
 clear on queue_init()
References: <1345727311-27478-1-git-send-email-elezegarcia@gmail.com>
 <1345727311-27478-4-git-send-email-elezegarcia@gmail.com>
 <503634D2.9000301@samsung.com>
In-reply-to: <503634D2.9000301@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/23/2012 03:49 PM, Sylwester Nawrocki wrote:
> Hi Ezequiel,
> 
> On 08/23/2012 03:08 PM, Ezequiel Garcia wrote:
>> queue_init() is always called by v4l2_m2m_ctx_init(), which allocates
>> a context struct v4l2_m2m_ctx with kzalloc.
>> Therefore, there is no need to clear vb2_queue src/dst structs.
>>
>> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
> 
> Looks good to me. Let me pick this and s5p-jpeg, s5p-g2d patches for v3.7.

whoops, I'll just pick s5p driver patches, i.e. 3 last ones in this series
 -  08/10, 09/10, 10/10 as I have other patches touching these drivers.

--
Regards,
Sylwester

