Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16285 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752465Ab3IILnM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Sep 2013 07:43:12 -0400
Message-ID: <522DB448.8060705@redhat.com>
Date: Mon, 09 Sep 2013 13:43:04 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] gspca: print small buffers via %*ph
References: <1378211497-16482-1-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1378211497-16482-1-git-send-email-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks! I've added these to my gspca tree for 3.13, and send a pull-request
with these for 3.13 to Mauro.

Regards,

Hans


On 09/03/2013 02:31 PM, Andy Shevchenko wrote:
> Instead of passing each byte through stack let's use %*ph specifier to do this
> job better.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>   drivers/media/usb/gspca/sonixb.c      |  5 +----
>   drivers/media/usb/gspca/xirlink_cit.c | 12 ++++--------
>   2 files changed, 5 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/media/usb/gspca/sonixb.c b/drivers/media/usb/gspca/sonixb.c
> index d7ff3b9..5e5613e 100644
> --- a/drivers/media/usb/gspca/sonixb.c
> +++ b/drivers/media/usb/gspca/sonixb.c
> @@ -513,10 +513,7 @@ static void i2c_w(struct gspca_dev *gspca_dev, const u8 *buf)
>   		if (gspca_dev->usb_buf[0] & 0x04) {
>   			if (gspca_dev->usb_buf[0] & 0x08) {
>   				dev_err(gspca_dev->v4l2_dev.dev,
> -					"i2c error writing %02x %02x %02x %02x"
> -					" %02x %02x %02x %02x\n",
> -					buf[0], buf[1], buf[2], buf[3],
> -					buf[4], buf[5], buf[6], buf[7]);
> +					"i2c error writing %8ph\n", buf);
>   				gspca_dev->usb_err = -EIO;
>   			}
>   			return;
> diff --git a/drivers/media/usb/gspca/xirlink_cit.c b/drivers/media/usb/gspca/xirlink_cit.c
> index 7eaf64e..3beb351 100644
> --- a/drivers/media/usb/gspca/xirlink_cit.c
> +++ b/drivers/media/usb/gspca/xirlink_cit.c
> @@ -2864,20 +2864,16 @@ static u8 *cit_find_sof(struct gspca_dev *gspca_dev, u8 *data, int len)
>   				if (data[i] == 0xff) {
>   					if (i >= 4)
>   						PDEBUG(D_FRAM,
> -						       "header found at offset: %d: %02x %02x 00 %02x %02x %02x\n",
> +						       "header found at offset: %d: %02x %02x 00 %3ph\n",
>   						       i - 1,
>   						       data[i - 4],
>   						       data[i - 3],
> -						       data[i],
> -						       data[i + 1],
> -						       data[i + 2]);
> +						       &data[i]);
>   					else
>   						PDEBUG(D_FRAM,
> -						       "header found at offset: %d: 00 %02x %02x %02x\n",
> +						       "header found at offset: %d: 00 %3ph\n",
>   						       i - 1,
> -						       data[i],
> -						       data[i + 1],
> -						       data[i + 2]);
> +						       &data[i]);
>   					return data + i + (sd->sof_len - 1);
>   				}
>   				break;
>
