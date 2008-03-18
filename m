Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+b9c06d2e3da2f0ede24a+1668+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1Jbizk-0001DO-VR
	for linux-dvb@linuxtv.org; Tue, 18 Mar 2008 22:05:17 +0100
Date: Tue, 18 Mar 2008 18:04:15 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: timf <timf@iinet.net.au>
Message-ID: <20080318180415.5dfc4319@gaivota>
In-Reply-To: <1205873332.11231.17.camel@ubuntu>
References: <47A5D8AF.2090800@googlemail.com> <20080205075014.6b7091d9@gaivota>
	<47A8CE7E.6020908@googlemail.com> <20080205222437.1397896d@gaivota>
	<47AA014F.2090608@googlemail.com> <20080207092607.0a1cacaa@gaivota>
	<47AAF0C4.8030804@googlemail.com> <47AB6A1B.5090100@googlemail.com>
	<20080207184221.1ea8e823@gaivota> <47ACA9AA.4090702@googlemail.com>
	<47AE20BD.7090503@googlemail.com> <20080212124734.62cd451d@gaivota>
	<47B1E22D.4090901@googlemail.com> <20080313114633.494bc7b1@gaivota>
	<1205457408.6358.5.camel@ubuntu> <20080314121423.670f31a0@gaivota>
	<1205518856.6094.14.camel@ubuntu> <20080314155851.52677f28@gaivota>
	<1205523274.6364.5.camel@ubuntu> <20080314172143.62390b1f@gaivota>
	<1205573636.5941.1.camel@ubuntu> <20080318103044.4363fefd@gaivota>
	<1205864312.11231.11.camel@ubuntu>
	<20080318161729.6da782ee@gaivota>
	<1205873332.11231.17.camel@ubuntu>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org, "Richard \(MQ\)" <osl2008@googlemail.com>
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

On Wed, 19 Mar 2008 05:48:52 +0900
timf <timf@iinet.net.au> wrote:

> 1) New install ubuntu, extract tip.tgz.

There's no need for you to reinstall Linux for each test. This is not MS**t ;)

You don't even need to reboot.

> [   40.753552] saa7133[0]: i2c scan: found device @ 0xc2  [???]
> [   40.864616] tuner' 2-0061: Setting mode_mask to 0x0e
> [   40.864621] tuner' 2-0061: chip found @ 0xc2 (saa7133[0])
> [   40.864624] tuner' 2-0061: tuner 0x61: Tuner type absent
> [   40.864658] tuner' 2-0061: Calling set_type_addr for type=0,
> addr=0xff, mode=0x02, config=0xffff8100

mode=0x02 is radio.

Try to add this to the struct:

.radio_type     = UNSET,

> 3) No DVB, installed tvtime - no signal.

DVB won't work yet. What the demod inside this board? There's no setup for it.

Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
