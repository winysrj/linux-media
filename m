Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n77JLabw005669
	for <video4linux-list@redhat.com>; Fri, 7 Aug 2009 15:21:36 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de
	[92.198.50.35])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n77JLJiZ003189
	for <video4linux-list@redhat.com>; Fri, 7 Aug 2009 15:21:19 -0400
Date: Fri, 7 Aug 2009 21:20:46 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: javier Martin <javier.martin@vista-silicon.com>
Message-ID: <20090807192045.GK5842@pengutronix.de>
References: <eedb5540908060842rb7e2ac7g920310563fa8ddb4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <eedb5540908060842rb7e2ac7g920310563fa8ddb4@mail.gmail.com>
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

On Thu, Aug 06, 2009 at 05:42:12PM +0200, javier Martin wrote:
> I have been reading formats supported in V4L2 api and I haven't found
> H.264 in compressed formats.
> 
> Do you plan to add a define for this format? If not what would be the
> problem with it?

If I remember correctly, Freescale has H.264 encoding in the same
package that also contains MPEG4 stuff, both as gstreamer plugins.

Check how it is integrated in OSELAS.Phytec-phyCORE-12-1:
http://www.pengutronix.de/oselas/bsp/phytec/download/phyCORE/OSELAS.BSP-Phytec-phyCORE-12-1.tar.gz

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
