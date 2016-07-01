Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:55968 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751960AbcGALPL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Jul 2016 07:15:11 -0400
Subject: Re: usbvision: problems adding support for ATI TV Wonder USB Edition
To: Christopher Chavez <chrischavez@gmx.us>,
	linux-media@vger.kernel.org
References: <CAAFQ00=2qFjs41KJs5evJVcCHjuCwtATeTL6aOvz8tN47_RyTQ@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <d37d5725-b6cb-fe15-1767-a28649153137@xs4all.nl>
Date: Fri, 1 Jul 2016 13:15:05 +0200
MIME-Version: 1.0
In-Reply-To: <CAAFQ00=2qFjs41KJs5evJVcCHjuCwtATeTL6aOvz8tN47_RyTQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Christopher,

On 12/19/2015 07:12 AM, Christopher Chavez wrote:
> Hi,
> 
> Not yet an experienced developer here, still working on BSCmpE.
> 
> I have attempted to add long-awaited support for the ATI TV Wonder USB Edition
> (NTSC) to usbvision. I have patches of what I've accomplished so far, but I'm
> not yet able to test it due to a couple of issues, at least one of which appears
> to be an outstanding bug from a few years ago (the "cannot change alternate
> number to 1 (error=-22)" issue). The entry in usbvision-cards.c is based on a
> similar Pinnacle and Hauppauge entries: the device looks like it might have been
> a rebadged Hauppauge WinTV USB, but inside it has both the NT1004 and NT1005
> bridges, SAA7113H input processor, and FI1236MK2 tuner (although none of the
> supported devices use .tuner_type = TUNER_PHILIPS_NTSC).
> 
> I'm still researching what other programs to test this with (VLC? v4l-utils?)...

I use qv4l2 from v4l-utils.

Did you make any progress with this?

The problem is that the usbvision driver is very old and very badly written. And
I doubt anyone will have time to upgrade this driver to modern standards.

I don't mind taking this patch, but I should at least have confirmation that you
got it to work :-)

Regards,

	Hans (who is cleaning out old submitted patches)

> 
> Christopher Chavez
> 
> 
> ---
>  drivers/media/usb/usbvision/usbvision-cards.c | 15 +++++++++++++++
>  drivers/media/usb/usbvision/usbvision-cards.h |  1 +
>  drivers/media/usb/usbvision/usbvision-video.c |  3 ++-
>  3 files changed, 18 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/usbvision/usbvision-cards.c
> b/drivers/media/usb/usbvision/usbvision-cards.c
> index 3103d0d..7b1edb7 100644
> --- a/drivers/media/usb/usbvision/usbvision-cards.c
> +++ b/drivers/media/usb/usbvision/usbvision-cards.c
> @@ -1054,6 +1054,20 @@ struct usbvision_device_data_st
> usbvision_device_data[] = {
>          .y_offset       = 18,
>          .model_string   = "Nogatech USB MicroCam PAL (NV3001P)",
>      },
> +    [ATI_TV_WONDER_USB_NTSC] = {
> +        .interface      = 0,
> +        .codec          = CODEC_SAA7113,
> +        .video_channels = 3,
> +        .video_norm     = V4L2_STD_NTSC,
> +        .audio_channels = 1,
> +        .radio          = 0,
> +        .vbi            = 1,
> +        .tuner          = 1,
> +        .tuner_type     = TUNER_PHILIPS_NTSC,
> +        .x_offset       = -1,
> +        .y_offset       = -1,
> +        .model_string   = "ATI TV Wonder USB Edition (NTSC)",
> +    },
>  };
>  const int usbvision_device_data_size = ARRAY_SIZE(usbvision_device_data);
> 
> @@ -1064,6 +1078,7 @@ struct usb_device_id usbvision_table[] = {
>      { USB_DEVICE(0x050d, 0x0106), .driver_info = BELKIN_VIDEOBUS_II },
>      { USB_DEVICE(0x050d, 0x0207), .driver_info = BELKIN_VIDEOBUS },
>      { USB_DEVICE(0x050d, 0x0208), .driver_info = BELKIN_USB_VIDEOBUS_II },
> +    { USB_DEVICE(0x0528, 0x7561), .driver_info = ATI_TV_WONDER_USB_NTSC },
>      { USB_DEVICE(0x0571, 0x0002), .driver_info = ECHOFX_INTERVIEW_LITE },
>      { USB_DEVICE(0x0573, 0x0003), .driver_info = USBGEAR_USBG_V1 },
>      { USB_DEVICE(0x0573, 0x0400), .driver_info = D_LINK_V100 },
> diff --git a/drivers/media/usb/usbvision/usbvision-cards.h
> b/drivers/media/usb/usbvision/usbvision-cards.h
> index a51cc11..ed1197c 100644
> --- a/drivers/media/usb/usbvision/usbvision-cards.h
> +++ b/drivers/media/usb/usbvision/usbvision-cards.h
> @@ -65,5 +65,6 @@
>  #define PINNA_PCTV_USB_NTSC_FM_V3                64
>  #define MICROCAM_NTSC                            65
>  #define MICROCAM_PAL                             66
> +#define ATI_TV_WONDER_USB_NTSC                   67
> 
>  extern const int usbvision_device_data_size;
> diff --git a/drivers/media/usb/usbvision/usbvision-video.c
> b/drivers/media/usb/usbvision/usbvision-video.c
> index de9ff3b..c76e1397 100644
> --- a/drivers/media/usb/usbvision/usbvision-video.c
> +++ b/drivers/media/usb/usbvision/usbvision-video.c
> @@ -1511,7 +1511,8 @@ static int usbvision_probe(struct usb_interface *intf,
> 
>      if (dev->descriptor.bNumConfigurations > 1)
>          usbvision->bridge_type = BRIDGE_NT1004;
> -    else if (model == DAZZLE_DVC_90_REV_1_SECAM)
> +    else if ((model == DAZZLE_DVC_90_REV_1_SECAM) ||
> +             (model == ATI_TV_WONDER_USB_NTSC))
>          usbvision->bridge_type = BRIDGE_NT1005;
>      else
>          usbvision->bridge_type = BRIDGE_NT1003;
> 
