Return-path: <mchehab@pedra>
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:36327 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752709Ab1BDG7v convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Feb 2011 01:59:51 -0500
From: Bhupesh SHARMA <bhupesh.sharma@st.com>
To: "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Fri, 4 Feb 2011 14:59:28 +0800
Subject: soc-camera: RGB888, RBG8888 and JPEG formats not supported in
 v4l2_mbus_pixelcode
Message-ID: <D5ECB3C7A6F99444980976A8C6D896384DEE2BDCD0@EAPEX1MAIL1.st.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi,

We are developing a Camera Host and Sensor driver for our ST specific SoC and are
using the soc-camera framework for the same. Our Camera Host supports a number of
YUV, RGB formats in addition to JPEG and Mode3C(color filler mode) formats.

1. I have a few questions regarding the pixel formats supported in enum v4l2_mbus_pixelcode.
While formats like RGB888 and RGB8888 are supported by V4L2_PIX_FMT_* macros, I
couldn't find corresponding support in V4L2_MBUS_FMT_* .

2. Similar is the case for JPEG format. I could see a discussion between you and QingXu for
adding JPEG support in soc-camera framework here http://www.spinics.net/lists/linux-media/msg27980.html
Could you please let me know if the JPEG support has already been added to the soc-camera framework or
are there plans to add the same in near future.

3. Also please let me know which formats should be reported by 

static const struct soc_mbus_pixelfmt st_camera_formats[]

in the camera host driver? Are these, the pixel formats supported by:
	a. Camera Host
	b. Camera sensor
	c. Or formats supported both by the Host and Sensor

Thanks for your help.

Regards,
Bhupesh
ST Microelectronics
