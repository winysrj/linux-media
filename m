Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45000 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001Ab2IEQG7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Sep 2012 12:06:59 -0400
Received: by obbuo13 with SMTP id uo13so543087obb.19
        for <linux-media@vger.kernel.org>; Wed, 05 Sep 2012 09:06:58 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 5 Sep 2012 13:06:58 -0300
Message-ID: <CAOMZO5D7Ar0SE9vmi41jSxbPqv8sSOQshbL6Uzv4Ltow5xKx4w@mail.gmail.com>
Subject: Camera not detected on linux-next
From: Fabio Estevam <festevam@gmail.com>
To: Javier Martin <javier.martin@vista-silicon.com>,
	=?UTF-8?Q?Ga=C3=ABtan_Carlier?= <gcembed@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am running linux-next 20120905 on a mx31pdk board with a ov2640 CMOS
and I am not able to get the ov2640 to be probed:

soc-camera-pdrv soc-camera-pdrv.0: Probing soc-camera-pdrv.0
mx3-camera mx3-camera.0: MX3 Camera driver attached to camera 0
mx3-camera mx3-camera.0: MX3 Camera driver detached from camera 0
.... (no messages showing ov2640 being probed)

I noticed that Kconfig changed the way to select the "Sensors used on
soc_camera driver" and I selected ov2640 in the .config.

camera worked fine on this board running 3.5.3. So before start
bisecting, I would like to know if there is anything obvious I am
missing.

Also tested on a mx27pdk and ov2640 could not be probed there as well.

Thanks,

Fabio Estevam
