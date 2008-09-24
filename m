Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from joan.kewl.org ([212.161.35.248])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <darron@kewl.org>) id 1KiVOT-0000bl-Ko
	for linux-dvb@linuxtv.org; Wed, 24 Sep 2008 16:31:06 +0200
From: Darron Broad <darron@kewl.org>
To: Christophe Thommeret <hftom@free.fr>
In-reply-to: <200809241538.51217.hftom@free.fr> 
References: <200809211905.34424.hftom@free.fr>
	<200809221201.26115.hftom@free.fr> <20080923162757.282370@gmx.net>
	<200809241538.51217.hftom@free.fr>
Date: Wed, 24 Sep 2008 15:31:02 +0100
Message-ID: <4454.1222266662@kewl.org>
Cc: Hans Werner <HWerner4@gmx.de>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] hvr4000-s2api + QAM_AUTO
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

In message <200809241538.51217.hftom@free.fr>, Christophe Thommeret wrote:

hi.

<snip>

>Btw, while cx24116 single-frontend seems pretty stable, the mfe driver is n=
>ot =
>here. As soon as i switch to dvb-t, the cx24116 firmware crashes (at least =
>seems so: ~"Firmware doen't respond .." ) and is reloaded on next S/S2 zap, =
>and after a while, the dvb-t signal appears more and more noisy. I have to =
>unload/reload the modules to cure this.

Can you load dvb_core like this:

	dvb_core dvb_powerdown_on_sleep=0

This will stop access to the cx24116 when the bus is in use by the cx22702.

This is a workaround until a better fix is found. Tell me if it solves it
for you, Thanks.


--

 // /
{:)==={ Darron Broad <darron@kewl.org>
 \\ \ 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
