Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46212 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756001Ab2FZKgo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jun 2012 06:36:44 -0400
Received: by lbbgm6 with SMTP id gm6so7828727lbb.19
        for <linux-media@vger.kernel.org>; Tue, 26 Jun 2012 03:36:42 -0700 (PDT)
Message-ID: <4FE99091.7070001@mvista.com>
Date: Tue, 26 Jun 2012 14:36:01 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
MIME-Version: 1.0
To: Manjunath Hadli <manjunath.hadli@ti.com>
CC: LMML <linux-media@vger.kernel.org>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [PATCH v3 04/13] davinci: vpif: fix setting of data width in
 config_vpif_params() function
References: <1340622455-10419-1-git-send-email-manjunath.hadli@ti.com> <1340622455-10419-5-git-send-email-manjunath.hadli@ti.com>
In-Reply-To: <1340622455-10419-5-git-send-email-manjunath.hadli@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 25-06-2012 15:07, Manjunath Hadli wrote:

> fix setting of data width in config_vpif_params() function,
> which was wrongly set.

> Signed-off-by: Manjunath Hadli<manjunath.hadli@ti.com>
> Signed-off-by: Lad, Prabhakar<prabhakar.lad@ti.com>
> ---
>   drivers/media/video/davinci/vpif.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)

> diff --git a/drivers/media/video/davinci/vpif.c b/drivers/media/video/davinci/vpif.c
> index 774bcd3..08fb81f 100644
> --- a/drivers/media/video/davinci/vpif.c
> +++ b/drivers/media/video/davinci/vpif.c
> @@ -346,7 +346,7 @@ static void config_vpif_params(struct vpif_params *vpifparams,
>
>   			value = regr(reg);
>   			/* Set data width */
> -			value&= ((~(unsigned int)(0x3))<<
> +			value&= ~(((unsigned int)(0x3))<<

    Why not just 0x3u instead of (unsigned int)(0x3)?

WBR, Sergei
