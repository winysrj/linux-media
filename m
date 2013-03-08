Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:56598 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302Ab3CHLSH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 8 Mar 2013 06:18:07 -0500
Message-ID: <5139C8DC.3010307@ti.com>
Date: Fri, 8 Mar 2013 16:47:48 +0530
From: Sekhar Nori <nsekhar@ti.com>
MIME-Version: 1.0
To: Prabhakar lad <prabhakar.csengg@gmail.com>
CC: LMML <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] davinci: vpbe: fix module build
References: <1362738130-24543-1-git-send-email-prabhakar.lad@ti.com>
In-Reply-To: <1362738130-24543-1-git-send-email-prabhakar.lad@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 3/8/2013 3:52 PM, Prabhakar lad wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> add a null entry in platform_device_id {}.
> 
> This patch fixes following error:
> drivers/media/platform/davinci/vpbe_venc: struct platform_device_id is 24 bytes.  The last of 3 is:
> 0x64 0x6d 0x33 0x35 0x35 0x2c 0x76 0x70 0x62 0x65 0x2d 0x76 0x65 0x6e 0x63 0x00 0x00 0x00 0x00 0x00 0x03 0x00 0x00 0x00
> FATAL: drivers/media/platform/davinci/vpbe_venc: struct platform_device_id is not terminated with a NULL entry!
> make[1]: *** [__modpost] Error 1
> 
> Reported-by: Sekhar Nori <nsekhar@ti.com>
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

This fixed the issue for me. Thanks!

Tested-by: Sekhar Nori <nsekhar@ti.com>

~Sekhar
