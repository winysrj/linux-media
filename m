Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([74.208.4.200]:52019 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932792Ab3E0OkH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 27 May 2013 10:40:07 -0400
Received: from mailout-us.gmx.com ([172.19.198.46]) by mrigmx.server.lan
 (mrigmxus001) with ESMTP (Nemesis) id 0MMjfv-1Unqkj1q5X-008ZkR for
 <linux-media@vger.kernel.org>; Mon, 27 May 2013 16:40:06 +0200
Content-Type: text/plain; charset="utf-8"
Date: Mon, 27 May 2013 10:40:02 -0400
From: kewlcat@gmx.com
Message-ID: <20130527144003.287100@gmx.com>
MIME-Version: 1.0
Subject: Creative WebCam Live! Pro recognized, initialised but unusable
To: linux-media@vger.kernel.org
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello
 
I'm having trouble with a Creative WebCam Live! Pro, usb id 041e:4038 "Creative Technology, Ltd ORITE CCD Webcam [PC370R]"
This device is supposed to be "supported" but is marked as "untested". Apparently it works up to the point where sq930x fail with this message : gspca_sq930x: reg_r 001f failed -32
 
See a more complete log here : http://pastebin.com/SMTuhdAF
 
The kernel I'm using is a custom made 3.9.3.
What other information do you need to debug this issue ? What options must I activate in the kernel in order to get a more verbose syslog regarding this component ?
Is there any hope at all for this device, as there seems to be no information available at all from Creative or any other source ?
 
Sincerely,
  =^.^=
