Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52317 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932636Ab3DBPr5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 2 Apr 2013 11:47:57 -0400
Message-ID: <515AFDA0.8090802@redhat.com>
Date: Tue, 02 Apr 2013 17:47:44 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: zhaokai@loongson.cn
Subject: saa7134 irq status bits
References: <515A8D5A.4060605@loongson.cn>
In-Reply-To: <515A8D5A.4060605@loongson.cn>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  Hi,

Forwarding to linux-media mailing list, hoping that someone there can
help out.  I havn't worked in the code for years now, can't remember
what the AR irq bit is and can't find my copy of the saa7134 data sheet
too ...

cheers,
  Gerd

-------- Original Message --------
Subject: hello kraxel
Date: Tue, 02 Apr 2013 15:48:42 +0800
From: zhaokai <zhaokai@loongson.cn>
To: kraxel@bytesex.org

Dear Kraxel:

My name is zhaokai, I am a soft developer working in beijing.
This is my first mail to The Kernel Developer, I am very excited.
Now I have a question about your code for saa7134 driver in linux kernel
2.6.21.
We use Loongson CPU,I compile kernel and run the image,when I run my
test app for saa7134 camera
this message will print:
saa7130[0]/irq: looping -- clearing all enable bits

I study the saa7134 driver code,find the message come from the follow code:

    if (10 == loop) {
        print_irqstatus(dev,loop,report,status);
        if (report & SAA7134_IRQ_REPORT_PE) {
            /* disable all parity error */
            printk(KERN_WARNING "%s/irq: looping -- "
                   "clearing PE (parity error!) enable bit\n",dev->name);
            saa_clearl(SAA7134_IRQ2,SAA7134_IRQ2_INTE_PE);
        } else if (report & SAA7134_IRQ_REPORT_GPIO16) {
            /* disable gpio16 IRQ */
            printk(KERN_WARNING "%s/irq: looping -- "
                   "clearing GPIO16 enable bit\n",dev->name);
            saa_clearl(SAA7134_IRQ2, SAA7134_IRQ2_INTE_GPIO16);
        } else if (report & SAA7134_IRQ_REPORT_GPIO18) {
            /* disable gpio18 IRQs */
            printk(KERN_WARNING "%s/irq: looping -- "
                   "clearing GPIO18 enable bit\n",dev->name);
            saa_clearl(SAA7134_IRQ2, SAA7134_IRQ2_INTE_GPIO18);
        } else {
            /* disable all irqs */
            printk(KERN_WARNING "%s/irq: looping -- "
                   "clearing all enable bits\n",dev->name);
            saa_writel(SAA7134_IRQ1,0);
            saa_writel(SAA7134_IRQ2,0);
        }
    }
this is in the interrupt handle function,I add some print and find the
value of SAA7134_IRQ_REPORT register is 0x11 or 0x10, normally it would
be 0x1 or 0x0,
0x1x means SAA7134_IRQ_REPORT_AR, So what is the meaning of
SAA7134_IRQ_REPORT_AR ?

Best regards,
ZhaoKai




