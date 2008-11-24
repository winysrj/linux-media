Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bane.moelleritberatung.de ([77.37.2.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <artem@makhutov.org>) id 1L4Vc3-00064f-Lo
	for linux-dvb@linuxtv.org; Mon, 24 Nov 2008 08:12:05 +0100
Message-ID: <492A53C4.5030509@makhutov.org>
Date: Mon, 24 Nov 2008 08:12:04 +0100
From: Artem Makhutov <artem@makhutov.org>
MIME-Version: 1.0
To: Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de>
References: <49293640.10808@cadsoft.de>
In-Reply-To: <49293640.10808@cadsoft.de>
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

Hello,

Klaus Schmidinger schrieb:
> The attached patch adds a capability flag that allows an application
> to determine whether a particular device can handle "second generation
> modulation" transponders. This is necessary in order for applications
> to be able to decide which device to use for a given channel in
> a multi device environment, where DVB-S and DVB-S2 devices are mixed.
> 
> It is assumed that a device capable of handling "second generation
> modulation" can implicitly handle "first generation modulation".
> The flag is not named anything with DVBS2 in order to allow its
> use with future DVBT2 devices as well (should they ever come).
> 
> Signed-off by: Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de>

Wouldn't it be better to add something like this:

FE_CAN_8PSK
FE_CAN_16APSK
FE_CAN_32APSK

or

FE_CAN_DVBS2

Instead of FE_CAN_2ND_GEN_MODULATION ? It is too generic for me.

Regards, Artem

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
