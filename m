Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7R3kaHr018365
	for <video4linux-list@redhat.com>; Tue, 26 Aug 2008 23:46:37 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7R3kMFH032568
	for <video4linux-list@redhat.com>; Tue, 26 Aug 2008 23:46:22 -0400
From: Andy Walls <awalls@radix.net>
To: Trent Piepho <xyzzy@speakeasy.org>
In-Reply-To: <Pine.LNX.4.58.0808261911000.2423@shell2.speakeasy.net>
References: <200808251445.22005.jdelvare@suse.de>
	<1219711251.2796.47.camel@morgan.walls.org>
	<20080826232913.GA2145@daniel.bse>
	<Pine.LNX.4.58.0808261911000.2423@shell2.speakeasy.net>
Content-Type: text/plain
Date: Tue, 26 Aug 2008 23:45:10 -0400
Message-Id: <1219808710.2929.8.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
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

On Tue, 2008-08-26 at 19:20 -0700, Trent Piepho wrote:
> On Wed, 27 Aug 2008, Daniel [iso-8859-1] Glckner wrote:

> Isn't the latency timer in units of 250 ns, not PCI cycles?

Latency timer is in PCI clock cycles.  Most devices ignore the 3 least
significant bits of the setting (as allowed/suggested by the PCI spec),
making most latency timers as multiple of 8 PCI clock cycles.  

MIN_GNT and MAX_LAT are in units of 250 ns according to the PCI spec.
I'm assuming it's no coincidence that 8 PCI clock cycles = 8/33 MHZ =
242.4 ns or approximately 250 ns.

-Andy

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
