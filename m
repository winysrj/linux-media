Return-path: <linux-media-owner@vger.kernel.org>
Received: from bh-25.webhostbox.net ([208.91.199.152]:47455 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752339AbbD0F3d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Apr 2015 01:29:33 -0400
Received: from mailnull by bh-25.webhostbox.net with sa-checked (Exim 4.85)
	(envelope-from <linux@roeck-us.net>)
	id 1Ymbbp-000VyW-3G
	for linux-media@vger.kernel.org; Mon, 27 Apr 2015 05:29:33 +0000
Message-ID: <553DC91D.4080108@roeck-us.net>
Date: Sun, 26 Apr 2015 22:29:01 -0700
From: Guenter Roeck <linux@roeck-us.net>
MIME-Version: 1.0
To: Michal Simek <michal.simek@xilinx.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>
CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Kedareswara rao Appana <appana.durga.rao@xilinx.com>
Subject: Re: [PATCH] [media] xilinx: Reflect dma header file move
References: <1429903476-24161-1-git-send-email-linux@roeck-us.net> <fcd18355-b06d-4afd-b8c3-9af9adcf8021@BY2FFO11OLC013.protection.gbl>
In-Reply-To: <fcd18355-b06d-4afd-b8c3-9af9adcf8021@BY2FFO11OLC013.protection.gbl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/26/2015 10:22 PM, Michal Simek wrote:
> On 04/24/2015 09:24 PM, Guenter Roeck wrote:
>> Commit 937abe88aea3 ("dmaengine: xilinx-dma: move header file to common
>> location") moved xilinx_dma.h to a common location but neglected to reflect
>> this move in all its users.
>>
>> This causes compile errors for several builds.
>>
>> drivers/media/platform/xilinx/xilinx-dma.c:15:35:
>> 	fatal error: linux/amba/xilinx_dma.h: No such file or directory
>>
>> Cc: Kedareswara rao Appana <appana.durga.rao@xilinx.com>
>> Fixes: 937abe88aea3 ("dmaengine: xilinx-dma: move header file to common
>> 	location")
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> ---
>>   drivers/media/platform/xilinx/xilinx-dma.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> FYI:
> http://www.serverphorums.com/read.php?12,1179281
>
> https://lkml.org/lkml/2015/4/25/25
>

Yes, I noticed Stephen's patch in mainline.

Guenter


