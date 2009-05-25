Return-path: <linux-media-owner@vger.kernel.org>
Received: from deliverator6.ecc.gatech.edu ([130.207.185.176]:52190 "EHLO
	deliverator6.ecc.gatech.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751405AbZEYAws (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 May 2009 20:52:48 -0400
Message-ID: <4A19EBDE.4080602@gatech.edu>
Date: Sun, 24 May 2009 20:52:46 -0400
From: David Ward <david.ward@gatech.edu>
MIME-Version: 1.0
To: Matt Doran <matt.doran@papercut.com>
CC: linux-media@vger.kernel.org
Subject: Re: videodev: Unknown symbol i2c_unregister_device (in kernels older
 than 2.6.26)
References: <4A19D3D9.9010800@papercut.com>
In-Reply-To: <4A19D3D9.9010800@papercut.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/24/2009 07:10 PM, Matt Doran wrote:
> Hi there,
>
> I tried using the latest v4l code on an Mythtv box running 2.6.20, but
> the v4l videodev module fails to load with the following warnings:
>
>    videodev: Unknown symbol i2c_unregister_device
>    v4l2_common: Unknown symbol v4l2_device_register_subdev
>
>
> It seems the "i2c_unregister_device" function was added in 2.6.26.
> References to this function in v4l2-common.c are enclosed in an ifdef
> like:
>
>    #if LINUX_VERSION_CODE >= KERNEL_VERSION(2, 6, 26)
>
>
> However in "v4l2_device_unregister()" in v4l2-device.c, there is a
> reference to "i2c_unregister_device" without any ifdefs.   I am
> running a pretty old kernel, but I'd guess anyone running 2.6.25 or
> earlier will have this problem.   It seems this code was added by
> Mauro 3 weeks ago in this rev:
>
>    http://linuxtv.org/hg/v4l-dvb/rev/87afa7a4ccdf
>
>
>
>
> I also had some other compile problems, but don't have all the details
> (sorry!).  I had to disable the following drivers to get it to compile:
>
>    * CONFIG_VIDEO_PVRUSB2
>    * CONFIG_VIDEO_THS7303
>    * CONFIG_VIDEO_ADV7343
>    * CONFIG_DVB_SIANO_SMS1XXX
>
>
> Regards,
> Matt
>

Matt, I checked out v4l-dvb today and am using it under 2.6.24 and so 
far so good.  When did the error appear -- when you were trying to load 
the module?

I have been seeing the errors compiling adv7343.c and ths7303.c under 
2.6.24 as well.  Andy Walls and Chaithrika Subrahmanya had written 
patches for those two modules respectively, but there were some comments 
during the review of the patches, so I think they are still being worked on.

David
