Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from crow.cadsoft.de ([217.86.189.86] helo=raven.cadsoft.de)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Klaus.Schmidinger@cadsoft.de>) id 1L4eFr-0007s8-Gr
	for linux-dvb@linuxtv.org; Mon, 24 Nov 2008 17:25:44 +0100
Received: from [192.168.100.10] (hawk.cadsoft.de [192.168.100.10])
	by raven.cadsoft.de (8.14.3/8.14.3) with ESMTP id mAOGPdn6007369
	for <linux-dvb@linuxtv.org>; Mon, 24 Nov 2008 17:25:39 +0100
Message-ID: <492AD583.4040809@cadsoft.de>
Date: Mon, 24 Nov 2008 17:25:39 +0100
From: Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <13077.130.36.62.140.1227542142.squirrel@webmail.xs4all.nl>
In-Reply-To: <13077.130.36.62.140.1227542142.squirrel@webmail.xs4all.nl>
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

On 24.11.2008 16:55, Niels Wagenaar wrote:
> ...
> For the time being I have only two options which will work without any
> additional patching in S2API:
> 
> - Let the user set this as an option
> - Use my VUP (very ugly patch) by checking the deliverystem for the string
> "DVBS2".

Both are ugly workarounds and any reasonable API requiring them instead
of simply reporting the -S2 capability of a device should
be ashamed, go home and do its homework.

For the time being I'll work with my suggested FE_CAN_2ND_GEN_MODULATION
patch - until somebody can suggest a different way of doing this (without
parsing strings or requiring the user to do it).

Klaus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
