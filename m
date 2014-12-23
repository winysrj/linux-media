Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:54807 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751440AbaLWRM3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Dec 2014 12:12:29 -0500
Message-ID: <5499A26E.802@xs4all.nl>
Date: Tue, 23 Dec 2014 18:12:14 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Huang Shijie <shijie8@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	devel@driverdev.osuosl.org, Jim Davis <jim.epost@gmail.com>
Subject: Re: [PATCH 2/2] tlg2300: Fix media dependencies
References: <0e0a5eabdd703a7afcf310cc24ea1425eea3ef07.1419354167.git.mchehab@osg.samsung.com> <1242d0830a5a384155efaaf84325d342a078aca4.1419354167.git.mchehab@osg.samsung.com>
In-Reply-To: <1242d0830a5a384155efaaf84325d342a078aca4.1419354167.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

On 12/23/2014 06:02 PM, Mauro Carvalho Chehab wrote:
> Changeset ea2e813e8cc3 moved the driver to staging, but it forgot to
> preserve the existing dependency.
> 
> Fixes: ea2e813e8cc3 ("[media] tlg2300: move to staging in preparation for removal")
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Cc: Jim Davis <jim.epost@gmail.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/drivers/staging/media/tlg2300/Kconfig b/drivers/staging/media/tlg2300/Kconfig
> index 81784c6f7b88..77d8753f6ba4 100644
> --- a/drivers/staging/media/tlg2300/Kconfig
> +++ b/drivers/staging/media/tlg2300/Kconfig
> @@ -1,6 +1,7 @@
>  config VIDEO_TLG2300
>  	tristate "Telegent TLG2300 USB video capture support (Deprecated)"
>  	depends on VIDEO_DEV && I2C && SND && DVB_CORE
> +	depends on MEDIA_USB_SUPPORT
>  	select VIDEO_TUNER
>  	select VIDEO_TVEEPROM
>  	depends on RC_CORE
> 
