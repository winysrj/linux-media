Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp1.betherenow.co.uk ([87.194.0.68])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tghewett2@onetel.com>) id 1JYKId-0007SA-FX
	for linux-dvb@linuxtv.org; Sun, 09 Mar 2008 13:06:44 +0100
Message-Id: <292EC716-2744-4518-96B5-95562A2D1E15@onetel.com>
From: Tim Hewett <tghewett2@onetel.com>
To: Simeon Simeonov <simeonov_2000@yahoo.com>
In-Reply-To: <80671.57460.qm@web33106.mail.mud.yahoo.com>
Mime-Version: 1.0 (Apple Message framework v919.2)
Date: Sun, 9 Mar 2008 12:05:18 +0000
References: <80671.57460.qm@web33106.mail.mud.yahoo.com>
Cc: Tim Hewett <tghewett2@onetel.com>, linux-dvb@linuxtv.org,
	Manu Abraham <abraham.manu@gmail.com>
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

Just to clarify, the diseqc switches mentioned do not work reliably  
with any of the D-Sat cards in my PC (one Skystar HD2 DVB-S/DVB-S2,  
three Skystar 2 (DVB-S only)), the VP-1041 driver is not the issue -  
it was best to remove the switch as they can be troublesome, in my  
case they tend to block tuning to either horizontal or vertical  
transponders (apparently randomly over time). All three switches work  
fine with a Technomate TM1000 receiver, incidentally.

If of any help, these are the commands I am using to tune successfully  
and reliably to DVB-S2 transponders on Astra 2D (28East). I am using  
the current mantis tree with a Skystar HD2 card, using the replacement  
szap.c from the VP1041 wiki.

Entry in channels.conf:

DVBS2:11798:h:1:29500:513:641:2:2018


szap command line and output:

root@kubuntu7:~/linuxtv-dvb-apps-1.1.1/util/szap# ./szap -r -p -a 5 -l  
UNIVERSAL -t 2 DVBS2
reading channels from file '/root/.szap/channels.conf'
zapping to 11 'DVBS2':
sat 1, frequency = 11798 MHz H, symbolrate 29500000, vpid = 0x0201,  
apid = 0x0281 sid = 0x0002
Querying info .. Delivery system=DVB-S2
using '/dev/dvb/adapter5/frontend0' and '/dev/dvb/adapter5/demux0'
----------------------------------> Using 'STB0899 DVB-S2' DVB-S2
do_tune: API version=3, delivery system = 2
do_tune: Frequency = 1198000, Srate = 29500000
do_tune: Frequency = 1198000, Srate = 29500000


couldn't find pmt-pid for sid 0002
status 1a | signal 05aa | snr 0030 | ber 00000000 | unc fffffffe |  
FE_HAS_LOCK
status 1a | signal 05aa | snr 002f | ber 00000000 | unc fffffffe |  
FE_HAS_LOCK
status 1a | signal 05aa | snr 002f | ber 00516155 | unc fffffffe |  
FE_HAS_LOCK
status 1a | signal 05aa | snr 002e | ber 00145855 | unc fffffffe |  
FE_HAS_LOCK
status 1a | signal 05aa | snr 002f | ber 00000000 | unc fffffffe |  
FE_HAS_LOCK
status 1a | signal 05aa | snr 002f | ber 00000000 | unc fffffffe |  
FE_HAS_LOCK
status 1a | signal 05aa | snr 002e | ber 00000000 | unc fffffffe |  
FE_HAS_LOCK
status 1a | signal 05aa | snr 002f | ber 00000000 | unc fffffffe |  
FE_HAS_LOCK

root@kubuntu7:~/linuxtv-dvb-apps-1.1.1/util/szap#


In a different shell, output of scan while the card is tuned using  
szap above:

