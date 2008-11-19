Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtpd4.aruba.it ([62.149.128.209] helo=smtp5.aruba.it)
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <a.venturi@avalpa.com>) id 1L2q2X-0000Wh-VB
	for linux-dvb@linuxtv.org; Wed, 19 Nov 2008 17:36:32 +0100
Message-ID: <49244E4F.3000901@avalpa.com>
Date: Wed, 19 Nov 2008 18:35:11 +0100
From: Andrea Venturi <a.venturi@avalpa.com>
MIME-Version: 1.0
CC: linux-dvb@linuxtv.org
References: <911565.38943.qm@web38801.mail.mud.yahoo.com>
In-Reply-To: <911565.38943.qm@web38801.mail.mud.yahoo.com>
Subject: Re: [linux-dvb] [PATCH 1/2] Siano's SMS subsystems API - SmsHost
 support
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
> Siano DTV module works with three subsystem API (DVB-API v3, DVB-API v5 (S2) and SmsHost)
>
> Until now, only the DVB-API v3 has been supported.
> The following two patch's parts add the support for the two other APIs.
>
> The first adds the SmsHost API support. This API supports DTV standards yet to be fully supported by the DVB-API (CMMB, T-DMB and more).
>   

hi, as i live in italy under one of the few trials of T-DMB network,  
i'm interested in the T-DMB support.
i happen to own a Cinergy Terratec Piranha based on a SMS 100x chipset 
and under another OS i can lock and see the T-DMB services. i'd like to 
do the same under linux.

is there some public spec about this SmsHost API to hack a simple 
application to dump the TS from a T-DMB network?
google doesn't return with much interesting..

thanx

andrea venturi


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
