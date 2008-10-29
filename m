Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from dyn60-31.dsl.spy.dnainternet.fi ([83.102.60.31]
	helo=shogun.pilppa.org) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lamikr@pilppa.org>) id 1KvIZv-0005aZ-8u
	for linux-dvb@linuxtv.org; Wed, 29 Oct 2008 22:27:47 +0100
Date: Wed, 29 Oct 2008 23:27:35 +0200 (EET)
From: Mika Laitio <lamikr@pilppa.org>
To: Alex Betis <alex.betis@gmail.com>
In-Reply-To: <c74595dc0810291219i520e3e9fv1769374f2e61a6de@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0810292320260.13931@shogun.pilppa.org>
References: <c74595dc0810251452s65154902td934e87560cad9f0@mail.gmail.com>
	<Pine.LNX.4.64.0810291745410.13299@shogun.pilppa.org>
	<c74595dc0810291219i520e3e9fv1769374f2e61a6de@mail.gmail.com>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [ANNOUNCE] scan-s2 is available, please test
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

> I'm not aware of dvb-apps that use S2API, can you point me to that version?

I meant that because S2API drivers are backward compatible and supports 
also the older driver API, the old apps works also with S2API version of 
drivers.

> S2 channels are found with old scan version using mantis driver as well.
> The output of scan-s2 is a bit different to support S2, there are few more
> parameters that will appear in the output such as:
> Sx - used delivery system
> Mx - modulation
> Rx - rolloff
> Cx - FEC rate
>
> Some of those are not yet ready, but I'm adding them right now.
> The frequencies files will be also extended to support those parameters as
> inputs.

Ok. Do you have time to add to README some words listing the 
names and order for all parameters that scan-s2 requires to be in the 
input files. That would be very helpful, when one later try to add 
information from other satellite frequencies to those files.

Mika

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
