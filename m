Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:35421 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751666Ab2DBWmD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Apr 2012 18:42:03 -0400
Message-ID: <4F7A2B37.8030200@iki.fi>
Date: Tue, 03 Apr 2012 01:41:59 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Gianluca Gennari <gennarone@gmail.com>
CC: linux-media@vger.kernel.org, m@bues.ch, hfvogt@gmx.net,
	mchehab@redhat.com
Subject: Re: [PATCH 4/5] af9035: fix warning
References: <1333401917-27203-1-git-send-email-gennarone@gmail.com> <1333401917-27203-5-git-send-email-gennarone@gmail.com>
In-Reply-To: <1333401917-27203-5-git-send-email-gennarone@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03.04.2012 00:25, Gianluca Gennari wrote:
> af9035.c: In function 'af9035_download_firmware':
> af9035.c:446:3: warning: format '%lu' expects argument of type 'long unsigned
> int', but argument 3 has type 'unsigned int' [-Wformat]
>
> Signed-off-by: Gianluca Gennari<gennarone@gmail.com>
> ---
>   drivers/media/dvb/dvb-usb/af9035.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/media/dvb/dvb-usb/af9035.c b/drivers/media/dvb/dvb-usb/af9035.c
> index f943c57..8bf6367 100644
> --- a/drivers/media/dvb/dvb-usb/af9035.c
> +++ b/drivers/media/dvb/dvb-usb/af9035.c
> @@ -443,7 +443,7 @@ static int af9035_download_firmware(struct usb_device *udev,
>
>   		i -= hdr_data_len + HDR_SIZE;
>
> -		pr_debug("%s: data uploaded=%lu\n", __func__, fw->size - i);
> +		pr_debug("%s: data uploaded=%u\n", __func__, fw->size - i);
>   	}
>
>   	/* firmware loaded, request boot */

That gives similar error on 64bit. Maybe %zu works both 64 and 32 bit 
without warnings? Could you try and sent new patch if it works for you?

drivers/media/dvb/dvb-usb/af9035.c: In function ‘af9035_download_firmware’:
drivers/media/dvb/dvb-usb/af9035.c:446:3: warning: format ‘%u’ expects 
argument of type ‘unsigned int’, but argument 4 has type ‘long unsigned 
int’ [-Wformat]

see here:
http://www.velocityreviews.com/forums/t593117-printf-specification-for-size_t.html

regards
Antti
-- 
http://palosaari.fi/
