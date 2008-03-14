Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+2f2457f4b8686c4b8dda+1664+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1JaBcf-0003uv-LA
	for linux-dvb@linuxtv.org; Fri, 14 Mar 2008 16:15:05 +0100
Date: Fri, 14 Mar 2008 12:14:23 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: timf <timf@iinet.net.au>
Message-ID: <20080314121423.670f31a0@gaivota>
In-Reply-To: <1205457408.6358.5.camel@ubuntu>
References: <47A5D8AF.2090800@googlemail.com> <20080205075014.6b7091d9@gaivota>
	<47A8CE7E.6020908@googlemail.com> <20080205222437.1397896d@gaivota>
	<47AA014F.2090608@googlemail.com> <20080207092607.0a1cacaa@gaivota>
	<47AAF0C4.8030804@googlemail.com> <47AB6A1B.5090100@googlemail.com>
	<20080207184221.1ea8e823@gaivota> <47ACA9AA.4090702@googlemail.com>
	<47AE20BD.7090503@googlemail.com> <20080212124734.62cd451d@gaivota>
	<47B1E22D.4090901@googlemail.com> <20080313114633.494bc7b1@gaivota>
	<1205457408.6358.5.camel@ubuntu>
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

On Fri, 14 Mar 2008 10:16:48 +0900
timf <timf@iinet.net.au> wrote:

> Hi Mauro,
> Improved, but still no tuner-xc3028, no dvb.
> Relevant part of my dmesg:

> [   15.120000] tuner' 2-0061: chip found @ 0xc2 (saa7133[0])
> [   15.120000] tuner' 2-0061: tuner type not set
> [   15.120000] tuner' 2-0061: tuner type not set

The above messages are very weird... are you passing any option to saa7134? It
should autodetect tuner=71...

Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
