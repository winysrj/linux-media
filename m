Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 39.mail-out.ovh.net ([213.251.138.60])
	by mail.linuxtv.org with smtp (Exim 4.69)
	(envelope-from <luca@ventoso.org>) id 1NGBtM-0000Le-Qt
	for linux-dvb@linuxtv.org; Thu, 03 Dec 2009 14:38:45 +0100
Message-ID: <4B17BF5B.7010400@ventoso.org>
Date: Thu, 03 Dec 2009 14:38:35 +0100
From: Luca Olivetti <luca@ventoso.org>
MIME-Version: 1.0
To: BOUWSMA Barry <freebeer.bouwsma@gmail.com>
References: <4B14CC1E.7030102@ventoso.org>
	<alpine.DEB.2.01.0912030540570.4548@ybpnyubfg.ybpnyqbznva>
	<4B177C81.5030900@ventoso.org>
	<alpine.DEB.2.01.0912031303050.4548@ybpnyubfg.ybpnyqbznva>
In-Reply-To: <alpine.DEB.2.01.0912031303050.4548@ybpnyubfg.ybpnyqbznva>
Cc: Linux DVB <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] siano firmware and behaviour after resuming power
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

En/na BOUWSMA Barry ha escrit:

>> I found a something here
>>
>> http://marc.info/?l=linux-usb-users&m=116827193506484&w=2
>>
>> that purportedly resets an usb device.
>> What I tried was, before powering off:
>>
>> 1) unload the drivers
>> 2) use the above to reset the stick
>> 3) power off
>>
>> and, before loading the drivers, issue a reset again.
>> Sometimes it works, sometimes it doesn't, the end result is that I cannot
>> leave the device plugged-in if I want to use it.
> 
> That might work for a planned reboot 

This being a vdr machine, the reboot is either planned or due to a power 
loss, and I suppose that the latter would really reset the device, but I 
didn't try.
The problem is that even so (planned reboot/switch off) it only works 
sometimes.


> -- my reboots are 
> occasionally unplanned, and the devices are in part hanging
> at boot time.  I guess if I had had the patience to watch and
> see if the wait eventually timed out, I could test just how
> the system came up and reset anything not present (and then
> configure it as needed). Too much work for a non-critical
> system, when I'd rather it Just Work.
> 
> I am lazy.  So sue me  :-)

As I'm getting older, I'm also getting lazier, so I'm not going to sue 
you ;-)

Bye
-- 
Luca

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
