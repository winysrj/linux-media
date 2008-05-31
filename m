Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from static.135.41.46.78.clients.your-server.de ([78.46.41.135]
	helo=hetzner.kompasmedia.nl)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bas@kompasmedia.nl>) id 1K2Mvn-0005fd-ML
	for linux-dvb@linuxtv.org; Sat, 31 May 2008 10:59:20 +0200
To: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
Date: Sat, 31 May 2008 10:59:16 +0200
From: Bas v.d. Wiel <bas@kompasmedia.nl>
In-Reply-To: <48405F2E.6080108@gmail.com>
References: <48405F2E.6080108@gmail.com>
Message-ID: <52c5d588adc86b6dce64284511ed734a@localhost>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] CAM of Mantis 2033 still not working
Reply-To: bas@kompasmedia.nl
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




On Sat, 31 May 2008 00:10:22 +0400, Manu Abraham <abraham.manu@gmail.com>
wrote:
> Bas v.d. Wiel wrote:
>> Hi,
>> I'm running 2.6.24-16 64-bit, and I get a whole stream of errors
>> (writing to registers fails) from the frontend whether or not the cam is
>> inserted. I don't get any hard crashes anymore when I insert the CAM,
>> but there's still my previous problem of not being able to find any
>> signal/channels whatsoever using w_scan and a constant stream of 'tuning
>> failure' from dvb-scan. Femon also shows everything as zero values,
>> except the snr ration which is completely maxed out.
>>
> 
> Do you have the LOCK failure problem only when the CAM is inserted ?
> 
> Regards,
> Manu

Hi Manu,
The failures occur regardless of what I do. Whether or not the CAM is
inserted makes no difference at all. I tried it with different Linux
versions (Debian, Mythbuntu, Mythdora) in 32 bit and 64 bit versions. With
the current version of the driver my PC won't unload the mantis module
anymore and therefore refuses to even shut down properly. I'll post a dmesg
output later today. I've been tracking your driver for I guess a little
over a month now. The hard errors and crashes only started to occur after
functionality for the CAM was introduced. Before that the mantis module
loaded properly, it just didn't seem to do anything at all except just sit
there. Using Windows it works fine. A few days ago I posted all the
information I could find about my hardware (simply by looking at it) on the
list.

Regards,
Bas


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
