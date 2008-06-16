Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5GGAR3J029059
	for <video4linux-list@redhat.com>; Mon, 16 Jun 2008 12:10:28 -0400
Received: from metis.extern.pengutronix.de (metis.extern.pengutronix.de
	[83.236.181.26])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5GG9dHF023568
	for <video4linux-list@redhat.com>; Mon, 16 Jun 2008 12:09:53 -0400
Date: Mon, 16 Jun 2008 18:09:25 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Message-ID: <20080616160925.GE21869@pengutronix.de>
References: <48512E08.6020608@teltonika.lt>
	<Pine.LNX.4.64.0806121748070.18017@axis700.grange>
	<20080616145511.GB21869@pengutronix.de>
	<485681DE.4010701@teltonika.lt>
	<20080616151929.GC21869@pengutronix.de>
	<48568C5E.6050800@teltonika.lt>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <48568C5E.6050800@teltonika.lt>
Cc: Greg KH <greg@kroah.com>, video4linux-list@redhat.com,
	Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>,
	Sascha Hauer <sha@pengutronix.de>
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

On Mon, Jun 16, 2008 at 06:53:02PM +0300, Paulius Zaleckas wrote:
> I have just checked "Reference Manual" and apart from couple missing
> modes and interrupts in MXL it looks extremely similar.
>
> Don't you have a problem that SOF interrupt is triggered too late?

I've set Sascha Hauer on Cc: who has written the driver. If the hardware
is so similar, we should merge the both drivers.

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
