Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2095 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab3BVADY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Feb 2013 19:03:24 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ismael Luceno <ismael.luceno@gmail.com>
Subject: Re: [PATCH] solo6x10: Maintainer change
Date: Thu, 21 Feb 2013 16:03:08 -0800
Cc: gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>
References: <1361487238-4921-1-git-send-email-ismael.luceno@corp.bluecherry.net>
In-Reply-To: <1361487238-4921-1-git-send-email-ismael.luceno@corp.bluecherry.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302211603.08411.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday, February 21, 2013 14:53:58 Ismael Luceno wrote:
> Signed-off-by: Ismael Luceno <ismael.luceno@corp.bluecherry.net>
> ---
>  MAINTAINERS | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3b95564..eb277c9 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7315,8 +7315,8 @@ S:	Odd Fixes
>  F:	drivers/staging/sm7xxfb/
>  
>  STAGING - SOFTLOGIC 6x10 MPEG CODEC
> -M:	Ben Collins <bcollins@bluecherry.net>
> -S:	Odd Fixes
> +M:	Ismael Luceno <ismael.luceno@corp.bluecherry.net>
> +S:	Supported
>  F:	drivers/staging/media/solo6x10/
>  
>  STAGING - SPEAKUP CONSOLE SPEECH DRIVER
> 

Hi Ismael!

FYI: I'm working on updates to the solo driver:

http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/solo

It's work-in-progress but I hope to finish it within 1-2 weeks.

I might ask you for some help if I need some information.

Regards,

	Hans
