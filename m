Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3OEXxkd017884
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 10:33:59 -0400
Received: from imo-d20.mx.aol.com (imo-d20.mx.aol.com [205.188.139.136])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3OEXjgW002239
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 10:33:45 -0400
References: <8CA703CA994FDB6-D6C-ADB@webmail-me16.sysops.aol.com>	<20080422040728.GD24855@plankton.ifup.org>	<8CA7307126F01E0-1644-3A1B@webmail-de04.sysops.aol.com>	<20080423200134.GJ6703@plankton.ifup.org>	<480FA22D.7010507@linuxtv.org>
	<8CA7429B5FF15EF-9C8-FC@mblk-d14.sysops.aol.com>
To: jonlowe@aol.com, stoth@linuxtv.org, brandon@ifup.org
Date: Thu, 24 Apr 2008 10:32:49 -0400
In-Reply-To: <8CA7429B5FF15EF-9C8-FC@mblk-d14.sysops.aol.com>
MIME-Version: 1.0
From: Jon Lowe <jonlowe@aol.com>
Message-Id: <8CA742F34634D33-9C8-48F@mblk-d14.sysops.aol.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
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

While not exactly the same, this bug MAY be related to my hot swap poblem:
https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.15/+bug/12519


Jon Lowe


-----Original Message-----
From: Jon Lowe <jonlowe@aol.com>
To: stoth@linuxtv.org; brandon@ifup.org
Cc: video4linux-list@redhat.com
Sent: Thu, 24 Apr 2008 8:53 am
Subject: Re: [BUG] HVR-1500 Hot swap causes lockup



The problem is taking the card out.? That is when it hangs up.? If there is a 
gui way in Linux (Ubuntu) to stop a card to safely remove?it ala Windows, I 
haven't found it.? Frankly, I haven't tried putting the card in while Linux is 
running.? I always boot with it in place. I guess I assumed Linux wouldn't see 
it and load the drivers unless I booted with it in.? Am I wrong?

Also, has anyone gotten this card to work in analog mode in Linux?

Thanks.


Jon Lowe


-----Original Message-----
From: Steven Toth <stoth@linuxtv.org>
To: Brandon Philips <brandon@ifup.org>
Cc: Jon Lowe <jonlowe@aol.com>; v4l <video4linux-list@redhat.com>
Sent: Wed, 23 Apr 2008 3:55 pm
Subject: Re: [BUG] HVR-1500 Hot swap causes lockup


Brandon Philips wrote:?
> On 23:13 Tue 22 Apr 2008, Jon Lowe wrote:?
>> I read that page, but I don't have a clue what to do with it.? I'm a?
>> Linux newbie.? Is there some other logfile that might capture the?
>> problem?? If you give me a detail explanation of what you need me to?
>> do, I will do it.?
> > Since it is hard locking and I am completely unfamiliar with HVR-1500?
> and PCI hot plugging a netconsole is the best thing I can offer...?
> > 1) You will need a second computer connected to your laptop via a LAN.?
> > 2) Find out the IP address of the computer that is not your laptop.?
> > $ /sbin/ifconfig > > eth0 Link encap:Ethernet HWaddr > inet 
addr:192.168.1.150 Bcast:192.168.1.255 Mask:255.255.255.0?
> .....?
> > So, in this case the IP address is 192.168.1.150?
> > 3) Start netcat in a terminal on this system.?
> > $ netcat -u -l -p 666?
> > 4) Now, on your laptop run the following commands as root in a terminal.?
> NOTE: replace 192.168.1.150 with the IP address you found in step 2.?
> > $ dmesg -n 8?
> $ modprobe netconsole netconsole=@/,@192.168.1.150/?
> > 5) netconsole: network logging started should appear in the terminal?
> where you ran netcat.?
> > 6) Try to reproduce the hard lock on your laptop and include the output?
> from netcat.?
> > Let me know if this works.?
> > Also, please continue to CC the v4l list.?
> > Cheers,?
> > Brandon?
> >> -----Original Message----- From: Brandon Philips <brandon@ifup.org>?
>> To: Jon Lowe <jonlowe@aol.com> Cc: video4linux-list@redhat.com Sent:?
>> Mon, 21 Apr 2008 11:07 pm Subject: Re: [BUG] HVR-1500 Hot swap causes?
>> lockup?
>>?
>> On 09:59 Sat 19 Apr 2008, Jon Lowe wrote:?
>>> Hope this is the right place to do this.?
>>>?
>>> Hauppauge HVR-1500 Expresscard, Ubuntu 8.04, latest V4L drivers.?
>>>?
>>> Removing (hotswap) this card from a ASUS F3SV laptop running Ubuntu?
>>> 8.04 causes a hard lock up of the computer.? Unresponsive to any?
>>> input. Requires complete shutdown of the computer and restart.??
>>> Easily repeatable.? Same card is hot swappable under Windows Vista.? >>>?
>>> This is critical because Expresscards are notoriously easy to?
>>> dislodge in notebooks.??
>> Could you please setup a netconsole and try and get some debugging?
>> output??
?
Brandon / Jon,?
?
Some background info, not that it helps much...?
?
We had a ton of issues under windows bringing the device into existence, largely 
because of the PCIe chipset implementations and various timing issues. None of 
these issues resulted in a complete system hang so your symptoms are a mystery. 
Typically the windows issues were that occasionally windows would not detect the 
device on insertion, removing and inserting again would always case windows to 
re-detect properly.?
?
I have to be honest and say that I've never tried hotplug PCIe on linux, I just 
don't have capable hardware.?
?
Speaking as the cx23885 Linux dev I would ask one thing, remove the cx23885.ko 
driver from your system and cold boot the system before your next set of tests. 
The hang sounds like a PCIe chipset issue on the motherboard, but if you can 
prove the hang only happens when the cx23885.ko driver is installed I'd be happy 
to work with you on the problem.?
?
Good luck, let me know how it goes, regards.?
?
Steve?
?

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
