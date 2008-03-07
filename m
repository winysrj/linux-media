Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JXQNK-0002e3-PY
	for linux-dvb@linuxtv.org; Fri, 07 Mar 2008 01:23:51 +0100
Message-ID: <47D08B08.9010703@gmail.com>
Date: Fri, 07 Mar 2008 04:23:36 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: manu <eallaud@yahoo.fr>
References: <227C7E65-BCB7-4990-B0F2-02FFF56DC976@krastelcom.ru>
	<1204845652l.7051l.0l@manu-laptop>
In-Reply-To: <1204845652l.7051l.0l@manu-laptop>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Re : TT S2-3200. No lock on high symbol rate (45M)
 transponders
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

manu wrote:
> On 03/06/2008 06:34:28 AM, Vladimir Prudnikov wrote:
>> Can't get TT S2-3200 locked on high SR transponders. I have seen a 
>> lot
>>  
>> of suggestions regarding changing Frequency/Symbol rate on various  
>> forums but no luck. Low SR are fine.
>> Does anyone have a "revision" of multiproto that was tested with high 
>>
>> SR?
>>
>> I hope Manu can comment on that as well...
>>
> Just a "me too", well kind of: for me certain transponders do not lock 
> or lock but with corrupted streams whereas others are perfect (on the 
> same sat with the same characteristics, SR is 30M).


Please try whether these register setup changes does help as applicable.

http://jusst.de/hg/mantis/rev/72e81184fb9f

Regards,
Manu

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
