Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway-1237.mvista.com ([206.112.117.35]:43442 "HELO
	imap.sh.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1761059AbZLJRjR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2009 12:39:17 -0500
Message-ID: <4B213200.1030603@ru.mvista.com>
Date: Thu, 10 Dec 2009 20:38:08 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
MIME-Version: 1.0
To: m-karicheri2@ti.com
Cc: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	khilman@deeprootsystems.com, nsekhar@ti.com, hvaibhav@ti.com,
	davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH - v1 5/6] V4L - vpfe capture - build environment for ISIF
 driver
References: <1260464429-10537-1-git-send-email-m-karicheri2@ti.com>	<1260464429-10537-2-git-send-email-m-karicheri2@ti.com>	<1260464429-10537-3-git-send-email-m-karicheri2@ti.com>	<1260464429-10537-4-git-send-email-m-karicheri2@ti.com> <1260464429-10537-5-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1260464429-10537-5-git-send-email-m-karicheri2@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

m-karicheri2@ti.com wrote:

> From: Muralidharan Karicheri <m-karicheri2@ti.com>
>
> Adding Makefile and Kconfig for ISIF driver
>
> Signed-off-by: Muralidharan Karicheri <m-karicheri2@ti.com>
> ---
> Applies to linux-next tree
>  drivers/media/video/Kconfig          |   15 ++++++++++++++-
>  drivers/media/video/davinci/Makefile |    1 +
>  2 files changed, 15 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
> index 9dc74c9..8250c68 100644
> --- a/drivers/media/video/Kconfig
> +++ b/drivers/media/video/Kconfig
> @@ -552,7 +552,7 @@ config VIDEO_VPSS_SYSTEM
>  	depends on ARCH_DAVINCI
>  	help
>  	  Support for vpss system module for video driver
> -	default y
> +	default n
>   

   You might as well have deleted "default".

WBR, Sergei

