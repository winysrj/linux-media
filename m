Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43658 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932236AbcFAHEN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Jun 2016 03:04:13 -0400
Subject: Re: [PATCH] media: af9035 I2C combined write + read transaction fix
To: Alessandro Radicati <alessandro@radicati.net>
References: <1459895023-9593-1-git-send-email-alessandro@radicati.net>
Cc: linux-media@vger.kernel.org
From: Antti Palosaari <crope@iki.fi>
Message-ID: <42916f44-a7a1-5316-36d8-b3b53402a1c8@iki.fi>
Date: Wed, 1 Jun 2016 10:04:11 +0300
MIME-Version: 1.0
In-Reply-To: <1459895023-9593-1-git-send-email-alessandro@radicati.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Applied for 4.8, thanks!

Antti

On 04/06/2016 01:23 AM, Alessandro Radicati wrote:
> This patch will modify the af9035 driver to use the register address
> fields of the I2C read command for the combined write/read transaction
> case.  Without this change, the firmware issues just a I2C read transaction
> without the preceding write transaction to select the register.
>
> Signed-off-by: Alessandro Radicati <alessandro@radicati.net>
> ---
>  drivers/media/usb/dvb-usb-v2/af9035.c | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
> index 2638e32..09a549b 100644
> --- a/drivers/media/usb/dvb-usb-v2/af9035.c
> +++ b/drivers/media/usb/dvb-usb-v2/af9035.c
> @@ -367,10 +367,25 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
>  				memcpy(&buf[3], msg[0].buf, msg[0].len);
>  			} else {
>  				buf[1] = msg[0].addr << 1;
> -				buf[2] = 0x00; /* reg addr len */
>  				buf[3] = 0x00; /* reg addr MSB */
>  				buf[4] = 0x00; /* reg addr LSB */
> -				memcpy(&buf[5], msg[0].buf, msg[0].len);
> +
> +				/* Keep prev behavior for write req len > 2*/
> +				if (msg[0].len > 2) {
> +					buf[2] = 0x00; /* reg addr len */
> +					memcpy(&buf[5], msg[0].buf, msg[0].len);
> +
> +				/* Use reg addr fields if write req len <= 2 */
> +				} else {
> +					req.wlen = 5;
> +					buf[2] = msg[0].len;
> +					if (msg[0].len == 2) {
> +						buf[3] = msg[0].buf[0];
> +						buf[4] = msg[0].buf[1];
> +					} else if (msg[0].len == 1) {
> +						buf[4] = msg[0].buf[0];
> +					}
> +				}
>  			}
>  			ret = af9035_ctrl_msg(d, &req);
>  		}
>

-- 
http://palosaari.fi/
