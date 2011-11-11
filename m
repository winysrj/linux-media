Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54531 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab1KKQsf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Nov 2011 11:48:35 -0500
Received: by ywt32 with SMTP id 32so373869ywt.19
        for <linux-media@vger.kernel.org>; Fri, 11 Nov 2011 08:48:35 -0800 (PST)
Message-ID: <4EBD5162.2010406@gmail.com>
Date: Fri, 11 Nov 2011 11:46:26 -0500
From: damateem <damateem4@gmail.com>
MIME-Version: 1.0
To: linux-media list <linux-media@vger.kernel.org>
Subject: select() timeout in video capture example
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm trying to use a dm355-leopardboard to capture images.

When I execute the capture example from the Video for Linux Two API 
Specification: Revision 0.24 
(http://v4l2spec.bytesex.org/spec/a16706.htm), it always time's out on 
the select() call. I'm not sure where to start looking for the cause of 
this problem. The ccdc and camera are passing registration.

[    2.020000] vpfe_init
[    2.020000] vpfe-capture: vpss clock vpss_master enabled
[    2.030000] vpfe-capture: vpss clock vpss_slave enabled
[    2.040000] vpfe-capture vpfe-capture: v4l2 device registered
[    2.040000] vpfe-capture vpfe-capture: video device registered
[    2.050000] mt9v113 1-003c: Detected a mt9v113 chip ID 2280
[    2.170000] mt9v113 1-003c: mt9v113 1-003c decoder driver registered !!
[    2.180000] vpfe-capture vpfe-capture: v4l2 sub device mt9v113 registered
[    2.190000] vpfe_register_ccdc_device: DM355 CCDC
[    2.190000] DM355 CCDC is registered with vpfe.

Furthermore, by inspecting the electrical interface to the camera, I 
have verified that the camera is transmitting pixel data.

What things would cause select() to timeout? Should I look for something 
in the drivers?

I'm using kernel version  Arago/2.6.31+2.6.32-rc2-r52+gitr.

Thanks,
David
