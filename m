Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:45738 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752395AbcGSIad (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 04:30:33 -0400
Subject: Re: [PATCH 2/2] [media] cec: add RC_CORE dependency
To: Arnd Bergmann <arnd@arndb.de>,
	Mauro Carvalho Chehab <mchehab@kernel.org>
References: <20160719081040.2685845-1-arnd@arndb.de>
 <20160719081040.2685845-2-arnd@arndb.de>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Kamil Debski <kamil@wypas.org>, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <578DE51E.8080604@xs4all.nl>
Date: Tue, 19 Jul 2016 10:30:22 +0200
MIME-Version: 1.0
In-Reply-To: <20160719081040.2685845-2-arnd@arndb.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/19/16 10:10, Arnd Bergmann wrote:
> We cannot build the cec driver when the RC core is a module
> and cec is built-in:
> 
> drivers/staging/built-in.o: In function `cec_allocate_adapter':
> :(.text+0x134): undefined reference to `rc_allocate_device'
> drivers/staging/built-in.o: In function `cec_register_adapter':
> :(.text+0x304): undefined reference to `rc_register_device'
> 
> This adds an explicit dependency to avoid this case. We still
> allow building when CONFIG_RC_CORE is disabled completely,
> as the driver has checks for this case itself.

This makes no sense: the rc_allocate_device and rc_register_device
are under:

#if IS_REACHABLE(CONFIG_RC_CORE)

So it shouldn't be enabled at all, should it?

Regards,

	Hans

> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> I originally submitted this on June 29, but it may have gotten
> lost as out of the three patch series, one patch got replaced
> and another patch got applied, but nothing happened on this one.
> ---
>  drivers/staging/media/cec/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/media/cec/Kconfig b/drivers/staging/media/cec/Kconfig
> index 21457a1f6c9f..c623bd32a5b8 100644
> --- a/drivers/staging/media/cec/Kconfig
> +++ b/drivers/staging/media/cec/Kconfig
> @@ -1,6 +1,7 @@
>  config MEDIA_CEC
>  	bool "CEC API (EXPERIMENTAL)"
>  	depends on MEDIA_SUPPORT
> +	depends on RC_CORE || !RC_CORE
>  	select MEDIA_CEC_EDID
>  	---help---
>  	  Enable the CEC API.
> 
