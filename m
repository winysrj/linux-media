Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail1.radix.net ([207.192.128.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <awalls@radix.net>) id 1L0e41-0002mM-OV
	for linux-dvb@linuxtv.org; Thu, 13 Nov 2008 16:24:58 +0100
From: Andy Walls <awalls@radix.net>
To: Dmitry Podyachev <vdp@teletec.com.ua>
In-Reply-To: <49196891.9060004@teletec.com.ua>
References: <49196891.9060004@teletec.com.ua>
Date: Thu, 13 Nov 2008 10:25:50 -0500
Message-Id: <1226589950.3114.32.camel@palomino.walls.org>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Compro VideoMate H900
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

On Tue, 2008-11-11 at 13:12 +0200, Dmitry Podyachev wrote:
> v4l analogue TV question.
> Could somebody (Andy Walls help me please) advice with next situation:
> All my cards cx18 (Compro VideoMate H900) drop synchro - and TV
> picture has problem.
> This effect like broken analogue signal (I check, it was correct)

Dmitry,

Yes the CX23418 AV is temporarily losing horizontal sync, looking at the
MPEG sample you sent me.  We should hopefully be able to come up with
fix in the cx18 driver with configuring the CX23418's AV decoder's
analog front end.  I believe Hans' has an H900, let me talk with him
about it.


> Are you have any idea what can helps (firmware, aplifier)?

This is strictly a problem with components external to the CX23418 A/V
decoder and the AV decoder's interaction with them, if your video signal
is completely clean.  

No firmware change will fix it.

Changes to settings in the Analog Front End configuration need to be
made in the cx18 driver.


> This situation usually when all background too light and some part (at top) dark.
> If picture not so brightness - all ok.

"Too light" is consistent with the conditions that I know can trigger
the problem.


Regards,
Andy


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
