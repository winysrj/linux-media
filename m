Return-path: <mchehab@gaivota>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5387 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756907Ab0KSXXD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Nov 2010 18:23:03 -0500
Received: from SHUZHENW (pdmz-snip-v218.qualcomm.com [192.168.218.1])
	by mostmsg01.qualcomm.com (Postfix) with ESMTPA id 5C9B810004D5
	for <linux-media@vger.kernel.org>; Fri, 19 Nov 2010 15:22:56 -0800 (PST)
From: "Shuzhen Wang" <shuzhenw@codeaurora.org>
To: <linux-media@vger.kernel.org>
Subject: Zooming with V4L2
Date: Fri, 19 Nov 2010 15:22:23 -0800
Message-ID: <001601cb8840$9ee567b0$dcb03710$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: en-us
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Hello, 

I am working on a SOC V4L2 video driver, and need to implement zoom
functionality. 

>From application, there are 2 ways to do zooming. The 1st way is to use
cropping and scaling as described in section 1.11.1. The application calls
VIDIOC_S_CROP to achieve zoom. The 2nd way is to use V4L2_CID_ZOOM_ABSOLUTE
and V4L2_CID_ZOOM_RELATIVE as described by Laurent in
http://video4linux-list.1448896.n2.nabble.com/RFC-Zoom-controls-in-V4L2-td14
51987.html.

Our camera hardware supports digital zoom. However, it acts LIKE optical
zoom because it doesn't do upscaling, so no video quality is sacrificed. As
a driver writter, is it okay to support only V4L2_CID_ZOOM_ABSOLUTE and
V4L2_CID_ZOOM_RELATIVE? 

I guess it also depends on how zooming is done for most of the V4L2 user
application out there. 

Your comments are appreciated.
-Shuzhen


