Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3DLCSMn026319
	for <video4linux-list@redhat.com>; Sun, 13 Apr 2008 17:12:28 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3DLCCxh005073
	for <video4linux-list@redhat.com>; Sun, 13 Apr 2008 17:12:12 -0400
Date: Sun, 13 Apr 2008 18:10:18 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Markus Rechberger <mrechberger@empiatech.com>
Message-ID: <20080413181018.7ac689cd@areia>
In-Reply-To: <529381.57396.qm@web907.biz.mail.mud.yahoo.com>
References: <20080413172207.4276a17f@areia>
	<529381.57396.qm@web907.biz.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Video <video4linux-list@redhat.com>
Subject: Re: [ANNOUNCE] Videobuf improvements to allow its usage with USB
 drivers
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

> my eeePC shows up 0-5% CPU usage with mplayer
> fullscreen without videobuf, seems more like
> something's broken in your testapplication or
> somewhere else?

The test application (capture_example) is the one documented at the V4L2 spec.
The only difference is that I've incremented count to 1000, to get more frames.
I don't see what's wrong on it.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
