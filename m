Return-path: <mchehab@gaivota>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:48118 "HELO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751010Ab1AECFT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 4 Jan 2011 21:05:19 -0500
From: Qing Xu <qingx@marvell.com>
To: "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 4 Jan 2011 18:02:55 -0800
Subject: SOC-Camera VIDIOC_ENUM_FRAMESIZES interface?
Message-ID: <7BAC95F5A7E67643AAFB2C31BEE662D01403F0DE64@SC-VEXCH2.marvell.com>
References: <AANLkTimucMmO8Vb_y4xnhehQt+mamNMmXyY_qfrVOSo7@mail.gmail.com>
 <AANLkTinv64SL4HavFRK-s2Tr4CTGPH4iQ9bz7=40v1Hc@mail.gmail.com>
In-Reply-To: <AANLkTinv64SL4HavFRK-s2Tr4CTGPH4iQ9bz7=40v1Hc@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hi,

We are now trying to adapt to soc-camera framework, though we have one question when reviewing the source code about V4L2_VIDIOC_ENUM_FRAMESIZE:

We find that there is no vidioc_enum_framesizes implementation in soc-camera.c.

Do you feel it's reasonable to add it into soc-camera about vidioc_enum_framesizes, so that the application knows how many frame-size is supported by camera driver, and then show all the size options in UI, then allow user to choose one size from the list.

Any ideas will be appreciated!

Thanks!
Qing Xu


Email: qingx@marvell.com
Application Processor Systems Engineering
Marvell Technology Group Ltd.

