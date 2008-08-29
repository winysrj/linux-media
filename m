Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7TMNTvK010995
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 18:23:30 -0400
Received: from mail1.sea5.speakeasy.net (mail1.sea5.speakeasy.net
	[69.17.117.3])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7TMNHuJ029670
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 18:23:17 -0400
Date: Fri, 29 Aug 2008 15:23:16 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Andy Walls <awalls@radix.net>
In-Reply-To: <1220011778.3174.19.camel@morgan.walls.org>
Message-ID: <Pine.LNX.4.58.0808291517030.24305@shell4.speakeasy.net>
References: <200808251445.22005.jdelvare@suse.de>
	<1219711251.2796.47.camel@morgan.walls.org>
	<200808281658.28151.jdelvare@suse.de>
	<1220011778.3174.19.camel@morgan.walls.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Linux and Kernel Video <video4linux-list@redhat.com>,
	v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
	Jean Delvare <jdelvare@suse.de>
Subject: Re: [v4l-dvb-maintainer] bttv driver questions
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

On Fri, 29 Aug 2008, Andy Walls wrote:
> On Thu, 2008-08-28 at 16:58 +0200, Jean Delvare wrote:
> Consistently meeting the real-time communications needs of the 8 BT878's
> and the disks on the PCI bus could well be impossible with (the very
> common) round robin arbiters.

Trying to capture 8 full resolution streams on one PCI bus is probably
impossible, but with a NIC or HD controller on the same bus, forget it.

You'd need to get a chipset with multiple busses and put the capture card
on its own bus.

Or get something like viewcast's multi-bttv cards that use a PCI to PCI-E
bridge.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
