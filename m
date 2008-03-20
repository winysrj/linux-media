Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay-pt1.poste.it ([62.241.4.164])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Nicola.Sabbi@poste.it>) id 1JcGf7-0000CA-5H
	for linux-dvb@linuxtv.org; Thu, 20 Mar 2008 10:02:13 +0100
Received: from nico2.od.loc (89.97.249.170) by relay-pt1.poste.it (7.3.122)
	(authenticated as Nicola.Sabbi@poste.it)
	id 47E1B79100003B8B for linux-dvb@linuxtv.org;
	Thu, 20 Mar 2008 10:02:09 +0100
From: Nico Sabbi <Nicola.Sabbi@poste.it>
To: linux-dvb@linuxtv.org
Date: Thu, 20 Mar 2008 10:02:47 +0100
References: <47E226E7.7030601@shikadi.net>
In-Reply-To: <47E226E7.7030601@shikadi.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803201002.47240.Nicola.Sabbi@poste.it>
Subject: Re: [linux-dvb] dvbstream reliability issues?
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

On Thursday 20 March 2008 09:57:11 Adam Nielsen wrote:
> Hi all,
>
> I've recently started using dvbstream (instead of dvbrecord) to
> record shows using cron but I'm finding it to be very unreliable.
>
> Depending on my reception quality, it has a tendency to segfault
> fairly regularly - enough that I wrote a script to reload it after
> a segfault so that I wouldn't miss my recording.  With this set up
> it usually segfaults once every 15 minutes or so, and sometimes as
> often as every 4-5 minutes if the reception isn't so great.
>
> Sometimes it doesn't segfault though, it just stops recording for
> some reason (the output file only grows by a few bytes a minute.) 
> This is worse because it doesn't terminate, so my script isn't able
> to reload it to catch the rest of the recording.
>
> For those people using dvbstream to do their recording, are any of
> you having issues like this?
>
> I'm running CVS from 2008-02-24 and I'm using -prog to record based
> on the program instead of using PIDs (as our broadcasters here seem
> to change their PIDs without warning every couple of months.)
>
> I'm hoping there's some easy fix for this, because I'd rather not
> have to try to get dvbrecord to work again!
>
> Thanks,
> Adam.
>

I use it for hours, even forgetting that it's recording, without 
segfaults.
Try to run it under gdb (after having compiled it with -g) and 
see with "bt" where it segfaults, or bugs can't be fixed

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
