Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([74.208.4.200]:50032 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423180Ab3FUQf7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 21 Jun 2013 12:35:59 -0400
Received: from mailout-us.gmx.com ([172.19.198.46]) by mrigmx.server.lan
 (mrigmxus002) with ESMTP (Nemesis) id 0Lkxsn-1UFugN2Hkj-00amGP for
 <linux-media@vger.kernel.org>; Fri, 21 Jun 2013 18:35:58 +0200
Content-Type: text/plain; charset="utf-8"
Date: Fri, 21 Jun 2013 12:35:57 -0400
From: kewlcat@gmx.com
Message-ID: <20130621163558.128500@gmx.com>
MIME-Version: 1.0
Subject: gspca_sq930x: Creative WebCam Live! Pro recognized, kinda initialised
 but unusable
To: linux-media@vger.kernel.org
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello again

I've just compiled a new 3.9.7 kernel and applied a patch suggested by hverkuil on #v4l : I removed the comments around reg_w(gspca_dev, SQ930_CTRL_RESET, 0x0000); in ./drivers/media/usb/gspca/sq930x.c at line 839
This is what I get now :
Jun 21 18:19:31 elnath kernel: [    6.587245] gspca_sq930x: reg_w 001e 0000 failed -110

Log extract : http://pastebin.com/ay74d5YB

If reg_r() and reg_w fail, it means that usb_control_msg() returns those -32 and -110. How do I debug that ?


 =^.^=
