Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.191])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1JjFaX-0005l8-5U
	for linux-dvb@linuxtv.org; Tue, 08 Apr 2008 17:18:28 +0200
Received: by ti-out-0910.google.com with SMTP id y6so869553tia.13
	for <linux-dvb@linuxtv.org>; Tue, 08 Apr 2008 08:18:12 -0700 (PDT)
Message-ID: <37219a840804080818x729fd503ka3ba048c46169bcb@mail.gmail.com>
Date: Tue, 8 Apr 2008 11:18:10 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Janne Grunau" <janne-dvb@grunau.be>
In-Reply-To: <200804080213.26671.linuxdreas@launchnet.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <200803292240.25719.janne-dvb@grunau.be>
	<200803302017.49799.janne-dvb@grunau.be>
	<200804081030.04745.janne-dvb@grunau.be>
	<200804080213.26671.linuxdreas@launchnet.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Add driver specific module option to choose
	dvb adapter numbers, second try
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

On Tue, Apr 8, 2008 at 5:13 AM, Andreas <linuxdreas@launchnet.com> wrote:
> Am Dienstag, 08. April 2008 01:30:04 schrieb Janne Grunau:
>  > ping.
>
>  pong
>
>
>  > Any interest in this change? Anything speaking against merging this
>  > except the potential duplication of udev functinality?
>
>  Janne, I have no clue at all how a udev rule can be written that reflects
>  the structure of adapter[n]/frontend[n]. And if Google is any indicator,
>  this is either not possible or it is a lost art. Speaking as a user of
>  mythtv & subsequently the linux dvb drivers, I would like to see this patch
>  integrated rather sooner than later.
>
>  Thanks for creating the patch!

I would really like to see this patch get merged.

If nobody has an issue with this, I plan to push this into a mercurial
tree at the end of the week and request that it be merged into the
master branch.

Regards,

Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
