Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.152])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <e9hack@googlemail.com>) id 1Jurg7-0003ft-4o
	for linux-dvb@linuxtv.org; Sat, 10 May 2008 18:12:07 +0200
Received: by fg-out-1718.google.com with SMTP id e21so1255808fga.25
	for <linux-dvb@linuxtv.org>; Sat, 10 May 2008 09:12:03 -0700 (PDT)
Message-ID: <4825C950.40103@gmail.com>
Date: Sat, 10 May 2008 18:12:00 +0200
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <482560EB.2000306@gmail.com>
	<200805101717.23199@orion.escape-edv.de>
In-Reply-To: <200805101717.23199@orion.escape-edv.de>
From: e9hack <e9hack@googlemail.com>
Subject: Re: [linux-dvb] [PATCH] Fix the unc for the frontends tda10021 and
 stv0297
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

Oliver Endriss schrieb:
> e9hack wrote:
>> the uncorrected block count is reset on a read request for the tda10021 and stv0297. This 
>> makes the UNC value of the femon plugin useless.
> 
> Why? It does not make sense to accumulate the errors forever, i.e.
> nobody wants to know what happened last year...

The femon plugin from vdr updates its values every half second. If the driver got only a 
few block errors, maybe you will not see the value.

For DVB-C, it's more interesting to see the accumulated unc value. If you see some 
artefacts, maybe they are a result of the DVB-C transmission or they are a result of the 
DVB-S transmission and the cable provider wasn't able to correct all errors or wasn't able 
to remux the stream correctly. In this case, it is useful to see the accumulated count.

-Hartmut

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
