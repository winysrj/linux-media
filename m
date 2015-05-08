Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:41182 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752719AbbEHLeF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 8 May 2015 07:34:05 -0400
Message-ID: <554C9F1A.6000502@xs4all.nl>
Date: Fri, 08 May 2015 13:33:46 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 01/18] media controller: add EXPERIMENTAL to Kconfig option
 for DVB support
References: <cover.1431046915.git.mchehab@osg.samsung.com> <35cb86bc03b693fd5ef6133c22c78aacfd63a0e2.1431046915.git.mchehab@osg.samsung.com>
In-Reply-To: <35cb86bc03b693fd5ef6133c22c78aacfd63a0e2.1431046915.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/08/2015 03:12 AM, Mauro Carvalho Chehab wrote:
> The Media Controller DVB support is still an experimental feature,
> as it is under heavy development. It is already said that it is
> an experimental feature at the help, but let make it even clearer
> and louder, as we may need to adjust some bits when we start using it
> on embedded drivers.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans

> 
> diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
> index 3ef0f90b128f..8af89b084267 100644
> --- a/drivers/media/Kconfig
> +++ b/drivers/media/Kconfig
> @@ -95,7 +95,7 @@ config MEDIA_CONTROLLER
>  	  This API is mostly used by camera interfaces in embedded platforms.
>  
>  config MEDIA_CONTROLLER_DVB
> -	bool "Enable Media controller for DVB"
> +	bool "Enable Media controller for DVB (EXPERIMENTAL)"
>  	depends on MEDIA_CONTROLLER
>  	---help---
>  	  Enable the media controller API support for DVB.
> 

