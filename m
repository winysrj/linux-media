Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:46992 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbZD3Tns convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2009 15:43:48 -0400
Received: by ey-out-2122.google.com with SMTP id 9so517782eyd.37
        for <linux-media@vger.kernel.org>; Thu, 30 Apr 2009 12:43:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200904301616.23303.nsoranzo@tiscali.it>
References: <200904301616.23303.nsoranzo@tiscali.it>
Date: Thu, 30 Apr 2009 23:43:46 +0400
Message-ID: <208cbae30904301243x273620d1y2d0e2d2e984b1b13@mail.gmail.com>
Subject: Re: [PATCH] radio_si470x: Drop unused label
From: Alexey Klimov <klimov.linux@gmail.com>
To: Nicola Soranzo <nsoranzo@tiscali.it>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	tobias.lorenz@gmx.net, Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(added Tobias and Mauro on c/c)

On Thu, Apr 30, 2009 at 6:16 PM, Nicola Soranzo <nsoranzo@tiscali.it> wrote:
> Fix this warning:
>
> /home/nicola/v4l-dvb/v4l/radio-si470x.c: In function 'si470x_fops_release':
> /home/nicola/v4l-dvb/v4l/radio-si470x.c:1218: warning: label 'unlock' defined but not used
>
> Priority: normal
>
> Signed-off-by: Nicola Soranzo <nsoranzo@tiscali.it>
>
> ---
> diff -r 83712d149893 -r 97be9e920832 linux/drivers/media/radio/radio-si470x.c
> --- a/linux/drivers/media/radio/radio-si470x.c  Wed Apr 29 18:01:48 2009 -0300
> +++ b/linux/drivers/media/radio/radio-si470x.c  Thu Apr 30 16:10:24 2009 +0200
> @@ -1214,8 +1214,6 @@
>                retval = si470x_stop(radio);
>                usb_autopm_put_interface(radio->intf);
>        }
> -
> -unlock:
>        mutex_unlock(&radio->disconnect_lock);
>
>  done:

Looks good. Thank you.
When i built latest up-to-date git kernel i noticed that this warning
showed there also.
Probably, it's better this patch reach 2.6.30 kernel. Now we are at rc4.

-- 
Best regards, Klimov Alexey
