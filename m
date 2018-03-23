Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:63502 "EHLO
        aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751793AbeCWMfR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 08:35:17 -0400
Subject: Re: [PATCH 07/30] media: v4l2-tpg-core: avoid buffer overflows
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
 <1a086879fdd37d9e4c3dd4e49fac62f7e418e17e.1521806166.git.mchehab@s-opensource.com>
From: Hans Verkuil <hansverk@cisco.com>
Message-ID: <c71636ab-80f5-0173-ad45-bb5bd414a10a@cisco.com>
Date: Fri, 23 Mar 2018 13:35:13 +0100
MIME-Version: 1.0
In-Reply-To: <1a086879fdd37d9e4c3dd4e49fac62f7e418e17e.1521806166.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/23/18 12:56, Mauro Carvalho Chehab wrote:
> Fix the following warnings:
> 	drivers/media/common/v4l2-tpg/v4l2-tpg-core.c:1146 gen_twopix() error: buffer overflow 'buf[1]' 8 <= 8
> 	drivers/media/common/v4l2-tpg/v4l2-tpg-core.c:1152 gen_twopix() error: buffer overflow 'buf[1]' 8 <= 8
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---
>  drivers/media/common/v4l2-tpg/v4l2-tpg-core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
> index d248d1fb9d1d..37632bc524d4 100644
> --- a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
> +++ b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
> @@ -1143,13 +1143,13 @@ static void gen_twopix(struct tpg_data *tpg,
>  	case V4L2_PIX_FMT_NV24:
>  		buf[0][offset] = r_y_h;
>  		buf[1][2 * offset] = g_u_s;
> -		buf[1][2 * offset + 1] = b_v;
> +		buf[1][(2 * offset + 1) % 8] = b_v;
>  		break;
>  
>  	case V4L2_PIX_FMT_NV42:
>  		buf[0][offset] = r_y_h;
>  		buf[1][2 * offset] = b_v;
> -		buf[1][2 * offset + 1] = g_u_s;
> +		buf[1][(2 * offset + 1) %8] = g_u_s;

Space after '%'

>  		break;
>  
>  	case V4L2_PIX_FMT_YUYV:
> 

Nice! I always wondered how to fix this bogus error, but this will do it.

After fixing the space:

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks,

	Hans
