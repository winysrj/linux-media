Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from pne-smtpout4-sn1.fre.skanova.net ([81.228.11.168])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <seppo.ingalsuo@iki.fi>) id 1JVAfl-0002y6-MC
	for linux-dvb@linuxtv.org; Fri, 29 Feb 2008 20:13:33 +0100
Received: from kemuli.localdomain (84.250.94.112) by
	pne-smtpout4-sn1.fre.skanova.net (7.3.129)
	id 47A7970A0015ED75 for linux-dvb@linuxtv.org;
	Fri, 29 Feb 2008 20:13:00 +0100
Received: from [192.168.1.2] (ident=seppo)
	by kemuli.localdomain with esmtp (Exim 4.68)
	(envelope-from <seppo.ingalsuo@iki.fi>) id 1JVAmr-00077B-2G
	for linux-dvb@linuxtv.org; Fri, 29 Feb 2008 21:20:53 +0200
Message-ID: <47C8593B.1070802@iki.fi>
Date: Fri, 29 Feb 2008 21:12:59 +0200
From: Seppo Ingalsuo <seppo.ingalsuo@iki.fi>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <597595.82940.qm@web33101.mail.mud.yahoo.com>
In-Reply-To: <597595.82940.qm@web33101.mail.mud.yahoo.com>
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

Simeon Simeonov wrote:
>
> Did you try changing line 250 in mantis_dvb.c to:
>                 if (!lnbp21_attach(mantis->fe, &mantis->adapter, LNBP21_PCL, LNBP21_ISEL)) {
>   
I tried mantis-a9ecd19a37c9. Without the change success in positioning 
was about 0% similarly as with multiproto-0448e5a6d8a6. After this 
change the success in zapping between different satellite positions 
increased to about 40% so it looks now promising and vdr satellite 
channels are usable with some patience :^)

Is there some kind of soft-diseqc bit timing used with this DVB-S2 card 
or driver SW (I didn't yet look at the source) or why is the operation 
so unreliable? I had to use command duplication in vdr-rotor plugin with 
my old card but with that it was about 100% reliable.

Which DVB-S2 multiproto driver tree should I follow for latest 
development for TT S2-3200 (/Skystar HD)?

Cheers,
Seppo



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
