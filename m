Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx09.extmail.prod.ext.phx2.redhat.com
	[10.5.110.13])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nBBLIjir022096
	for <video4linux-list@redhat.com>; Fri, 11 Dec 2009 16:18:45 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de
	[92.198.50.35])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nBBLIX7e019144
	for <video4linux-list@redhat.com>; Fri, 11 Dec 2009 16:18:33 -0500
Date: Fri, 11 Dec 2009 22:18:29 +0100
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Carlos Lavin <carlos.lavin@vista-silicon.com>
Message-ID: <20091211211829.GI22533@pengutronix.de>
References: <fe6fd5f60912110228s80ce93ax1f73e019c697ec46@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <fe6fd5f60912110228s80ce93ax1f73e019c697ec46@mail.gmail.com>
Cc: video4linux-list <video4linux-list@redhat.com>
Subject: Re: imx27_camera is correct
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

On Fri, Dec 11, 2009 at 11:28:26AM +0100, Carlos Lavin wrote:
> hello, I'll want the host camera imx27_camera driver from PHYTEC,his
> repository is:
> git://git.pengutronix.de/git/phytec/linux-2.6.git
> 
> but I don't know if this file is correct. Have someone used it before? is a
> good file or this file isn't correct?

Yes, it is in use here. However, the code needs probably some work in
order to be ready for mainline.

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