root@kubuntu7:# scan -c -a 5
using '/dev/dvb/adapter5/frontend0' and '/dev/dvb/adapter5/demux0'
0x0000 0x0ef9: pmt_pid 0x0102 BSkyB -- Sky Screen 1HD (running,  
scrambled)
0x0000 0x0f23: pmt_pid 0x0103 BSkyB -- Channel 4 HD (running, scrambled)
0x0000 0x1034: pmt_pid 0x0000 BSkyB -- Anytime (???, scrambled)
dumping lists (4 services)
Sky Screen 1HD           (0x0ef9) 86:            V 0514   A 0642    
(NAR) TT 2305   AC3 0662
Channel 4 HD             (0x0f23) 86:            V 0513   AC3 0661
[0f38]                   (0x0f38) 00:
Anytime                  (0x1034) 04:
Done.
root@kubuntu7:#


HTH,

Tim.


On 8 Mar 2008, at 22:00, Simeon Simeonov wrote:

> Just for the record: in my case eliminating the diseqc did not make  
> a difference.
>
> ----- Original Message ----
> From: Manu Abraham <abraham.manu@gmail.com>
> To: Tim Hewett <tghewett2@onetel.com>
> Cc: Simeon Simeonov <simeonov_2000@yahoo.com>; linux-dvb@linuxtv.org
> Sent: Saturday, March 8, 2008 11:50:33 AM
> Subject: Re: [linux-dvb] VP 1041: Is anybody able to tune to DVBS2  
> or DSS?
>
> Tim Hewett wrote:
>> Simeon,
>>
>> It doesn't matter re: the diseqc commands, with no switch present  
>> will
>> be nothing listening, assuming there is nothing else connected such  
>> as
>> a rotor.
>
>
> The SEC equipment should work fine AFAICS. The bad aspect of the tests
> were that no one really came up with any real logs that could really
> reproduced  a driver bug or a hardware bug.
>
> Nevertheless, there had been an interesting post on the VDR mailing  
> list.
>
> http://www.linuxtv.org/pipermail/vdr/2008-March/016068.html
>
> Regards,
> Manu
>
>
>
>>
>> Tim.
>>
>>
>> On 8 Mar 2008, at 01:27, Simeon Simeonov wrote:
>>
>>> Thanks for the answer Tim!
>>>
>>> That's a good point - I do have a switch. I will try bypassing it  
>>> but
>>> do you still send the diseqc commands or I have to get rid of them?
>>>
>>> Simeon
>>>
>>> ----- Original Message ----
>>> From: Tim Hewett <tghewett2@onetel.com>
>>> To: simeonov_2000@yahoo.com
>>> Cc: Tim Hewett <tghewett2@onetel.com>; linux-dvb@linuxtv.org
>>> Sent: Friday, March 7, 2008 5:18:43 PM
>>> Subject: VP 1041: Is anybody able to tune to DVBS2 or DSS?
>>>
>>> Yes, I have the Skystar HD2 tuning to DVB-S2 transponders using the
>>> replacement szap.c mentioned on the wiki page, then listing the
>>> channels using 'scan -c -a <n>' to prove proper reception, all using
>>> the current mantis tree. No hacks were needed, it works out of the  
>>> box
>>> every time now that the mantis tree has been updated to support the
>>> HD2 card (same one as the VP-1041).
>>>
>>> If you are using a Diseqc switch then get rid of it for now, mine  
>>> was
>>> causing lots of unreliability. I tried three different types of  
>>> Diseqc
>>> switch, all were the same. Got rid of them then it all started
>>> working.
>>>
>>> Tim.
>>>
>>>> Hi, I am curious to find out if anybody is able to use Twinhan/
>>>> Azurware VP-1041 with the mantis drivers to tune to standards other
>>>> than DVBS - DVBS2 and DSS? Thanks, Simeon
>>>
>>>
>>>
>>>
>>>
>>> ____________________________________________________________________________________
>>> Looking for last minute shopping deals?
>>> Find them fast with Yahoo! Search.  http://tools.search.yahoo.com/newsearch/category.php?category=shopping
>>
>>
>> _______________________________________________
>> linux-dvb mailing list
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>
>
>
>
>
>
>
>       
> ____________________________________________________________________________________
> Be a better friend, newshound, and
> know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ
>


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
