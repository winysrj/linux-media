Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3NK3A56008270
	for <video4linux-list@redhat.com>; Wed, 23 Apr 2008 16:03:10 -0400
Received: from rv-out-0506.google.com (rv-out-0708.google.com [209.85.198.243])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3NK2kxC011170
	for <video4linux-list@redhat.com>; Wed, 23 Apr 2008 16:02:47 -0400
Received: by rv-out-0506.google.com with SMTP id b17so1566447rvf.51
	for <video4linux-list@redhat.com>; Wed, 23 Apr 2008 13:02:36 -0700 (PDT)
Date: Wed, 23 Apr 2008 13:01:34 -0700
From: Brandon Philips <brandon@ifup.org>
To: Jon Lowe <jonlowe@aol.com>
Message-ID: <20080423200134.GJ6703@plankton.ifup.org>
References: <8CA703CA994FDB6-D6C-ADB@webmail-me16.sysops.aol.com>
	<20080422040728.GD24855@plankton.ifup.org>
	<8CA7307126F01E0-1644-3A1B@webmail-de04.sysops.aol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8CA7307126F01E0-1644-3A1B@webmail-de04.sysops.aol.com>
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

On 23:13 Tue 22 Apr 2008, Jon Lowe wrote:
>  I read that page, but I don't have a clue what to do with it.? I'm a
>  Linux newbie.? Is there some other logfile that might capture the
>  problem?? If you give me a detail explanation of what you need me to
>  do, I will do it.

Since it is hard locking and I am completely unfamiliar with HVR-1500
and PCI hot plugging a netconsole is the best thing I can offer...

1) You will need a second computer connected to your laptop via a LAN.

2) Find out the IP address of the computer that is not your laptop.

 $ /sbin/ifconfig 

eth0      Link encap:Ethernet  HWaddr 
          inet addr:192.168.1.150  Bcast:192.168.1.255 Mask:255.255.255.0
.....

So, in this case the IP address is 192.168.1.150

3) Start netcat in a terminal on this system.

  $ netcat -u -l -p 666

4) Now, on your laptop run the following commands as root in a terminal.
NOTE: replace 192.168.1.150 with the IP address you found in step 2.

  $ dmesg -n 8
  $ modprobe netconsole netconsole=@/,@192.168.1.150/

5) netconsole: network logging started should appear in the terminal
where you ran netcat.

6) Try to reproduce the hard lock on your laptop and include the output
from netcat.

Let me know if this works.

Also, please continue to CC the v4l list.

Cheers,

	Brandon

> -----Original Message----- From: Brandon Philips <brandon@ifup.org>
> To: Jon Lowe <jonlowe@aol.com> Cc: video4linux-list@redhat.com Sent:
> Mon, 21 Apr 2008 11:07 pm Subject: Re: [BUG] HVR-1500 Hot swap causes
> lockup
> 
> On 09:59 Sat 19 Apr 2008, Jon Lowe wrote:
> > Hope this is the right place to do this.
> >
> > Hauppauge HVR-1500 Expresscard, Ubuntu 8.04, latest V4L drivers.
> >
> > Removing (hotswap) this card from a ASUS F3SV laptop running Ubuntu
> > 8.04 causes a hard lock up of the computer.? Unresponsive to any
> > input. Requires complete shutdown of the computer and restart.?
> > Easily repeatable.? Same card is hot swappable under Windows Vista.? 
> >
> > This is critical because Expresscards are notoriously easy to
> > dislodge in notebooks.?
> 
> Could you please setup a netconsole and try and get some debugging
> output?
> 
> For details on setting up a netconsole see the documentation:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob_plain;f=Documentation/networking/netconsole.txt;hb=HEAD

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
