Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ffm.saftware.de ([83.141.3.46])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <obi@linuxtv.org>) id 1Kddhe-0006aW-6V
	for linux-dvb@linuxtv.org; Thu, 11 Sep 2008 06:22:47 +0200
Received: from localhost (localhost [127.0.0.1])
	by ffm.saftware.de (Postfix) with ESMTP id 0B974E6DA0
	for <linux-dvb@linuxtv.org>; Thu, 11 Sep 2008 06:22:43 +0200 (CEST)
Received: from ffm.saftware.de ([83.141.3.46])
	by localhost (pinky.saftware.org [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id CXOJTJxXbJR5 for <linux-dvb@linuxtv.org>;
	Thu, 11 Sep 2008 06:22:42 +0200 (CEST)
Received: from [172.22.22.60] (unknown [92.50.81.33])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by ffm.saftware.de (Postfix) with ESMTPSA id 71264E6D96
	for <linux-dvb@linuxtv.org>; Thu, 11 Sep 2008 06:22:42 +0200 (CEST)
Message-ID: <48C89D12.4060207@linuxtv.org>
Date: Thu, 11 Sep 2008 06:22:42 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <48B8400A.9030409@linuxtv.org>
	<20080910161222.21640@gmx.net>	<48C85153.8010205@linuxtv.org>
	<200809110201.48935.hftom@free.fr> <48C86DBD.6090108@linuxtv.org>
In-Reply-To: <48C86DBD.6090108@linuxtv.org>
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

Steven Toth wrote:
> Christophe Thommeret wrote:
>> Sounds logical. And that's why Kaffeine search for frontend/demux/dvr > 0 and 
>> uses demux1 with frontend1. (That was just a guess since i've never seen 
>> neither any such devices nor comments/recommendations/rules about such case).
>>
>> However, all dual tuners devices drivers i know expose the 2 frontends as 
>> frontend0 in separate adapters. But all these devices seems to be USB.

The way I described is used on dual and quad tuner Dreambox models.

>> The fact that Kaffeine works with the experimental hvr4000 drier indicates 
>> that this driver populates frontend1/demux1/dvr1 and then doesn't follow the 
>> way you describe (since the tuners can't be used at once).
>> I would like to hear from Steve on this point.
>>
>>
> 
> Correct, frontend1, demux1, dvr1 etc. All on the same adapter. The 
> driver and multi-frontend patches manage exclusive access to the single 
> internal resource.

How about dropping demux1 and dvr1 for this adapter, since they don't
create any benefit? IMHO the number of demux devices should always equal
the number of simultaneously usable transport stream inputs.

Regards,
Andreas


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
