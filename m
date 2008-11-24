Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1L4hBh-0005GG-LT
	for linux-dvb@linuxtv.org; Mon, 24 Nov 2008 20:33:38 +0100
Message-ID: <492B0182.2030602@gmail.com>
Date: Mon, 24 Nov 2008 23:33:22 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de>
References: <13077.130.36.62.140.1227542142.squirrel@webmail.xs4all.nl>
	<492AD583.4040809@cadsoft.de>
In-Reply-To: <492AD583.4040809@cadsoft.de>
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

Klaus Schmidinger wrote:
> On 24.11.2008 16:55, Niels Wagenaar wrote:
>> ...
>> For the time being I have only two options which will work without any
>> additional patching in S2API:
>>
>> - Let the user set this as an option
>> - Use my VUP (very ugly patch) by checking the deliverystem for the string
>> "DVBS2".
> 
> Both are ugly workarounds and any reasonable API requiring them instead
> of simply reporting the -S2 capability of a device should
> be ashamed, go home and do its homework.

ACK

> For the time being I'll work with my suggested FE_CAN_2ND_GEN_MODULATION
> patch - until somebody can suggest a different way of doing this (without
> parsing strings or requiring the user to do it).

ACK.

That is a saner way of doing it rather than anything else, as it stands.

Anyway, we won't be seeing professional device support as it stands with
the current API anytime soon, so as it stands the better alternative is
thus.

But it would be nice to have something shorter: say FE_IS_2G or
something that way, for the minimal typing.


Regards,
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
