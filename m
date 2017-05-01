Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:39495 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S3000680AbdEAKic (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 May 2017 06:38:32 -0400
Date: Mon, 1 May 2017 11:38:30 +0100
From: Sean Young <sean@mess.org>
To: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com
Subject: Re: [PATCH] [RFC] rc-core: report protocol information to userspace
Message-ID: <20170501103830.GB10867@gofer.mess.org>
References: <149346313232.25459.10475301883786006034.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <149346313232.25459.10475301883786006034.stgit@zeus.hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Apr 29, 2017 at 12:52:12PM +0200, David Härdeman wrote:
> Whether we decide to go for any new keytable ioctl():s or not in rc-core, we
> should provide the protocol information of keypresses to userspace.
> 
> Note that this means that the RC_TYPE_* definitions become part of the
> userspace <-> kernel API/ABI (meaning a full patch should maybe move those
> defines under include/uapi).
> 
> This would also need to be ack:ed by the input maintainers.

This was already NACKed in the past.

http://www.spinics.net/lists/linux-input/msg46941.html

> ---
>  drivers/media/rc/rc-main.c             |    1 +
>  include/uapi/linux/input-event-codes.h |    1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index e0f9b322ab02..a38c1f3569ee 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -773,6 +773,7 @@ static void ir_do_keydown(struct rc_dev *dev, enum rc_type protocol,
>  	if (new_event && dev->keypressed)
>  		ir_do_keyup(dev, false);
>  
> +	input_event(dev->input_dev, EV_MSC, MSC_PROTOCOL, protocol);
>  	input_event(dev->input_dev, EV_MSC, MSC_SCAN, scancode);
>  
>  	if (new_event && keycode != KEY_RESERVED) {
> diff --git a/include/uapi/linux/input-event-codes.h b/include/uapi/linux/input-event-codes.h
> index 3af60ee69053..1a8c3554cbcb 100644
> --- a/include/uapi/linux/input-event-codes.h
> +++ b/include/uapi/linux/input-event-codes.h
> @@ -794,6 +794,7 @@
>  #define MSC_RAW			0x03
>  #define MSC_SCAN		0x04
>  #define MSC_TIMESTAMP		0x05
> +#define MSC_PROTOCOL		0x06
>  #define MSC_MAX			0x07
>  #define MSC_CNT			(MSC_MAX+1)
>  
