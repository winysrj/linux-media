Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBM9XcFN014976
	for <video4linux-list@redhat.com>; Mon, 22 Dec 2008 04:33:38 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de
	[92.198.50.35])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBM9XLr2030190
	for <video4linux-list@redhat.com>; Mon, 22 Dec 2008 04:33:22 -0500
Date: Mon, 22 Dec 2008 10:32:51 +0100
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Agustin <gatoguan-os@yahoo.com>
Message-ID: <20081222093250.GM22230@pengutronix.de>
References: <20081218170015.10DD88E03CC@hormel.redhat.com>
	<44440.83878.qm@web32104.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <44440.83878.qm@web32104.mail.mud.yahoo.com>
Cc: video4linux-list@redhat.com, Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sascha Hauer <sha@pengutronix.de>
Subject: Re: soc-camera: current stack
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

Hi Agustin,

On Fri, Dec 19, 2008 at 03:58:46AM -0800, Agustin wrote:
> I was about to try this stack on my Phytec i.MX31 system when I found
> there is no mx3_camera driver in it. Too bad!

We are working hard on a mainline quality patch series for the
phyCORE-i.MX31 and a bunch of these patches already went into the
maintainer trees for the 2.6.29 merge window.

One of the next central components is the pmic driver, which hasn't
reached mainline quality yet. If that's finished, camera drivers will
surely be in a better situation wrt. mainline.

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
