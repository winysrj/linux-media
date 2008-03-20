Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+58f8ad55774394d91ee7+1670+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1JcOEx-0005Hf-Qw
	for linux-dvb@linuxtv.org; Thu, 20 Mar 2008 18:07:44 +0100
Date: Thu, 20 Mar 2008 14:07:15 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: timf <timf@iinet.net.au>
Message-ID: <20080320140715.4204ec78@gaivota>
In-Reply-To: <1206030503.5997.2.camel@ubuntu>
References: <47A5D8AF.2090800@googlemail.com> <47AA014F.2090608@googlemail.com>
	<20080207092607.0a1cacaa@gaivota> <47AAF0C4.8030804@googlemail.com>
	<47AB6A1B.5090100@googlemail.com> <20080207184221.1ea8e823@gaivota>
	<47ACA9AA.4090702@googlemail.com> <47AE20BD.7090503@googlemail.com>
	<20080212124734.62cd451d@gaivota> <47B1E22D.4090901@googlemail.com>
	<20080313114633.494bc7b1@gaivota> <1205457408.6358.5.camel@ubuntu>
	<20080314121423.670f31a0@gaivota> <1205518856.6094.14.camel@ubuntu>
	<20080314155851.52677f28@gaivota> <1205523274.6364.5.camel@ubuntu>
	<20080314172143.62390b1f@gaivota> <1205573636.5941.1.camel@ubuntu>
	<20080318103044.4363fefd@gaivota>
	<1205864312.11231.11.camel@ubuntu>
	<20080318161729.6da782ee@gaivota>
	<1205873332.11231.17.camel@ubuntu>
	<20080318180415.5dfc4319@gaivota>
	<1205875868.3385.133.camel@pc08.localdom.local>
	<1205904196.6510.3.camel@ubuntu> <20080320115531.7ab450ba@gaivota>
	<1206030503.5997.2.camel@ubuntu>
Mime-Version: 1.0
Cc: Hackmann <hartmut.hackmann@t-online.de>, lucarasp <lucarasp@inwind.it>,
	"Richard \(MQ\)" <osl2008@googlemail.com>, linux-dvb@linuxtv.org
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

On Fri, 21 Mar 2008 01:28:23 +0900
timf <timf@iinet.net.au> wrote:

> Hi Mauro,
> 
> > 
> > Could you please test and give us a feedback?
> Maybe I did something wrong:
> 
> timf@ubuntu:~/v4l-dvb$ patch -p1 < mauro_patch1
> patching file linux/drivers/media/dvb/dvb-usb/cxusb.c
> Hunk #1 FAILED at 509.
> 1 out of 1 hunk FAILED -- saving rejects to file
> linux/drivers/media/dvb/dvb-usb/cxusb.c.rej
> patching file linux/drivers/media/dvb/frontends/tda827x.c
> Hunk #1 FAILED at 579.
> Hunk #2 FAILED at 588.
> 2 out of 2 hunks FAILED -- saving rejects to file
> linux/drivers/media/dvb/frontends/tda827x.c.rej
> patching file linux/drivers/media/video/cx23885/cx23885-dvb.c
> Hunk #1 FAILED at 298.
> 1 out of 1 hunk FAILED -- saving rejects to file
> linux/drivers/media/video/cx23885/cx23885-dvb.c.rej
> patching file linux/drivers/media/video/cx88/cx88-cards.c
> Hunk #1 FAILED at 2140.
> Hunk #2 FAILED at 2160.
> Hunk #3 FAILED at 2189.
> Hunk #4 FAILED at 2242.
> Hunk #5 FAILED at 2287.
> Hunk #6 FAILED at 2323.
> 6 out of 6 hunks FAILED -- saving rejects to file
> linux/drivers/media/video/cx88/cx88-cards.c.rej
> patching file linux/drivers/media/video/cx88/cx88-dvb.c
> Hunk #1 FAILED at 465.
> Hunk #2 FAILED at 786.
> 2 out of 2 hunks FAILED -- saving rejects to file
> linux/drivers/media/video/cx88/cx88-dvb.c.rej
> patching file linux/drivers/media/video/saa7134/saa7134-cards.c
> Hunk #1 FAILED at 5353.
> 1 out of 1 hunk FAILED -- saving rejects to file
> linux/drivers/media/video/saa7134/saa7134-cards.c.rej
> patching file linux/drivers/media/video/saa7134/saa7134-dvb.c
> Hunk #1 FAILED at 1173.
> 1 out of 1 hunk FAILED -- saving rejects to file
> linux/drivers/media/video/saa7134/saa7134-dvb.c.rej
> patching file linux/drivers/media/video/tuner-core.c
> Hunk #1 FAILED at 448.
> 1 out of 1 hunk FAILED -- saving rejects to file
> linux/drivers/media/video/tuner-core.c.rej
> patching file linux/drivers/media/video/tuner-xc2028.c
> Hunk #1 FAILED at 1174.
> Hunk #2 FAILED at 1182.
> Hunk #3 FAILED at 1222.
> 3 out of 3 hunks FAILED -- saving rejects to file
> linux/drivers/media/video/tuner-xc2028.c.rej
> timf@ubuntu:~/v4l-dvb$ 

100% of rejects??? This is really weird... Maybe your emailer did something bad
with the patches, like converting to DOS end-of-line marks. You may try to use
'-l' option on patch.

I'll also forward you in priv the patch, as an attachment.





Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
