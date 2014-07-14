Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754288AbaGNK2C (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Jul 2014 06:28:02 -0400
Message-ID: <53C3B0AD.7070001@redhat.com>
Date: Mon, 14 Jul 2014 12:27:57 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Antonio Ospite <ao2@ao2.it>, linux-media@vger.kernel.org
Subject: Re: [PATCH] gspca_stv06xx: enable button found on some Quickcam Express
 variant
References: <1405083417-20615-1-git-send-email-ao2@ao2.it>
In-Reply-To: <1405083417-20615-1-git-send-email-ao2@ao2.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 07/11/2014 02:56 PM, Antonio Ospite wrote:
> Signed-off-by: Antonio Ospite <ao2@ao2.it>

Thanks, I've added this to my tree and send a pull-req for it
to Mauro.

Regards,

Hans

> ---
>  drivers/media/usb/gspca/stv06xx/stv06xx.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/usb/gspca/stv06xx/stv06xx.c b/drivers/media/usb/gspca/stv06xx/stv06xx.c
> index 49d209b..6ac93d8 100644
> --- a/drivers/media/usb/gspca/stv06xx/stv06xx.c
> +++ b/drivers/media/usb/gspca/stv06xx/stv06xx.c
> @@ -505,13 +505,13 @@ static int sd_int_pkt_scan(struct gspca_dev *gspca_dev,
>  {
>  	int ret = -EINVAL;
>  
> -	if (len == 1 && data[0] == 0x80) {
> +	if (len == 1 && (data[0] == 0x80 || data[0] == 0x10)) {
>  		input_report_key(gspca_dev->input_dev, KEY_CAMERA, 1);
>  		input_sync(gspca_dev->input_dev);
>  		ret = 0;
>  	}
>  
> -	if (len == 1 && data[0] == 0x88) {
> +	if (len == 1 && (data[0] == 0x88 || data[0] == 0x11)) {
>  		input_report_key(gspca_dev->input_dev, KEY_CAMERA, 0);
>  		input_sync(gspca_dev->input_dev);
>  		ret = 0;
> 
