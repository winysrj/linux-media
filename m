Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.238])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <l.pinguin@gmail.com>) id 1KJQbK-0006sI-16
	for linux-dvb@linuxtv.org; Thu, 17 Jul 2008 12:20:58 +0200
Received: by rv-out-0506.google.com with SMTP id b25so6930783rvf.41
	for <linux-dvb@linuxtv.org>; Thu, 17 Jul 2008 03:20:36 -0700 (PDT)
Message-ID: <3efb10970807170320w39377ae9p9db0081dda9c3f5f@mail.gmail.com>
Date: Thu, 17 Jul 2008 12:20:36 +0200
From: "Remy Bohmer" <linux@bohmer.net>
To: ajurik@quick.cz, "ChaosMedia > WebDev" <webdev@chaosmedia.org>
In-Reply-To: <200807170023.57637.ajurik@quick.cz>
MIME-Version: 1.0
Content-Disposition: inline
References: <200807170023.57637.ajurik@quick.cz>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TT S2-3200 driver
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

Hello Ales and Marc,

> please try attached patch. With this patch I'm able to get lock on channels

Okay, I want to test it too, but I have some troubles getting the
multiproto drivers up and running.
The S2-3200 is detected properly in my system, but I have no working
szap2, or scan, or dvbstream tools.

The two of you seem to have it working, so maybe you can give me some hints:
What sources (what version) do I need?
Is there a clear manual available somewhere that describes how to use
the multiproto drivers?
What version of szap2 (and scan) should I use? and where can I find it?
Does dvbstream still work? Or can I use Mythtv directly?

Kind Regards,

Remy

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
