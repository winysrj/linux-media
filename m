Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m97IbQfu023002
	for <video4linux-list@redhat.com>; Tue, 7 Oct 2008 14:37:26 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m97IbNAr015609
	for <video4linux-list@redhat.com>; Tue, 7 Oct 2008 14:37:24 -0400
Date: Tue, 7 Oct 2008 20:37:01 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Brian Phelps <lm317t@gmail.com>
Message-ID: <20081007183701.GA3167@daniel.bse>
References: <ea3b75ed0810070657i2f673bb1ub858b2871d7b387a@mail.gmail.com>
	<20081007145206.GA1664@daniel.bse>
	<ea3b75ed0810070934y6fd6a720g42173e0b93eca578@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea3b75ed0810070934y6fd6a720g42173e0b93eca578@mail.gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: capture.c example (multiple inputs)
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

On Tue, Oct 07, 2008 at 12:34:50PM -0400, Brian Phelps wrote:
> I am a bit of a newbie the concept of PCI buses. In this example (not
> mine) is the 1e that the bt878 card is on, on a different bus than the
> IDE controller, 1f?:

PCI busses always form a logical tree structure with the CPU at its root.
So there will always be one bus in the lspci -tv diagram that appears
to be affected by capturing and harddisk access. If this bus (and every
other bus between it and main memory) is plain 33 MHz 32 bit PCI, you're
out of luck. If it is PCIe, PCI-X, 66 MHz PCI, or 64 bit PCI (assuming
the non-PCIe busses are not throttled to 33 MHz/32 bit during transfers),
it should be possible to transfer the incoming data to the harddisk
controller.

> -[00]-+-00.0  Intel Corporation 82845G/GL[Brookdale-G]/GE/PE DRAM
> Controller/Host-Hub Interface
>       +-1e.0-[01]--+-02.0  Brooktree Corporation Bt878 Video Capture
>       |            +-02.1  Brooktree Corporation Bt878 Audio Capture
>       +-1f.1  Intel Corporation 82801DB (ICH4) IDE Controller

In your example the IDE controller is in the same chip that provides the
PCI interface. The datasheet says:

"By placing the I/O bridge on the hub interface (instead of PCI), the hub
architecture ensures that both the I/O functions integrated into the ICH4
and the PCI peripherals obtain the bandwidth necessary for peak performance."

According to Wikipedia (couldn't find it in the datasheet..) the hub
interface to the host controller is 266 MHz 8 bit.

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
