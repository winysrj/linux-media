Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud8.xs4all.net ([194.109.24.25]:50298 "EHLO
        lb2-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752394AbeEKOf0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 11 May 2018 10:35:26 -0400
Subject: Re: [PATCH 6/7] Fix frame vector wildcard file check
To: Brad Love <brad@nextdimension.cc>, linux-media@vger.kernel.org
References: <1524763162-4865-1-git-send-email-brad@nextdimension.cc>
 <1524763162-4865-7-git-send-email-brad@nextdimension.cc>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <42682437-2134-023e-fc73-248689241936@xs4all.nl>
Date: Fri, 11 May 2018 16:35:20 +0200
MIME-Version: 1.0
In-Reply-To: <1524763162-4865-7-git-send-email-brad@nextdimension.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/26/18 19:19, Brad Love wrote:
> This check was consistently failing on all systems tested.
> The path to object directory is used here to explicitly override
> CWD. The thought is, if frame_vector.c exists in the build
> directory then the build system has determined it is required,
> and the source therefore should be compiled. The module will
> not be built unless the build system has enabled it's config
> option anyways, so this change should be safe in all circumstances.
> 
> Signed-off-by: Brad Love <brad@nextdimension.cc>
> ---
>  v4l/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/v4l/Makefile b/v4l/Makefile
> index b512600..270a624 100644
> --- a/v4l/Makefile
> +++ b/v4l/Makefile
> @@ -88,7 +88,7 @@ ifneq ($(filter $(no-makefile-media-targets), $(MAKECMDGOALS)),)
>  endif
>  
>  makefile-mm := 1
> -ifeq ($(wildcard ../linux/mm/frame_vector.c),)
> +ifeq ("$(wildcard $(obj)/frame_vector.c)","")
>  	makefile-mm := 0
>  endif
>  
> 

Ah, nice. Hopefully this fixes this issue. I never could figure out
why it failed for some people.

Regards,

	Hans
