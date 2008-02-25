Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JTlWL-0001ft-0l
	for linux-dvb@linuxtv.org; Mon, 25 Feb 2008 23:10:01 +0100
Message-ID: <47C33CB1.1080502@gmail.com>
Date: Tue, 26 Feb 2008 02:09:53 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Vangelis Nonas <vnonas@otenet.gr>
References: <32245669.2613.1203594791803.JavaMail.tomcat@dali.otenet.gr>	<47C01325.10407@otenet.gr>	<20080223174406.GB30387@moelleritberatung.de>	<47C0803D.2020504@gmail.com>	<20080223212013.GD30387@moelleritberatung.de>	<47C0903B.70606@gmail.com>	<20080223213258.GE30387@moelleritberatung.de>	<20080223214718.GF30387@moelleritberatung.de>	<47C09519.2090904@gmail.com>	<47C09BCC.50403@gmail.com>
	<47C0CADE.6040203@otenet.gr>	<47C0B1F9.1000609@gmail.com>
	<47C1764C.5070103@otenet.gr> <47C1AFC1.7050704@otenet.gr>
	<47C19735.4030601@gmail.com> <47C1D52B.6070906@otenet.gr>
	<47C1C55F.5030406@gmail.com> <47C32947.1030604@otenet.gr>
In-Reply-To: <47C32947.1030604@otenet.gr>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TechniSat SkyStar HD: Problems scaning and zaping
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

Vangelis Nonas wrote:
> Hello,
> 
> I have tested again changesets 7201 and 7205 with verbose 5, 2 and 1 
> scanning 101 transponders on Hotbird (I attach my transponders file -- 
> it is taken and adopted from ProgDvb).
> 
> Here are my statistics:
> 
> Changeset   Verbose  channels
> --------------------------------
> 7201         1        2152
> 7201         2        2105
> 7201         5        2081
> 7205         1        1760
> 7205         2        1608
> 7205         5        1578


Are you "really" sure that 7201 behaves better than others. I ask this, 
since
there was a bug in 7201 which caused many people not to have a LOCK, the
bugs which was fixed in 7203 and 7204. I am at a loss now, as to
understanding this strange phenomena, how a lock was achieved with no
communication to the tuner.

If it were 7200, i could have still believed, there was a possibility, 
but 7201
i am terribly confused.

Can you please verify whether you didn't get mixed up with the changeset
numbers or the logs that were produced ?


Regards,
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
