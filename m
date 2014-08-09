Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34275 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbaHIWy2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Aug 2014 18:54:28 -0400
Message-ID: <53E6A6A2.7070309@iki.fi>
Date: Sun, 10 Aug 2014 01:54:26 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Olli Salonen <olli.salonen@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH 4/4] cxusb: Add read_mac_address for TT CT2-4400 and CT2-4650
References: <1407481598-24598-1-git-send-email-olli.salonen@iki.fi> <1407481598-24598-4-git-send-email-olli.salonen@iki.fi>
In-Reply-To: <1407481598-24598-4-git-send-email-olli.salonen@iki.fi>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Reviewed-by: Antti Palosaari <crope@iki.fi>

your code is easy to read!

Antti

On 08/08/2014 10:06 AM, Olli Salonen wrote:
> Read MAC address from the EEPROM.
>
> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
> ---
>   drivers/media/usb/dvb-usb/cxusb.c | 37 +++++++++++++++++++++++++++++++++++++
>   1 file changed, 37 insertions(+)
>
> diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
> index c3a44c7..6abfd6b 100644
> --- a/drivers/media/usb/dvb-usb/cxusb.c
> +++ b/drivers/media/usb/dvb-usb/cxusb.c
> @@ -673,6 +673,41 @@ static struct rc_map_table rc_map_d680_dmb_table[] = {
>   	{ 0x0025, KEY_POWER },
>   };
>
> +static int cxusb_tt_ct2_4400_read_mac_address(struct dvb_usb_device *d, u8 mac[6])
> +{
> +	u8 wbuf[2];
> +	u8 rbuf[6];
> +	int ret;
> +	struct i2c_msg msg[] = {
> +		{
> +			.addr = 0x51,
> +			.flags = 0,
> +			.buf = wbuf,
> +			.len = 2,
> +		}, {
> +			.addr = 0x51,
> +			.flags = I2C_M_RD,
> +			.buf = rbuf,
> +			.len = 6,
> +		}
> +	};
> +
> +	wbuf[0] = 0x1e;
> +	wbuf[1] = 0x00;
> +	ret = cxusb_i2c_xfer(&d->i2c_adap, msg, 2);
> +
> +	if (ret == 2) {
> +		memcpy(mac, rbuf, 6);
> +		return 0;
> +	} else {
> +		if (ret < 0)
> +			return ret;
> +		else
> +			return -EIO;
> +		}
> +	}
> +}
> +
>   static int cxusb_tt_ct2_4650_ci_ctrl(void *priv, u8 read, int addr,
>   					u8 data, int *mem)
>   {
> @@ -2315,6 +2350,8 @@ static struct dvb_usb_device_properties cxusb_tt_ct2_4400_properties = {
>   	.size_of_priv     = sizeof(struct cxusb_state),
>
>   	.num_adapters = 1,
> +	.read_mac_address = cxusb_tt_ct2_4400_read_mac_address,
> +
>   	.adapter = {
>   		{
>   		.num_frontends = 1,
>

-- 
http://palosaari.fi/
