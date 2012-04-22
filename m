Return-path: <linux-media-owner@vger.kernel.org>
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:53394 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751909Ab2DVS0x convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Apr 2012 14:26:53 -0400
From: Bhupesh SHARMA <bhupesh.sharma@st.com>
To: "laurent.pinchart@ideasonboard.com"
	<laurent.pinchart@ideasonboard.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"balbi@ti.com" <balbi@ti.com>,
	"g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>
Date: Mon, 23 Apr 2012 02:24:53 +0800
Subject: Using UVC webcam gadget with a real v4l2 device
Message-ID: <D5ECB3C7A6F99444980976A8C6D896384FA44454C7@EAPEX1MAIL1.st.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

I have been doing some experimentation with the UVC webcam gadget along with the UVC user-space
application which you have written.

The UVC webcam gadget works fine with the user space application handling the CONTROL events and
providing DATA events. Now, I wish to interface a real v4l2 device, for e.g. VIVI or more particularly
a soc_camera based host and subdev pair.

Now, I see that I can achieve this by opening the UVC and V4L2 devices and doing MMAP -> REQBUF ->
QBUF -> DQBUF calls on both the devices per the UVC control event received. But this will involve
copying the video buffer in the user-space application from v4l2 (_CAPTURE) to uvc (_OUTPUT) domains,
which will significantly reduce the video capture performance.

Is there a better solution to this issue? Maybe doing something like a RNDIS gadget does with
the help of u_ether.c like helper routines. But if I remember well it also requires the BRCTL (Bridge
Control Utility) in userspace to route data arriving on usb0 to eth0 and vice-versa. Not sure though,
if it does copying of a skb buffer from ethernet to usb domain and vice-versa.

Any idea is much appreciated.

Thanks for your help,
Bhupesh
