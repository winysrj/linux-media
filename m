Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:34034 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab3JLJjX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Oct 2013 05:39:23 -0400
Message-ID: <525918C1.7090704@gmail.com>
Date: Sat, 12 Oct 2013 11:39:13 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Seung-Woo Kim <sw0312.kim@samsung.com>
CC: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	s.nawrocki@samsung.com
Subject: Re: [PATCH] s5p-jpeg: fix uninitialized use in hdr parse
References: <1381388791-1828-1-git-send-email-sw0312.kim@samsung.com>
In-Reply-To: <1381388791-1828-1-git-send-email-sw0312.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Seung-Woo,

On 10/10/2013 09:06 AM, Seung-Woo Kim wrote:
> For hdr parse error, it can return false without any assignments
> which cause build warning.
>
> Signed-off-by: Seung-Woo Kim<sw0312.kim@samsung.com>
> ---
>   drivers/media/platform/s5p-jpeg/jpeg-core.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> index 15d2396..7db374e 100644
> --- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
> +++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> @@ -442,14 +442,14 @@ static bool s5p_jpeg_parse_hdr(struct s5p_jpeg_q_data *result,
>   	while (notfound) {
>   		c = get_byte(&jpeg_buffer);
>   		if (c == -1)
> -			break;
> +			return false;

notfound is being assigned before entering the while loop, so I'm not sure
what exactly is not correct here. Can you quote the original build 
warning ?
It's a good idea to always include compiler errors/warnings in the commit
message.

BTW, name of the variable is a bit confusing, I think naming it 'found' and
using negation of it would be easier to follow; that's not something we'd
be changing now though.

>   		if (c != 0xff)
>   			continue;
>   		do
>   			c = get_byte(&jpeg_buffer);
>   		while (c == 0xff);
>   		if (c == -1)
> -			break;
> +			return false;
>   		if (c == 0)
>   			continue;
>   		length = 0;

Thanks,
Sylwester
