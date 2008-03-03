Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JW9Dn-0006Kd-Aw
	for linux-dvb@linuxtv.org; Mon, 03 Mar 2008 12:52:45 +0100
Message-ID: <47CBE67D.3080503@gmail.com>
Date: Mon, 03 Mar 2008 15:52:29 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Simeon Simeonov <simeonov_2000@yahoo.com>
References: <625613.51483.qm@web33108.mail.mud.yahoo.com>
In-Reply-To: <625613.51483.qm@web33108.mail.mud.yahoo.com>
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

Simeon Simeonov wrote:
> I am using mythtv and here is the sequence of commands:
> 
> Without repeat:
> DiSEqCDevTree: Changing LNB voltage to 13V
> DiSEqCDevTree: Rotor - Goto Stored Position 2
> DiSEqCDevTree: Sending DiSEqC Command: e0 31 6b  2 
> DiSEqCDevTree: Changing to DiSEqC switch port 1/4
> DiSEqCDevTree: Sending DiSEqC Command: e0 10 38 f0 
> 
> With repeat:
> DiSEqCDevTree: Changing LNB voltage to 13V
> DiSEqCDevTree: Rotor - Goto Stored Position 2
> DiSEqCDevTree: Sending DiSEqC Command: e0 31 6b  2 
> DiSEqCDevTree: Changing to DiSEqC switch port 1/4
> DiSEqCDevTree: Sending DiSEqC Command: e0 10 38 f0 
> DiSEqCDevTree: Repeat DiSEqC Command: e1 10 38 f0 


In fact, looks really confusing to me. The diseqc commands just go out 
as it is,
through the FIFO. I don't see anything that which changes the commands, but
if it was working with another card, it should be working with this card 
too (i
had some doubts, but when you said it worked with some other card, then i
don't see the issue in here with the diseqc part. The FiFO either works 
or not)



> ----- Original Message ----
> From: Manu Abraham <abraham.manu@gmail.com>
> To: Simeon Simeonov <simeonov_2000@yahoo.com>
> Cc: linux-dvb@linuxtv.org
> Sent: Sunday, March 2, 2008 2:38:51 PM
> Subject: Re: [linux-dvb] STB0899 users, please verify results was Re: TechniSat SkyStar HD: Problems scaning and zaping
> 
> Simeon Simeonov wrote:
>> Hi Manu,
>>
>> I am attaching two gzipped logs. They are supposed to tune to the same frequency using the tip
>> of Mantis tree. The difference between the two are that in the GOOD log no repeat command is used
>> and in the BAD log one repeat for the switch is issued. The initial position of my rotor is about 20 deg
>> east from the target rotor position. 
>> Using the tunning without the repeats the rotor goes all the way through and tunes successfully - GOOD log.
>> When repeat command is included in the diseqc sequence the rotor goes about 10 degrees to the west and stops as if it has reached the desired position.  The BAD log corresponds to that.
>> When I tried to move to any other rotor stored position I find that that all of the memorized in the rotor positions are shifted. My guess is that for some reason the rotor stops, stores current position as the target one and then
>> re-calculates all of them. But I do not see anything like that in the log file. The only thing I see is that
>> after the third byte  in the  diseqc  repeat command fifo  get  full  and  sending  the  next  byte  has  to
>> wait for one cycle.
>> The  same  sequences  work  just  fine  with  my  102g  card  and the v4l drivers.
> 
> Can you please try to get the DiSEqC strings that you are sending
> (from the application) in these 2 cases ?
> 
> * Without repeat
> * With repeat
> 
> Regards,
> Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
