Return-path: <linux-media-owner@vger.kernel.org>
Received: from hl140.dinaserver.com ([82.98.160.94]:50560 "EHLO
	hl140.dinaserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbbFWKaM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jun 2015 06:30:12 -0400
Received: from [192.168.2.27] (5.Red-212-170-183.staticIP.rima-tde.net [212.170.183.5])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by hl140.dinaserver.com (Postfix) with ESMTPSA id 98CD14B95810
	for <linux-media@vger.kernel.org>; Tue, 23 Jun 2015 12:20:41 +0200 (CEST)
Message-ID: <558932F7.3070509@by.com.es>
Date: Tue, 23 Jun 2015 12:20:39 +0200
From: Javier Martin <javiermartin@by.com.es>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: i.MX6 video capture support in mainline
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
we have an BD-SL-i.MX6 platform (compatible with the Nitrogen6X) where 
we are currently running the BSP from Freescale, which is based on 
kernel 3.10 if I recall properly.

We are aware that those drivers have some issues, specially when it 
comes to compliance with the V4L2 frameworks like the media controller 
API, stability, etc...

Furthermore, we need to use the mainline kernel because some of the 
drivers that we need to use are not available in the Freescale kernel.


The biggest problem that we have found so far for switching to the 
mainline kernel is the video capture support in the I.MX6 IPU. I've been 
following some old e-mail threads (from 2014) and I eventually found 
Philipp Zabel's repository branch 'nitrogen6x-ipu-media' which has what 
seems to be an early version of an i.MX6 IPU capture driver via the CSI 
interface.

We've got here the same setup with an ov5642 sensor connected to the CSI 
interface and we have been giving a try to the driver.

This is what we have tried so far:

cat /dev/video0 # This is needed so that open gets called and the csi 
links are created
media-ctl -l '"ov5642 1-003c":0->"mipi_ipu1_mux":1[1], 
"/soc/ipu@02400000/port@0":1->"IPU0 SMFC0":0[1]'
media-ctl -l '"IPU0 SMFC0":1->"imx-ipuv3-camera.2":0[1]'

The last command will fail like this:

imx-ipuv3 2400000.ipu: invalid link 'IPU0 SMFC0'(5):1 -> 
'imx-ipuv3-camera.2'(2):0
Unable to parse link: Invalid argument (22)

The reason it fails, apparently, is that the links that have been 
created when opening /dev/video0 are not included in the "ipu_links[]" 
static table defined in "drivers/gpio/ipu-v3/ipu-media.c" which is where 
the "ipu_smfc_link_setup()" function tries to find a valid link.

I've got some questions regarding this driver and iMX6 video capture 
support in general that someone here may gladly answer:

a) Is anyone currently working on mainlining iMX6 video capture support? 
I know about Steve's and Philipp's work but I haven't seen any progress 
since September 2014.

b) Does anyone know whether it's possible to capture YUV420P video using 
the driver in Philipp's repository? If so could you please provide the 
pipeline setup that you used with media-ctl?

c) If we were willing to help with mainline submission of this driver 
what issues should we focus on?


Regards,
Javier.

[1] git://git.pengutronix.de/git/pza/linux.git

