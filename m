Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:59424 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751911AbaLWRMg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 12:12:36 -0500
Message-ID: <5499A27C.3070508@xs4all.nl>
Date: Tue, 23 Dec 2014 18:12:28 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	devel@driverdev.osuosl.org
Subject: Re: [PATCH 1/2] vino: Fix media dependencies
References: <0e0a5eabdd703a7afcf310cc24ea1425eea3ef07.1419354167.git.mchehab@osg.samsung.com>
In-Reply-To: <0e0a5eabdd703a7afcf310cc24ea1425eea3ef07.1419354167.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

On 12/23/2014 06:02 PM, Mauro Carvalho Chehab wrote:
> Changeset c1d9e03d4ef4 moved the driver to staging, but it forgot to
> preserve the existing dependency.
> 
> fixes: c1d9e03d4ef4 ("[media] vino/saa7191: move to staging in preparation for removal")
> 
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/drivers/staging/media/vino/Kconfig b/drivers/staging/media/vino/Kconfig
> index 03700dadafd8..8fc1a7a9bd10 100644
> --- a/drivers/staging/media/vino/Kconfig
> +++ b/drivers/staging/media/vino/Kconfig
> @@ -1,6 +1,7 @@
>  config VIDEO_VINO
>  	tristate "SGI Vino Video For Linux (Deprecated)"
>  	depends on I2C && SGI_IP22 && VIDEO_V4L2
> +	depends on V4L_PLATFORM_DRIVERS
>  	select VIDEO_SAA7191 if MEDIA_SUBDRV_AUTOSELECT
>  	help
>  	  Say Y here to build in support for the Vino video input system found
> 
