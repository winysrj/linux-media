Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ffm.saftware.de ([83.141.3.46])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <obi@linuxtv.org>) id 1Kdrxu-0000fz-9F
	for linux-dvb@linuxtv.org; Thu, 11 Sep 2008 21:36:32 +0200
Received: from localhost (localhost [127.0.0.1])
	by ffm.saftware.de (Postfix) with ESMTP id 1153BE6E16
	for <linux-dvb@linuxtv.org>; Thu, 11 Sep 2008 21:36:27 +0200 (CEST)
Received: from ffm.saftware.de ([83.141.3.46])
	by localhost (pinky.saftware.org [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id xjNV0dqeqyS7 for <linux-dvb@linuxtv.org>;
	Thu, 11 Sep 2008 21:36:26 +0200 (CEST)
Received: from [172.22.22.60] (unknown [92.50.81.33])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by ffm.saftware.de (Postfix) with ESMTPSA id 2B634E6E10
	for <linux-dvb@linuxtv.org>; Thu, 11 Sep 2008 21:36:26 +0200 (CEST)
Message-ID: <48C9733A.2000209@linuxtv.org>
Date: Thu, 11 Sep 2008 21:36:26 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <708306.32642.qm@web38802.mail.mud.yahoo.com>
In-Reply-To: <708306.32642.qm@web38802.mail.mud.yahoo.com>
Subject: Re: [linux-dvb] Multiple frontends on a single adapter support
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

Uri Shkolnik wrote:
>> From: Andreas Oberritter <obi@linuxtv.org>
>> While your statements about non-TS based standards make
>> sense, those
>> standards would require further work to be covered by a
>> future API. In
>> this special case, however, we're discussing correct
>> usage of the
>> current (TS based) demux API.
> 
> Regarding the diversity mode - Need to be kept flexible, a device can switch mode (between using a given set of tuners as input for single content or use each tuner for different content)
> 
> Regarding Non-TS - I must disagree, there are several posts on this ML that contradict your assumptions, and (much) more important, CMMB after two months of service has much bigger deployment than DVB-H, DVB-T2 and DVB-S2 putting together. T-DMB (DAB) also has much bigger audience.

Maybe my phrasing was unclear. "Future API" shall mean any API not
covered by  Linux 2.6 _now_. I.e. "future API" is any of S2API or
multiproto or whatever extension will eventually be merged into the
upstream kernel in the future.

What we are discussing here is an implementation detail for a driver
using the _current_ API (unless someone thinks that the API needs to be
changed to support the two tuners of the HVR4000).

Please keep your suggestions for yet unimplemented transmission methods
in a seperate thread.

Regards,
Andreas


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
