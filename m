Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from quechua.inka.de ([193.197.184.2] helo=mail.inka.de ident=mail)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <olaf@bigred.inka.de>) id 1JV2F9-0001ZP-RY
	for linux-dvb@linuxtv.org; Fri, 29 Feb 2008 11:13:31 +0100
To: linux-dvb@linuxtv.org
References: <1204233917.22520.12.camel@youkaida>
Cc: 
From: Olaf Titz <olaf@bigred.inka.de>
Date: Fri, 29 Feb 2008 11:13:21 +0100
Message-ID: <E1JV2Ez-00029k-VX@bigred.inka.de>
Subject: Re: [linux-dvb] [OT] UHF masthead amp power supply location
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

> http://www.youplala.net/~will/htpc/Satellite/masthead_amp-where.png

Option A is not possible, because the LNB is powered by the tuner too.
You can't have two power supplies in parallel on the same wire.

(The only solution would be to draw the power for the amp from the LNB
supply too, so you would need a suitable combiner and perhaps a
suitable amp which runs on 13-17V [AC or DC?], and you would need a
sat tuner which can deliver enough power for LNB plus amp, and never
turn it off. Unlikely that such components exist.)

Olaf

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
