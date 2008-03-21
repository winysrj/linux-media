Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp1.mtw.ru ([194.135.105.241])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <a-j@a-j.ru>) id 1Jclzk-0002KG-F2
	for linux-dvb@linuxtv.org; Fri, 21 Mar 2008 19:29:37 +0100
Date: Fri, 21 Mar 2008 21:29:27 +0300
From: Andrew Junev <a-j@a-j.ru>
Message-ID: <1499404682.20080321212927@a-j.ru>
To: Oliver Endriss <o.endriss@gmx.de>
In-Reply-To: <200803210742.57119@orion.escape-edv.de>
References: <1115343012.20080318233620@a-j.ru>
	<200803200048.15063@orion.escape-edv.de>
	<1206067079.3362.10.camel@pc08.localdom.local>
	<200803210742.57119@orion.escape-edv.de>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TT S-1401 problem with kernel 2.6.24 ???
Reply-To: Andrew Junev <a-j@a-j.ru>
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

Friday, March 21, 2008, 9:42:56 AM, you wrote:

> hermann pitton wrote:
>> hmm, thought that this we exactly did avoid on 2.6.24 and 2.6.25.
>> 
>> IIRC, this should never made it into 2.6.24, at least I thought we could
>> always stop it on 2.6.25 before it harms.
>> 
>> Fedora downports from release canditates, and almost always is fine,
>> so I don't trust the 2.6._24_ here.
>> 
>> If nothing else to do ..., might investigate it.

> Unfortunately, the regression made it into the 2.6.24 series.
> I just checked and found it in 2.6.24.2. :-(

> So we should submit a bug fix for 2.6,24, too.

For the record: I just checked it with kernel-2.6.24.3-34.fc8
and the problem is still there.

Is there an easy way to check whether the bug fix was added to the
kernel (2.6.24.x)?

Thank you guys for your support!!!

> CU
> Oliver


-- 
Best regards,
 Andrew



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
