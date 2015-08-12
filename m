Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:38684 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750856AbbHLLTn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Aug 2015 07:19:43 -0400
Date: Wed, 12 Aug 2015 13:19:36 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
To: "Shah, Yash (Y.)" <yshah1@visteon.com>
Cc: "mchehab@osg.samsung.com" <mchehab@osg.samsung.com>,
	"gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"hans.verkuil@cisco.com" <hans.verkuil@cisco.com>,
	"prabhakar.csengg@gmail.com" <prabhakar.csengg@gmail.com>,
	"hamohammed.sa@gmail.com" <hamohammed.sa@gmail.com>,
	"luis@debethencourt.com" <luis@debethencourt.com>,
	"wsa@the-dreams.de" <wsa@the-dreams.de>,
	"elfring@users.sourceforge.net" <elfring@users.sourceforge.net>,
	"carlos@cgarcia.org" <carlos@cgarcia.org>,
	"vthakkar1994@gmail.com" <vthakkar1994@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Babu, Viswanathan (V.)" <vbabu3@visteon.com>
Subject: Re: [PATCH] Staging: media/bcm2048: Fix line over 80 characters
 warning as  detected by checkpatch.pl
Message-ID: <20150812111935.GA15037@pali>
References: <20150812111245.GA24492@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150812111245.GA24492@ubuntu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 12 August 2015 11:12:49 Shah, Yash (Y.) wrote:
> From: Yash Shah <yshah1@visteon.com>
> 
> Fix line over 80 characters warning as detected by checkpatch.pl
> 
> Signed-off-by: Yash Shah <yshah1@visteon.com>
> ---
>  drivers/staging/media/bcm2048/radio-bcm2048.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
> index 8bc68e2..d36350e 100644
> --- a/drivers/staging/media/bcm2048/radio-bcm2048.c
> +++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
> @@ -2243,7 +2243,8 @@ static ssize_t bcm2048_fops_read(struct file *file, char __user *buf,
>  
>  		tmpbuf[i] = bdev->rds_info.radio_text[bdev->rd_index+i+2];
>  		tmpbuf[i+1] = bdev->rds_info.radio_text[bdev->rd_index+i+1];
> -		tmpbuf[i+2] = (bdev->rds_info.radio_text[bdev->rd_index + i] & 0xf0) >> 4;
> +		tmpbuf[i+2] = (bdev->rds_info.radio_text[bdev->rd_index + i]
> +				 & 0xf0) >> 4;
>  		if ((bdev->rds_info.radio_text[bdev->rd_index+i] &
>  			BCM2048_RDS_CRC_MASK) == BCM2048_RDS_CRC_UNRECOVARABLE)
>  			tmpbuf[i+2] |= 0x80;

Hi! I think that code after this change is less readable as before.

-- 
Pali Rohár
pali.rohar@gmail.com
