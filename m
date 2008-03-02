Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from pne-smtpout4-sn1.fre.skanova.net ([81.228.11.168])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <seppo.ingalsuo@iki.fi>) id 1JVvYv-00029b-FO
	for linux-dvb@linuxtv.org; Sun, 02 Mar 2008 22:17:38 +0100
Received: from kemuli.localdomain (84.250.94.112) by
	pne-smtpout4-sn1.fre.skanova.net (7.3.129)
	id 47A7970A0016DA34 for linux-dvb@linuxtv.org;
	Sun, 2 Mar 2008 22:17:03 +0100
Received: from [192.168.1.2] (ident=seppo)
	by kemuli.localdomain with esmtp (Exim 4.68)
	(envelope-from <seppo.ingalsuo@iki.fi>) id 1JVvgM-0004lG-LL
	for linux-dvb@linuxtv.org; Sun, 02 Mar 2008 23:25:18 +0200
Message-ID: <47CB194E.50600@iki.fi>
Date: Sun, 02 Mar 2008 23:17:02 +0200
From: Seppo Ingalsuo <seppo.ingalsuo@iki.fi>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <597595.82940.qm@web33101.mail.mud.yahoo.com>	<47C8593B.1070802@iki.fi>
	<47C8901E.9040206@gmail.com> <47C99B16.30005@iki.fi>
In-Reply-To: <47C99B16.30005@iki.fi>
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
> Manu Abraham wrote:
>   
>> Seppo Ingalsuo wrote:
>>     
>>> Simeon Simeonov wrote:
>>>       
>>>> Did you try changing line 250 in mantis_dvb.c to:
>>>>                 if (!lnbp21_attach(mantis->fe, &mantis->adapter, 
>>>> LNBP21_PCL, LNBP21_ISEL)) {
>>>>   
>>>>         
>>> I tried mantis-a9ecd19a37c9. Without the change success in 
>>> positioning was about 0% similarly as with multiproto-0448e5a6d8a6. 
>>> After this change the success in zapping between different satellite 
>>> positions increased to about 40% so it looks now promising and vdr 
>>> satellite channels are usable with some patience :^)
>>>       
>> You mean the LNBP21 attach line improved things for you by 40% ?
>>     
Now I've run original multiproto-8db34ae061ed driver for a day. It 
achives about similar success (my guess 40%) in driving my positioner 
motor as the edited mantis tree driver. As far as I understand the code 
the lnbp21_attach in ttpci/budget-ci.c is different from Simeon's 
proposed attach command for mantis. => I hope my comments are not 
confusing the development.

Excluding driving/commanding the motor, the current multiproto driver 
works well in DVB-S/DVB-S2 (and 2xDVB-T)  zapping.

BR,
Seppo


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
