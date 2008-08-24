Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7OBvjOZ009554
	for <video4linux-list@redhat.com>; Sun, 24 Aug 2008 07:57:45 -0400
Received: from metis.extern.pengutronix.de (metis.extern.pengutronix.de
	[83.236.181.26])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7OBvVgM014634
	for <video4linux-list@redhat.com>; Sun, 24 Aug 2008 07:57:32 -0400
Date: Sun, 24 Aug 2008 13:57:25 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Message-ID: <20080824115725.GG10168@pengutronix.de>
References: <Pine.LNX.4.64.0808201138070.7589@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0808201138070.7589@axis700.grange>
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH RFC] soc-camera: add API documentation
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

Hi Guennadi,

On Wed, Aug 20, 2008 at 11:40:39AM +0200, Guennadi Liakhovetski wrote:
> +Existing drivers
> +----------------
> +
> +Currently there are two host drivers in the mainline: pxa_camera.c for PXA27x
> +SoCs and sh_mobile_ceu_camera.c for SuperH SoCs, and four sensor drivers:
> +mt9m001.c, mt9m111.c, mt9v022.c and a generic soc_camera_platform.c driver.
> +Please, use these driver as examples when developing new ones.

I wouldn't include this kind of cross-link between a generic
documentation and what's in the tree. The tree is moving quickly and
people tend to forget to update the docs then.

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
