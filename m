Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1Kpl8j-0002OV-AO
	for linux-dvb@linuxtv.org; Tue, 14 Oct 2008 16:44:52 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta5.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K8Q00M44GXO3F21@mta5.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Tue, 14 Oct 2008 10:44:14 -0400 (EDT)
Date: Tue, 14 Oct 2008 10:44:12 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <1.3.200810140105.23818@arpacoop.it>
To: Carlo Scarfoglio <scarfoglio@arpacoop.it>,
	linux-dvb <linux-dvb@linuxtv.org>
Message-id: <48F4B03C.1000509@linuxtv.org>
MIME-version: 1.0
References: <1.3.200810140105.23818@arpacoop.it>
Subject: Re: [linux-dvb] Multi-frontend patch merge (TESTERS FEEDBACK) was:
 Re: [PATCH] S2API:
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

>> Over time I've heard constant suggestions that the patches are 
>> ready for
>> merge, the cx88 and saa7134 trees are working correctly. Now 
>> is the time
>> that I need you all to announce this. I need you each in turn 
>> to
>> describe you testing, and state whether you think the patches 
>> are ready
>> for merge.
>>
>> Hans Werner <HWerner4@gmx.de>
>> darron@kewl.org
>> scarfoglio@arpacoop.it
>> fabbione@fabbione.net
>>
>> If you're not normally members of this list then please say so, 
>> I'll
>> ensure your response is cc'd back to the list.
>>
>> Thanks,
>>
>> Steve
>>
> Well, I've been using the HVR4000 for over one year with the mfe driver.
> I use it daily for watching DVB-T TV and listening to DVB radio, occasionally
> for analogue TV, and now for listening to FM radio. I have also recorded DVB-T HD programs. 
> Kaffeine, kdetv. tvtime, fmtools and kradio work without issues. Only caveat is
> the analog audio routing with arecord/aplay.
> Stability is excellent. I had problems about 12 months ago with AGC and DVB-T, but
> they were solved. I use it to record TV programs and watch them later. I have recorded
> for 5-6 hours many times and never had issues.
> From the user perspective mfe is very convenient. No need to change configs.
> A KDE user finds in kaffeine DVB-T, DVB-S/S2 and DVB radio. For analog he has
> got kdetv and kradio. 
> IMHO it should be merged into kernel 2.6.28.
> 
> Great thanks to all developers.
> 
> Carlo Scarfoglio

Thanks Carlo, I've cc'd the mailing list so they can share your feedback.

Regards,

Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
