Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:57494 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751730AbdBME6I (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 12 Feb 2017 23:58:08 -0500
Subject: Re: [PATCH 2/2] [media] cx231xx: Fix I2C on Internal Master 3 Bus
To: Oleh Kravchenko <oleg@kaa.org.ua>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Steven Toth <stoth@kernellabs.com>,
        Jacob Johan Verkuil <hverkuil@xs4all.nl>
References: <20170207193514.14929-1-oleg@kaa.org.ua>
 <20170207193514.14929-2-oleg@kaa.org.ua>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <b0809baf-5fca-4747-480d-b34784dc489b@iki.fi>
Date: Mon, 13 Feb 2017 06:58:00 +0200
MIME-Version: 1.0
In-Reply-To: <20170207193514.14929-2-oleg@kaa.org.ua>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/07/2017 09:35 PM, Oleh Kravchenko wrote:
> Internal Master 3 Bus can send and receive only 4 bytes per time.
>
> Signed-off-by: Oleh Kravchenko <oleg@kaa.org.ua>
> ---
>  drivers/media/usb/cx231xx/cx231xx-core.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/usb/cx231xx/cx231xx-core.c b/drivers/media/usb/cx231xx/cx231xx-core.c
> index 550ec93..46646ec 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-core.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-core.c
> @@ -355,7 +355,12 @@ int cx231xx_send_vendor_cmd(struct cx231xx *dev,
>  	 */
>  	if ((ven_req->wLength > 4) && ((ven_req->bRequest == 0x4) ||
>  					(ven_req->bRequest == 0x5) ||
> -					(ven_req->bRequest == 0x6))) {
> +					(ven_req->bRequest == 0x6) ||
> +
> +					/* Internal Master 3 Bus can send
> +					 * and receive only 4 bytes per time
> +					 */
> +					(ven_req->bRequest == 0x2))) {
>  		unsend_size = 0;
>  		pdata = ven_req->pBuff;
>
>

Good that you finally got i2c fixed properly and get rid of that ugly 
device specific hack.

That new comment still does not open for me, why you call i2c bus tuner 
sits as internal?

There is now commands 2, 4, 5, and 6 that should be split to 4 byte 
long, is there any vendor command that could be longer? Maybe you could 
just add single comment which states what all those 4 commands are.

Your patches are still on wrong order - you should first fix i2c and 
after that add device support.

regards
Antti
-- 
http://palosaari.fi/
