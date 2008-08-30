Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7UGjq8P011020
	for <video4linux-list@redhat.com>; Sat, 30 Aug 2008 12:45:53 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m7UGjMWg003297
	for <video4linux-list@redhat.com>; Sat, 30 Aug 2008 12:45:22 -0400
Date: Sat, 30 Aug 2008 18:44:44 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Jean Delvare <jdelvare@suse.de>
Message-ID: <20080830164444.GA263@daniel.bse>
References: <200808251445.22005.jdelvare@suse.de>
	<Pine.LNX.4.58.0808291517030.24305@shell4.speakeasy.net>
	<20080830001038.GA609@daniel.bse>
	<200808300954.19361.jdelvare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808300954.19361.jdelvare@suse.de>
Cc: v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
	Linux and Kernel Video <video4linux-list@redhat.com>,
	Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: bttv driver questions
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

On Sat, Aug 30, 2008 at 09:54:18AM +0200, Jean Delvare wrote:
> But I have to admit that I'm not really sure how the different PCI
> Express slots relate to each other. Does each slot have its own bus
> and thus bandwidth? Or is the same PCI Express bus shared by all
> slots as is usually the case for PCI?

Each slot has the full bandwidth, but the receiving end can stop the
transmitter if it has no space left in its buffer.

> And what about the motherboards
> which have both PCI and PCI Express slots/on-board devices?

There will be a PCI-PCIe bridge. Both busses will be independent as
long as they don't exchange data.

> I see no reference to the XIO2000 in the kernel source tree. If I am
> supposed to tweak QoS parameters, how would I do that?

Having read the XIO2000 datasheet I would try to use the second VC with
a higher traffic class for access from the PCI bus to memory.
The configuration of the bridge should be modifiable with setpci.
Other chips might need tweaking too for this to have effect.

> According to "lspci -vv" the latency timer of the bridge is set to 0.

The latency timer is meaningless for PCIe.
The secondary, PCI bus has a separate latency timer, but I wouldn't set
that one to a high value.

> As far as I remember, all PCI-PCI bridges I've ever seen always had
> their latency timer set to 0.

0 is the default for a bridge after reset.

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
