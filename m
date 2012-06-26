Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59772 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab2FZUoO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jun 2012 16:44:14 -0400
Received: by dady13 with SMTP id y13so398313dad.19
        for <linux-media@vger.kernel.org>; Tue, 26 Jun 2012 13:44:13 -0700 (PDT)
Date: Tue, 26 Jun 2012 13:44:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Antti Palosaari <crope@iki.fi>, Kay Sievers <kay@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH RFC 4/4] tuner-xc2028: tag the usual firmwares to help
 dracut
Message-ID: <20120626204410.GE3885@kroah.com>
References: <4FE9169D.5020300@redhat.com>
 <1340739262-13747-1-git-send-email-mchehab@redhat.com>
 <1340739262-13747-5-git-send-email-mchehab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340739262-13747-5-git-send-email-mchehab@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 26, 2012 at 04:34:22PM -0300, Mauro Carvalho Chehab wrote:
> When tuner-xc2028 is not compiled as a module, dracut will
> need to copy the firmware inside the initfs image.
> 
> So, use MODULE_FIRMWARE() to indicate such need.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> ---
>  drivers/media/common/tuners/tuner-xc2028.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/media/common/tuners/tuner-xc2028.c b/drivers/media/common/tuners/tuner-xc2028.c
> index b5ee3eb..2e6c966 100644
> --- a/drivers/media/common/tuners/tuner-xc2028.c
> +++ b/drivers/media/common/tuners/tuner-xc2028.c
> @@ -1375,3 +1375,5 @@ MODULE_DESCRIPTION("Xceive xc2028/xc3028 tuner driver");
>  MODULE_AUTHOR("Michel Ludwig <michel.ludwig@gmail.com>");
>  MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@infradead.org>");
>  MODULE_LICENSE("GPL");
> +MODULE_FIRMWARE(XC2028_DEFAULT_FIRMWARE);
> +MODULE_FIRMWARE(XC3028L_DEFAULT_FIRMWARE);

This is proabably something that needs to get in now, independant of the
other 3 patches, right?

greg k-h
