Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:62107 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759686Ab3GSIx2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jul 2013 04:53:28 -0400
Received: by mail-oa0-f43.google.com with SMTP id i7so5570979oag.2
        for <linux-media@vger.kernel.org>; Fri, 19 Jul 2013 01:53:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201307191137522969679@gmail.com>
References: <201307191137522969679@gmail.com>
Date: Fri, 19 Jul 2013 09:53:28 +0100
Message-ID: <CAGj5WxC0ADsdA7KcW92wu-KNLPUSbVspbvq5SLqdbFt49NMZXA@mail.gmail.com>
Subject: Re: [PATCH] cx23885[v2]: Fix IR interrupt storm.
From: Luis Alves <ljalvs@gmail.com>
To: "nibble.max" <nibble.max@gmail.com>
Cc: mchehab <mchehab@infradead.org>, crope <crope@iki.fi>,
	awalls <awalls@md.metrocast.net>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Max,

Should have thought on that! I'll change it to preserve all other bits.

Thanks,
Luis


On Fri, Jul 19, 2013 at 4:37 AM, nibble.max <nibble.max@gmail.com> wrote:
> Hello Luis,
> The internel interrupts are rounted as follow:
> flatiron(include ADC)--->HammerHead(include IR inside)--->Pecos(PCIe)
> The flatiron interrupt is enabled when chip power up.
> When HammerHead interrupt is enalbe in Pecos, the most of interrupts are coming from flatiron.
> The more accurate code is that reading back these left and right registers(0x1f, 0x23), set its bit-7 to "1" , then write back.
> So that it does not touch other bits.
> BR,
> Max
>
>>Hi all,
>>This path is meant to be up-streamed.
>>
>>Andy has a nice explanation for the interrupt storm when
>>enabling the IR interrupt:
>>
>>The flatiron core (the audio adc) signals the end of its self-test
>>with an interrupt. Since the flatiron irq seems OR-wired
>>with the IR irq the result is this interrupt storm.
>>This i2c tranfers will clear the flatiron interrupts - the left
>>and right channels self-tests.
>>
>>Also as suggested by Andy I moved the i2c transfers to the
>>cx23885 av core interrupt handling worker. If any spurious
>>interrupt happens we silence them.
>>
>>The flatiron has some dedicated register read/write functions but are
>>not exported so Antti just suggested to call the i2c_transfer directly.
>>
>>Tested in the TBS6981 Dual DVB-S2 card.
>>
>>PS: I've found this i2c_transfers in TBS media tree, more precisely
>>in the cx23885-i2c.c file.
>>
>>Regards,
>>Luis
>>
>>
>>Signed-off-by: Luis Alves <ljalvs@gmail.com>
>>---
>> drivers/media/pci/cx23885/cx23885-av.c |   17 +++++++++++++++++
>> 1 file changed, 17 insertions(+)
>>
>>diff --git a/drivers/media/pci/cx23885/cx23885-av.c b/drivers/media/pci/cx23885/cx23885-av.c
>>index e958a01..d33570f 100644
>>--- a/drivers/media/pci/cx23885/cx23885-av.c
>>+++ b/drivers/media/pci/cx23885/cx23885-av.c
>>@@ -29,8 +29,25 @@ void cx23885_av_work_handler(struct work_struct *work)
>>       struct cx23885_dev *dev =
>>                          container_of(work, struct cx23885_dev, cx25840_work);
>>       bool handled;
>>+      char buffer[2];
>>+      struct i2c_msg msg = {
>>+              .addr = 0x98 >> 1,
>>+              .flags = 0,
>>+              .len = 2,
>>+              .buf = buffer,
>>+      };
>>
>>       v4l2_subdev_call(dev->sd_cx25840, core, interrupt_service_routine,
>>                        PCI_MSK_AV_CORE, &handled);
>>+
>>+      if (!handled) {
>>+              /* clear any pending flatiron interrupts */
>>+              buffer[0] = 0x1f;
>>+              buffer[1] = 0x80;
>>+              i2c_transfer(&dev->i2c_bus[2].i2c_adap, &msg, 1);
>>+              buffer[0] = 0x23;
>>+              i2c_transfer(&dev->i2c_bus[2].i2c_adap, &msg, 1);
>>+      }
>>+
>>       cx23885_irq_enable(dev, PCI_MSK_AV_CORE);
>> }
>>--
>>1.7.9.5
>>
>>--
>>To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>the body of a message to majordomo@vger.kernel.org
>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
