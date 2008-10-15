Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from srv5.sysproserver.de ([78.46.249.130])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <nicolai@xeve.de>) id 1KqACV-0003tp-05
	for linux-dvb@linuxtv.org; Wed, 15 Oct 2008 19:30:23 +0200
Received: from [192.168.2.4] (p4FDB4B01.dip.t-dialin.net [79.219.75.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by srv5.sysproserver.de (Postfix) with ESMTP id 29EB12FCEA30
	for <linux-dvb@linuxtv.org>; Wed, 15 Oct 2008 19:30:19 +0200 (CEST)
Message-ID: <48F628AE.9000308@xeve.de>
Date: Wed, 15 Oct 2008 19:30:22 +0200
From: Nicolai Spohrer <nicolai@xeve.de>
MIME-Version: 1.0
CC: linux-dvb@linuxtv.org
References: <48F502D7.5070607@xeve.de>
	<E1KpyCw-0002md-00.goga777-bk-ru@f110.mail.ru>
In-Reply-To: <E1KpyCw-0002md-00.goga777-bk-ru@f110.mail.ru>
Subject: Re: [linux-dvb] S2API / TT3200 / STB0899 support
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

Goga777 wrote:
> You can use the ffplay instead of mplayer. Ffplay can play h.264 stream from dvb-s2 channel
>   

How?
When I dump the stream (dd if=/dev/..../dvr0 of=hd.ts) and use "ffplay 
hd.ts", I get
hd.ts: could not open codecs

ffplay - < /dev/..../dvr0
and ffplay /dev/..../dvr0

don't output anything (they run forever, I can neither see the video nor 
see the audio.

N.S.

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
