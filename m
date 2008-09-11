Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ffm.saftware.de ([83.141.3.46])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <obi@linuxtv.org>) id 1Kdnu4-0004qK-DQ
	for linux-dvb@linuxtv.org; Thu, 11 Sep 2008 17:16:16 +0200
Received: from localhost (localhost [127.0.0.1])
	by ffm.saftware.de (Postfix) with ESMTP id 4C6B1E6E2B
	for <linux-dvb@linuxtv.org>; Thu, 11 Sep 2008 17:16:13 +0200 (CEST)
Received: from ffm.saftware.de ([83.141.3.46])
	by localhost (pinky.saftware.org [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id d3Lm3TaAUOHC for <linux-dvb@linuxtv.org>;
	Thu, 11 Sep 2008 17:16:12 +0200 (CEST)
Received: from [172.22.22.60] (unknown [92.50.81.33])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by ffm.saftware.de (Postfix) with ESMTPSA id E7CC9E6E1D
	for <linux-dvb@linuxtv.org>; Thu, 11 Sep 2008 17:16:12 +0200 (CEST)
Message-ID: <48C9363C.6070801@linuxtv.org>
Date: Thu, 11 Sep 2008 17:16:12 +0200
From: Andreas Oberritter <obi@linuxtv.org>
MIME-Version: 1.0
CC: linux-dvb@linuxtv.org
References: <200809111621.44365.hftom@free.fr>
In-Reply-To: <200809111621.44365.hftom@free.fr>
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

Christophe Thommeret wrote:
> Uri Shkolnik said:
> "Some of the hardware devices which using our chipset have two tuners per 
> instance, and should expose 1-2 tuners with 0-2 demux (TS), since not all DTV 
> standard are TS based, and when they are (TS based), it depends when you are 
> using two given tuners together (diversity  mode, same content) or each one 
> is used separately (different frequency and modulation, different content, 
> etc.)."
> 
> 
> 
> So, here are my questions:
> 
> @Steven Toth:
> What do you think of Andreas' suggestion? Do you think it could be done that 
> way for HVR4000 (and 3000?) ?
> 
> @Uri Shkolnik:
> Do you mean that non-TS based standards don't make use of multiplexing at all?
> 

I guess diversity mode should be transparent to the user, so such a
device would register only one frontend (and thus only one demux) per
set of tuners used in diversity mode.

While your statements about non-TS based standards make sense, those
standards would require further work to be covered by a future API. In
this special case, however, we're discussing correct usage of the
current (TS based) demux API.

Regards,
Andreas

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
