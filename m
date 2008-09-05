Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KbbGz-0000wZ-2z
	for linux-dvb@linuxtv.org; Fri, 05 Sep 2008 15:22:50 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta4.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K6Q00IBC552UOR0@mta4.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Fri, 05 Sep 2008 09:22:14 -0400 (EDT)
Date: Fri, 05 Sep 2008 09:22:13 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <e32e0e5d0809041625y22993606vae7f7ee63e936f9c@mail.gmail.com>
To: Tim Lucas <lucastim@gmail.com>
Message-id: <48C13285.1040604@linuxtv.org>
MIME-version: 1.0
References: <e32e0e5d0809041625y22993606vae7f7ee63e936f9c@mail.gmail.com>
Cc: linux dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] [PATCH] cx23885 analog TV and audio support for
	HVR-1500
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

Tim Lucas wrote:
>>  Tim Lucas wrote:
>>
>> > For some reason, when I  add the line
>> > options cx23885 card=6
>> > I can no longer boot the machine successfully.
>> > The machine hangs saying that
>> >
>> > (Ctl-alt-F1)
>> > kinit: No resume image, doing normal boot . . .
>> > (Ctl-alt-F8)
>> > udevd-event[3374]: run-program: '/sbin/modprobe' abnormal exit
>> >
>> > After a while it continues to boot, but the messages go by so fast that I
>> > can't read them.  Finally, it just sits on a blank screen.  Since 
> 2.6.24-19
>> > was originally installed and it updated to 2.6.24-21, I am able to 
> boot into
>> > the older kernel and then comment out that line.
>> >
>> > I am pretty sure that HVR1500 is card 6, so I am not sure what is wrong.
>> >  I didn't have that problem, the first time I rebooted, but have had that
>> > problem on every succesive reboot.
>> >
>> > Any ideas?
>> >
>>
>>  Please cc the list in all email, which I've done.
>>
>>  Check the /var/log/messages or kern.log files to see what they contain.
>>
>>  Or, if the system isn't booting, remove the module from your
>>  /lib/modules/`uname -r`/kernel/drivers/media/video/cx23885 dir then boot
>>  again.
>>
>>  The card won't get initialised by the driver won't exist, then you can
>>  install the driver with 'make install' which will install it from your
>>  linux-dvb/v4l test tree, then load it at your own leisure with modprobe
>>  cx23885 debug=1.
>>
>>
>>  - Steve
>>
> 
> Using your instructions, I figured out that the driver will not load 
> using modprobe. That is why the computer has trouble booting with that 
> driver and the HVR-1500 card selected.
> I also tried copying the relevant code and putting it into the DViCO 
> FusionHDTV7 Dual Express area to see if that worked. I had the same 
> results as when I tried loading the card as a HVR-1500. I cannot get any 
> signal from the card that way.  I know the card is getting a signal 
> because it shows a signal when loaded as a digital card.  If you have 
> any suggestions I would appreciate them.  Thank you.

Why doesn't the driver load if you force it with card=X? What does dmesg 
show?

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
