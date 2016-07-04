Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753025AbcGDNWo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 09:22:44 -0400
Subject: Re: [PATCH] MAINTAINERS: change maintainer for gscpa/pwc/radio-shark
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <606f9f65-2ca9-d2dd-b9e2-e12a9aeaa0f7@xs4all.nl>
From: Hans de Goede <hdegoede@redhat.com>
Message-ID: <62571654-deb1-33ce-fd32-5effcd62eb2f@redhat.com>
Date: Mon, 4 Jul 2016 15:22:40 +0200
MIME-Version: 1.0
In-Reply-To: <606f9f65-2ca9-d2dd-b9e2-e12a9aeaa0f7@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 04-07-16 15:20, Hans Verkuil wrote:
> Hans de Goede has no more time to work on those, so I'll take over.
> For gspca/pwc I'll do 'Odd Fixes', for radio-shark I'll be a
> full maintainer.
>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

Acked-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans


> ---
>  MAINTAINERS | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 02299fd..9499b8e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5163,10 +5163,10 @@ S:	Maintained
>  F:	drivers/media/usb/gspca/m5602/
>
>  GSPCA PAC207 SONIXB SUBDRIVER
> -M:	Hans de Goede <hdegoede@redhat.com>
> +M:	Hans Verkuil <hverkuil@xs4all.nl>
>  L:	linux-media@vger.kernel.org
>  T:	git git://linuxtv.org/media_tree.git
> -S:	Maintained
> +S:	Odd Fixes
>  F:	drivers/media/usb/gspca/pac207.c
>
>  GSPCA SN9C20X SUBDRIVER
> @@ -5184,10 +5184,10 @@ S:	Maintained
>  F:	drivers/media/usb/gspca/t613.c
>
>  GSPCA USB WEBCAM DRIVER
> -M:	Hans de Goede <hdegoede@redhat.com>
> +M:	Hans Verkuil <hverkuil@xs4all.nl>
>  L:	linux-media@vger.kernel.org
>  T:	git git://linuxtv.org/media_tree.git
> -S:	Maintained
> +S:	Odd Fixes
>  F:	drivers/media/usb/gspca/
>
>  GUID PARTITION TABLE (GPT)
> @@ -9237,10 +9237,10 @@ F:	Documentation/video4linux/README.pvrusb2
>  F:	drivers/media/usb/pvrusb2/
>
>  PWC WEBCAM DRIVER
> -M:	Hans de Goede <hdegoede@redhat.com>
> +M:	Hans Verkuil <hverkuil@xs4all.nl>
>  L:	linux-media@vger.kernel.org
>  T:	git git://linuxtv.org/media_tree.git
> -S:	Maintained
> +S:	Odd Fixes
>  F:	drivers/media/usb/pwc/*
>
>  PWM FAN DRIVER
> @@ -9455,14 +9455,14 @@ F:	drivers/video/fbdev/aty/radeon*
>  F:	include/uapi/linux/radeonfb.h
>
>  RADIOSHARK RADIO DRIVER
> -M:	Hans de Goede <hdegoede@redhat.com>
> +M:	Hans Verkuil <hverkuil@xs4all.nl>
>  L:	linux-media@vger.kernel.org
>  T:	git git://linuxtv.org/media_tree.git
>  S:	Maintained
>  F:	drivers/media/radio/radio-shark.c
>
>  RADIOSHARK2 RADIO DRIVER
> -M:	Hans de Goede <hdegoede@redhat.com>
> +M:	Hans Verkuil <hverkuil@xs4all.nl>
>  L:	linux-media@vger.kernel.org
>  T:	git git://linuxtv.org/media_tree.git
>  S:	Maintained
>
