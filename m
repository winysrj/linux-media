Return-path: <linux-media-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.240]:20713 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964828AbZGQQH4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jul 2009 12:07:56 -0400
Received: by an-out-0708.google.com with SMTP id d40so1316126and.1
        for <linux-media@vger.kernel.org>; Fri, 17 Jul 2009 09:07:55 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 17 Jul 2009 12:07:55 -0400
Message-ID: <bb2708720907170907g5cb9c2b7o9873e943c1fd6830@mail.gmail.com>
Subject: Omap34xx and OV5620
From: John Sarman <johnsarman@gmail.com>
To: "Aguirre Rodriguez, Sergio" <saaguirre@ti.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sergio,
   Success, I  was able to capture data from the OV5620 using the
omap34xxcam and isp.  The problem I was was having was due to several
wrong setups (all my fault of course :)
   I am using the v4l2 example code.  The code wanted YUYV and Interlaced.
           I changed it to the SGBRG10 and FIELD_NONE and I started
getting VD1 interrupts.
             I read through the isr in isp.c and saw that in raw mode
it wanted a VD0.  I changed that to VD1 and then got a message
stating the wait was too long :(
          At that point I made the sensor send 1280x 1024 data instead
of 640x 480.  Now i was getting VD0 and VD1 interrupts.
          Changed the isp.c back to the original code and voila.  Images.
    So i saved a buffer to a file and converted the data to 8-bit data
I saw my first mono image.

   Now I would like to be able to have a YUYV output pixelformat and
let the isp engine do all the conversion for me.
   The datasheet says this is possible and the code seems to support
it, but I am not getting interrupts for it.

So here is my new questions:

    Is converting from raw to YUYV possible in hardware on the
omap34xx Specifically omap3530
       If so do you think that having the interrupts print is causing
the isr to miss other interrupts.

Thanks,
John Sarman
