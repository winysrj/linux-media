Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:3058 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab2E0RPz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 May 2012 13:15:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC PATCH 1/3] media: reorganize the main Kconfig items
Date: Sun, 27 May 2012 19:15:44 +0200
References: <4FC24E34.3000406@redhat.com> <1338137803-12231-1-git-send-email-mchehab@redhat.com> <1338137803-12231-2-git-send-email-mchehab@redhat.com>
In-Reply-To: <1338137803-12231-2-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205271915.44288.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just a few typos...

On Sun May 27 2012 18:56:41 Mauro Carvalho Chehab wrote:
> Change the main items to:
> 
> <m> Multimedia support  --->
>    [ ]   Webcams and video grabbers support
>    [ ]   Analog TV API and drivers support
>    [ ]   Digital TV support
>    [ ]   AM/FM radio receivers/transmitters support
>    [ ]   Remote Controller support
> 
> This provides an interface that is clearer to end users that
> are compiling the Kernel, and will allow the building system
> to automatically unselect drivers for unused functions.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/media/Kconfig               |  110 ++++++++++++++++++++++++-----------
>  drivers/media/common/tuners/Kconfig |    1 +
>  drivers/media/dvb/frontends/Kconfig |    1 +
>  drivers/media/rc/Kconfig            |   29 ++++-----
>  4 files changed, 90 insertions(+), 51 deletions(-)
> 
> diff --git a/drivers/media/Kconfig b/drivers/media/Kconfig
> index 9575db4..8deddcd 100644
> --- a/drivers/media/Kconfig
> +++ b/drivers/media/Kconfig
> @@ -6,20 +6,83 @@ menuconfig MEDIA_SUPPORT
>  	tristate "Multimedia support"
>  	depends on HAS_IOMEM
>  	help
> -	  If you want to use Video for Linux, DVB for Linux, or DAB adapters,
> +	  If you want to use Webcams, Video grabber devices and/or TV devices
>  	  enable this option and other options below.
>  
> +	  Additional info and docs are available on the web at
> +	  <http://linuxtv.org>
> +
>  if MEDIA_SUPPORT
>  
>  comment "Multimedia core support"
>  
>  #
> +# Multimedia support - automatically enable V4L2 and DVB core
> +#
> +config MEDIA_WEBCAM_SUPP
> +	bool "Webcams and video grabbers support"
> +	---help---
> +	  Enable support for webcams and video grabbers.
> +
> +	  Say Y when you have a webcam or a video capture grabber board.
> +
> +config MEDIA_ANALOG_TV_SUPP
> +	bool "Analog TV API and drivers support"

I would rename this to "Analog TV support" to be consistent with the digital
option.

> +	---help---
> +	  Enable analog TV support.
> +
> +	  Say Y when you have a TV board with analog support of with an

Typo: of with an -> or with a

> +	  hybrid analog/digital TV chipset.
> +
> +	  Note: There are several DVB cards that are based on chips that
> +		supports both analog and digital TV. Disabling this option

supports -> support

> +		will disable support for them.
> +
> +config MEDIA_DIGITAL_TV_SUPP
> +	bool "Digital TV support"
> +	---help---
> +	  Enable digital TV support.
> +
> +	  Say Y when you have a board with digital support or a board with
> +	  hybrid digital TV and analog TV.
> +
> +config MEDIA_RADIO_SUPP
> +	bool "AM/FM radio receivers/transmitters support"
> +	---help---
> +	  Enable AM/FM radio support.
> +
> +	  Additional info and docs are available on the web at
> +	  <http://linuxtv.org>
> +
> +	  Say Y when you have a board with radio support.
> +
> +	  Note: There are several TV cards that are based on chips that
> +		supports radio reception Disabling this option will

supports -> support

Also add a period after reception.

Regards,

	Hans
