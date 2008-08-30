Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KZSAG-0007mq-MD
	for linux-dvb@linuxtv.org; Sat, 30 Aug 2008 17:15:01 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta5.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K6F00AHQ6C2AY30@mta5.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Sat, 30 Aug 2008 11:14:26 -0400 (EDT)
Date: Sat, 30 Aug 2008 11:14:25 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <20080830150844.GQ7830@moelleritberatung.de>
To: Artem Makhutov <artem@makhutov.org>
Message-id: <48B963D1.3060908@linuxtv.org>
MIME-version: 1.0
References: <48B8400A.9030409@linuxtv.org>
	<20080830150844.GQ7830@moelleritberatung.de>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] DVB-S2 / Multiproto and future modulation support
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

Artem Makhutov wrote:
> Hi,
> 
> On Fri, Aug 29, 2008 at 02:29:30PM -0400, Steven Toth wrote:
>> Regarding the multiproto situation:
>>
>> A number of developers, maintainers and users are unhappy with the
>> multiproto situation, actually they've been unhappy for a considerable
>> amount of time. The linuxtv developer community (to some degree) is seen
>> as a joke and a bunch in-fighting people. Multiproto is a great
>> demonstration of this. [1] The multiproto project has gone too far, for
>> too long and no longer has any credibility in the eyes of many people.
> 
> Can you please explain me what you do not like in multiproto?


1. Where is the support for ISDB-T/ATSC-MH/CMMB/DVB-H/DBM-T/H and other 
modulation types. If we're going to make a massive kernel change then 
why aren't we accommodating these new modulation types? If we don't 
added now then we'll have the rev the kernel ABI again in 2 months.... 
that isn't a forward looking future proof API.

2. It's too big, too risky, too late. It doesn't add enough new fatures 
to the kernel to justify the massive code change.

Thanks your for your feedback.

Regards,

Steve



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
