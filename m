Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web33101.mail.mud.yahoo.com ([209.191.69.131])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <simeonov_2000@yahoo.com>) id 1JUyqb-0008Vx-RY
	for linux-dvb@linuxtv.org; Fri, 29 Feb 2008 07:35:58 +0100
Date: Thu, 28 Feb 2008 22:35:23 -0800 (PST)
From: Simeon Simeonov <simeonov_2000@yahoo.com>
To: Seppo Ingalsuo <seppo.ingalsuo@iki.fi>, linux-dvb@linuxtv.org
MIME-Version: 1.0
Message-ID: <597595.82940.qm@web33101.mail.mud.yahoo.com>
Subject: Re: [linux-dvb] STB0899 users,
	please verify results was Re: TechniSat SkyStar HD: Problems
	scaning and zaping
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

> ... But diseqc positioner commands (GotoX from vdr rotor plugin) seem to 
> not get through with 100% reliability. Changing to use diseqc.conf 
> seemed to help a bit but I haven't been able to convince the motor to 
> turn to 28.2E at all.

Did you try changing line 250 in mantis_dvb.c to:
                if (!lnbp21_attach(mantis->fe, &mantis->adapter, LNBP21_PCL, LNBP21_ISEL)) {





      ____________________________________________________________________________________
Never miss a thing.  Make Yahoo your home page. 
http://www.yahoo.com/r/hs

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
