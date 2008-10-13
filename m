Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KpW46-0002np-Q3
	for linux-dvb@linuxtv.org; Tue, 14 Oct 2008 00:39:04 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta3.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K8P00IB08823E31@mta3.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Mon, 13 Oct 2008 18:38:28 -0400 (EDT)
Date: Mon, 13 Oct 2008 18:38:26 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <442626.63058.qm@web38806.mail.mud.yahoo.com>
To: Koen Rabaey <krabaey@yahoo.com>
Message-id: <48F3CDE2.5010706@linuxtv.org>
MIME-version: 1.0
References: <442626.63058.qm@web38806.mail.mud.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] cx88_wakeup message with HVR4000
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

Koen Rabaey wrote:
> Hi,
> 
> I don't know if it is of any use to anyone, but when I do a dmesg after booting, 
> at the end I get (from time to time, not consistently, the number of buffers also varies)
> 
> [  123.601789] cx88_wakeup: 7 buffers handled (should be 1)
> [  123.751892] cx88_wakeup: 7 buffers handled (should be 1)
> 
> This does not seem to interfere with dvb playback however.
> 
> I'm owning an HVR4000, compiled with http://linuxtv.org/hg/~stoth/s2/ 
> on a '2.6.27-4-generic' kernel.

FYI

http://linuxtv.org/hg/~stoth/s2-mfe/rev/6b6e9be35963

I've changed the message into a debug only message. It's still visible
when running the driver in debug mode, but for normal users they should 
not be bothered by this any more.

It will hopefully be merged this week. Thanks for raising this issue.

- Steve


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
