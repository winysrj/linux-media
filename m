Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758441AbZJEH2o (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Oct 2009 03:28:44 -0400
Message-ID: <4AC9A108.8040504@redhat.com>
Date: Mon, 05 Oct 2009 09:32:24 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
CC: Jean-Francois Moine <moinejf@free.fr>,
	Thomas Kaiser <thomas@kaiser-linux.li>,
	Kyle Guinn <elyk03@gmail.com>,
	Theodore Kilgore <kilgota@auburn.edu>,
	V4L Mailing List <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	ltp-list@lists.sourceforge.net
Subject: Re: [PATCH] pac_common: redesign function for finding Start Of Frame
References: <4AC90BBF.9040803@freemail.hu>
In-Reply-To: <4AC90BBF.9040803@freemail.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Good one,

Acked-by: Hans de Goede <hdegoede@redhat.com>

Jean-Francois, can you please add this patch to your tree?

Thanks,

Hans


On 10/04/2009 10:55 PM, Németh Márton wrote:
> From: Márton Németh<nm127@freemail.hu>
>
> The original implementation of pac_find_sof() does not always find
> the Start Of Frame (SOF) marker. Replace it with a state machine
> based design.
>
> The change was tested with Labtec Webcam 2200.
>
> Signed-off-by: Márton Németh<nm127@freemail.hu>
> ---
> --- linux-2.6.32-rc1.orig/drivers/media/video/gspca/pac_common.h	2009-09-10 00:13:59.000000000 +0200
> +++ linux-2.6.32-rc1/drivers/media/video/gspca/pac_common.h	2009-10-04 21:49:19.000000000 +0200
> @@ -33,6 +33,45 @@
>   static const unsigned char pac_sof_marker[5] =
>   		{ 0xff, 0xff, 0x00, 0xff, 0x96 };
>
> +/*
> +   The following state machine finds the SOF marker sequence
> +   0xff, 0xff, 0x00, 0xff, 0x96 in a byte stream.
> +
> +	   +----------+
> +	   | 0: START |<---------------\
> +	   +----------+<-\             |
> +	     |       \---/otherwise    |
> +	     v 0xff                    |
> +	   +----------+ otherwise      |
> +	   |     1    |--------------->*
> +	   |          |                ^
> +	   +----------+                |
> +	     |                         |
> +	     v 0xff                    |
> +	   +----------+<-\0xff         |
> +	/->|          |--/             |
> +	|  |     2    |--------------->*
> +	|  |          | otherwise      ^
> +	|  +----------+                |
> +	|    |                         |
> +	|    v 0x00                    |
> +	|  +----------+                |
> +	|  |     3    |                |
> +	|  |          |--------------->*
> +	|  +----------+ otherwise      ^
> +	|    |                         |
> +   0xff |    v 0xff                    |
> +	|  +----------+                |
> +	\--|     4    |                |
> +	   |          |----------------/
> +	   +----------+ otherwise
> +	     |
> +	     v 0x96
> +	   +----------+
> +	   |  FOUND   |
> +	   +----------+
> +*/
> +
>   static unsigned char *pac_find_sof(struct gspca_dev *gspca_dev,
>   					unsigned char *m, int len)
>   {
> @@ -41,17 +80,54 @@ static unsigned char *pac_find_sof(struc
>
>   	/* Search for the SOF marker (fixed part) in the header */
>   	for (i = 0; i<  len; i++) {
> -		if (m[i] == pac_sof_marker[sd->sof_read]) {
> -			sd->sof_read++;
> -			if (sd->sof_read == sizeof(pac_sof_marker)) {
> +		switch (sd->sof_read) {
> +		case 0:
> +			if (m[i] == 0xff)
> +				sd->sof_read = 1;
> +			break;
> +		case 1:
> +			if (m[i] == 0xff)
> +				sd->sof_read = 2;
> +			else
> +				sd->sof_read = 0;
> +			break;
> +		case 2:
> +			switch (m[i]) {
> +			case 0x00:
> +				sd->sof_read = 3;
> +				break;
> +			case 0xff:
> +				/* stay in this state */
> +				break;
> +			default:
> +				sd->sof_read = 0;
> +			}
> +			break;
> +		case 3:
> +			if (m[i] == 0xff)
> +				sd->sof_read = 4;
> +			else
> +				sd->sof_read = 0;
> +			break;
> +		case 4:
> +			switch (m[i]) {
> +			case 0x96:
> +				/* Pattern found */
>   				PDEBUG(D_FRAM,
>   					"SOF found, bytes to analyze: %u."
>   					" Frame starts at byte #%u",
>   					len, i + 1);
>   				sd->sof_read = 0;
>   				return m + i + 1;
> +				break;
> +			case 0xff:
> +				sd->sof_read = 2;
> +				break;
> +			default:
> +				sd->sof_read = 0;
>   			}
> -		} else {
> +			break;
> +		default:
>   			sd->sof_read = 0;
>   		}
>   	}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
