Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:36899 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755062Ab3GSDh4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jul 2013 23:37:56 -0400
Received: by mail-pa0-f49.google.com with SMTP id ld11so3912257pab.36
        for <linux-media@vger.kernel.org>; Thu, 18 Jul 2013 20:37:56 -0700 (PDT)
Date: Fri, 19 Jul 2013 11:37:54 +0800
From: "nibble.max" <nibble.max@gmail.com>
To: "Luis Alves" <ljalvs@gmail.com>
Cc: "mchehab" <mchehab@infradead.org>, "crope" <crope@iki.fi>,
	"awalls" <awalls@md.metrocast.net>,
	"Luis Alves" <ljalvs@gmail.com>,
	"linux-media" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] cx23885[v2]: Fix IR interrupt storm.
Message-ID: <201307191137522969679@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Luis,
The internel interrupts are rounted as follow:
flatiron(include ADC)--->HammerHead(include IR inside)--->Pecos(PCIe)
The flatiron interrupt is enabled when chip power up.
When HammerHead interrupt is enalbe in Pecos, the most of interrupts are coming from flatiron.
The more accurate code is that reading back these left and right registers(0x1f, 0x23), set its bit-7 to "1" , then write back.
So that it does not touch other bits.
BR,
Max

>Hi all,
>This path is meant to be up-streamed.
>
>Andy has a nice explanation for the interrupt storm when
>enabling the IR interrupt:
>
>The flatiron core (the audio adc) signals the end of its self-test
>with an interrupt. Since the flatiron irq seems OR-wired
>with the IR irq the result is this interrupt storm.
>This i2c tranfers will clear the flatiron interrupts - the left
>and right channels self-tests.
>
>Also as suggested by Andy I moved the i2c transfers to the
>cx23885 av core interrupt handling worker. If any spurious
>interrupt happens we silence them.
>
>The flatiron has some dedicated register read/write functions but are
>not exported so Antti just suggested to call the i2c_transfer directly.
>
>Tested in the TBS6981 Dual DVB-S2 card.
>
>PS: I've found this i2c_transfers in TBS media tree, more precisely
>in the cx23885-i2c.c file.
>
>Regards,
>Luis
>
>
>Signed-off-by: Luis Alves <ljalvs@gmail.com>
>---
> drivers/media/pci/cx23885/cx23885-av.c |   17 +++++++++++++++++
> 1 file changed, 17 insertions(+)
>
>diff --git a/drivers/media/pci/cx23885/cx23885-av.c b/drivers/media/pci/cx23885/cx23885-av.c
>index e958a01..d33570f 100644
>--- a/drivers/media/pci/cx23885/cx23885-av.c
>+++ b/drivers/media/pci/cx23885/cx23885-av.c
>@@ -29,8 +29,25 @@ void cx23885_av_work_handler(struct work_struct *work)
> 	struct cx23885_dev *dev =
> 			   container_of(work, struct cx23885_dev, cx25840_work);
> 	bool handled;
>+	char buffer[2];
>+	struct i2c_msg msg = {
>+		.addr = 0x98 >> 1,
>+		.flags = 0,
>+		.len = 2,
>+		.buf = buffer,
>+	};
> 
> 	v4l2_subdev_call(dev->sd_cx25840, core, interrupt_service_routine,
> 			 PCI_MSK_AV_CORE, &handled);
>+
>+	if (!handled) {
>+		/* clear any pending flatiron interrupts */
>+		buffer[0] = 0x1f;
>+		buffer[1] = 0x80;
>+		i2c_transfer(&dev->i2c_bus[2].i2c_adap, &msg, 1);
>+		buffer[0] = 0x23;
>+		i2c_transfer(&dev->i2c_bus[2].i2c_adap, &msg, 1);
>+	}
>+
> 	cx23885_irq_enable(dev, PCI_MSK_AV_CORE);
> }
>-- 
>1.7.9.5
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

