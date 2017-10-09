Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:38608 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754002AbdJIK3m (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 9 Oct 2017 06:29:42 -0400
Subject: Re: [PATCH] media: v4l2-tpg: use __u16 instead of int for struct
 tpg_rbg_color16
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
References: <a96b3f52121ef0e3446a4e33c8c34871ddabc319.1507544529.git.mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <a5ea1e04-afe6-c1be-f300-49256537f547@xs4all.nl>
Date: Mon, 9 Oct 2017 12:29:39 +0200
MIME-Version: 1.0
In-Reply-To: <a96b3f52121ef0e3446a4e33c8c34871ddabc319.1507544529.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/10/17 12:23, Mauro Carvalho Chehab wrote:
> Despite the struct says "color16", it was actually using 32 bits
> for each color. Fix it.
> 
> Suggested-by: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> ---
> 
> Should come after this patch series:
>     V4L2 kAPI cleanups and documentation improvements part 2
> 
> 
>  include/media/tpg/v4l2-tpg.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/media/tpg/v4l2-tpg.h b/include/media/tpg/v4l2-tpg.h
> index bc0b38440719..823fadede7bf 100644
> --- a/include/media/tpg/v4l2-tpg.h
> +++ b/include/media/tpg/v4l2-tpg.h
> @@ -32,7 +32,7 @@ struct tpg_rbg_color8 {
>  };
>  
>  struct tpg_rbg_color16 {
> -	int r, g, b;
> +	__u16 r, g, b;
>  };
>  
>  enum tpg_color {
> 
