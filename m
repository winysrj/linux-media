Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:1029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756173Ab1EWSOx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 May 2011 14:14:53 -0400
Message-ID: <4DDAA415.40007@redhat.com>
Date: Mon, 23 May 2011 15:14:45 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Petter Selasky <hselasky@c2i.net>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] Alternate setting 1 must be selected for interface 0
 on the model that I received. Else the rest is identical.
References: <201105231637.39053.hselasky@c2i.net>
In-Reply-To: <201105231637.39053.hselasky@c2i.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 23-05-2011 11:37, Hans Petter Selasky escreveu:
> -HPS
> 
> 
> dvb-usb-0016.patch
> 
> 
> From 3cf61d6a77b22f58471188cd0e7e3dc6c3a29b0b Mon Sep 17 00:00:00 2001
> From: Hans Petter Selasky <hselasky@c2i.net>
> Date: Mon, 23 May 2011 16:36:55 +0200
> Subject: [PATCH] Alternate setting 1 must be selected for interface 0 on the model that I received. Else the rest is identical.
> 
> Signed-off-by: Hans Petter Selasky <hselasky@c2i.net>
> ---
>  drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c b/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
> index cbe2f0d..38a7d03 100644
> --- a/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
> +++ b/drivers/media/dvb/ttusb-budget/dvb-ttusb-budget.c
> @@ -971,6 +971,14 @@ static int ttusb_stop_feed(struct dvb_demux_feed *dvbdmxfeed)
>  
>  static int ttusb_setup_interfaces(struct ttusb *ttusb)
>  {
> +	/*
> +	 * Try to select alternate setting 1 for first interface. If
> +	 * that does not work, restore to alternate setting 0.
> +	 */
> +	if (usb_set_interface(ttusb->dev, 0, 1) < 0)
> +		usb_set_interface(ttusb->dev, 0, 0);
> +
> +	/* Select alternate setting 1 for second interface. */
>  	usb_set_interface(ttusb->dev, 1, 1);
>  
>  	ttusb->bulk_out_pipe = usb_sndbulkpipe(ttusb->dev, 1);
> -- 1.7.1.1


I don't have any ttusb device here, but I doubt that this would work. 

Alternates should be selected depending on the bandwidth needed. The right way
is to write some logic that will get the maximum packet size for each mode, between the
alternates that provide the type of transfer (Bulk or ISOC) accepted by the driver.

You may take a look at staging/tm6000 or at drivers/media/video/em28xx or at
drivers/media/video/gspca to see a few examples on how to do that. IMHO, the
alternates selection code at tm6000 is in better shape than the others I know.

Cheers,
Mauro.
