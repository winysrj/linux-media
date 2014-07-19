Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57740 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755327AbaGSCQA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Jul 2014 22:16:00 -0400
Message-ID: <53C9D4DE.3030308@iki.fi>
Date: Sat, 19 Jul 2014 05:15:58 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Matthias Schwarzott <zzam@gentoo.org>, linux-media@vger.kernel.org
Subject: Re: [PATCH 1/3] cxusb: Prepare for si2157 driver getting more parameters
References: <53C58067.8000601@gentoo.org> <1405452876-8543-1-git-send-email-zzam@gentoo.org>
In-Reply-To: <1405452876-8543-1-git-send-email-zzam@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Patch applied.

http://git.linuxtv.org/cgit.cgi/anttip/media_tree.git/log/?h=silabs

Antti

On 07/15/2014 10:34 PM, Matthias Schwarzott wrote:
> Modify all users of si2157_config to correctly initialize all not
> listed values to 0.
>
> Signed-off-by: Matthias Schwarzott <zzam@gentoo.org>
> ---
>   drivers/media/usb/dvb-usb/cxusb.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
> index ad20c39..285213c 100644
> --- a/drivers/media/usb/dvb-usb/cxusb.c
> +++ b/drivers/media/usb/dvb-usb/cxusb.c
> @@ -1371,6 +1371,7 @@ static int cxusb_tt_ct2_4400_attach(struct dvb_usb_adapter *adap)
>   	st->i2c_client_demod = client_demod;
>
>   	/* attach tuner */
> +	memset(&si2157_config, 0, sizeof(si2157_config));
>   	si2157_config.fe = adap->fe_adap[0].fe;
>   	memset(&info, 0, sizeof(struct i2c_board_info));
>   	strlcpy(info.type, "si2157", I2C_NAME_SIZE);
>

-- 
http://palosaari.fi/
