Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752931AbaBWVpo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Feb 2014 16:45:44 -0500
Message-ID: <530A6BFB.8060001@redhat.com>
Date: Sun, 23 Feb 2014 22:45:31 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Antonio Ospite <ospite@studenti.unina.it>,
	linux-media@vger.kernel.org
CC: m.chehab@samsung.com, Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 1/2] gspca_kinect: fix kinect_read() error path
References: <20131230165625.814796d9e041d2261e1d078a@studenti.unina.it> <1388421706-8366-1-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1388421706-8366-1-git-send-email-ospite@studenti.unina.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Thanks I've added both to my gspca tree for 3.15

Regards,

Hans


On 12/30/2013 05:41 PM, Antonio Ospite wrote:
> The error checking code relative to the invocations of kinect_read()
> does not return the actual return code of the function just called, it
> returns "res" which still contains the value of the last invocation of
> a previous kinect_write().
> 
> Return the proper value, and while at it also report with -EREMOTEIO the
> case of a partial transfer.
> 
> Reported-by: Julia Lawall <julia.lawall@lip6.fr>
> Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
> ---
>  drivers/media/usb/gspca/kinect.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/gspca/kinect.c b/drivers/media/usb/gspca/kinect.c
> index 3773a8a..48084736 100644
> --- a/drivers/media/usb/gspca/kinect.c
> +++ b/drivers/media/usb/gspca/kinect.c
> @@ -158,7 +158,7 @@ static int send_cmd(struct gspca_dev *gspca_dev, uint16_t cmd, void *cmdbuf,
>  	PDEBUG(D_USBO, "Control reply: %d", res);
>  	if (actual_len < sizeof(*rhdr)) {
>  		pr_err("send_cmd: Input control transfer failed (%d)\n", res);
> -		return res;
> +		return actual_len < 0 ? actual_len : -EREMOTEIO;
>  	}
>  	actual_len -= sizeof(*rhdr);
>  
> 
