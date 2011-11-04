Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:27126 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803Ab1KDJQ7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Nov 2011 05:16:59 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LU400IDRPS9WI30@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 04 Nov 2011 09:16:57 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LU400DFFPS8KG@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 04 Nov 2011 09:16:56 +0000 (GMT)
Date: Fri, 04 Nov 2011 10:16:56 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH resent] Fix logic in sanity check
In-reply-to: <4E99FD60.5090606@intra2net.com>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	"HeungJun Kim/Mobile S/W Platform Lab(DMC)/E3"
	<riverful.kim@samsung.com>
Message-id: <4EB3AD88.1090702@samsung.com>
References: <4E99FD60.5090606@intra2net.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Thomas,

On 10/15/2011 11:38 PM, Thomas Jarosch wrote:
> Detected by "cppcheck".
> 
> This time with "Signed-off-by" line.
> 
> Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

> ---
>  drivers/media/video/m5mols/m5mols_core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/media/video/m5mols/m5mols_core.c b/drivers/media/video/m5mols/m5mols_core.c
> index fb8e4a7..e485e9e 100644
> --- a/drivers/media/video/m5mols/m5mols_core.c
> +++ b/drivers/media/video/m5mols/m5mols_core.c
> @@ -333,7 +333,7 @@ int m5mols_mode(struct m5mols_info *info, u8 mode)
>  	int ret = -EINVAL;
>  	u8 reg;
>  
> -	if (mode < REG_PARAMETER && mode > REG_CAPTURE)
> +	if (mode < REG_PARAMETER || mode > REG_CAPTURE)
>  		return ret;
>  
>  	ret = m5mols_read_u8(sd, SYSTEM_SYSMODE, &reg);

-- 
Regards,
Sylwester
