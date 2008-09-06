Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1KbwOl-0005jW-KV
	for linux-dvb@linuxtv.org; Sat, 06 Sep 2008 13:56:16 +0200
Message-ID: <48C26FD1.5080404@gmail.com>
Date: Sat, 06 Sep 2008 15:56:01 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Francesco Schiavarelli <kaboom@tiscalinet.it>
References: <48C00822.4030509@gmail.com> <48C01698.4060503@gmail.com>
	<48C01A99.402@gmail.com> <48C174B0.6070409@tiscalinet.it>
In-Reply-To: <48C174B0.6070409@tiscalinet.it>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Multiproto API/Driver Update
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

Francesco Schiavarelli wrote:
> Seeing how hot API discussion got lately I think it's time to write on
> the subject.
> 
> Some time ago a discussion went on multiple TS support in DVB-S2, see:
> 
> http://article.gmane.org/gmane.linux.drivers.dvb/37299


Yes, i do remember.

> I know that is a typical broadcaster application that a "normal" user
> won't benefit so much, but I'd love to see it implemented as I think
> v4l-dvb will gain some professional adoption.
> 
> From a purely technical point of view how hard will be to extend
> multiproto to support such feature?


The data structure is quite simple with regards to S2. We've had some
lab tests only on this feature and not wide spread tests and results. If
someone can provide access to such streams in practical life it would be
quite easy to add it.


> And is S2API ready for the same?
> 

No idea. i guess not.

> I'd like also to see support for non-tuning devices like ASI input
> cards, is it planned?

We've had a discussion on ASI input. Also i do have an ASI patch on my
machine somewhere here. It can be added in to multiproto quite easily.

Regards,
Manu



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
