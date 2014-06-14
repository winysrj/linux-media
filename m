Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp04.smtpout.orange.fr ([80.12.242.126]:44423 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbaFNUad (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 Jun 2014 16:30:33 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: soc_camera and device-tree
Date: Sat, 14 Jun 2014 22:30:31 +0200
Message-ID: <87ppibtes8.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

I'm slowly converting all of my drivers to device-tree.
In the process, I met ... soc_camera.

I converted mt9m111.c and pxa_camera.c, but now I need the linking
soc_camera. And I don't have a clear idea on how it should be done.

I was thinking of having soc_camera_pdrv_probe() changed, to handle
device-tree. What bothers me a bit is that amongst the needed data for me are
the bus_id and a soc_camera_subdev_desc. I was thinking that this could be
expressed in device-tree like :
	soc_camera {
		icd = <&mt9m111>;
        	ici = <&pxa_camera>;
        }
...
	pxai2c1: i2c@40301680 {
		status = "okay";

		mt9m111@5d {
			compatible = "micron,mt9m111";
			reg = <0x5d>;
		};
	};

	pxa_camera {
		compatible = "mrvl,pxa_camera";
		mclk_10khz = <5000>;
		flags = <0xc9>;
	};

Do you have any hints and advices to help me ?

Cheers.

-- 
Robert
