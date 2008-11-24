Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ik-out-1112.google.com ([66.249.90.181])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <user.vdr@gmail.com>) id 1L4edb-0002aj-PZ
	for linux-dvb@linuxtv.org; Mon, 24 Nov 2008 17:50:16 +0100
Received: by ik-out-1112.google.com with SMTP id c28so1876763ika.1
	for <linux-dvb@linuxtv.org>; Mon, 24 Nov 2008 08:50:12 -0800 (PST)
Message-ID: <a3ef07920811240850sc41725as9256a7e23ab8c509@mail.gmail.com>
Date: Mon, 24 Nov 2008 08:50:12 -0800
From: "VDR User" <user.vdr@gmail.com>
To: n.wagenaar@xs4all.nl
In-Reply-To: <13502.130.36.62.140.1227543276.squirrel@webmail.xs4all.nl>
MIME-Version: 1.0
Content-Disposition: inline
References: <13502.130.36.62.140.1227543276.squirrel@webmail.xs4all.nl>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Add missing S2 caps flag to S2API
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

On Mon, Nov 24, 2008 at 8:14 AM, Niels Wagenaar <n.wagenaar@xs4all.nl> wrote:
> Op Ma, 24 november, 2008 16:59, schreef VDR User:
>> If the multiproto method is superior, which it certainly seems to be,
>> why can't that method be adopted into s2api?  It seems silly that this
>> problem hasn't been addressed in the conception of s2api.
>
> Is multiproto superior? Perhaps on several points it's indeed better or
> more complete. But then again, it was allready 2 years in development so
> it's bound to have additional enhancements which S2API doesn't have atm.
>
> But then again, we're comparing multiproto with S2API which was build from
> the ground in just little over 3 months. So yeah, it doesn't have it all.

I was talking about the multiproto method of reporting the cards
capabilities, not the entire api.  There's no need to go on about the
history of multiproto & s2api so please don't turn this thread into
"one of those".  There's one big problem that needs to be addressed
and the less people get OT, the faster it might be resolved.

> From my personal POV. I think S2API isn't missing something concerning
> tuning.

You don't think an api's ability to correctly report a cards
capabilities is a big deal?  It's a very basic & fundamental feature!!
 I guess we will have to agree to disagree.  ;)

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
