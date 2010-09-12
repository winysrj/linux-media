Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:26663 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751792Ab0ILRp2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Sep 2010 13:45:28 -0400
Subject: [PATCH v2 0/3] gpsca_cpia1: Intel Play QX3 microscope illuminator
 controls
From: Andy Walls <awalls@md.metrocast.net>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Jean-Francois Moine <moinejf@free.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 12 Sep 2010 13:45:10 -0400
Message-ID: <1284313510.2027.29.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

The following 3 patches implement v4l2 illuminator controls for the
Intel Play QX3 microscope.  These patches depend on Jean-Francois
Moine's patch that adds V4L2_CID_ILLUMINATORS_[12] to the standard v4l2
controls.

These patches do not attempt to turn off the illuminators at module
unload or at suspend time as I could not easily test suspend at the
moment.  These patches will restore the state of the illumination at
resume time and will ensure the illuminators are off at module load.

Thanks go to Hans de Goede for pointing out problems with the 
patch and suggested solutions.

Thanks go to Jean-Francois Moine for working to get Illuminator controls
in place as standard V4L2 controls.


Maybe soon we'll be able to answer the question:

"How many LMML posts does it take to turn on a light bulb?"

;)

Regards,
Andy 

http://groups.google.com/group/rec.humor.funny/browse_thread/thread/3658cbec599fd7e4/19496cbc3270f3a9?hl=en&q=rec.humor.funny+light+bulb+subscribers#19496cbc3270f3a9


