Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp0.epfl.ch ([128.178.224.219]:38304 "HELO smtp0.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752271AbZFRIvt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jun 2009 04:51:49 -0400
Message-ID: <4A39FE96.4010004@epfl.ch>
Date: Thu, 18 Jun 2009 10:45:10 +0200
From: Valentin Longchamp <valentin.longchamp@epfl.ch>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Sascha Hauer <s.hauer@pengutronix.de>
Subject: mx31moboard MT9T031 camera support
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

I am trying to follow your developments at porting soc-camera to 
v4l2-subdev. However, even if I understand quite correctly soc-camera, 
it is quite difficult for me to get all the subtleties in your work.

That's why I am asking you for a little help: when do you think would be 
the best timing for me to add the mt9t031 camera support for mx31moboard 
within your current process ?

I guess it should not be too difficult, I had done it before, and I can 
base myself on what you have done for pcm037:
http://download.open-technology.de/soc-camera/20090617/0025-pcm037-add-MT9T031-camera-support.patch

Now I have a second question. On our robot, we physically have two 
cameras (one looking to the front and one looking at a mirror) connected 
to the i.MX31 physical bus. We have one signal that allows us to control 
the multiplexer for the bus lines (video signals and I2C) through a 
GPIO. This now works with a single camera declared in software and 
choices to the multiplexer done when no image transfer is happening ( 
/dev/video is not open). What do you think should be the correct way of 
dealing with these two cameras with the current driver implementation 
(should I continue to declare only one camera in the software) ?

And do you think it could be possible to "hot-switch" from one camera to 
the other ? My colleagues ask about it, I tell them that from my point 
of view this seems not possible without changing the drivers, and even 
the drivers would have to be changed quite heavily and it is not trivial.

Best Regards

Val

-- 
Valentin Longchamp, PhD Student, EPFL-STI-LSRO1
valentin.longchamp@epfl.ch, Phone: +41216937827
http://people.epfl.ch/valentin.longchamp
MEA3485, Station 9, CH-1015 Lausanne
