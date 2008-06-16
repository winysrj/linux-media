Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5GFbfID030432
	for <video4linux-list@redhat.com>; Mon, 16 Jun 2008 11:37:41 -0400
Received: from metis.extern.pengutronix.de (metis.extern.pengutronix.de
	[83.236.181.26])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5GFaODS001098
	for <video4linux-list@redhat.com>; Mon, 16 Jun 2008 11:36:25 -0400
Date: Mon, 16 Jun 2008 17:36:18 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
Message-ID: <20080616153618.GD21869@pengutronix.de>
References: <48512E08.6020608@teltonika.lt>
	<Pine.LNX.4.64.0806121748070.18017@axis700.grange>
	<20080616145511.GB21869@pengutronix.de>
	<485681DE.4010701@teltonika.lt>
	<20080616151929.GC21869@pengutronix.de>
	<Pine.LNX.4.64.0806161724230.13459@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0806161724230.13459@axis700.grange>
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

On Mon, Jun 16, 2008 at 05:25:11PM +0200, Guennadi Liakhovetski wrote:
> Please, don't forget, that camera drivers should also be reviewed and
> acked on the v4l list.

Sure. It's just to make sure that it does still apply ontop of the imx
rework. The non-arm stuff has to go through the responsible maintainers
anyway. So if it's MX1/MXL, it should not be related to i.MX27, so
the v4l list would be a better choice.

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
