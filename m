Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ffm.saftware.de ([83.141.3.46])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <obi@linuxtv.org>) id 1KdYf4-0007wR-8d
	for linux-dvb@linuxtv.org; Thu, 11 Sep 2008 00:59:47 +0200
Received: from localhost (localhost [127.0.0.1])
	by ffm.saftware.de (Postfix) with ESMTP id 0118AE6D9B
	for <linux-dvb@linuxtv.org>; Thu, 11 Sep 2008 00:59:43 +0200 (CEST)
Received: from ffm.saftware.de ([83.141.3.46])
	by localhost (pinky.saftware.org [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 31zxpxwBOYIo for <linux-dvb@linuxtv.org>;
	Thu, 11 Sep 2008 00:59:42 +0200 (CEST)
Received: from [172.22.22.60] (unknown [92.50.81.33])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by ffm.saftware.de (Postfix) with ESMTPSA id 63CD0E6D98
	for <linux-dvb@linuxtv.org>; Thu, 11 Sep 2008 00:59:42 +0200 (CEST)
Message-ID: <48C85153.8010205@linuxtv.org>
Date: Thu, 11 Sep 2008 00:59:31 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <48B8400A.9030409@linuxtv.org>
	<200809101340.09702.hftom@free.fr>	<48C7CDCF.9090300@hauppauge.com>
	<200809101710.19695.hftom@free.fr> <20080910161222.21640@gmx.net>
In-Reply-To: <20080910161222.21640@gmx.net>
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

Hans Werner wrote:
>> So applications could know that these 2 frontends are exclusive.
>> That would not require any API change, but would have to be a rule
>> followed by 
>> all drivers.
> 
> Yes, if we keep to that rule then only frontends which can operate truly
> simultaneously should have a different adapter number.

An adapter refers to a self-contained piece of hardware, whose parts can
not be used by a second adapter (e.g. adapter0/demux0 can not access the
data from adapter1/frontend1). In a commonly used setup it means that
adapter0 is the first initialized PCI card and adapter1 is the second.

Now, if you want a device with two tuners that can be accessed
simultaneously to create a second adapter, then you would have to
artificially divide its components so that it looks like two independant
PCI cards. This might become very complicated and limits the functions
of the hardware.

However, on a setup with multiple accessible tuners you can expect at
least the same amount of accessible demux devices on the same adapter
(and also dvr devices for that matter). There is an ioctl to connect a
frontend to a specific demux (DMX_SET_SOURCE).

So, if there are demux0, frontend0 and frontend1, then the application
knows that it can't use both frontends simultaneously. Otherwise, if
there are demux0, demux1, frontend0 and frontend1, then it can use both
of them (by using both demux devices and connecting them to the
frontends via the ioctl mentioned above).

Regards,
Andreas

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
