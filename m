Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web33106.mail.mud.yahoo.com ([209.191.69.136])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <simeonov_2000@yahoo.com>) id 1JY75w-0007iw-Av
	for linux-dvb@linuxtv.org; Sat, 08 Mar 2008 23:00:47 +0100
Date: Sat, 8 Mar 2008 14:00:10 -0800 (PST)
From: Simeon Simeonov <simeonov_2000@yahoo.com>
To: Manu Abraham <abraham.manu@gmail.com>, Tim Hewett <tghewett2@onetel.com>
MIME-Version: 1.0
Message-ID: <80671.57460.qm@web33106.mail.mud.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] VP 1041: Is anybody able to tune to DVBS2 or DSS?
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

Just for the record: in my case eliminating the diseqc did not make a difference.

----- Original Message ----
From: Manu Abraham <abraham.manu@gmail.com>
To: Tim Hewett <tghewett2@onetel.com>
Cc: Simeon Simeonov <simeonov_2000@yahoo.com>; linux-dvb@linuxtv.org
Sent: Saturday, March 8, 2008 11:50:33 AM
Subject: Re: [linux-dvb] VP 1041: Is anybody able to tune to DVBS2 or DSS?

Tim Hewett wrote:
> Simeon,
> 
> It doesn't matter re: the diseqc commands, with no switch present will  
> be nothing listening, assuming there is nothing else connected such as  
> a rotor.


The SEC equipment should work fine AFAICS. The bad aspect of the tests
were that no one really came up with any real logs that could really
reproduced  a driver bug or a hardware bug.

Nevertheless, there had been an interesting post on the VDR mailing list.

http://www.linuxtv.org/pipermail/vdr/2008-March/016068.html

Regards,
Manu



> 
> Tim.
> 
> 
> On 8 Mar 2008, at 01:27, Simeon Simeonov wrote:
> 
>> Thanks for the answer Tim!
>>
>> That's a good point - I do have a switch. I will try bypassing it but
>> do you still send the diseqc commands or I have to get rid of them?
>>
>> Simeon
>>
>> ----- Original Message ----
>> From: Tim Hewett <tghewett2@onetel.com>
>> To: simeonov_2000@yahoo.com
>> Cc: Tim Hewett <tghewett2@onetel.com>; linux-dvb@linuxtv.org
>> Sent: Friday, March 7, 2008 5:18:43 PM
>> Subject: VP 1041: Is anybody able to tune to DVBS2 or DSS?
>>
>> Yes, I have the Skystar HD2 tuning to DVB-S2 transponders using the
>> replacement szap.c mentioned on the wiki page, then listing the
>> channels using 'scan -c -a <n>' to prove proper reception, all using
>> the current mantis tree. No hacks were needed, it works out of the box
>> every time now that the mantis tree has been updated to support the
>> HD2 card (same one as the VP-1041).
>>
>> If you are using a Diseqc switch then get rid of it for now, mine was
>> causing lots of unreliability. I tried three different types of Diseqc
>> switch, all were the same. Got rid of them then it all started  
>> working.
>>
>> Tim.
>>
>>> Hi, I am curious to find out if anybody is able to use Twinhan/
>>> Azurware VP-1041 with the mantis drivers to tune to standards other
>>> than DVBS - DVBS2 and DSS? Thanks, Simeon
>>
>>
>>
>>
>>       
>> ____________________________________________________________________________________
>> Looking for last minute shopping deals?
>> Find them fast with Yahoo! Search.  http://tools.search.yahoo.com/newsearch/category.php?category=shopping
> 
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 






      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
