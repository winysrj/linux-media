Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]
	helo=mail.wilsonet.com) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jarod@wilsonet.com>) id 1L2dM4-0007ez-RB
	for linux-dvb@linuxtv.org; Wed, 19 Nov 2008 04:03:50 +0100
Received: from mail.wilsonet.com (chronos.wilsonet.com [127.0.0.1])
	by mail.wilsonet.com (Postfix) with ESMTP id 65A2017B12
	for <linux-dvb@linuxtv.org>; Tue, 18 Nov 2008 22:03:42 -0500 (EST)
Received: from mail.wilsonet.com ([127.0.0.1])
	by mail.wilsonet.com (mail.wilsonet.com [127.0.0.1]) (amavisd-maia,
	port 10024) with ESMTP id 27033-01 for <linux-dvb@linuxtv.org>;
	Tue, 18 Nov 2008 22:03:38 -0500 (EST)
Received: from [172.31.27.12] (static-72-93-233-5.bstnma.fios.verizon.net
	[72.93.233.5])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested) (Authenticated sender: jarod)
	by mail.wilsonet.com (Postfix) with ESMTPSA id B02FF17B11
	for <linux-dvb@linuxtv.org>; Tue, 18 Nov 2008 22:03:38 -0500 (EST)
From: Jarod Wilson <jarod@wilsonet.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <e246419f0811181722i2b614e3aj623f07909e7f7744@mail.gmail.com>
References: <e246419f0811181722i2b614e3aj623f07909e7f7744@mail.gmail.com>
Date: Tue, 18 Nov 2008 22:03:37 -0500
Message-Id: <1227063817.3167.10.camel@icarus.wilsonet.com>
Mime-Version: 1.0
Subject: Re: [linux-dvb] HVR-850 (HVR-950Q?) NTSC Analog Video
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

On Tue, 2008-11-18 at 20:22 -0500, Tom Wambold wrote:
> Hello all:
> 
> I have a Hauppauge HVR-850, and I am trying to get it to work with
> Linux.  I am able to use the au0828 drivers in the 2.6.27 kernel to
> get digital signals from my 850, but I can't seem to find any way to
> get an analog signal.  I have searched all around and could not find a
> solution.  Does anyone have any information on this?
> 
> To clarify, my kernel version is 2.6.27, the HVR-850's USB ID is
> 2040:7240.  I found some links saying that the 850 is similar to the
> 950Q, if so, any information on that might help too.

I believe the HVR-850 is actually a rebadge of the original HVR-950,
which didn't do QAM. The 950Q does QAM and uses a completely different
chipset than the 850.

> I know the hardware supports analog, as the Windows software is able
> to get a signal.

I vaguely recall analog support being missing at one point, dunno if its
been added. Don't know much of anything about it beyond that.

--jarod



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
