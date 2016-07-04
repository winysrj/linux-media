Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34445 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515AbcGDUv5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Jul 2016 16:51:57 -0400
Received: by mail-wm0-f65.google.com with SMTP id 187so24184011wmz.1
        for <linux-media@vger.kernel.org>; Mon, 04 Jul 2016 13:51:56 -0700 (PDT)
Subject: Re: [PATCH] media: rc: nuvoton: decrease size of raw event fifo
To: Sean Young <sean@mess.org>
References: <aa9c30cd-5364-f460-2967-8a028b1093db@gmail.com>
 <20160704201338.GA28620@gofer.mess.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
From: Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <fa0d5ad8-961d-60f2-f2e4-eeb7407e0210@gmail.com>
Date: Mon, 4 Jul 2016 22:51:50 +0200
MIME-Version: 1.0
In-Reply-To: <20160704201338.GA28620@gofer.mess.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 04.07.2016 um 22:13 schrieb Sean Young:
> On Wed, May 18, 2016 at 10:29:41PM +0200, Heiner Kallweit wrote:
>> This chip has a 32 byte HW FIFO only. Therefore the default fifo size
>> of 512 raw events is not needed and can be significantly decreased.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> The 32 byte hardware queue is read from an interrupt handler and added
> to the kfifo. The kfifo is read by the decoders in a seperate kthread
> (in ir_raw_event_thread). If we have a long IR (e.g. nec which has 
> 66 edges) and the kthread is not scheduled in time (e.g. high load), will
> we not end up with an overflow in the kfifo and unable to decode it?
> 
The interrupt handler is triggered latest when 24 bytes have been read.
(at least that's how the chip gets configured at the moment)
This gives the decoder thread at least 8 bytes time to process the
kfifo. This should be sufficient even under high load.

If somebody configures the driver the generate an interrupt after 32 bytes
only then there are possible issues under high load or with longer code
pieces with interrupts disabled anyway:
Then the next byte might arrive (and make the chip fifo overrun) before
the interrupt handler can read the chip fifo.

Heiner

> 
> Sean
> 
>> ---
>>  drivers/media/rc/nuvoton-cir.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
>> index 99b303b..e98c955 100644
>> --- a/drivers/media/rc/nuvoton-cir.c
>> +++ b/drivers/media/rc/nuvoton-cir.c
>> @@ -1186,6 +1186,7 @@ static int nvt_probe(struct pnp_dev *pdev, const struct pnp_device_id *dev_id)
>>  	rdev->priv = nvt;
>>  	rdev->driver_type = RC_DRIVER_IR_RAW;
>>  	rdev->allowed_protocols = RC_BIT_ALL;
>> +	rdev->raw_fifo_size = RX_BUF_LEN;
>>  	rdev->open = nvt_open;
>>  	rdev->close = nvt_close;
>>  	rdev->tx_ir = nvt_tx_ir;
>> -- 
>> 2.8.2
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

