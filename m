Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ia0-f182.google.com ([209.85.210.182]:48212 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506Ab3BVGcK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Feb 2013 01:32:10 -0500
Received: by mail-ia0-f182.google.com with SMTP id k38so273366iah.13
        for <linux-media@vger.kernel.org>; Thu, 21 Feb 2013 22:32:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1361487238-4921-1-git-send-email-ismael.luceno@corp.bluecherry.net>
References: <1361487238-4921-1-git-send-email-ismael.luceno@corp.bluecherry.net>
Date: Fri, 22 Feb 2013 03:32:08 -0300
Message-ID: <CALF0-+VBUW-YrC2eKgb1XSahZOS9cTde=vivk7q24PD8oNhzcA@mail.gmail.com>
Subject: Re: [PATCH] solo6x10: Maintainer change
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Ismael Luceno <ismael.luceno@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-media@vger.kernel.org,
	Ismael Luceno <ismael.luceno@corp.bluecherry.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ismael,

On Thu, Feb 21, 2013 at 7:53 PM, Ismael Luceno <ismael.luceno@gmail.com> wrote:
> Signed-off-by: Ismael Luceno <ismael.luceno@corp.bluecherry.net>
> ---
>  MAINTAINERS | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3b95564..eb277c9 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7315,8 +7315,8 @@ S:        Odd Fixes
>  F:     drivers/staging/sm7xxfb/
>
>  STAGING - SOFTLOGIC 6x10 MPEG CODEC
> -M:     Ben Collins <bcollins@bluecherry.net>
> -S:     Odd Fixes
> +M:     Ismael Luceno <ismael.luceno@corp.bluecherry.net>
> +S:     Supported
>  F:     drivers/staging/media/solo6x10/
>

It's great to see that you're going to maintain this!

FYI, Greg has nothing to do with drivers/staging/media, so you don't
need to put him in Cc.
The media maintainer is Mauro, and you don't need to Cc him, just send
your patches to linux-media ML.

-- 
    Ezequiel
