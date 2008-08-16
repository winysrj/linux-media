Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7GBlRJv022577
	for <video4linux-list@redhat.com>; Sat, 16 Aug 2008 07:47:27 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7GBlD0i032220
	for <video4linux-list@redhat.com>; Sat, 16 Aug 2008 07:47:13 -0400
Date: Sat, 16 Aug 2008 08:47:04 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Message-ID: <20080816084704.60709971@mchehab.chehab.org>
In-Reply-To: <48A689C1.7070007@hhs.nl>
References: <20080816050023.GB30725@thumper> <48A67A8D.8040104@hhs.nl>
	<7813ee860808160046s60de698bu307ab5255631a5e@mail.gmail.com>
	<48A689C1.7070007@hhs.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] Add support for OmniVision OV534 based USB cameras.
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

On Sat, 16 Aug 2008 10:03:13 +0200
> > I would definitely be willing to merge the code into an existing driver,
> > though I was under the impression that the gspca core was for ISOC based
> > USB devices.  The ov534's imagine end-point is bulk transfer, with the
> > audio endpoints being isoc.
> > 
> 
> Ah yes it is I didn't know non isoc cams existed, so thats why your driver is 
> so small I already was sorta missing the isoc setup stufff :)

The usage of videobuf simplifies a lot the driver logic. That's why it is so small :)

I think it would be good if gspca could also use videobuf in the future.


> In that case its fine as is. Mauro as this is a new driver and looks clean (and 
> uses videobuf) any chance this can get merged for 2.6.27 ?

Maybe. I'll see when I receive Mark updates.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
