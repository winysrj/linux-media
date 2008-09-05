Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m85AddD1023337
	for <video4linux-list@redhat.com>; Fri, 5 Sep 2008 06:39:40 -0400
Received: from metis.extern.pengutronix.de (metis.extern.pengutronix.de
	[83.236.181.26])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m85AdIQC014119
	for <video4linux-list@redhat.com>; Fri, 5 Sep 2008 06:39:25 -0400
Date: Fri, 5 Sep 2008 12:39:17 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: video4linux-list@redhat.com
Message-ID: <20080905103917.GQ4941@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [soc-camera] about the y_skip_top parameter
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

Hi all,

The y_skip_top parameter tells the cameras to effectively make the
picture one line higher. I think this parameter was introduced to work
around a bug in the pxa camera interface. The pxa refuses to read the
first line of a picture. The problem with this parameter is that it is
set to 1 in the sensor drivers and not in the pxa driver, so it's the
sensor drivers which work around a bug in the pxa. On other
hardware platforms (mx27 in this particular case) I cannot skip the
first line, so I think this parameter should be set to 1 in the pxa
driver and not the sensor drivers.

What do you think?

Sascha

-- 
 Pengutronix - Linux Solutions for Science and Industry
   Handelsregister:  Amtsgericht Hildesheim, HRA 2686
     Hannoversche Str. 2, 31134 Hildesheim, Germany
   Phone: +49-5121-206917-0 |  Fax: +49-5121-206917-9

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
