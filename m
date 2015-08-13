Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:53557 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752212AbbHMWYd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Aug 2015 18:24:33 -0400
Message-ID: <55CD18FF.5060103@xs4all.nl>
Date: Fri, 14 Aug 2015 00:23:59 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Robert 'Bobby' Zenz <Robert.Zenz@bonsaimind.org>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] Fixed syntax errors in v4.1_pat_enabled.patch.
References: <20150813214712.7e5c2814@Dagon>
In-Reply-To: <20150813214712.7e5c2814@Dagon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Oops, my mistake.

Thanks for the patch, I've applied it.

Regards,

	Hans


On 08/13/2015 09:47 PM, Robert 'Bobby' Zenz wrote:
> Signed-off-by: Robert Zenz <Robert.Zenz@bonsaimind.org>
> ---
>  backports/v4.1_pat_enabled.patch | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/backports/v4.1_pat_enabled.patch b/backports/v4.1_pat_enabled.patch
> index b266d9d..66a8671 100644
> --- a/backports/v4.1_pat_enabled.patch
> +++ b/backports/v4.1_pat_enabled.patch
> @@ -10,9 +10,8 @@ index 8b95eef..020955d 100644
>  -		pr_warn("ivtvfb needs PAT disabled, boot with nopat kernel parameter\n");
>  +#ifdef CONFIG_X86_PAT
>  +	if (WARN(pat_enabled,
> -+		"ivtvfb needs PAT disabled, boot with nopat kernel parameter\n");
> ++		"ivtvfb needs PAT disabled, boot with nopat kernel parameter\n"))
>   		return -ENODEV;
> - 	}
>   #endif
>  +#endif
>   
> 

