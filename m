Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:24568 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbaAJNKJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Jan 2014 08:10:09 -0500
Message-ID: <52CFF094.5080408@cisco.com>
Date: Fri, 10 Jan 2014 14:07:32 +0100
From: Hans Verkuil <hansverk@cisco.com>
MIME-Version: 1.0
To: Ethan Zhao <ethan.kernel@gmail.com>
CC: hans.verkuil@cisco.com, m.chehab@samsung.com,
	gregkh@linuxfoundation.org,
	linux-media <linux-media@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH] media: gspaca: check pointer against NULL before using
 it in create_urbs()
References: <1389088562-463-1-git-send-email-ethan.kernel@gmail.com>
In-Reply-To: <1389088562-463-1-git-send-email-ethan.kernel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cc to linux-media and Hans de Goede (gspca maintainer).

Regards,

	Hans

On 01/07/14 10:56, Ethan Zhao wrote:
> function alt_xfer() may return NULL, should check its return value passed into
> create_urbs() as parameter.
> 
> gspca_init_transfer()
> {
> ... ...
> ret = create_urbs(gspca_dev,alt_xfer(&intf->altsetting[alt], xfer));
> ... ...
> }
> 
> Signed-off-by: Ethan Zhao <ethan.kernel@gmail.com>
> ---
>  drivers/media/usb/gspca/gspca.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
> index 048507b..eb45bc0 100644
> --- a/drivers/media/usb/gspca/gspca.c
> +++ b/drivers/media/usb/gspca/gspca.c
> @@ -761,6 +761,8 @@ static int create_urbs(struct gspca_dev *gspca_dev,
>  	struct urb *urb;
>  	int n, nurbs, i, psize, npkt, bsize;
>  
> +	if (!ep)
> +		return -EINVAL;
>  	/* calculate the packet size and the number of packets */
>  	psize = le16_to_cpu(ep->desc.wMaxPacketSize);
>  
> 
