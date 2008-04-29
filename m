Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3T8tMAh018126
	for <video4linux-list@redhat.com>; Tue, 29 Apr 2008 04:55:22 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3T8svvr031532
	for <video4linux-list@redhat.com>; Tue, 29 Apr 2008 04:54:57 -0400
Date: Tue, 29 Apr 2008 04:54:57 -0400 (EDT)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: =?iso-8859-1?Q?Vicent_Jord=E0?= <vjorda@hotmail.com>
In-Reply-To: <BAY109-W55EF752D25B0EAF1361C40CBDE0@phx.gbl>
Message-ID: <Pine.LNX.4.64.0804290444440.22785@bombadil.infradead.org>
References: <BAY109-W5337BE0CEB1701C6AC945ACBDE0@phx.gbl>
	<20080428114741.040ccfd6@gaivota>
	<BAY109-W55EF752D25B0EAF1361C40CBDE0@phx.gbl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: video4linux-list@redhat.com
Subject: RE: Trying to set up a NPG Real DVB-T PCI Card
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

This is what we need:

> MO_GP0_IO:                       000004fb   (00000000 00000000 00000100 11111011)
> MO_GP1_IO:                       000000ff   (00000000 00000000 00000000 11111111)
> MO_GP2_IO:                       00000001   (00000000 00000000 00000000 00000001)
> MO_GP3_IO:                       00000000   (00000000 00000000 00000000 00000000)

Those GPIO registers controls external devices. you'll need to start 
regedit before your video app. There's a mode at regspy that tracks 
changes on register. After starting, you'll have those values changed.

The firmware load happens when you change from PAL to NTSC. You may try to 
do this on your software and see what register will change.

For example, let's say that GPIO2 has xc3028 reset pin at bit 1. You'll 
notice something like this, during reset:

> MO_GP2_IO:                       00000001   (00000000 00000000 00000000 00000001)
> MO_GP2_IO:                       00000003   (00000000 00000000 00000000 00000011)
> MO_GP2_IO:                       00000001   (00000000 00000000 00000000 00000001)

Cheers,
Mauro.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
