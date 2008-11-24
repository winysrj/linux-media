Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from crow.cadsoft.de ([217.86.189.86] helo=raven.cadsoft.de)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Klaus.Schmidinger@cadsoft.de>) id 1L4eH8-0008NM-0f
	for linux-dvb@linuxtv.org; Mon, 24 Nov 2008 17:27:03 +0100
Received: from [192.168.100.10] (hawk.cadsoft.de [192.168.100.10])
	by raven.cadsoft.de (8.14.3/8.14.3) with ESMTP id mAOGQsDj007557
	for <linux-dvb@linuxtv.org>; Mon, 24 Nov 2008 17:26:56 +0100
Message-ID: <492AD5CD.7050107@cadsoft.de>
Date: Mon, 24 Nov 2008 17:26:53 +0100
From: Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <13502.130.36.62.140.1227543276.squirrel@webmail.xs4all.nl>
In-Reply-To: <13502.130.36.62.140.1227543276.squirrel@webmail.xs4all.nl>
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

On 24.11.2008 17:14, Niels Wagenaar wrote:
> Op Ma, 24 november, 2008 16:59, schreef VDR User:
>> If the multiproto method is superior, which it certainly seems to be,
>> why can't that method be adopted into s2api?  It seems silly that this
>> problem hasn't been addressed in the conception of s2api.
>>
> 
> Is multiproto superior? Perhaps on several points it's indeed better or
> more complete. But then again, it was allready 2 years in development so
> it's bound to have additional enhancements which S2API doesn't have atm.
> 
> But then again, we're comparing multiproto with S2API which was build from
> the ground in just little over 3 months. So yeah, it doesn't have it all.
> 
>>From my personal POV. I think S2API isn't missing something concerning
> tuning. The latest VDR 1.7.0 patch (which I made available on 7-10), still
> works in my configuration. And I heard from several others that it works
> for them also. Even after updating the v4l repo to the latest editions. So
> DVB tuning works with S2API.
> 
> So, what we're missing are enhancements! Well, we can add that since it's
> OpenSource and all. So add it allready instead of complaining ;)

Well, I did - but apparently nobody cares... :-(

Klaus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
