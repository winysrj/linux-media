Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473Ab2ATKUp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jan 2012 05:20:45 -0500
Message-ID: <4F193FF9.4030604@redhat.com>
Date: Fri, 20 Jan 2012 08:20:41 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Benjamin Limmer <benjamin.limmer@readytalk.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Build change in media_build to support Debian
References: <52FE2DCC5CDB044F8C0070326FFDFBF30A3542@WYNENT02.readytalk.com>
In-Reply-To: <52FE2DCC5CDB044F8C0070326FFDFBF30A3542@WYNENT02.readytalk.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 19-01-2012 21:04, Benjamin Limmer escreveu:
> commit 2949a7393f3e2598d4de49b408587462b11f819f
> Author: Ben Limmer <benjamin.limmer@readytalk.com>
> Date:   Thu Jan 19 16:01:15 2012 -0700
> 
>     Update to build script to give Debian users the Ubunutu package hints. The aptitude package names are the same.
> 
> diff --git a/build b/build
> index c3947b3..6843033 100755
> --- a/build
> +++ b/build
> @@ -134,6 +134,10 @@ sub give_hints()
>                 give_arch_linux_hints;
>                 return;
>         }
> +       if ($system_release =~ /Debian/) {
> +               give_ubuntu_hints;
> +               return; 
> +       }
>  
>         # Fall-back to generic hint code
>         foreach my $prog (@missing) {
> 
> 
> Please see the above commit message. This is an easy change to support hints for debian users. I've confirmed these changes work on Debian Squeeze.
> 
> -Ben Limmer--
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Applied, thanks!
