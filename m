Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7VGkN16004985
	for <video4linux-list@redhat.com>; Sun, 31 Aug 2008 12:46:25 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7VGbQWT023569
	for <video4linux-list@redhat.com>; Sun, 31 Aug 2008 12:37:32 -0400
From: Andy Walls <awalls@radix.net>
To: Daniel =?ISO-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
In-Reply-To: <20080830151233.GA221@daniel.bse>
References: <200808251445.22005.jdelvare@suse.de>
	<200808281611.38241.jdelvare@suse.de> <20080828202043.GB824@daniel.bse>
	<200808301201.47561.jdelvare@suse.de> <20080830151233.GA221@daniel.bse>
Content-Type: text/plain; charset=utf8
Date: Sun, 31 Aug 2008 12:37:12 -0400
Message-Id: <1220200632.2640.1.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org,
	Jean Delvare <jdelvare@suse.de>
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

On Sat, 2008-08-30 at 17:12 +0200, Daniel Glöckner wrote:


> A smaller trigger point will make the PCI bus less idle but the average
> FIFO fill will be lower.
> 
> Yesterday I wrote a small program that simulates a number of PCI masters
> with constant data rate filling their FIFOs. There is a simple round
> robin arbiter and neither the target nor the master needs wait cycles.
> 
> For 5 masters with 24.2MB/s each (peak data rate of YUY2 640x480 NTSC),
> a latency counter of 254, and a FIFO trigger of 4, the bus is never idle.
> The maximum FIFO fill is 16 DWords. With a latency counter below 20,
> the FIFO fill rises infinitely.
> 
> With a FIFO trigger of 32 and a latency counter of 254, the maximum fill
> is 33 DWords and the bus is 4.5% idle.
> 
> Those 17 less FIFO entries in the 4-entry-trigger case can buffer for 93
> PCI cycles. The 4.5% idle cycles in the 32-entry-trigger case are wasted
> if there is no other master on the bus, as is the case when the Bt878s are
> behind a bridge.
> 
> In reality there are always idle phases during syncs and additional
> traffic will be generated to fetch RISC instructions and to access
> registers.

Modeling, simulation and analysis.  Very cool. :)

Regards,
Andy

>   Daniel
> 


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
