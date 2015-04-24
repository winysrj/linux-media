Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:57735 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754729AbbDXHjJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Apr 2015 03:39:09 -0400
Message-ID: <5539F301.4080304@xs4all.nl>
Date: Fri, 24 Apr 2015 09:38:41 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: TCMaps@gmx.net, linux-media@vger.kernel.org
Subject: Re: [PATCH] fix: make menuconfig breaks due to whitespaces in Kconfig
References: <trinity-ae8b4068-9fe5-4516-ab2f-1e8f7c02436a-1428636115681@msvc021>
In-Reply-To: <trinity-ae8b4068-9fe5-4516-ab2f-1e8f7c02436a-1428636115681@msvc021>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Can you show the Kconfig script that contains the syntax error? I don't
quite see how this goes wrong. Perhaps if I see the broken Kconfig I
understand this better.

Thanks,

	Hans

On 04/10/2015 05:21 AM, TCMaps@gmx.net wrote:
> From: TC <tcmaps@gmx.net>
> Date: Fri, 10 Apr 2015 04:29:20 +0200
> Subject: on some systems like Ubuntu 14.04, whitespaces are added from make_kconfig.pl to Kconfig script during make menuconfig
> causing it to fail with "./Kconfig:778: syntax error"!
> this patch just removes the originating spaces in two lines
> 
> 
> ---
>  v4l/scripts/make_kconfig.pl | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/v4l/scripts/make_kconfig.pl b/v4l/scripts/make_kconfig.pl
> index 28b56d0..9228a7b 100755
> --- a/v4l/scripts/make_kconfig.pl
> +++ b/v4l/scripts/make_kconfig.pl
> @@ -252,8 +252,8 @@ sub checkdeps()
>  # Text to be added to disabled options
>  my $disabled_msg = <<'EOF';
>  	---help---
> -	  WARNING! This driver needs at least kernel %s!  It may not
> -	  compile or work correctly on your kernel, which is too old.
> +	WARNING! This driver needs at least kernel %s!  It may not
> +	compile or work correctly on your kernel, which is too old.
>  
>  EOF
>  
> 

