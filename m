Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5GFPVtZ018614
	for <video4linux-list@redhat.com>; Mon, 16 Jun 2008 11:25:31 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m5GFOwrv025930
	for <video4linux-list@redhat.com>; Mon, 16 Jun 2008 11:24:59 -0400
Date: Mon, 16 Jun 2008 17:25:11 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
To: Robert Schwebel <r.schwebel@pengutronix.de>
In-Reply-To: <20080616151929.GC21869@pengutronix.de>
Message-ID: <Pine.LNX.4.64.0806161724230.13459@axis700.grange>
References: <48512E08.6020608@teltonika.lt>
	<Pine.LNX.4.64.0806121748070.18017@axis700.grange>
	<20080616145511.GB21869@pengutronix.de> <485681DE.4010701@teltonika.lt>
	<20080616151929.GC21869@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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

On Mon, 16 Jun 2008, Robert Schwebel wrote:

> On Mon, Jun 16, 2008 at 06:08:14PM +0300, Paulius Zaleckas wrote:
> > Robert Schwebel wrote:
> >> On Thu, Jun 12, 2008 at 05:51:42PM +0200, Guennadi Liakhovetski wrote:
> >>> BTW, I'd love to see at least one of those i.MX CSI drivers I only 
> >>> get to hear about and never to see one...
> >>
> >> We have them in the internal linux-latest series; however, it is based
> >> on the entire i.MX support, and as long as we don't get this forward
> >> through alkml, it will be stuck ...
> >
> > I have written driver for i.MX1/L... Its not finished yet, but generally
> > working :) Should we cooperate here?
> 
> Our driver is for the i.MX27, so probably a different beast, right?
> 
> However, if you send me the patches, we can integrate it into our next
> i.MX series.

Please, don't forget, that camera drivers should also be reviewed and 
acked on the v4l list.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
