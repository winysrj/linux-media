Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.159])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1KSbdv-0003Ft-RF
	for linux-dvb@linuxtv.org; Mon, 11 Aug 2008 19:57:22 +0200
Received: by fg-out-1718.google.com with SMTP id e21so1047876fga.25
	for <linux-dvb@linuxtv.org>; Mon, 11 Aug 2008 10:57:16 -0700 (PDT)
Message-ID: <37219a840808111057w5945ecc6wd200c624168a196a@mail.gmail.com>
Date: Mon, 11 Aug 2008 13:57:16 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: mark.paulus@verizonbusiness.com
In-Reply-To: <48A05F58.8090405@verizonbusiness.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <48A05F58.8090405@verizonbusiness.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [Fwd: Help with recent DVB/QAM problem please.]
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

2008/8/11 Mark Paulus <mark.paulus@verizonbusiness.com>:
> Redirecting to linux-dvb on suggestion from
> Video4Linux user.
>
> -------- Original Message --------
> Subject: Help with recent DVB/QAM problem please.
>
> Hi all,
>
> Background:
> I have a machine in my basement with:
> Hauppauge PVR-150 (connected to DCT2524)
> Air2PC ATSC/OTA card (connected to antenna in attic)
> Avermedia A180 (connected to comcast cable)
> Dvico FusionHDTV RT 5 Lite (connectec comcast cable)
> Debian using 2.6.24-x64 kernel
>
> Situation:
> Up until a week ago, I was able to use azap to tune in
> a bunch of mplexids, and get good locks on both the A180 and the Dvico card.
>  However, starting on Monday,
> I am not able to get locks on either of my DVB cards.
> I have been able, and am still able to get good locks
> on my air2pc OTA card.
>
> Can anyone help me figure out why I can't seem to see
> anything from my 2 QAM cards?  I've tried running a
> dvbscan and neither card can make a good lock.  What
> other debugging tools can I use to try to find any QAM
> signals?  I've also tried doing a VSB-8 scan on the cable
> cards, and also don't get any locks.

Mark,

It's good that you've moved the thread to the correct mailing list.
However, I did already answer you and asked you some questions, to
which you have not yet responded....

Quoting myself:

What variables have changed in your test environment since last Monday?

If the answer is "nothing" , then the problem is more than likely due
to your cable company moving services around.

First, you should confirm that you still have clear QAM available...
assuming yes, then I recommend scanning for channels again, using each card.

Regards,

Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
