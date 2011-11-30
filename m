Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758005Ab1K3RWG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Nov 2011 12:22:06 -0500
Message-ID: <4ED66637.2050406@redhat.com>
Date: Wed, 30 Nov 2011 15:21:59 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: linuxtv@stefanringel.de
CC: linux-media@vger.kernel.org, d.belimov@gmail.com
Subject: Re: [PATCH 5/5] tm6000: bugfix data check
References: <1322509580-14460-1-git-send-email-linuxtv@stefanringel.de> <1322509580-14460-5-git-send-email-linuxtv@stefanringel.de>
In-Reply-To: <1322509580-14460-5-git-send-email-linuxtv@stefanringel.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stefan and Dmitri,

The entire RC input looked badly implemented. It never worked with HVR-900H,
and it were doing polling even on URB interrupt mode.

I've rewritten the entire code, and fixed it to be more reliable.

I've tested both interrupt and polling modes, with HVR-900H. On HVR-900H,
polling mode returns 0 when a scancode arrives, 0xff otherwise. This is
not the expected behavior on polling mode, but it seems to e due to the
way this device is wired. Anyway, the test were enough to test both ways
of receiving scancodes.

So, I broke the code for interrupt-driven and for polling-driven IR. This
made the code simpler to understand and more reliable. Also, on interrupt
driven mode, the CPU won't need to wake on every 50ms due to IR.

Both NEC and RC-5 protocols were tested, and I tried to make sure that the
driver would support 1 byte scancode, where devices can't provide
two bytes.

Please double check the patches I've made against your devices, in order
to be sure that nothing went wrong. Maybe something more would be needed
for IR on tm5600/tm6000.

I should be applying them upstream later today or tomorrow.

Regards,
Mauro

On 28-11-2011 17:46, linuxtv@stefanringel.de wrote:
> From: Stefan Ringel<linuxtv@stefanringel.de>
>
> beholder use a map with 3 bytes, but many rc maps have 2 bytes, so I add a workaround for beholder rc.
>
> Signed-off-by: Stefan Ringel<linuxtv@stefanringel.de>
> ---
>   drivers/media/video/tm6000/tm6000-input.c |   21 ++++++++++++++++-----
>   1 files changed, 16 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/media/video/tm6000/tm6000-input.c b/drivers/media/video/tm6000/tm6000-input.c
> index 405d127..ae7772e 100644
> --- a/drivers/media/video/tm6000/tm6000-input.c
> +++ b/drivers/media/video/tm6000/tm6000-input.c
> @@ -178,9 +178,21 @@ static int default_polling_getkey(struct tm6000_IR *ir,
>   			poll_result->rc_data = ir->urb_data[0];
>   			break;
>   		case RC_TYPE_NEC:
> -			if (ir->urb_data[1] == ((ir->key_addr>>  8)&  0xff)) {
> +			switch (dev->model) {
> +			case 10:
> +			case 11:
> +			case 14:
> +			case 15:

Using magic numbers here is a very bad idea.

> +				if (ir->urb_data[1] ==
> +					((ir->key_addr>>  8)&  0xff)) {
> +					poll_result->rc_data =
> +					ir->urb_data[0]
> +					| ir->urb_data[1]<<  8;
> +				}

Despite your comment, this is a 2 bytes scancode.

> +				break;
> +			default:
>   				poll_result->rc_data = ir->urb_data[0]
> -							| ir->urb_data[1]<<  8;
> +					| ir->urb_data[1]<<  8;
>   			}
>   			break;
>   		default:
> @@ -238,8 +250,6 @@ static void tm6000_ir_handle_key(struct tm6000_IR *ir)
>   		return;
>   	}
>
> -	dprintk("ir->get_key result data=%04x\n", poll_result.rc_data);
> -
>   	if (ir->pwled) {
>   		if (ir->pwledcnt>= PWLED_OFF) {
>   			ir->pwled = 0;
> @@ -250,6 +260,7 @@ static void tm6000_ir_handle_key(struct tm6000_IR *ir)
>   	}
>
>   	if (ir->key) {
> +		dprintk("ir->get_key result data=%04x\n", poll_result.rc_data);
>   		rc_keydown(ir->rc, poll_result.rc_data, 0);
>   		ir->key = 0;
>   		ir->pwled = 1;
> @@ -333,7 +344,7 @@ int tm6000_ir_int_start(struct tm6000_core *dev)
>   		ir->int_urb->transfer_buffer, size,
>   		tm6000_ir_urb_received, dev,
>   		dev->int_in.endp->desc.bInterval);
> -	err = usb_submit_urb(ir->int_urb, GFP_KERNEL);
> +	err = usb_submit_urb(ir->int_urb, GFP_ATOMIC);
>   	if (err) {
>   		kfree(ir->int_urb->transfer_buffer);
>   		usb_free_urb(ir->int_urb);

