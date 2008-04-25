Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+cdbc83983d2090c8071f+1706+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1JpNmr-0003mw-GA
	for linux-dvb@linuxtv.org; Fri, 25 Apr 2008 15:16:25 +0200
Date: Fri, 25 Apr 2008 10:15:17 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: timf <timf@iinet.net.au>
Message-ID: <20080425101517.71017817@gaivota>
In-Reply-To: <4811D385.8010605@iinet.net.au>
References: <480F40C8.1000102@iinet.net.au> <20080423115940.304c089a@gaivota>
	<480F7569.8010002@iinet.net.au>
	<Pine.LNX.4.64.0804232254340.31358@bombadil.infradead.org>
	<4811D385.8010605@iinet.net.au>
Mime-Version: 1.0
Cc: lucarasp@inwind.it, linux-dvb@linuxtv.org, osl2008@googlemail.com
Subject: Re: [linux-dvb] Avermedia A16D
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

On Fri, 25 Apr 2008 20:50:13 +0800
timf <timf@iinet.net.au> wrote:

> Hi Mauro,
> 
> OK, I gave ubuntu Hardy 8.04 away, they appear to have frozen at a time 
> way before the latest developments on v4l-dvb.
> So, used ubuntu Gutsy 7.10 instead.
> 
> Success at about 80% for Avermedia A16D.

Good.

> [ 52.742640] tuner' 2-0061: Cmd TUNER_SET_STANDBY accepted for analog TV
> [ 52.742643] xc2028 2-0061: xc2028_sleep called

It seems that you're not using the latest version of the tree. I've commented
xc2028_sleep, since this were being called at the wrong moment. This sleep
function should be called at S1/S3 sleep, but the current code calls it too
frequently. A proper fix would likely require some adjustments at tuner-core.

Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
