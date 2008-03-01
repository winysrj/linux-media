Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from pne-smtpout3-sn1.fre.skanova.net ([81.228.11.120])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <seppo.ingalsuo@iki.fi>) id 1JVW6k-0005xa-HO
	for linux-dvb@linuxtv.org; Sat, 01 Mar 2008 19:06:50 +0100
Received: from kemuli.localdomain (84.250.94.112) by
	pne-smtpout3-sn1.fre.skanova.net (7.3.129)
	id 47A788570016228C for linux-dvb@linuxtv.org;
	Sat, 1 Mar 2008 19:06:16 +0100
Received: from [192.168.1.2] (ident=seppo)
	by kemuli.localdomain with esmtp (Exim 4.68)
	(envelope-from <seppo.ingalsuo@iki.fi>) id 1JVWDz-0001Ss-BB
	for linux-dvb@linuxtv.org; Sat, 01 Mar 2008 20:14:19 +0200
Message-ID: <47C99B16.30005@iki.fi>
Date: Sat, 01 Mar 2008 20:06:14 +0200
From: Seppo Ingalsuo <seppo.ingalsuo@iki.fi>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <597595.82940.qm@web33101.mail.mud.yahoo.com>
	<47C8593B.1070802@iki.fi> <47C8901E.9040206@gmail.com>
In-Reply-To: <47C8901E.9040206@gmail.com>
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

Manu Abraham wrote:
> Seppo Ingalsuo wrote:
>> Simeon Simeonov wrote:
>>> Did you try changing line 250 in mantis_dvb.c to:
>>>                 if (!lnbp21_attach(mantis->fe, &mantis->adapter, 
>>> LNBP21_PCL, LNBP21_ISEL)) {
>>>   
>> I tried mantis-a9ecd19a37c9. Without the change success in 
>> positioning was about 0% similarly as with multiproto-0448e5a6d8a6. 
>> After this change the success in zapping between different satellite 
>> positions increased to about 40% so it looks now promising and vdr 
>> satellite channels are usable with some patience :^)
>
>
> You mean the LNBP21 attach line improved things for you by 40% ?
Yes, the LNBP21_PCL and LNBP21_ISEL additions did the improvement. By 
40% I mean that about 4/10 zappings between channels in different 
satellite positions are succesfull. Without this change it was very rare 
to get the dish to move, the success rate was < 1/10.

> If you can really identify what is "really" unreliable, that itself 
> will be a help
> to fix the issue, in most cases.
Compared to my old DVB-S card this DVB-S2 card is too unreliable for my 
family to use it. There is one possible issue with vdr rotor plugin. It 
would help in my case if it would set always high LNB voltage before 
sending gotox command and keep it for estimated time of movent (based on 
about 0.9 seconds/degree speed) before setting the voltage for the tuned 
channel. The motor movement with low LNB voltage is very slow especially 
in winter and I'm not absolutely sure that the failure is due to 
corrupted diseqc gotox command or just too low voltage to get the motor 
running. The old DVB-S card was also driving the dish at slow speed with 
low LNB voltage but I need to hack the rotor code to rule out this 
theory. I need to check also the LNB cable that connects to the PC that 
it is still OK.

>
>> Which DVB-S2 multiproto driver tree should I follow for latest 
>> development for TT S2-3200 (/Skystar HD)?
>
> For the SAA7146 based cards, use the multiproto tree, for the Mantis 
> based
> cards, use the mantis tree.
OK, thanks. It seems there is now 10min fresh new code to try!

BR,
Seppo


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
