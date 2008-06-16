Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5GEtVcD026055
	for <video4linux-list@redhat.com>; Mon, 16 Jun 2008 10:55:31 -0400
Received: from metis.extern.pengutronix.de (metis.extern.pengutronix.de
	[83.236.181.26])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5GEtJCR005216
	for <video4linux-list@redhat.com>; Mon, 16 Jun 2008 10:55:19 -0400
Date: Mon, 16 Jun 2008 16:55:11 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Message-ID: <20080616145511.GB21869@pengutronix.de>
References: <48512E08.6020608@teltonika.lt>
	<Pine.LNX.4.64.0806121748070.18017@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0806121748070.18017@axis700.grange>
Cc: Greg KH <greg@kroah.com>, video4linux-list@redhat.com,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Subject: Re: SoC camera crashes when host is not module
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

On Thu, Jun 12, 2008 at 05:51:42PM +0200, Guennadi Liakhovetski wrote:
> BTW, I'd love to see at least one of those i.MX CSI drivers I only get to 
> hear about and never to see one...

We have them in the internal linux-latest series; however, it is based
on the entire i.MX support, and as long as we don't get this forward
through alkml, it will be stuck ...

However, next series was posted today, so let's hope for some progress.

rsc
-- 
 Dipl.-Ing. Robert Schwebel | http://www.pengutronix.de
 Pengutronix - Linux Solutions for Science and Industry
   Handelsregister:  Amtsgericht Hildesheim, HRA 2686
     Hannoversche Str. 2, 31134 Hildesheim, Germany
   Phone: +49-5121-206917-0 |  Fax: +49-5121-206917-9

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
