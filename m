Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1JVwpp-0007UG-EZ
	for linux-dvb@linuxtv.org; Sun, 02 Mar 2008 23:39:09 +0100
Message-ID: <47CB2C7B.1080205@gmail.com>
Date: Mon, 03 Mar 2008 02:38:51 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Simeon Simeonov <simeonov_2000@yahoo.com>
References: <574101.28172.qm@web33102.mail.mud.yahoo.com>
In-Reply-To: <574101.28172.qm@web33102.mail.mud.yahoo.com>
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
> Hi Manu,
> 
> I am attaching two gzipped logs. They are supposed to tune to the same frequency using the tip
> of Mantis tree. The difference between the two are that in the GOOD log no repeat command is used
> and in the BAD log one repeat for the switch is issued. The initial position of my rotor is about 20 deg
> east from the target rotor position. 
> Using the tunning without the repeats the rotor goes all the way through and tunes successfully - GOOD log.
> When repeat command is included in the diseqc sequence the rotor goes about 10 degrees to the west and stops as if it has reached the desired position.  The BAD log corresponds to that.
> When I tried to move to any other rotor stored position I find that that all of the memorized in the rotor positions are shifted. My guess is that for some reason the rotor stops, stores current position as the target one and then
> re-calculates all of them. But I do not see anything like that in the log file. The only thing I see is that
> after the third byte  in the  diseqc  repeat command fifo  get  full  and  sending  the  next  byte  has  to
> wait for one cycle.
> The  same  sequences  work  just  fine  with  my  102g  card  and the v4l drivers.

Can you please try to get the DiSEqC strings that you are sending
(from the application) in these 2 cases ?

* Without repeat
* With repeat

Regards,
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
