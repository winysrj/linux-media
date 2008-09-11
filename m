Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ffm.saftware.de ([83.141.3.46])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <obi@linuxtv.org>) id 1Kdnl0-0003vj-5g
	for linux-dvb@linuxtv.org; Thu, 11 Sep 2008 17:06:55 +0200
Received: from localhost (localhost [127.0.0.1])
	by ffm.saftware.de (Postfix) with ESMTP id D510CE6E1D
	for <linux-dvb@linuxtv.org>; Thu, 11 Sep 2008 17:06:50 +0200 (CEST)
Received: from ffm.saftware.de ([83.141.3.46])
	by localhost (pinky.saftware.org [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id aIhYRmf8wxnY for <linux-dvb@linuxtv.org>;
	Thu, 11 Sep 2008 17:06:50 +0200 (CEST)
Received: from [172.22.22.60] (unknown [92.50.81.33])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by ffm.saftware.de (Postfix) with ESMTPSA id 4F830E6DF7
	for <linux-dvb@linuxtv.org>; Thu, 11 Sep 2008 17:06:50 +0200 (CEST)
Message-ID: <48C9340A.4030901@linuxtv.org>
Date: Thu, 11 Sep 2008 17:06:50 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <570512.55545.qm@web46113.mail.sp1.yahoo.com>
In-Reply-To: <570512.55545.qm@web46113.mail.sp1.yahoo.com>
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

barry bouwsma wrote:
> --- On Thu, 9/11/08, Andreas Oberritter <obi@linuxtv.org> wrote:
> 
>> How about dropping demux1 and dvr1 for this adapter, since they don't
>> create any benefit? IMHO the number of demux devices should always equal
>> the number of simultaneously usable transport stream inputs.
> 
> I like this `solution', but I'm not sure it is optimal...
> 
> Sure, it works for 2x devices, where only one at a time can be
> used, but if one has a hypothetical DVB-S(2) + DVB-C/T device,
> with two RF inputs, so that one could simultaneously use sat
> and one of cable/terrestrial, you'd get two demux devices, and
> three frontends, and you'd need to map the exclusivity of the
> cable/terrestrial frontend somehow.

That's indeed a case where you can not easily determine how many inputs
can be handled at the same time. This might require another enhancement
of the userland API. Until then, for such a small number of frontends,
an application could simply try out which combination of frontends can
be used at the same time (either open() or DMX_SET_SOURCE would fail if
you try to use the mentioned -C and -T at the same time).

Regards,
Andreas

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
