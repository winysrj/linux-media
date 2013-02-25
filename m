Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758019Ab3BYAu6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Feb 2013 19:50:58 -0500
Date: Sun, 24 Feb 2013 21:50:52 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Ismael Luceno <ismael.luceno@corp.bluecherry.net>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] solo6x10: Update TODO (maintainer change)
Message-ID: <20130224215052.3c4ed350@redhat.com>
In-Reply-To: <1361549583-14195-1-git-send-email-ismael.luceno@corp.bluecherry.net>
References: <1361549583-14195-1-git-send-email-ismael.luceno@corp.bluecherry.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 22 Feb 2013 13:13:03 -0300
Ismael Luceno <ismael.luceno@corp.bluecherry.net> escreveu:

> 
> Signed-off-by: Ismael Luceno <ismael.luceno@corp.bluecherry.net>
> ---
>  drivers/staging/media/solo6x10/TODO | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/media/solo6x10/TODO b/drivers/staging/media/solo6x10/TODO
> index 539f739..8ae814b 100644
> --- a/drivers/staging/media/solo6x10/TODO
> +++ b/drivers/staging/media/solo6x10/TODO
> @@ -20,6 +20,5 @@ TODO (general):
>  	  - implement loopback of external sound jack with incoming audio?
>  	  - implement pause/resume
>  
> -Plase send patches to Mauro Carvalho Chehab <mchehab@redhat.com> and Cc Ben Collins
> -<bcollins@bluecherry.net>
> +Please send patches to Mauro Carvalho Chehab <mchehab@redhat.com> and
> +Cc Ismael Luceno <ismael.luceno@corp.bluecherry.net>

It would be better to also change from "Mauro Carvalho Chehab <mchehab@redhat.com>"
to "Linux Media ML <linux-media@vger.kernel.org>".


-- 

Cheers,
Mauro
