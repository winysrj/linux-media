Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n77JJ5Gk003950
	for <video4linux-list@redhat.com>; Fri, 7 Aug 2009 15:19:05 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de
	[92.198.50.35])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n77JIlZk001697
	for <video4linux-list@redhat.com>; Fri, 7 Aug 2009 15:18:47 -0400
Date: Fri, 7 Aug 2009 21:18:09 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: javier Martin <javier.martin@vista-silicon.com>
Message-ID: <20090807191809.GJ5842@pengutronix.de>
References: <eedb5540908060552n43021d5bla6ee655c294307eb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <eedb5540908060552n43021d5bla6ee655c294307eb@mail.gmail.com>
Cc: video4linux-list@redhat.com, Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sascha Hauer <sha@pengutronix.de>
Subject: Re: soc-camera driver for i.MX27
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

On Thu, Aug 06, 2009 at 02:52:31PM +0200, javier Martin wrote:
> we are trying to develop a soc-camera host driver for the i.MX27 cpu
> and include it in mainline kernel.
> We have read that there is an out-of-tree patch for this. Maybe if
> someone could point us to it we could use as a base for our
> development.

We have a driver for the phyCORE-i.MX27 board:
http://git.pengutronix.de/?p=phytec/linux-2.6.git;a=blob;f=drivers/media/video/mx27_camera.c;h=9e9f4426c3db890e6fc13130e047c65c073aa0b4;hb=refs/heads/phytec-master

Sascha, can you comment on the status regarding mainline?

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
