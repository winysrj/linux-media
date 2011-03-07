Return-path: <mchehab@pedra>
Received: from devils.ext.ti.com ([198.47.26.153]:42774 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab1CGUlz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Mar 2011 15:41:55 -0500
Message-ID: <4D75430E.8070001@ti.com>
Date: Mon, 7 Mar 2011 14:41:50 -0600
From: Sergio Aguirre <saaguirre@ti.com>
MIME-Version: 1.0
To: <g.liakhovetski@gmx.de>, <linux-media@vger.kernel.org>
Subject: [Query][soc_camera] How to handle hosts w/color conversion built
 in?
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Guennadi and all,

I've been trying to make my omap4 camera host driver to allow YUYV -> 
NV12 color conversion, and add that to the supported host-client 
formats, but I think I have hit the wall with the host design.

I noticed that the soc_camera seems to be designed to just pass-through 
the client supported formats (i.e. if my sensor supports YUYV and JPEG, 
those will be the supported formats only)

Now, in my host driver, I have a feature to do a color conversion to 
NV12, but I'm still not sure on how to expand the supported formats to, 
say: YUYV, JPEG, and NV12 (which would be available only if the client 
outputs YUYV, of course).

I was trying adding a customized get_formats function, but as 
soc_camera_init_user_formats anyways depends heavly on the sensor's 
enum_mbus_fmt, it's hard to add supported formats that the sensor 
doesn't directly support.

Has this been done before? Any advice?

Regards,
Sergio
