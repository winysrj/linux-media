Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n8a.bullet.ukl.yahoo.com ([217.146.183.156])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <r.schedel@yahoo.de>) id 1JneyV-0003AL-4U
	for linux-dvb@linuxtv.org; Sun, 20 Apr 2008 21:13:26 +0200
Message-ID: <480B95A8.5050607@yahoo.de>
Date: Sun, 20 Apr 2008 21:12:40 +0200
From: Robert Schedel <r.schedel@yahoo.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <47F9E95D.6070705@yahoo.de> <48066F62.8000709@yahoo.de>
	<48076C7A.7070901@yahoo.de>
	<200804180234.34558@orion.escape-edv.de>
In-Reply-To: <200804180234.34558@orion.escape-edv.de>
Subject: Re: [linux-dvb] High CPU load in "top" due to budget_av slot polling
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

Oliver Endriss wrote:
> Robert Schedel wrote:
>> Robert Schedel wrote:
>>
>>> Is the 250ms timeout an approved limit? Decreasing it would push the
>>> load further down. Probably it still has to cover slow CAMs as well as a
>>> stressed PCI bus. Unfortunately, without CAM/CI I cannot make any
>>> statements myself.
>> Just got another idea to improve the code: Function 
>> "saa7146_wait_for_debi_done_sleep" could be reworked to use what is 
>> known as "truncated binary exponential backoff" algorithm. IOW, on each 
>> sleep duplicate the period from 1ms until a fixed maximum, e.g. 32ms. 
>> This way polling ends fast for those users with fast bus/CAM, and those 
>> requiring 200ms due to slow bus/CAM should not worry about e.g. 216ms 
>> response time.
>>
>> My first tests look promising (load goes down to 0). However, is not the 
>> simple BEB algorithm already patented?
> 
> Load should go down to 0 if the sleep call does not busy-wait.
> 
> Please test whether the attached code fixes the problem.
> Btw, I will not claim a patent for that. :D

OK, I just took the time to make a more reliable test series (because 
load measurements varied). All nonessential system processes and modules 
were terminated before the test. Basically, only the login shell and the 
budget_av module were left. 1 minute uptime was used for measurements.

Kernel: Linux 2.6.25
HW: Athlon 64 X2 3800+, Satelco EasyWatch DVB-C (as before)

1. Original module budget_av is loaded:
Load: ~0,6-0,8

2. Module + Patch "saa7146_sleep.diff" (1ms/10ms polling intervals in 
debi_done function):
Load: ~0,6-0,8 (same as in 1., no difference visible)

3. Module + Patch "incr-empty-ca-slot-poll-2.6.24.4.patch" (5s polling 
timer on slot state EMPTY):
Load: Decays to 0,02, but after about 105s always a spike to 0,10, then 
again decays to 0,02, and so on

4. Module + Patch "incr-empty-ca-slot-poll" + "saa7146_sleep.diff":
Same as 3.

5. Module + Patch "incr-empty-ca-slot-poll" + "binary exponential backoff":
Same as 3.

6. Module budget_av is unloaded:
Load constantly stays at 0, no spikes

Bottomline for me:
- Increasing the poll timer from 100ms, e.g. to 5s, makes sense. 
Changing the polling intervals in the debi_done function, however, makes 
no difference (unlike my previous assumption which was caused by the 
ugly variations).
- There seems to be a spike in the CPU load, each ~105s, but only when 
budget_av is loaded. I cannot explain it (maybe some frontend background 
functions), but it is no issue for me.

Regards,
Robert


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
