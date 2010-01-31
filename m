Return-path: <linux-media-owner@vger.kernel.org>
Received: from jim.sh ([75.150.123.25]:42482 "EHLO psychosis.jim.sh"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024Ab0AaAOx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jan 2010 19:14:53 -0500
Date: Sat, 30 Jan 2010 19:05:05 -0500
From: Jim Paris <jim@jtan.com>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>,
	Max Thrun <bear24rw@gmail.com>
Subject: Re: [PATCH] ov534: fix end of frame handling, make the camera work
	again.
Message-ID: <20100131000504.GA24024@psychosis.jim.sh>
References: <1263678300-20313-1-git-send-email-ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263678300-20313-1-git-send-email-ospite@studenti.unina.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Antonio Ospite wrote:
> Fix a regression, probably introduced in the driver split, which made
> the ov534 driver unusable: every last packet was discarded because we
> were mis-calculating the frame size before actually adding the packet.

Hi Antonio,

> Index: gspca/linux/drivers/media/video/gspca/ov534.c
> ===================================================================
> --- gspca.orig/linux/drivers/media/video/gspca/ov534.c
> +++ gspca/linux/drivers/media/video/gspca/ov534.c
> @@ -992,9 +992,9 @@
>  			frame = gspca_get_i_frame(gspca_dev);
>  			if (frame == NULL)
>  				goto discard;
> -			if (frame->data_end - frame->data !=
> +			if (frame->data_end - frame->data + (len - 12) !=
>  			    gspca_dev->width * gspca_dev->height * 2) {
> -				PDEBUG(D_PACK, "short frame");
> +				PDEBUG(D_PACK, "wrong sized frame");
>  				goto discard;
>  			}
>  			gspca_frame_add(gspca_dev, LAST_PACKET,

This change looks correct to me.  Thanks.

Acked-by: Jim Paris <jim@jtan.com>

-jim
