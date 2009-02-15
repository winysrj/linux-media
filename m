Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n1FLvbPk002440
	for <video4linux-list@redhat.com>; Sun, 15 Feb 2009 16:57:37 -0500
Received: from smtp120.rog.mail.re2.yahoo.com (smtp120.rog.mail.re2.yahoo.com
	[68.142.224.75])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n1FLvN1Y010399
	for <video4linux-list@redhat.com>; Sun, 15 Feb 2009 16:57:23 -0500
Message-ID: <49988FC2.3000800@rogers.com>
Date: Sun, 15 Feb 2009 16:57:22 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: "Chris S. Wilson" <info@coolcatpc.com>
References: <001801c98962$3ab5e7d0$b021b770$@com>
In-Reply-To: <001801c98962$3ab5e7d0$b021b770$@com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: ViXS & ATI Pro 550
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

Chris S. Wilson wrote:
> I have a few devices I'm trying to find more information on, from what I've
> read out there, there is not much support for the ViXS 2100 series or the
> ATI 550 Pro Chipsets.
>   

There is zero support for either.

> I was wondering if anyone had any knowledge as to how to get these devices
> working. 
>   

First, a driver for those chipsets has to be written and then, second,
device specific information has to be added to the drivers. This also
assume that the other components on the devices are already supported.

> Here is my LSPCI output:
>
>
> 04:00.0 Multimedia controller: ViXS Systems, Inc. XCode 2100 Series
>
> 1:05.0 Multimedia controller: ATI Technologies Inc Theater 550 PRO PCI [ATI
> TV Wonder 550]
>   

"lspci" alone doesn't tell us anything we don't already know -- i.e.
that the devices use the 550 or 2100 chipsets. The information that
you'd want to supply, under other circumstances, is "lspci -vnn", as it
provides, amongst other things, the subsystem ID information for your
device. In any regard, given that there is no driver for either of those
ICs, such information is at this point in time not particularly germane.

> I've been messing with this issue for the past couple of weeks, with no
> luck. If anyone out there knows anything please let me know ;) the cards are
> nice and I'd like to be able to use them.

ViXS has been advertising for a Linux kernel driver developer for a
while, so perhaps there is some hope on that front. You could always
enquire directly with them as to what their intentions are in regards to
Linux.

AFAIK, there has been no word from AMD in regards to Linux and the 550 &
650 components. Given the tougher economic climate, I can't see them
initiating something like they have for their GPUs. Though perhaps they
would be open something less formal. Again, you could enquire directly
with them. The more people who bug them, the more they might consider
something

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
