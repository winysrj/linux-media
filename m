Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3M47whe025007
	for <video4linux-list@redhat.com>; Tue, 22 Apr 2008 00:07:58 -0400
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.174])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3M47lYk026874
	for <video4linux-list@redhat.com>; Tue, 22 Apr 2008 00:07:47 -0400
Received: by wf-out-1314.google.com with SMTP id 28so1469823wfc.6
	for <video4linux-list@redhat.com>; Mon, 21 Apr 2008 21:07:46 -0700 (PDT)
Date: Mon, 21 Apr 2008 21:07:28 -0700
From: Brandon Philips <brandon@ifup.org>
To: Jon Lowe <jonlowe@aol.com>
Message-ID: <20080422040728.GD24855@plankton.ifup.org>
References: <8CA703CA994FDB6-D6C-ADB@webmail-me16.sysops.aol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8CA703CA994FDB6-D6C-ADB@webmail-me16.sysops.aol.com>
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

On 09:59 Sat 19 Apr 2008, Jon Lowe wrote:
> Hope this is the right place to do this.
>
> Hauppauge HVR-1500 Expresscard, Ubuntu 8.04, latest V4L drivers.
>
> Removing (hotswap) this card from a ASUS F3SV laptop running Ubuntu
> 8.04 causes a hard lock up of the computer.? Unresponsive to any
> input. Requires complete shutdown of the computer and restart.? Easily
> repeatable.? Same card is hot swappable under Windows Vista.? 
>
> This is critical because Expresscards are notoriously easy to dislodge
> in notebooks.?

Could you please setup a netconsole and try and get some debugging
output?

For details on setting up a netconsole see the documentation:
  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob_plain;f=Documentation/networking/netconsole.txt;hb=HEAD

Thanks,

	Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
