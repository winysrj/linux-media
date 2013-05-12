Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54992 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751243Ab3ELHRY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 May 2013 03:17:24 -0400
Date: Sun, 12 May 2013 10:17:19 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Roberto =?iso-8859-1?Q?Alc=E2ntara?= <roberto@eletronica.org>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] smscoreapi: Make Siano firmware load more verbose
Message-ID: <20130512071719.GA6748@valkosipuli.retiisi.org.uk>
References: <CAEt6MXmqv6KwkKoQzAGkG+vU07z_vV6gET8hSDAdxu=WBt3jtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEt6MXmqv6KwkKoQzAGkG+vU07z_vV6gET8hSDAdxu=WBt3jtw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Roberto,

On Sat, May 11, 2013 at 12:53:29PM -0300, Roberto Alcântara wrote:
> Signed-off-by: Roberto Alcantara <roberto@eletronica.org>
> 
> diff --git a/drivers/media/common/siano/smscoreapi.c
> b/drivers/media/common/siano/smscoreapi.c
> index 45ac9ee..dbe9b4d 100644
> --- a/drivers/media/common/siano/smscoreapi.c
> +++ b/drivers/media/common/siano/smscoreapi.c
> @@ -1154,7 +1154,7 @@ static int
> smscore_load_firmware_from_file(struct smscore_device_t *coredev,
> 
>      char *fw_filename = smscore_get_fw_filename(coredev, mode);
>      if (!fw_filename) {
> -        sms_info("mode %d not supported on this device", mode);
> +        sms_err("mode %d not supported on this device", mode);
>          return -ENOENT;
>      }
>      sms_debug("Firmware name: %s", fw_filename);
> @@ -1165,14 +1165,14 @@ static int
> smscore_load_firmware_from_file(struct smscore_device_t *coredev,
> 
>      rc = request_firmware(&fw, fw_filename, coredev->device);
>      if (rc < 0) {
> -        sms_info("failed to open \"%s\"", fw_filename);
> +        sms_err("failed to open firmware file \"%s\"", fw_filename);
>          return rc;
>      }
>      sms_info("read fw %s, buffer size=0x%zx", fw_filename, fw->size);
>      fw_buf = kmalloc(ALIGN(fw->size, SMS_ALLOC_ALIGNMENT),
>               GFP_KERNEL | GFP_DMA);
>      if (!fw_buf) {
> -        sms_info("failed to allocate firmware buffer");
> +        sms_err("failed to allocate firmware buffer");

It's not really related to this patch, but I think there's a memory leak
here: release_firmware() isn't called if kmalloc() above fails. I'd just add
a goto and a label to the end of the function where that's being done (and
set rc, too).

While you're at it, could you send a patch for that, please?

>          return -ENOMEM;
>      }
>      memcpy(fw_buf, fw->data, fw->size);

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
