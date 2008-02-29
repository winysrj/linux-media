Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JVEK5-0003TQ-1b
	for linux-dvb@linuxtv.org; Sat, 01 Mar 2008 00:07:25 +0100
Message-ID: <47C8901E.9040206@gmail.com>
Date: Sat, 01 Mar 2008 03:07:10 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Seppo Ingalsuo <seppo.ingalsuo@iki.fi>
References: <597595.82940.qm@web33101.mail.mud.yahoo.com>
	<47C8593B.1070802@iki.fi>
In-Reply-To: <47C8593B.1070802@iki.fi>
Cc: linux-dvb@linuxtv.org
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

Seppo Ingalsuo wrote:
> Simeon Simeonov wrote:
>> Did you try changing line 250 in mantis_dvb.c to:
>>                 if (!lnbp21_attach(mantis->fe, &mantis->adapter, LNBP21_PCL, LNBP21_ISEL)) {
>>   
> I tried mantis-a9ecd19a37c9. Without the change success in positioning 
> was about 0% similarly as with multiproto-0448e5a6d8a6. After this 
> change the success in zapping between different satellite positions 
> increased to about 40% so it looks now promising and vdr satellite 
> channels are usable with some patience :^)


You mean the LNBP21 attach line improved things for you by 40% ?

> Is there some kind of soft-diseqc bit timing used with this DVB-S2 card 
> or driver SW (I didn't yet look at the source) or why is the operation 
> so unreliable? I had to use command duplication in vdr-rotor plugin with 
> my old card but with that it was about 100% reliable.

If you can really identify what is "really" unreliable, that itself will 
be a help
to fix the issue, in most cases.

> Which DVB-S2 multiproto driver tree should I follow for latest 
> development for TT S2-3200 (/Skystar HD)?

For the SAA7146 based cards, use the multiproto tree, for the Mantis based
cards, use the mantis tree.

Regards,
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
