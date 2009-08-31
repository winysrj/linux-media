Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from node6.gecad.com ([193.230.245.6])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <eduard.budulea@axigen.com>) id 1Mi3GB-0006KJ-OB
	for linux-dvb@linuxtv.org; Mon, 31 Aug 2009 11:33:12 +0200
From: Eduard Budulea <eduard.budulea@axigen.com>
To: linux-dvb@linuxtv.org
Date: Mon, 31 Aug 2009 12:35:32 +0300
Message-Id: <1251711332.3990.18.camel@edi-desktop>
Mime-Version: 1.0
Subject: [linux-dvb] saa 7162 chip, recording from s-video
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
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

Hi, I have this card:Kworld DVB-T PE310.
On a ubuntu 9.4 system with linux 2.6.28-15-generic.
I've managed to compile and install the drivers from:
http://www.jusst.de/hg/saa716x/
I've added my pci id to the driver list (used atlantis config structure)
I also added my tda10046 (actually my chips are tda 100046A, why the
extra 0?) id (whitch is 0xFF, not 0x46) in tda10046_attach function.
It kind of worked, because it has not crashed and the w_scan give output
like is working.
How ever, I don't know if in my region I have dvb-t.
I have gotten this board because the motherboard has only pci express.
What I want is to be able to record from an s-video source.
It should be possible with this card.
But the card does not export a /dev/videox file (no v4l?)
It only creates /dev/dvb/adapterx thing.
So how can I record s-video with this card?

Thanks, I am willing to do testing for the driver development.


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
