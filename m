Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <n.wagenaar@xs4all.nl>) id 1L4e5A-0006ui-8I
	for linux-dvb@linuxtv.org; Mon, 24 Nov 2008 17:14:41 +0100
Received: from webmail.xs4all.nl (dovemail11.xs4all.nl [194.109.26.13])
	by smtp-vbr16.xs4all.nl (8.13.8/8.13.8) with ESMTP id mAOGEbKX022003
	for <linux-dvb@linuxtv.org>; Mon, 24 Nov 2008 17:14:37 +0100 (CET)
	(envelope-from n.wagenaar@xs4all.nl)
Message-ID: <13502.130.36.62.140.1227543276.squirrel@webmail.xs4all.nl>
Date: Mon, 24 Nov 2008 17:14:36 +0100 (CET)
From: "Niels Wagenaar" <n.wagenaar@xs4all.nl>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: Re: [linux-dvb] [PATCH] Add missing S2 caps flag to S2API
Reply-To: n.wagenaar@xs4all.nl
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

Op Ma, 24 november, 2008 16:59, schreef VDR User:
> If the multiproto method is superior, which it certainly seems to be,
> why can't that method be adopted into s2api?  It seems silly that this
> problem hasn't been addressed in the conception of s2api.
>

Is multiproto superior? Perhaps on several points it's indeed better or
more complete. But then again, it was allready 2 years in development so
it's bound to have additional enhancements which S2API doesn't have atm.

But then again, we're comparing multiproto with S2API which was build from
the ground in just little over 3 months. So yeah, it doesn't have it all.

>From my personal POV. I think S2API isn't missing something concerning
tuning. The latest VDR 1.7.0 patch (which I made available on 7-10), still
works in my configuration. And I heard from several others that it works
for them also. Even after updating the v4l repo to the latest editions. So
DVB tuning works with S2API.

So, what we're missing are enhancements! Well, we can add that since it's
OpenSource and all. So add it allready instead of complaining ;)

Regards,

Niels Wagenaar




_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
