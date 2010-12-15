Return-path: <mchehab@gaivota>
Received: from mail-ey0-f171.google.com ([209.85.215.171]:52098 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab0LOLVW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Dec 2010 06:21:22 -0500
Received: by eyg5 with SMTP id 5so1051181eyg.2
        for <linux-media@vger.kernel.org>; Wed, 15 Dec 2010 03:21:20 -0800 (PST)
Message-ID: <4D08A475.6080703@mvista.com>
Date: Wed, 15 Dec 2010 14:20:21 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
MIME-Version: 1.0
To: Manjunath Hadli <manjunath.hadli@ti.com>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH v6 5/7] davinci vpbe: platform specific additions
References: <1292404268-12517-1-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1292404268-12517-1-git-send-email-manjunath.hadli@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hello.

On 15-12-2010 12:11, Manjunath Hadli wrote:

> This patch implements the overall device creation for the Video
> display driver, and addition of tables for the mode and output list.

> Signed-off-by: Manjunath Hadli<manjunath.hadli@ti.com>
> Acked-by: Muralidharan Karicheri<m-karicheri2@ti.com>
> Acked-by: Hans Verkuil<hverkuil@xs4all.nl>
[...]

> diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davinci/board-dm644x-evm.c
> index 34c8b41..e9b1243 100644
> --- a/arch/arm/mach-davinci/board-dm644x-evm.c
> +++ b/arch/arm/mach-davinci/board-dm644x-evm.c

    I think the DM644x EVM board changes should be in a separate patch.

WBR, Sergei
