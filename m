Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ey-out-2122.google.com ([74.125.78.26])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <freebeer.bouwsma@gmail.com>) id 1LHdso-0006qn-OZ
	for linux-dvb@linuxtv.org; Tue, 30 Dec 2008 13:39:39 +0100
Received: by ey-out-2122.google.com with SMTP id 25so530876eya.17
	for <linux-dvb@linuxtv.org>; Tue, 30 Dec 2008 04:39:35 -0800 (PST)
Date: Tue, 30 Dec 2008 13:39:31 +0100 (CET)
From: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
To: Dmitry Podyachev <vdp@teletec.com.ua>
In-Reply-To: <495A0E46.6030903@teletec.com.ua>
Message-ID: <alpine.DEB.2.00.0812301329490.29535@ybpnyubfg.ybpnyqbznva>
References: <mailman.1.1230548402.10016.linux-dvb@linuxtv.org>
	<495A0E46.6030903@teletec.com.ua>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] dvb-t config for Ukraine_Kiev (ua)
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

On Tue, 30 Dec 2008, Dmitry Podyachev wrote:

> #T freq     bw   fec_hi fec_lo  mod     transmission-mode guard-interval 
> hierarchy
> T 634000000 8MHz AUTO   NONE    QAM64   8k                AUTO          NONE
> T 650000000 8MHz AUTO   NONE    QAM64   8k                AUTO          NONE
> T 714000000 8MHz AUTO   NONE    QAM64   8k                AUTO          NONE
> T 818000000 8MHz AUTO   NONE    QAM64   8k                AUTO          NONE

I think the following parameters can be used in place of
`AUTO' for all the above...
FEC 2/3
Guard Interval 1/32

Can you verify this by parsing the NIT info on PID 16
(PID 0x10) on all frequencies?  This matches the results
from 650MHz below...

Particularly as I read that there's apparently a SFN,
making me wonder about the guard interval...

thanks

> MEGASPORT:650000000:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_2_3:FEC_2_3:QAM_64:TRANSMISSION_MODE_8K:GUARD_INTERVAL_1_32:HIERARCHY_NONE:4321:4322:2

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
