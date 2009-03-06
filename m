Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f177.google.com ([209.85.219.177]:50305 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbZCFE6y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2009 23:58:54 -0500
Received: by ewy25 with SMTP id 25so126221ewy.37
        for <linux-media@vger.kernel.org>; Thu, 05 Mar 2009 20:58:51 -0800 (PST)
From: Kyle Guinn <elyk03@gmail.com>
To: kilgota@banach.math.auburn.edu
Subject: Re: [PATCH] for the file gspca/mr97310a.c
Date: Thu, 5 Mar 2009 22:58:47 -0600
Cc: linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
	"Jean-Francois Moine" <moinejf@free.fr>
References: <alpine.LNX.2.00.0903052031490.28557@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.0903052031490.28557@banach.math.auburn.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903052258.48365.elyk03@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 05 March 2009 20:34:27 kilgota@banach.math.auburn.edu wrote:
> Signed-off-by: Theodore Kilgore <kilgota@auburn.edu>
> ----------------------------------------------------------------------
> --- mr97310a.c.old	2009-02-23 23:59:07.000000000 -0600
> +++ mr97310a.c	2009-03-05 19:14:13.000000000 -0600
> @@ -29,9 +29,7 @@ MODULE_LICENSE("GPL");
>   /* specific webcam descriptor */
>   struct sd {
>   	struct gspca_dev gspca_dev;  /* !! must be the first item */
> -
>   	u8 sof_read;
> -	u8 header_read;
>   };
>
>   /* V4L2 controls supported by the driver */
> @@ -100,12 +98,9 @@ static int sd_init(struct gspca_dev *gsp
>
>   static int sd_start(struct gspca_dev *gspca_dev)
>   {
> -	struct sd *sd = (struct sd *) gspca_dev;
>   	__u8 *data = gspca_dev->usb_buf;
>   	int err_code;
>
> -	sd->sof_read = 0;
> -

Good catch, I didn't realize this was kzalloc'd.

>   	/* Note:  register descriptions guessed from MR97113A driver */
>
>   	data[0] = 0x01;
> @@ -285,40 +280,29 @@ static void sd_pkt_scan(struct gspca_dev
>   			__u8 *data,                   /* isoc packet */
>   			int len)                      /* iso packet length */
>   {
> -	struct sd *sd = (struct sd *) gspca_dev;
>   	unsigned char *sof;
>
>   	sof = pac_find_sof(gspca_dev, data, len);
>   	if (sof) {
>   		int n;
> -
> +		int marker_len = sizeof pac_sof_marker;

The value doesn't change; there's no need to use a variable for this.

>   		/* finish decoding current frame */
>   		n = sof - data;
> -		if (n > sizeof pac_sof_marker)
> -			n -= sizeof pac_sof_marker;
> +		if (n > marker_len)
> +			n -= marker_len;
>   		else
>   			n = 0;
>   		frame = gspca_frame_add(gspca_dev, LAST_PACKET, frame,
>   					data, n);
> -		sd->header_read = 0;
> -		gspca_frame_add(gspca_dev, FIRST_PACKET, frame, NULL, 0);
> -		len -= sof - data;
> +		/* Start next frame. */
> +		gspca_frame_add(gspca_dev, FIRST_PACKET, frame,
> +			pac_sof_marker, marker_len);
> +		len -= n;
> +		len -= marker_len;
> +		if (len < 0)
> +			len = 0;

len -= sof - data; is a shorter way to find the remaining length.

>   		data = sof;
>   	}
> -	if (sd->header_read < 7) {
> -		int needed;
> -
> -		/* skip the rest of the header */
> -		needed = 7 - sd->header_read;
> -		if (len <= needed) {
> -			sd->header_read += len;
> -			return;
> -		}
> -		data += needed;
> -		len -= needed;
> -		sd->header_read = 7;
> -	}
> -
>   	gspca_frame_add(gspca_dev, INTER_PACKET, frame, data, len);
>   }
>
> @@ -337,6 +321,7 @@ static const struct sd_desc sd_desc = {
>   /* -- module initialisation -- */
>   static const __devinitdata struct usb_device_id device_table[] = {
>   	{USB_DEVICE(0x08ca, 0x0111)},
> +	{USB_DEVICE(0x093a, 0x010f)},

This change is unrelated; maybe it should be in a different patch?  Don't 
forget to update Documentation/video4linux/gspca.txt with the new camera.

-Kyle
