Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bombadil.infradead.org ([18.85.46.34])
	by www.linuxtv.org with esmtp (Exim 4.63) (envelope-from
	<SRS0+cb05ebc7a730df06bf39+1894+infradead.org+mchehab@bombadil.srs.infradead.org>)
	id 1KvUpw-00084Q-QD
	for linux-dvb@linuxtv.org; Thu, 30 Oct 2008 11:33:08 +0100
Date: Thu, 30 Oct 2008 08:33:12 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Helmut Auer <vdr@helmutauer.de>
Message-ID: <20081030083312.551de49b@pedra.chehab.org>
In-Reply-To: <47B492BE.809@helmutauer.de>
References: <47B492BE.809@helmutauer.de>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Support for Samsung SMT7020
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

Hi Helmut,

On Thu, 14 Feb 2008 20:13:02 +0100
Helmut Auer <vdr@helmutauer.de> wrote:

> Hello List
> 
> The attached patch (written by Dirk Herrendoerfer) adds support for the 
> builtin tuner of the samsung smt7020 box ( based on an Intel830 board ).
> It would be fine to see this one inside the v4l tree.
> 

Only today I noticed your patch, after starting to use a tool that digs patches
at the ML and creates a queue.

This patch have a few troubles:

1) It lacks your SOB (and also Dirk's SOB);

2) the smt7020 frontend code should be outside cx88-dvb. You need to create a
separate module for this frontend, like for example cx24123.c;

3) there are a few CodingStyle errors.

Please review and submit it again.

Cheers,
Mauro

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
