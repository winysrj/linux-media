Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3NKtVgP017258
	for <video4linux-list@redhat.com>; Wed, 23 Apr 2008 16:55:31 -0400
Received: from mta1.srv.hcvlny.cv.net (mta1.srv.hcvlny.cv.net [167.206.4.196])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3NKtJHM020458
	for <video4linux-list@redhat.com>; Wed, 23 Apr 2008 16:55:20 -0400
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta1.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0JZS004TQQ3X9HM0@mta1.srv.hcvlny.cv.net> for
	video4linux-list@redhat.com; Wed, 23 Apr 2008 16:55:11 -0400 (EDT)
Date: Wed, 23 Apr 2008 16:55:09 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <20080423200134.GJ6703@plankton.ifup.org>
To: Brandon Philips <brandon@ifup.org>
Message-id: <480FA22D.7010507@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <8CA703CA994FDB6-D6C-ADB@webmail-me16.sysops.aol.com>
	<20080422040728.GD24855@plankton.ifup.org>
	<8CA7307126F01E0-1644-3A1B@webmail-de04.sysops.aol.com>
	<20080423200134.GJ6703@plankton.ifup.org>
Cc: v4l <video4linux-list@redhat.com>
Subject: Re: [BUG] HVR-1500 Hot swap causes lockup
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Brandon Philips wrote:
> On 23:13 Tue 22 Apr 2008, Jon Lowe wrote:
>>  I read that page, but I don't have a clue what to do with it.? I'm a
>>  Linux newbie.? Is there some other logfile that might capture the
>>  problem?? If you give me a detail explanation of what you need me to
>>  do, I will do it.
> 
> Since it is hard locking and I am completely unfamiliar with HVR-1500
> and PCI hot plugging a netconsole is the best thing I can offer...
> 
> 1) You will need a second computer connected to your laptop via a LAN.
> 
> 2) Find out the IP address of the computer that is not your laptop.
> 
>  $ /sbin/ifconfig 
> 
> eth0      Link encap:Ethernet  HWaddr 
>           inet addr:192.168.1.150  Bcast:192.168.1.255 Mask:255.255.255.0
> .....
> 
> So, in this case the IP address is 192.168.1.150
> 
> 3) Start netcat in a terminal on this system.
> 
>   $ netcat -u -l -p 666
> 
> 4) Now, on your laptop run the following commands as root in a terminal.
> NOTE: replace 192.168.1.150 with the IP address you found in step 2.
> 
>   $ dmesg -n 8
>   $ modprobe netconsole netconsole=@/,@192.168.1.150/
> 
> 5) netconsole: network logging started should appear in the terminal
> where you ran netcat.
> 
> 6) Try to reproduce the hard lock on your laptop and include the output
> from netcat.
> 
> Let me know if this works.
> 
> Also, please continue to CC the v4l list.
> 
> Cheers,
> 
> 	Brandon
> 
>> -----Original Message----- From: Brandon Philips <brandon@ifup.org>
>> To: Jon Lowe <jonlowe@aol.com> Cc: video4linux-list@redhat.com Sent:
>> Mon, 21 Apr 2008 11:07 pm Subject: Re: [BUG] HVR-1500 Hot swap causes
>> lockup
>>
>> On 09:59 Sat 19 Apr 2008, Jon Lowe wrote:
>>> Hope this is the right place to do this.
>>>
>>> Hauppauge HVR-1500 Expresscard, Ubuntu 8.04, latest V4L drivers.
>>>
>>> Removing (hotswap) this card from a ASUS F3SV laptop running Ubuntu
>>> 8.04 causes a hard lock up of the computer.? Unresponsive to any
>>> input. Requires complete shutdown of the computer and restart.?
>>> Easily repeatable.? Same card is hot swappable under Windows Vista.? 
>>>
>>> This is critical because Expresscards are notoriously easy to
>>> dislodge in notebooks.?
>> Could you please setup a netconsole and try and get some debugging
>> output?

Brandon / Jon,

Some background info, not that it helps much...

We had a ton of issues under windows bringing the device into existence, 
largely because of the PCIe chipset implementations and various timing 
issues. None of these issues resulted in a complete system hang so your 
symptoms are a mystery. Typically the windows issues were that 
occasionally windows would not detect the device on insertion, removing 
and inserting again would always case windows to re-detect properly.

I have to be honest and say that I've never tried hotplug PCIe on linux, 
I just don't have capable hardware.

Speaking as the cx23885 Linux dev I would ask one thing, remove the 
cx23885.ko driver from your system and cold boot the system before your 
next set of tests. The hang sounds like a PCIe chipset issue on the 
motherboard, but if you can prove the hang only happens when the 
cx23885.ko driver is installed I'd be happy to work with you on the problem.

Good luck, let me know how it goes, regards.

Steve

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
