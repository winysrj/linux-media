Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([74.208.4.201]:65271 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161061Ab3FUNTm (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jun 2013 09:19:42 -0400
Received: from mailout-us.gmx.com ([172.19.198.48]) by mrigmx.server.lan
 (mrigmxus002) with ESMTP (Nemesis) id 0Mgf8V-1UcSiL3B9L-00O1lD for
 <linux-media@vger.kernel.org>; Fri, 21 Jun 2013 15:19:38 +0200
Content-Type: text/plain; charset="utf-8"
Date: Fri, 21 Jun 2013 09:19:35 -0400
From: kewlcat@gmx.com
Message-ID: <20130621131936.128540@gmx.com>
MIME-Version: 1.0
Subject: gspca_sq930x: Creative WebCam Live! Pro recognized, kinda initialised
 but unusable
To: linux-media@vger.kernel.org
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(Repost from 2013-05-27 14:40:02 GMT, with a better subject line and a new pastebin)

Hello 

I'm having trouble with a Creative WebCam Live! Pro, usb id 041e:4038 "Creative Technology, Ltd ORITE CCD 
Webcam [PC370R]" 
This device is supposed to be "supported" but is marked as "untested" at http://gkall.hobby.nl/sq930x.html
Apparently it works up to the point where sq930x fails with this message : gspca_sq930x: reg_r 001f failed -32 

See a more complete log here : http://pastebin.com/yY4THaFN 

The kernel I'm using is a custom made 3.9.3. 
What other information do you need to debug this issue ? What options must I activate in the kernel in order to 
get a more verbose syslog regarding this component ? 
Is there any hope at all for this device, as there seems to be no information available at all from Creative or 
any other source ? 

Sincerely, 
  =^.^= 

 
