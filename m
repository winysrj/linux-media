Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from webmail-outgoing.us4.outblaze.com ([205.158.62.67])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stev391@email.com>) id 1KcRir-0000y5-KP
	for linux-dvb@linuxtv.org; Sun, 07 Sep 2008 23:23:07 +0200
Received: from wfilter3.us4.outblaze.com.int (wfilter3.us4.outblaze.com.int
	[192.168.8.242])
	by webmail-outgoing.us4.outblaze.com (Postfix) with QMQP id
	BDE7C1800134
	for <linux-dvb@linuxtv.org>; Sun,  7 Sep 2008 21:22:30 +0000 (GMT)
Content-Disposition: inline
MIME-Version: 1.0
From: stev391@email.com
To: jackden <jackden@gmail.com>
Date: Mon, 8 Sep 2008 07:22:30 +1000
Message-Id: <20080907212230.7CF0747808F@ws1-5.us4.outblaze.com>
Cc: linux dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [PATCH] XC3028, fix firmware loading for D2620 DTV6
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


> ----- Original Message -----
> From: jackden <jackden@gmail.com>
> To: stev391@email.com
> Subject: Re: [PATCH] XC3028, fix firmware loading for D2620 DTV6
> Date: Mon, 8 Sep 2008 00:11:43 +0800
> 
> 
> 2008/9/7  <stev391@email.com>:
> > The attached patch resolves an issue (in tuner xc2028.c) where the seek firmware is required to
> > find the correct firmware for D2620 DTV6, as there is only one solution for this firmware 
> > (D2620
> > DTV6 QAM) search through all firmwares as a last attempt to find out if there is only one match
> > and try it. This bug was noticed while testing a Compro VideoMate E650 in Tapei using tw-Taipei
> > as the dvb-t scan file.
> >
> > Signed-off-by: Stephen Backway <stev391@email.com>
> >
> > Regards,
> >
> > Stephen.
> >
> >
> > --
> > Be Yourself @ mail.com!
> > Choose From 200+ Email Addresses
> > Get a Free Account at www.mail.com
> >
> >
> Stephen,
>     I used the patch. No error message form scan channel's output.
> 
---Snip---
> --
> 
> But, have ERROR message when I use scan command. ->"ERROR: initial
> tuning failed"
> 
> command:
> scan /usr/share/doc/dvb-utils/examples/scan/dvb-t/tw-taipei
> 
---Snip---
> 
> --
> ----=Jackden in Google=----
> --=Jackden@Gmail.com=--

Jackden,

Which version of my Compro VideoMate Exxx drivers did you try?  V0.1 is most likely to get it to work.
However I would like you to try each of them and see what happens.  If the above was provided using the initial version or V0.2 then this is what I would expect.  (v0.2 intentionally broke the driver to confirm that all parts in V0.1 were required).

Also please cc the linux-dvb mailing list when replying to my emails, that is if they are related to the list.

Regards,
Stephen.


-- 
Be Yourself @ mail.com!
Choose From 200+ Email Addresses
Get a Free Account at www.mail.com


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
