Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m880qMtp021223
	for <video4linux-list@redhat.com>; Sun, 7 Sep 2008 20:52:22 -0400
Received: from mail1.radix.net (mail1.radix.net [207.192.128.31])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m880qAbx014088
	for <video4linux-list@redhat.com>; Sun, 7 Sep 2008 20:52:10 -0400
From: Andy Walls <awalls@radix.net>
To: Jejo Koola <jdkoola@gmail.com>
In-Reply-To: <ced06bb70809051119v5cb4fc09tc5d06ac6208dd52d@mail.gmail.com>
References: <ced06bb70809051119v5cb4fc09tc5d06ac6208dd52d@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 07 Sep 2008 20:51:58 -0400
Message-Id: <1220835118.2645.29.camel@morgan.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Hauppauge HVR-1600 (cx18): high pitched audio distortion for
	ATSC
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

On Fri, 2008-09-05 at 14:19 -0400, Jejo Koola wrote: 
> I'm using the cx18 driver on a Mythbuntu 8.0.4 system running the HVR-1600.
> Everything works well for NTSC; however, for OTA ATSC, there are very
> high-pitched bursts through the speaker that occur every few minutes.

For ATSC, OTA or Cable, the CX23418 essentially acts as a passthrough
for moving TS packets from the digital demod chip to memory buffers.

Here are some things to try:

1. Use the latest cx18 driver from the v4l-dvb repository.  I recently
fixed some buffer handling problems and that may make a difference.
(You may have to set the mmio_ndelay module parameter to 0.)

2. Use femon and azap to monitor the signal and see if errors occur
"every few minutes".  If they do, you may want to take actions to
improve signal strength.

3. If those don't help, send small sample of the TS with the problem to
me in an off list e-mail.  I'll can take a look at it to see if I can
spot anything unusual.

Regards,
Andy

>   Some
> channels are worse than others, but it seems to be present on all channels.
> There are no problems with the video reception.
> 
> Any ideas would be appreciated.


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
