Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7H7GDRe027607
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 03:16:13 -0400
Received: from smtp8-g19.free.fr (smtp8-g19.free.fr [212.27.42.65])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7H7FUs5005640
	for <video4linux-list@redhat.com>; Sun, 17 Aug 2008 03:15:30 -0400
From: Jean-Francois Moine <moinejf@free.fr>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <20080816084704.60709971@mchehab.chehab.org>
References: <20080816050023.GB30725@thumper> <48A67A8D.8040104@hhs.nl>
	<7813ee860808160046s60de698bu307ab5255631a5e@mail.gmail.com>
	<48A689C1.7070007@hhs.nl> <20080816084704.60709971@mchehab.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1
Date: Sun, 17 Aug 2008 09:03:17 +0200
Message-Id: <1218956597.1706.24.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
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

On Sat, 2008-08-16 at 08:47 -0300, Mauro Carvalho Chehab wrote:
> On Sat, 16 Aug 2008 10:03:13 +0200
> > > I would definitely be willing to merge the code into an existing driver,
> > > though I was under the impression that the gspca core was for ISOC based
> > > USB devices.  The ov534's imagine end-point is bulk transfer, with the
> > > audio endpoints being isoc.
> > > 
> > 
> > Ah yes it is I didn't know non isoc cams existed, so thats why your driver is 
> > so small I already was sorta missing the isoc setup stufff :)

Hello Mauro and Hans,

The code for bulk transfer existed in the first versions, but, as no
webcam used it, I removed. It should be easy to put it back.

> The usage of videobuf simplifies a lot the driver logic. That's why it is so small :)
> 
> I think it would be good if gspca could also use videobuf in the future.

I think that videobuf is rather complex for handling usually less than 8
buffers (max = 16 in gspca) and it asks for a mutex at irq level. My
buffer handling also offers a very small memory overhead...

Cheers.

-- 
Ken ar c'hentañ |             ** Breizh ha Linux atav! **
Jef             |               http://moinejf.free.fr/


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
