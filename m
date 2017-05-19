Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:20483 "EHLO
        mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750760AbdESHXC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 May 2017 03:23:02 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OQ6001X0V6C3230@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 19 May 2017 08:23:00 +0100 (BST)
Subject: Re: [PATCH 3/4] [media] s5p-jpeg: don't return a random width/height
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        linux-arm-kernel@lists.infradead.org
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Message-id: <991ced35-4d49-0c8b-2656-ba23046750a5@samsung.com>
Date: Fri, 19 May 2017 09:22:52 +0200
MIME-version: 1.0
In-reply-to: <db2a1b1de920cc4bccaadbbbeee11a854ab81f00.1495116400.git.mchehab@s-opensource.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-language: en-US
Content-transfer-encoding: 7bit
References: <754069659fbb44b458d8a8bef67d8f3f235d0c87.1495116400.git.mchehab@s-opensource.com>
 <CGME20170518140655epcas1p355f0f629cfef1f44dd6a23f4264af22a@epcas1p3.samsung.com>
 <db2a1b1de920cc4bccaadbbbeee11a854ab81f00.1495116400.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

W dniu 18.05.2017 o 16:06, Mauro Carvalho Chehab pisze:
> Gcc 7.1 complains about:
> 
> drivers/media/platform/s5p-jpeg/jpeg-core.c: In function 's5p_jpeg_parse_hdr.isra.9':
> drivers/media/platform/s5p-jpeg/jpeg-core.c:1207:12: warning: 'width' may be used uninitialized in this function [-Wmaybe-uninitialized]
>    result->w = width;
>    ~~~~~~~~~~^~~~~~~
> drivers/media/platform/s5p-jpeg/jpeg-core.c:1208:12: warning: 'height' may be used uninitialized in this function [-Wmaybe-uninitialized]
>    result->h = height;
>    ~~~~~~~~~~^~~~~~~~
> 
> Indeed the code would allow it to return a random value (although
> it shouldn't happen, in practice). So, explicitly set both to zero,
> just in case.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>


Acked-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>



> ---
>   drivers/media/platform/s5p-jpeg/jpeg-core.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> index 52dc7941db65..1da2c94e1dca 100644
> --- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
> +++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
> @@ -1099,10 +1099,10 @@ static bool s5p_jpeg_parse_hdr(struct s5p_jpeg_q_data *result,
>   			       struct s5p_jpeg_ctx *ctx)
>   {
>   	int c, components = 0, notfound, n_dht = 0, n_dqt = 0;
> -	unsigned int height, width, word, subsampling = 0, sos = 0, sof = 0,
> -		     sof_len = 0;
> -	unsigned int dht[S5P_JPEG_MAX_MARKER], dht_len[S5P_JPEG_MAX_MARKER],
> -		     dqt[S5P_JPEG_MAX_MARKER], dqt_len[S5P_JPEG_MAX_MARKER];
> +	unsigned int height = 0, width = 0, word, subsampling = 0;
> +	unsigned int sos = 0, sof = 0, sof_len = 0;
> +	unsigned int dht[S5P_JPEG_MAX_MARKER], dht_len[S5P_JPEG_MAX_MARKER];
> +	unsigned int dqt[S5P_JPEG_MAX_MARKER], dqt_len[S5P_JPEG_MAX_MARKER];
>   	long length;
>   	struct s5p_jpeg_buffer jpeg_buffer;
>   
> 
