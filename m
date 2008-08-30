Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7U0BbF1001859
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 20:11:38 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m7U0BESM017621
	for <video4linux-list@redhat.com>; Fri, 29 Aug 2008 20:11:14 -0400
Date: Sat, 30 Aug 2008 02:10:38 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Trent Piepho <xyzzy@speakeasy.org>
Message-ID: <20080830001038.GA609@daniel.bse>
References: <200808251445.22005.jdelvare@suse.de>
	<1219711251.2796.47.camel@morgan.walls.org>
	<200808281658.28151.jdelvare@suse.de>
	<1220011778.3174.19.camel@morgan.walls.org>
	<Pine.LNX.4.58.0808291517030.24305@shell4.speakeasy.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0808291517030.24305@shell4.speakeasy.net>
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

On Fri, Aug 29, 2008 at 03:23:16PM -0700, Trent Piepho wrote:
> Or get something like viewcast's multi-bttv cards that use a PCI to PCI-E
> bridge.

The DVC-5215 card Jean mentioned in his first post is a PCIe card.
The bridge visible on the card must be a TI XIO2000A with external
PCI arbiter. It allows to tweak some QoS parameters for PCIe traffic
that might be helpful.

Btw., for cards with PCI-PCI bridge the latency counter of the bridge
on the main bus should be set to a high value to give it an advantage
to flush its buffers.

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
