Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.153])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <christophpfister@gmail.com>) id 1KJwqP-0000ze-2Z
	for linux-dvb@linuxtv.org; Fri, 18 Jul 2008 22:46:26 +0200
Received: by fg-out-1718.google.com with SMTP id e21so227300fga.25
	for <linux-dvb@linuxtv.org>; Fri, 18 Jul 2008 13:46:21 -0700 (PDT)
From: Christoph Pfister <christophpfister@gmail.com>
To: linux-dvb@linuxtv.org
Date: Fri, 18 Jul 2008 22:46:17 +0200
References: <g5llos$b75$1@ger.gmane.org>
In-Reply-To: <g5llos$b75$1@ger.gmane.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807182246.17897.christophpfister@gmail.com>
Cc: Andrea <mariofutire@googlemail.com>
Subject: Re: [linux-dvb] [PATCH] 2 patches for dvb-apps gnutv
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

Am Mittwoch 16 Juli 2008 22:28:33 schrieb Andrea:
> Hi,
>
> I would like to repost 2 patches for gnutv, part of dvb-apps.
>
> http://www.linuxtv.org/pipermail/linux-dvb/2008-July/027177.html
>
> They both try to make gnutv more robust when the system/destination file
> system are temporary slow.
>
> 1) http://www.linuxtv.org/pipermail/linux-dvb/2008-July/027176.html
> Once the dvb ringbuffer overflows, it is pointless to stop gnutv. I think
> it should continue and get the rest of the signal.
> What has been lost has been lost, let's not loose the future stream
>
> 2) http://www.linuxtv.org/pipermail/linux-dvb/2008-July/027177.html
> Allow to set a bigger (than default = 2MB) dvb ringbuffer to cope with
> temporary bottlenecks.
>
> Is anybody interested in reviewing them?

Guess no.

But I'll rework the first patch a bit (the sequence of revents <--> errno 
check is already bogus) and commit them. And I really suggest you to use an 
application like dvbstream which does its own buffering (at least I hope 
so ;) - because it has never happened to me yet that the ringbuffer 
overflowed (and it shouldn't with sane applications).

> Andrea

Christoph

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
