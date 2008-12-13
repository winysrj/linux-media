Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from crow.cadsoft.de ([217.86.189.86] helo=raven.cadsoft.de)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Klaus.Schmidinger@cadsoft.de>) id 1LBbQI-0003MT-C4
	for linux-dvb@linuxtv.org; Sat, 13 Dec 2008 21:49:16 +0100
Received: from [192.168.100.10] (hawk.cadsoft.de [192.168.100.10])
	by raven.cadsoft.de (8.14.3/8.14.3) with ESMTP id mBDCuMqC017618
	for <linux-dvb@linuxtv.org>; Sat, 13 Dec 2008 13:56:22 +0100
Message-ID: <4943B0F5.2090306@cadsoft.de>
Date: Sat, 13 Dec 2008 13:56:21 +0100
From: Klaus Schmidinger <Klaus.Schmidinger@cadsoft.de>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <4927F5FD.5080805@cadsoft.de> <4927F9D0.4050004@cadsoft.de>
In-Reply-To: <4927F9D0.4050004@cadsoft.de>
Subject: Re: [linux-dvb] S2API: problem unloading dvb_ttpci
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

On 22.11.2008 13:23, Klaus Schmidinger wrote:
> On 22.11.2008 13:07, Klaus Schmidinger wrote:
>> I'm making my first steps in using the S2API driver, and already
>> have a problem. When trying to do
>>
>>   /sbin/rmmod dvb_ttpci
>>
>> I get the error
>>
>>   ERROR: Removing 'dvb_ttpci': Device or resource busy
>>
>> 'lsmod' shows
>>
>>   Module                  Size  Used by
>>   dvb_ttpci             348748  0
>>
>> So who is using dvb_ttpci?
> 
> After rebooting and doing one more test, I got this when
> running /sbin/rmmod dvb_ttpci:
> 
> Nov 22 13:21:35 vdr2 kernel: saa7146: unregister extension 'dvb'.
> Nov 22 13:21:35 vdr2 kernel: PANIC: double fault, gdt at c2015000 [255 bytes]
> Nov 22 13:21:35 vdr2 kernel: double fault, tss at c2017780
> Nov 22 13:21:35 vdr2 kernel: eip = f7881416, esp = bf88921e
> Nov 22 13:21:35 vdr2 kernel: eax = f7881408, ebx = f6df6cc8, ecx = f7401a7f, edx = f788144d
> Nov 22 13:21:35 vdr2 kernel: esi = f7881409, edi = f79231c1
> 
> Looks like the S2API driver isn't in a state where it can actually be used, yet...

Just for the record: it turned out that there was a mixup between DVB driver
files from my SUSE 11.0 installation and the self-compiled driver source.
After making sure only the self-compiled driver files were loaded, I was
able to load/unload the S2API driver.

Sorry about the noise...

Klaus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
