Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+0af2e7848fb42186027e+1672+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1Jd6Mv-0006FT-JX
	for linux-dvb@linuxtv.org; Sat, 22 Mar 2008 17:14:53 +0100
Date: Sat, 22 Mar 2008 13:13:56 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: timf <timf@iinet.net.au>
Message-ID: <20080322131356.45a88176@gaivota>
In-Reply-To: <1206200253.6403.11.camel@ubuntu>
References: <47A5D8AF.2090800@googlemail.com> <47ACA9AA.4090702@googlemail.com>
	<47AE20BD.7090503@googlemail.com> <20080212124734.62cd451d@gaivota>
	<47B1E22D.4090901@googlemail.com> <20080313114633.494bc7b1@gaivota>
	<1205457408.6358.5.camel@ubuntu> <20080314121423.670f31a0@gaivota>
	<1205518856.6094.14.camel@ubuntu> <20080314155851.52677f28@gaivota>
	<1205523274.6364.5.camel@ubuntu> <20080314172143.62390b1f@gaivota>
	<1205573636.5941.1.camel@ubuntu> <20080318103044.4363fefd@gaivota>
	<1205864312.11231.11.camel@ubuntu>
	<20080318161729.6da782ee@gaivota>
	<1205873332.11231.17.camel@ubuntu>
	<20080318180415.5dfc4319@gaivota>
	<1205875868.3385.133.camel@pc08.localdom.local>
	<1205904196.6510.3.camel@ubuntu> <20080320115531.7ab450ba@gaivota>
	<1206030503.5997.2.camel@ubuntu> <20080320140715.4204ec78@gaivota>
	<20080322083435.2432256b@gaivota> <47E51CBD.1000906@googlemail.com>
	<20080322115925.69cc5b38@gaivota> <1206200253.6403.11.camel@ubuntu>
Mime-Version: 1.0
Cc: Hackmann <hartmut.hackmann@t-online.de>, lucarasp <lucarasp@inwind.it>,
	linux-dvb@linuxtv.org, "Richard \(MQ\)" <osl2008@googlemail.com>
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

On Sun, 23 Mar 2008 00:37:33 +0900
timf <timf@iinet.net.au> wrote:

> Hi again,

> Something strange happening here:
> 
> [   24.528000] mt352_read_register: readreg error (reg=127, ret==-5)
> [   24.528000] xc2028: Xcv2028/3028 init called!
> [   24.528000] xc2028: No frontend!
> [   24.528000] saa7133[0]/2: xc3028 attach failed
> [   24.528000] BUG: unable to handle kernel NULL pointer dereference at
> virtual address 000000ac
> [   24.528000]  printing eip:
> [   24.528000] f8b70074
> [   24.528000] *pde = 00000000
> [   24.528000] Oops: 0000 [#1]

Ok. This means that the mt352 initialization code is not Ok. So, you'll need to hack it. It also showed a bug on saa7134-dvb: if frontend is null it shouldn't register xc2028, but, instead, return with -EINVAL.

> 
> Regards,
> Tim




Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
