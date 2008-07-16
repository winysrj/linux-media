Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6G7WtsR014764
	for <video4linux-list@redhat.com>; Wed, 16 Jul 2008 03:32:55 -0400
Received: from metis.extern.pengutronix.de (metis.extern.pengutronix.de
	[83.236.181.26])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6G7WfQI032735
	for <video4linux-list@redhat.com>; Wed, 16 Jul 2008 03:32:42 -0400
Date: Wed, 16 Jul 2008 09:32:17 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Message-ID: <20080716073217.GB4319@pengutronix.de>
References: <20080715135618.GE6739@pengutronix.de>
	<20080715140141.GG6739@pengutronix.de>
	<Pine.LNX.4.64.0807152224040.6361@axis700.grange>
	<20080716054922.GI6739@pengutronix.de>
	<20080716064336.GK6739@pengutronix.de>
	<Pine.LNX.4.64.0807160845450.11471@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0807160845450.11471@axis700.grange>
Cc: video4linux-list@redhat.com
Subject: Re: PATCH: soc-camera: use flag for colour / bw camera instead of
	module parameter
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

On Wed, Jul 16, 2008 at 09:19:44AM +0200, Guennadi Liakhovetski wrote:
> But I can also imagine cases when end-users would benefit from this
> module parameter: think about a company producing two cameras - one
> with colour and one with bw sensor. With the module parameter they
> only have to load drivers / the kernel differently, with platform data
> they have to maintain two kernel versions.

They can also put the definitions in a separate module and load them
according to their needs.

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
