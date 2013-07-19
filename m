Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:34579 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751509Ab3GSJIo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jul 2013 05:08:44 -0400
References: <201307191137522969679@gmail.com> <CAGj5WxC0ADsdA7KcW92wu-KNLPUSbVspbvq5SLqdbFt49NMZXA@mail.gmail.com>
In-Reply-To: <CAGj5WxC0ADsdA7KcW92wu-KNLPUSbVspbvq5SLqdbFt49NMZXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] cx23885[v2]: Fix IR interrupt storm.
From: Andy Walls <awalls@md.metrocast.net>
Date: Fri, 19 Jul 2013 05:08:19 -0400
To: Luis Alves <ljalvs@gmail.com>, "nibble.max" <nibble.max@gmail.com>
CC: mchehab <mchehab@infradead.org>, crope <crope@iki.fi>,
	linux-media <linux-media@vger.kernel.org>
Message-ID: <10de921e-68e7-4e91-9cb2-552e20d511bc@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Luis Alves <ljalvs@gmail.com> wrote:

>Hi Max,
>
>Should have thought on that! I'll change it to preserve all other bits.
>
>Thanks,
>Luis
>
>
>On Fri, Jul 19, 2013 at 4:37 AM, nibble.max <nibble.max@gmail.com>
>wrote:
>> Hello Luis,
>> The internel interrupts are rounted as follow:
>> flatiron(include ADC)--->HammerHead(include IR inside)--->Pecos(PCIe)
>> The flatiron interrupt is enabled when chip power up.
>> When HammerHead interrupt is enalbe in Pecos, the most of interrupts
>are coming from flatiron.
>> The more accurate code is that reading back these left and right
>registers(0x1f, 0x23), set its bit-7 to "1" , then write back.
>> So that it does not touch other bits.
>> BR,
>> Max
>>
>>>Hi all,
>>>This path is meant to be up-streamed.
>>>
>>>Andy has a nice explanation for the interrupt storm when
>>>enabling the IR interrupt:
>>>
>>>The flatiron core (the audio adc) signals the end of its self-test
>>>with an interrupt. Since the flatiron irq seems OR-wired
>>>with the IR irq the result is this interrupt storm.
>>>This i2c tranfers will clear the flatiron interrupts - the left
>>>and right channels self-tests.
>>>
>>>Also as suggested by Andy I moved the i2c transfers to the
>>>cx23885 av core interrupt handling worker. If any spurious
>>>interrupt happens we silence them.
>>>
>>>The flatiron has some dedicated register read/write functions but are
>>>not exported so Antti just suggested to call the i2c_transfer
>directly.
>>>
>>>Tested in the TBS6981 Dual DVB-S2 card.
>>>
>>>PS: I've found this i2c_transfers in TBS media tree, more precisely
>>>in the cx23885-i2c.c file.
>>>
>>>Regards,
>>>Luis
>>>
>>>
>>>Signed-off-by: Luis Alves <ljalvs@gmail.com>
>>>---
>>> drivers/media/pci/cx23885/cx23885-av.c |   17 +++++++++++++++++
>>> 1 file changed, 17 insertions(+)
>>>
>>>diff --git a/drivers/media/pci/cx23885/cx23885-av.c
>b/drivers/media/pci/cx23885/cx23885-av.c
>>>index e958a01..d33570f 100644
>>>--- a/drivers/media/pci/cx23885/cx23885-av.c
>>>+++ b/drivers/media/pci/cx23885/cx23885-av.c
>>>@@ -29,8 +29,25 @@ void cx23885_av_work_handler(struct work_struct
>*work)
>>>       struct cx23885_dev *dev =
>>>                          container_of(work, struct cx23885_dev,
>cx25840_work);
>>>       bool handled;
>>>+      char buffer[2];
>>>+      struct i2c_msg msg = {
>>>+              .addr = 0x98 >> 1,
>>>+              .flags = 0,
>>>+              .len = 2,
>>>+              .buf = buffer,
>>>+      };
>>>
>>>       v4l2_subdev_call(dev->sd_cx25840, core,
>interrupt_service_routine,
>>>                        PCI_MSK_AV_CORE, &handled);
>>>+
>>>+      if (!handled) {
>>>+              /* clear any pending flatiron interrupts */
>>>+              buffer[0] = 0x1f;
>>>+              buffer[1] = 0x80;
>>>+              i2c_transfer(&dev->i2c_bus[2].i2c_adap, &msg, 1);
>>>+              buffer[0] = 0x23;
>>>+              i2c_transfer(&dev->i2c_bus[2].i2c_adap, &msg, 1);
>>>+      }
>>>+
>>>       cx23885_irq_enable(dev, PCI_MSK_AV_CORE);
>>> }
>>>--
>>>1.7.9.5
>>>
>>>--
>>>To unsubscribe from this list: send the line "unsubscribe
>linux-media" in
>>>the body of a message to majordomo@vger.kernel.org
>>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>

Yup, I was going to suggest that.

At that point you'll want to put prototypes for cx23885_flatiron_read/write() in a header file and remove any static keyword in front of the function definitions in cx23885-video.c.

Using those functions will make the change easier to read.

Regards,
Andy
