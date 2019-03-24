Return-Path: <SRS0=Cdzf=R3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6023C43381
	for <linux-media@archiver.kernel.org>; Sun, 24 Mar 2019 16:56:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 689E420870
	for <linux-media@archiver.kernel.org>; Sun, 24 Mar 2019 16:56:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728797AbfCXQ4m (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 24 Mar 2019 12:56:42 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:33910 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727960AbfCXQ4m (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 24 Mar 2019 12:56:42 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: ezequiel)
        with ESMTPSA id 9D401282268
Message-ID: <81627ad40d3e7ee9e8f6bb037e572111d784fc31.camel@collabora.com>
Subject: Re: [PATCH v2] gspca: Kill URBs on USB device disconnect
From:   Ezequiel Garcia <ezequiel@collabora.com>
To:     linux-media@vger.kernel.org
Cc:     Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        ccr@tnsp.org
Date:   Sun, 24 Mar 2019 13:56:32 -0300
In-Reply-To: <20190228152834.14308-1-ezequiel@collabora.com>
References: <20190227165643.5571-1-ezequiel@collabora.com>
         <20190228152834.14308-1-ezequiel@collabora.com>
Organization: Collabora
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Thu, 2019-02-28 at 12:28 -0300, Ezequiel Garcia wrote:
> In order to prevent ISOC URBs from being infinitely resubmitted,
> the driver's USB disconnect handler must kill all the in-flight URBs.
> 
> While here, change the URB packet status message to a debug level,
> to avoid spamming the console too much.
> 
> This commit fixes a lockup caused by an interrupt storm coming
> from the URB completion handler.
> 
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> ---
> v2:
>   * Also kill the int URB.
> 

Hans,

We still have to solve another race in this driver,
but I think this fix is good to go.

Thanks,
Eze

>  drivers/media/usb/gspca/gspca.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
> index 9448ac0b8bc9..4d7517411cc2 100644
> --- a/drivers/media/usb/gspca/gspca.c
> +++ b/drivers/media/usb/gspca/gspca.c
> @@ -294,7 +294,7 @@ static void fill_frame(struct gspca_dev *gspca_dev,
>  		/* check the packet status and length */
>  		st = urb->iso_frame_desc[i].status;
>  		if (st) {
> -			pr_err("ISOC data error: [%d] len=%d, status=%d\n",
> +			gspca_dbg(gspca_dev, D_PACK, "ISOC data error: [%d] len=%d, status=%d\n",
>  			       i, len, st);
>  			gspca_dev->last_packet_type = DISCARD_PACKET;
>  			continue;
> @@ -1642,6 +1642,8 @@ void gspca_disconnect(struct usb_interface *intf)
>  
>  	mutex_lock(&gspca_dev->usb_lock);
>  	gspca_dev->present = false;
> +	destroy_urbs(gspca_dev);
> +	gspca_input_destroy_urb(gspca_dev);
>  
>  	vb2_queue_error(&gspca_dev->queue);
>  

