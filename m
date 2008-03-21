Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+da5aaa25a30f212e576e+1671+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1JcWS1-0003rI-QL
	for linux-dvb@linuxtv.org; Fri, 21 Mar 2008 02:53:45 +0100
Date: Thu, 20 Mar 2008 21:53:30 -0400 (EDT)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: timf <timf@iinet.net.au>
In-Reply-To: <1206061004.6988.3.camel@ubuntu>
Message-ID: <Pine.LNX.4.64.0803202109130.8321@bombadil.infradead.org>
References: <47A5D8AF.2090800@googlemail.com> <47AA014F.2090608@googlemail.com>
	<47AB6A1B.5090100@googlemail.com>  <20080207184221.1ea8e823@gaivota>
	<47ACA9AA.4090702@googlemail.com>  <47AE20BD.7090503@googlemail.com>
	<20080212124734.62cd451d@gaivota>  <47B1E22D.4090901@googlemail.com>
	<20080313114633.494bc7b1@gaivota>  <1205457408.6358.5.camel@ubuntu>
	<20080314121423.670f31a0@gaivota>  <1205518856.6094.14.camel@ubuntu>
	<20080314155851.52677f28@gaivota>  <1205523274.6364.5.camel@ubuntu>
	<20080314172143.62390b1f@gaivota>  <1205573636.5941.1.camel@ubuntu>
	<20080318103044.4363fefd@gaivota>  <1205864312.11231.11.camel@ubuntu>
	<20080318161729.6da782ee@gaivota>  <1205873332.11231.17.camel@ubuntu>
	<20080318180415.5dfc4319@gaivota>
	<1205875868.3385.133.camel@pc08.localdom.local>
	<1205904196.6510.3.camel@ubuntu> <20080320115531.7ab450ba@gaivota>
	<1206030503.5997.2.camel@ubuntu>  <20080320140715.4204ec78@gaivota>
	<1206061004.6988.3.camel@ubuntu>
MIME-Version: 1.0
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

On Fri, 21 Mar 2008, timf wrote:

> [   51.446308] xc2028 2-0061: Device is Xceive 3028 version 1.0, firmware version 2.7

Ok, xc3028 loaded the firmware. This means that reset GPIO's are correct.

> Info:	- have /dev/video0
> 	- tvtime - no signal
> 	- have soundcard

There are some possibilities:

1) This board doesn't work with firmware version 2.7;

2) GPIO's are wrong;

3) vmux value is wrong.

I guess the issue is with the firmware version. Probably, it will need an 
earlier version.

>
> Regards,
> Tim
>

-- 
Cheers,
Mauro Carvalho Chehab
http://linuxtv.org
mchehab@infradead.org

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
