Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:2650 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757912Ab3BLIAl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Feb 2013 03:00:41 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Frank =?utf-8?q?Sch=C3=A4fer?= <fschaefer.oss@googlemail.com>
Subject: Re: [PATCH] em28xx: remove some obsolete function declarations
Date: Tue, 12 Feb 2013 09:00:23 +0100
Cc: mchehab@redhat.com, linux-media@vger.kernel.org
References: <1360605241-3192-1-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1360605241-3192-1-git-send-email-fschaefer.oss@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201302120900.23580.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon February 11 2013 18:54:01 Frank Schäfer wrote:
> Signed-off-by: Frank Schäfer <fschaefer.oss@googlemail.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  drivers/media/usb/em28xx/em28xx.h |    8 --------
>  1 Datei geändert, 8 Zeilen entfernt(-)
> 
> diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
> index 7dc27b5..a3c08ae 100644
> --- a/drivers/media/usb/em28xx/em28xx.h
> +++ b/drivers/media/usb/em28xx/em28xx.h
> @@ -654,11 +654,6 @@ int  em28xx_i2c_register(struct em28xx *dev);
>  int  em28xx_i2c_unregister(struct em28xx *dev);
>  
>  /* Provided by em28xx-core.c */
> -
> -u32 em28xx_request_buffers(struct em28xx *dev, u32 count);
> -void em28xx_queue_unusedframes(struct em28xx *dev);
> -void em28xx_release_buffers(struct em28xx *dev);
> -
>  int em28xx_read_reg_req_len(struct em28xx *dev, u8 req, u16 reg,
>  			    char *buf, int len);
>  int em28xx_read_reg_req(struct em28xx *dev, u8 req, u16 reg);
> @@ -691,7 +686,6 @@ int em28xx_init_usb_xfer(struct em28xx *dev, enum em28xx_mode mode,
>  					(struct em28xx *dev, struct urb *urb));
>  void em28xx_uninit_usb_xfer(struct em28xx *dev, enum em28xx_mode mode);
>  void em28xx_stop_urbs(struct em28xx *dev);
> -int em28xx_isoc_dvb_max_packetsize(struct em28xx *dev);
>  int em28xx_set_mode(struct em28xx *dev, enum em28xx_mode set_mode);
>  int em28xx_gpio_set(struct em28xx *dev, struct em28xx_reg_seq *gpio);
>  void em28xx_wake_i2c(struct em28xx *dev);
> @@ -710,10 +704,8 @@ int em28xx_stop_vbi_streaming(struct vb2_queue *vq);
>  extern const struct v4l2_ctrl_ops em28xx_ctrl_ops;
>  
>  /* Provided by em28xx-cards.c */
> -extern int em2800_variant_detect(struct usb_device *udev, int model);
>  extern struct em28xx_board em28xx_boards[];
>  extern struct usb_device_id em28xx_id_table[];
> -extern const unsigned int em28xx_bcount;
>  int em28xx_tuner_callback(void *ptr, int component, int command, int arg);
>  void em28xx_release_resources(struct em28xx *dev);
>  
> 
