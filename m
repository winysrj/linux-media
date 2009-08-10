Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n7A71qbX027552
	for <video4linux-list@redhat.com>; Mon, 10 Aug 2009 03:01:52 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de
	[92.198.50.35])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n7A71Xf5010702
	for <video4linux-list@redhat.com>; Mon, 10 Aug 2009 03:01:34 -0400
Date: Mon, 10 Aug 2009 09:01:33 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: javier Martin <javier.martin@vista-silicon.com>
Message-ID: <20090810070133.GB13320@pengutronix.de>
References: <eedb5540908060842rb7e2ac7g920310563fa8ddb4@mail.gmail.com>
	<20090807192045.GK5842@pengutronix.de>
	<eedb5540908092351v7b46b392i1a3c697a906c87dd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <eedb5540908092351v7b46b392i1a3c697a906c87dd@mail.gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: H.264 format support?
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

On Mon, Aug 10, 2009 at 08:51:49AM +0200, javier Martin wrote:
> > If I remember correctly, Freescale has H.264 encoding in the same
> > package that also contains MPEG4 stuff, both as gstreamer plugins.
>
> Yes, I know Freescale has it integrated in the same package, but the
> truth is that in V4L2 there is no definition for H264 output format.
> That makes a little difficult for a driver which outputs H.264 to
> enter mainline kernel. That is why I am asking for an H.264 output
> format definition..

Well, that's why using gstreamer for the encoding stage looks like a
good solution for me. If it needs something on the definition layer
(i.e. new color space 4cc definitions etc) it is usually solvable.

> See V4L2 API spec:
> http://www.linuxtv.org/downloads/video4linux/API/V4L2_API/spec-single/v4l2.html#AEN5634
>
> > Check how it is integrated in OSELAS.Phytec-phyCORE-12-1:
> > http://www.pengutronix.de/oselas/bsp/phytec/download/phyCORE/OSELAS.BSP-Phytec-phyCORE-12-1.tar.gz
>
> Thank you for the link, I will take a look at it.

Yup. If you are missing something, please ask back again.

rsc
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
