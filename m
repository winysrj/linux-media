Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB3I1hHa026819
	for <video4linux-list@redhat.com>; Wed, 3 Dec 2008 13:01:43 -0500
Received: from psychosis.jim.sh (a.jim.sh [75.150.123.25])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB3I1UA4007841
	for <video4linux-list@redhat.com>; Wed, 3 Dec 2008 13:01:30 -0500
Date: Wed, 3 Dec 2008 13:01:28 -0500
From: Jim Paris <jim@jtan.com>
To: Antonio Ospite <ospite@studenti.unina.it>
Message-ID: <20081203180128.GA19180@psychosis.jim.sh>
References: <20081125235249.d45b50f4.ospite@studenti.unina.it>
	<1227777784.1752.20.camel@localhost>
	<20081127120536.62b35cd6.ospite@studenti.unina.it>
	<1227788553.1752.42.camel@localhost>
	<20081127145233.f467442a.ospite@studenti.unina.it>
	<20081203174528.712f1549.ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081203174528.712f1549.ospite@studenti.unina.it>
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] gspca_ov534: Print only frame_rate actually used.
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

Hi Antonio,

Antonio Ospite wrote:
> it turned out that on PS3 the big current bulk_size doesn't work,
> because here the hardware needs contiguous memory for transfers (if
> the description is somewhat imprecise please correct me) and it is not
> always possible to allocate such a big contiguous chunk, so we have to
> use a smaller fixed size for bulk transfers and fill the frame in
> several passes in pkt_scan.

Such a large bulk_size is probably not a good idea on any system.
The PS3 in particular is already memory constrained so it's definitely
a good idea to break that up.

> I am preparing some patches, but I come across a problem.
> 
> Now I use this code in pkt_scan (I add a zero length FIRST_PACKET in
> sd_start):
> 
> 	if ((frame->data_end - frame->data + len) == (framesize - 4)) {
> 		PDEBUG(D_PACK, "  end of frame?");
> 		gspca_frame_add(gspca_dev, INTER_PACKET, frame, data, len);
> 		frame = gspca_frame_add(gspca_dev, LAST_PACKET, frame, last, 4);
> 		gspca_frame_add(gspca_dev, FIRST_PACKET, frame, data, 0);
> 	} else
> 		gspca_frame_add(gspca_dev, INTER_PACKET, frame, data, len);
...
> It looks like something is failing in gspca_frame_add(), it doesn't get
> to the statement frame->data_end = frame->data; when adding the
> FIRST_PACKET. That could be because the packet has been queued but not
> added yet, AFAIU. How to deal with such case?

If gspca decides to discard a frame with DISCARD_PACKET, I believe it
won't start working again until you send another FIRST_PACKET.  In
your code, if DISCARD_PACKET ever happens, the frame->data pointers
won't get updated so you'll never get to FIRST_PACKET?

> As a side note, if I use this check to detect the end of the frame:
> 
> 	if (len < gspca_dev->cam.bulk_size) {
> 		...
> 	} else ...
> 
> I can recover from the previous error even if I get some frame
> discarded from time to time. Is this check acceptable to you If I take
> care that framesize is not a multiple of bulk_size?

Hold off a bit on this work.

There's a problem with breaking up the transfers, because we're not
currently getting any header data from the bridge chip that lets us
know when we really hit the end of a frame, and it's easy to get out
of sync.  Using (len < bulk_size) is a good trick if they're not a
multiple, as you say, since the last payload will be shorter, but I
have a better solution -- I found how to get the camera to add a
UVC-format header on each payload.  I'm finishing up the patch and
will post it a bit later today once I iron out a few bugs.

-jim

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
