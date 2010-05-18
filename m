Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1OENkF-0002ZH-Bi
	for linux-dvb@linuxtv.org; Tue, 18 May 2010 16:26:07 +0200
Received: from ey-out-2122.google.com ([74.125.78.24])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-d) with esmtp
	for <linux-dvb@linuxtv.org>
	id 1OENkC-0001Gb-0W; Tue, 18 May 2010 16:26:06 +0200
Received: by ey-out-2122.google.com with SMTP id d26so501071eyd.39
	for <linux-dvb@linuxtv.org>; Tue, 18 May 2010 07:26:02 -0700 (PDT)
Date: Tue, 18 May 2010 16:25:56 +0200 (CEST)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: matpic <matpic@free.fr>
In-Reply-To: <4BF290A2.1020904@free.fr>
Message-ID: <alpine.DEB.2.01.1005181606440.29367@ureoreg>
References: <4BF290A2.1020904@free.fr>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] new DVB-T initial tuning for fr-nantes
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
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

On wto (wtorek) 18.maj (maj) 2010, 15:05:00, matpic wrote:

Salut!

> hello
> As from today (18/05/2010) there is new frequency since analogic signal
> is stopped and is now only numeric.
> guard-interval has to be set to AUTO or scan find anything
>  (1/32, 1/16, 1/8 ,1/4 doesn't work)

I do not have the CSA data at hand, but I understand that
presently use is made of single transmitter sites, in a MFN
(Multi-Frequency Network) and thus a guard interval of 1/32 should
be correct.

(I understand though that some filler transmitters may be in
planning so that a small SFN may be put in service, but I am
not clear as to these details...  I must research this.)


> #same frequency + offset 167000000 for some hardware DVB-T tuner

It was my understanding that the different offsets above or
below the nominal centre frequency is a result of mixed digital
and legacy analogue services co-broadcasting, in order to avoid
interference with adjacent channels.

So I am wondering whether, in the absence of local analogue
services, this offset is no longer employed?

I am afraid that I am not following the conversion to TNT so
closely to know if a whole geographic region, in this case the
Loire, is having the remaining analogue services shut down all
at once, or if it is being done on a site-by-site basis, with
the potential for interference to a more remote but still
operational analogue transmitter.

In any case, all but one of the new frequencies appear to be
very different from the ones previously used before today.


Merci, for reporting this change!

barry bouwsma

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
