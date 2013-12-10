Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:20438 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab3LJQVE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Dec 2013 11:21:04 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MXL001O0MR2F560@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 10 Dec 2013 11:21:02 -0500 (EST)
Date: Tue, 10 Dec 2013 14:20:57 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Martin Kittel <linux@martin-kittel.de>
Cc: linux-media@vger.kernel.org
Subject: Re: Patch mceusb: fix invalid urb interval
Message-id: <20131210142057.0d6ae3a6@samsung.com>
In-reply-to: <loom.20131110T113621-661@post.gmane.org>
References: <loom.20131110T113621-661@post.gmane.org>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 10 Nov 2013 10:50:45 +0000 (UTC)
Martin Kittel <linux@martin-kittel.de> escreveu:

> Hi,
> 
> I had trouble getting my MCE remote control to work on my new Intel
> mainboard. It was working fine with older boards but with the new board
> there would be no reply from the remote just after the setup package was
> received during the init phase.
> I traced the problem down to the mceusb_dev_recv function where the received
> urb is resubmitted again. The problem is that my new board is so blazing
> fast that the initial urb was processed in less than a single 125
> microsecond interval, so the urb as it was received had urb->interval set to 0.
> As the urb is just resubmitted as it came in it now had an invalid interval
> set and was rejected.
> The patch just resets urb->interval to its initial value and adds some error
> diagnostics (which would have saved me a lot of time during my analysis).
> 
> Any comment is welcome.
> 
> Best wishes,

You forgot to send your signed-off-by:
> 
> Martin.
> 
> 
> diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
> index 3c76101..c5313cb 100644
> --- a/drivers/media/rc/mceusb.c
> +++ b/drivers/media/rc/mceusb.c
> @@ -1030,7 +1030,7 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir
>  static void mceusb_dev_recv(struct urb *urb)
>  {
>         struct mceusb_dev *ir;
> -       int buf_len;
> +       int buf_len, res;
>  

Please use tabs and not spaces. Note: This could be something wrong with your
emailer that could be mangling whitespaces.


>         if (!urb)
>                 return;
> @@ -1067,7 +1067,11 @@ static void mceusb_dev_recv(struct urb *urb)
>                 break;
>         }
>  
> -       usb_submit_urb(urb, GFP_ATOMIC);
> +       urb->interval = ir->usb_ep_out->bInterval; /* reset urb interval */
> +       res = usb_submit_urb(urb, GFP_ATOMIC);
> +       if (res) {
> +               mce_dbg(ir->dev, "restart request FAILED! (res=%d)\n", res);
> +       }

No need for braces here. Just do:
+	if (res)
+		mce_dbg(ir->dev, "restart request FAILED! (res=%d)\n", res);

>  }

>  
>  static void mceusb_get_emulator_version(struct mceusb_dev *ir)
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
