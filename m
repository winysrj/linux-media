Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:43801 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab0G2Ci3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jul 2010 22:38:29 -0400
Received: by gwb20 with SMTP id 20so25246gwb.19
        for <linux-media@vger.kernel.org>; Wed, 28 Jul 2010 19:38:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100728022400.GA5398@redhat.com>
References: <20100728022400.GA5398@redhat.com>
Date: Wed, 28 Jul 2010 22:38:27 -0400
Message-ID: <AANLkTinthvW1=UK09fOcgP7adNaT0oNzMSQz5Mp3GgFT@mail.gmail.com>
Subject: Re: [PATCH] IR/mceusb: remove bad ir_input_dev use
From: Jarod Wilson <jarod@wilsonet.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-media@vger.kernel.org,
	Maxim Levitsky <maximlevitsky@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 27, 2010 at 10:24 PM, Jarod Wilson <jarod@redhat.com> wrote:
> The ir_input_dev gets filled in by __ir_input_register, the one
> allocated in mceusb_init_input_dev was being overwritten by the correct
> one shortly after it was initialized (ultimately resulting in a memory
> leak). This bug was inherited from imon.c, and was pointed out to me by
> Maxim Levitsky.

D'oh, there's a minor errorlet in this patch...


> CC: Maxim Levitsky <maximlevitsky@gmail.com>
> Signed-off-by: Jarod Wilson <jarod@redhat.com>
> ---
>  drivers/media/IR/mceusb.c |   15 +--------------
>  1 files changed, 1 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/media/IR/mceusb.c b/drivers/media/IR/mceusb.c
> index 78bf7f7..9a7da32 100644
> --- a/drivers/media/IR/mceusb.c
> +++ b/drivers/media/IR/mceusb.c
> @@ -228,7 +228,6 @@ static struct usb_device_id std_tx_mask_list[] = {
>  /* data structure for each usb transceiver */
>  struct mceusb_dev {
>        /* ir-core bits */
> -       struct ir_input_dev *irdev;
>        struct ir_dev_props *props;
>        struct ir_raw_event rawir;
>
> @@ -739,7 +738,7 @@ static void mceusb_dev_recv(struct urb *urb, struct pt_regs *regs)
>
>        if (ir->send_flags == RECV_FLAG_IN_PROGRESS) {
>                ir->send_flags = SEND_FLAG_COMPLETE;
> -               dev_dbg(&ir->irdev->dev, "setup answer received %d bytes\n",
> +               dev_dbg(&ir->dev, "setup answer received %d bytes\n",

This should be dev_dbg(ir->dev, ... (i.e., without the ampersand).
Mauro, shall I resend this, or can you fix that at commit time?

-- 
Jarod Wilson
jarod@wilsonet.com
