Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay01.pair.com ([209.68.5.15]:1383 "HELO relay01.pair.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752919AbZEXXKX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 24 May 2009 19:10:23 -0400
Message-ID: <4A19D3D9.9010800@papercut.com>
Date: Mon, 25 May 2009 09:10:17 +1000
From: Matt Doran <matt.doran@papercut.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: videodev: Unknown symbol i2c_unregister_device (in kernels older
 than 2.6.26)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi there,

I tried using the latest v4l code on an Mythtv box running 2.6.20, but 
the v4l videodev module fails to load with the following warnings:

    videodev: Unknown symbol i2c_unregister_device
    v4l2_common: Unknown symbol v4l2_device_register_subdev


It seems the "i2c_unregister_device" function was added in 2.6.26.   
References to this function in v4l2-common.c are enclosed in an ifdef like:

    #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)


However in "v4l2_device_unregister()" in v4l2-device.c, there is a 
reference to "i2c_unregister_device" without any ifdefs.   I am running 
a pretty old kernel, but I'd guess anyone running 2.6.25 or earlier will 
have this problem.   It seems this code was added by Mauro 3 weeks ago 
in this rev:

    http://linuxtv.org/hg/v4l-dvb/rev/87afa7a4ccdf




I also had some other compile problems, but don't have all the details 
(sorry!).  I had to disable the following drivers to get it to compile:

    * CONFIG_VIDEO_PVRUSB2
    * CONFIG_VIDEO_THS7303
    * CONFIG_VIDEO_ADV7343
    * CONFIG_DVB_SIANO_SMS1XXX


Regards,
Matt


