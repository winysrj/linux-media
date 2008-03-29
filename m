Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from vitalin.sorra.shikadi.net ([64.71.152.201])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <a.nielsen@shikadi.net>) id 1JfZJH-0000Mo-LR
	for linux-dvb@linuxtv.org; Sat, 29 Mar 2008 12:34:06 +0100
Message-ID: <47EE28F7.8000908@shikadi.net>
Date: Sat, 29 Mar 2008 21:33:11 +1000
From: Adam Nielsen <a.nielsen@shikadi.net>
MIME-Version: 1.0
To: Nico Sabbi <Nicola.Sabbi@poste.it>
References: <47E226E7.7030601@shikadi.net>	<200803210952.01192.Nicola.Sabbi@poste.it>	<200803241935.32389.Nicola.Sabbi@poste.it>
	<200803291025.23607.Nicola.Sabbi@poste.it>
In-Reply-To: <200803291025.23607.Nicola.Sabbi@poste.it>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] dvbstream reliability issues?
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

 > Adam, please report if the version in cvs fixed your problems

Sorry Nico, yes, since testing your update I haven't had a single crash. 
  The card still drops the signal when the reception isn't great and 
dvbstream doesn't realise that has happened, but as far as the crashes 
go the same programmes that used to have 15-20 crashes in them now have 
none!

Many thanks for fixing this!

Cheers,
Adam.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
