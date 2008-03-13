Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+3270550f2f8d24d48394+1663+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1JZohz-0000bT-KZ
	for linux-dvb@linuxtv.org; Thu, 13 Mar 2008 15:47:03 +0100
Date: Thu, 13 Mar 2008 11:46:33 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Richard (MQ)" <osl2008@googlemail.com>
Message-ID: <20080313114633.494bc7b1@gaivota>
In-Reply-To: <47B1E22D.4090901@googlemail.com>
References: <47A5D8AF.2090800@googlemail.com> <20080205075014.6b7091d9@gaivota>
	<47A8CE7E.6020908@googlemail.com> <20080205222437.1397896d@gaivota>
	<47AA014F.2090608@googlemail.com> <20080207092607.0a1cacaa@gaivota>
	<47AAF0C4.8030804@googlemail.com> <47AB6A1B.5090100@googlemail.com>
	<20080207184221.1ea8e823@gaivota> <47ACA9AA.4090702@googlemail.com>
	<47AE20BD.7090503@googlemail.com> <20080212124734.62cd451d@gaivota>
	<47B1E22D.4090901@googlemail.com>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Any chance of help with v4l-dvb-experimental /
 Avermedia A16D please?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi Richard,

On Tue, 12 Feb 2008 18:15:09 +0000
"Richard (MQ)" <osl2008@googlemail.com> wrote:

Sorry for a late answer. Too busy from my side :(

> > please forward the errors that it might produce. You may forward the full dmesg
> > errors to me in priv directly. I prefer if you don't generate a tarball, since
> > makes easier for me to comment, the results, if needed.

> Feb 12 18:03:26 DevBox2400 klogd: saa7133[0]: i2c scan: found device @ 0x1e  [???]
> Feb 12 18:03:26 DevBox2400 klogd: saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]

The issue here is that tuner-xc3028 weren't detected. It should have found a
device at 0xc2.

This could happen on two cases:

1) Some saa713x GPIO is needed before we can see xc3028. The better would be to
take a look on what windows driver is doing with GPIO's. This link helps you to
understand what should be done on windows:

http://www.linuxtv.org/v4lwiki/index.php/GPIO_pins

2) You need to open an i2c gate on your demod chip. In this case, some commands
need to be sent to your demod for it to open the i2c gate. 

I suspect that, on your case, it is (1). Please try the enclosed patch.

---

Enable GPIO's for AV A16D

From: Mauro Carvalho Chehab <mchehab@infradead.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>

diff -r 3580392c30da linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c	Thu Mar 13 10:57:22 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c	Thu Mar 13 11:43:45 2008 -0300
@@ -5499,6 +5499,7 @@ int saa7134_board_init1(struct saa7134_d
 	case SAA7134_BOARD_AVERMEDIA_CARDBUS_506:
 	case SAA7134_BOARD_AVERMEDIA_M115:
 	case SAA7134_BOARD_BEHOLD_COLUMBUS_TVFM:
+	case SAA7134_BOARD_AVERMEDIA_A16D:
 		/* power-up tuner chip */
 		saa_andorl(SAA7134_GPIO_GPMODE0 >> 2,   0xffffffff, 0xffffffff);
 		saa_andorl(SAA7134_GPIO_GPSTATUS0 >> 2, 0xffffffff, 0xffffffff);


Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
