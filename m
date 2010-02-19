Return-path: <linux-media-owner@vger.kernel.org>
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:57672 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab0BSSLH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Feb 2010 13:11:07 -0500
Date: Fri, 19 Feb 2010 18:44:51 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Richard =?iso-8859-15?Q?R=C3=B6jfors?=
	<richard.rojfors.ext@mocean-labs.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Message-ID: <20100219174451.GH21778@enneenne.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: adv7180 as SoC camera device
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

on my pxa27x based board I have a adv7180 connected with the CIF
interface. Due this fact I'm going to use the pxa_camera.c driver
which in turn registers a soc_camera_host.

In the latest kernel I found your driver for the ADV7180, but it
registers the chip as a v4l sub device.

I suppose these two interfaces are not compatible, aren't they?

In this situation, should I write a new driver for the
soc_camera_device? Which is The-Right-Thing(TM) to do? :)

Thanks in advance,

Rodolfo Giometti

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
