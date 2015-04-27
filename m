Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-by2on0078.outbound.protection.outlook.com ([207.46.100.78]:30624
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752138AbbD0Fzx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Apr 2015 01:55:53 -0400
Date: Mon, 27 Apr 2015 07:22:54 +0200
From: Michal Simek <michal.simek@xilinx.com>
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>,
	Hyun Kwon <hyun.kwon@xilinx.com>
CC: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Michal Simek <michal.simek@xilinx.com>,
	<linux-media@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>,
	Kedareswara rao Appana <appana.durga.rao@xilinx.com>
Subject: Re: [PATCH] [media] xilinx: Reflect dma header file move
References: <1429903476-24161-1-git-send-email-linux@roeck-us.net>
In-Reply-To: <1429903476-24161-1-git-send-email-linux@roeck-us.net>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Message-ID: <fcd18355-b06d-4afd-b8c3-9af9adcf8021@BY2FFO11OLC013.protection.gbl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/24/2015 09:24 PM, Guenter Roeck wrote:
> Commit 937abe88aea3 ("dmaengine: xilinx-dma: move header file to common
> location") moved xilinx_dma.h to a common location but neglected to reflect
> this move in all its users.
> 
> This causes compile errors for several builds.
> 
> drivers/media/platform/xilinx/xilinx-dma.c:15:35:
> 	fatal error: linux/amba/xilinx_dma.h: No such file or directory
> 
> Cc: Kedareswara rao Appana <appana.durga.rao@xilinx.com>
> Fixes: 937abe88aea3 ("dmaengine: xilinx-dma: move header file to common
> 	location")
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  drivers/media/platform/xilinx/xilinx-dma.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

FYI:
http://www.serverphorums.com/read.php?12,1179281

https://lkml.org/lkml/2015/4/25/25

Thanks,
Michal
