Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:47765 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750837AbaK0JEw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Nov 2014 04:04:52 -0500
Message-ID: <5476E92B.9000901@xs4all.nl>
Date: Thu, 27 Nov 2014 10:04:43 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ismael Luceno <ismael.luceno@corp.bluecherry.net>,
	linux-media@vger.kernel.org
CC: Andrey Utkin <andrey.utkin@corp.bluecherry.net>
Subject: Re: [PATCH] solo6x10: Maintainers update
References: <1417068663-18222-1-git-send-email-ismael.luceno@corp.bluecherry.net>
In-Reply-To: <1417068663-18222-1-git-send-email-ismael.luceno@corp.bluecherry.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ismael,

Can you make a patch on top of Andrey's earlier patch? That one is already
accepted for 3.18.

Regards,

	Hans

On 11/27/2014 07:11 AM, Ismael Luceno wrote:
> Adding Andrey Utkin, and I'll be using my personal email address from
> now on.
> 
> Signed-off-by: Ismael Luceno <ismael.luceno@corp.bluecherry.net>
> ---
>  MAINTAINERS | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0ff630d..b4ba217 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8682,7 +8682,8 @@ S:	Maintained
>  F:	drivers/leds/leds-net48xx.c
>  
>  SOFTLOGIC 6x10 MPEG CODEC
> -M:	Ismael Luceno <ismael.luceno@corp.bluecherry.net>
> +M:	Ismael Luceno <ismael@iodev.co.uk>
> +M:	Andrey Utkin <andrey.utkin@corp.bluecherry.net>
>  L:	linux-media@vger.kernel.org
>  S:	Supported
>  F:	drivers/media/pci/solo6x10/
> 
