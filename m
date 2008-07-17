Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.187])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <l.pinguin@gmail.com>) id 1KJZpa-0000H1-Dc
	for linux-dvb@linuxtv.org; Thu, 17 Jul 2008 22:12:03 +0200
Received: by ti-out-0910.google.com with SMTP id w7so71777tib.13
	for <linux-dvb@linuxtv.org>; Thu, 17 Jul 2008 13:11:57 -0700 (PDT)
Message-ID: <3efb10970807171311t46d075cdudef4b34cc069c265@mail.gmail.com>
Date: Thu, 17 Jul 2008 22:11:55 +0200
From: "Remy Bohmer" <linux@bohmer.net>
To: "ChaosMedia > WebDev" <webdev@chaosmedia.org>
In-Reply-To: <487F3365.4070306@chaosmedia.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <200807170023.57637.ajurik@quick.cz>
	<3efb10970807170320w39377ae9p9db0081dda9c3f5f@mail.gmail.com>
	<487F3365.4070306@chaosmedia.org>
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

Hello Marc and Ales,

Good news: I have the tools up and running and can tune into several
channels :-))
I even have a patched 'scan' tool that works to be able to generate a
channels.conf file from scratch.
Scanning channels works fine, it generates a proper channels.conf file.

So, while using szap2 to tune to a channel. I noticed some things:
* On a standard FTA channel (DVB-S) on Astra 19.2E, I see some
distortion during watching the channel. After some time (say 10-30
seconds) the link get lost, and I do not receive any data anymore
until the next tune-request with szap2. Sometimes the lock comes
quick, sometimes szap2 keeps retrying until it times out.
* On DVB-S2/HD channels (e.g. Arte HD) I only get sound, but that is
probably because I use the wrong tools (tools not supporting DVB-S2)
to read data from /dev/dvb/adapter0/dvr0.

> with szap2 you also can tune to FTA channels using the option "-p" and read
> the stream from your frontend dvr (/dev/dvb/adapter0/dvr0) with mplayer for
> example..

Can you please tell me how to do this with mplayer? Because I did not
manage that with mplayer directly.
Here mplayer blocks on the stream, and no audio/video is displayed.


Kind Regards,

Remy

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
