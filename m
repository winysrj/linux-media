Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:6898 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711AbaABKat convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jan 2014 05:30:49 -0500
From: "Ayoub, Hani" <hani.ayoub@intel.com>
To: Paulo Assis <pj.assis@gmail.com>
CC: "linux-uvc-devel@lists.sourceforge.net"
	<linux-uvc-devel@lists.sourceforge.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: RE: [linux-uvc-devel] Closing Bulk Stream in V4L2 UVC Linux driver
Date: Thu, 2 Jan 2014 10:30:44 +0000
Message-ID: <24AEC8CA92A64D49B27AF3710E3431292ADCBB90@HASMSX103.ger.corp.intel.com>
References: <24AEC8CA92A64D49B27AF3710E3431292ADCA3C2@HASMSX103.ger.corp.intel.com>
 <CAPueXH6CnuR3QRbc+wPrby62u_xZOZrgNqmpsjSA8octuP-5qg@mail.gmail.com>
In-Reply-To: <CAPueXH6CnuR3QRbc+wPrby62u_xZOZrgNqmpsjSA8octuP-5qg@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for the answer.
First, I mentioned something wrong below, I meant "AltSet 0" (alternateSetting set 0) instead of "AltSet 1" (alternateSetting set 1). Sorry about that.

What STREAMOFF does is the following:
      - uvc_uninit_video (frees URB buffers)
      - usb_set_interface 0 (sends set alternate 0)
      - uvc_queue_enable 0 (sends vb2_streamoff)
      - uvc_video_clock_cleanup (cleanup some memory)

What STREAMON does is the following:
	- uvc_video_clock_init (init some memory)
	- uvc_queue_enable (sends vb2_streamon)
	- uvc_commit_video (sends commit to USB)
	- uvc_init_video (allocated URB buffers)

So when do you think the device should "open"/"close" a stream/interface? 
Maybe "open" stream when "commit" is received and "close" stream when "set alternate 0" is received?

Thanks,
Hani;

-----Original Message-----
From: Paulo Assis [mailto:pj.assis@gmail.com] 
Sent: Thursday, January 02, 2014 11:43
To: Ayoub, Hani
Cc: linux-uvc-devel@lists.sourceforge.net; Linux Media Mailing List
Subject: Re: [linux-uvc-devel] Closing Bulk Stream in V4L2 UVC Linux driver

Hi,
guvcview just handles this like any other V4L2 device. You should look at the driver in this case, and check what it does when a VIDIOC_STREAMOFF is received.

Regards,
Paulo

PS: adding linux media to CC


2014/1/1 Ayoub, Hani <hani.ayoub@intel.com>:
> Hi,
>
> I'm trying to bring up a device which sends data using BULK transfer 
> using
> V4L2 UVC Linux driver (Ubuntu 12.04).
>
> Using guvcview, I can see that the device transfer data successfully 
> and I can see a stream. However, that works fine ONLY the first time I 
> run guvcview after I plug-in the device, closing the app and 
> re-launching it does not show any pictures... to get a good stream I 
> have to re-plug-in the device to the USB 3.0 port.
>
>
>
> Via USB analyzer, I can see that when closing the application (closing 
> the
> device) an "AltSet 1" (alternateSetting set 1) is sent although it's 
> prohibited by spec (UVC 1.1 section 2.4.3) - so the device ignores it, 
> this (I think) is the reason why the stream doesn't work when 
> re-launching the application.
>
>
>
> My question is: how should I properly close the stream in BULK? Is 
> there any way to "patch" V4L or the application to make closing the device works fine?
>
> There are some similar discussions in the web, but I think there's no 
> real answer (some references below)
>
>
>
> References:
>
> *         Thread1
>
> *         Thread2
>
> *         Thread3
>
> *         Thread4
>
>
>
> Thanks,
>
> Hani;
>
> ---------------------------------------------------------------------
> Intel Israel (74) Limited
>
> This e-mail and any attachments may contain confidential material for 
> the sole use of the intended recipient(s). Any review or distribution 
> by others is strictly prohibited. If you are not the intended 
> recipient, please contact the sender and delete all copies.
>
>
> ----------------------------------------------------------------------
> -------- Rapidly troubleshoot problems before they affect your 
> business. Most IT organizations don't have a clear picture of how 
> application performance affects their revenue. With AppDynamics, you 
> get 100% visibility into your Java,.NET, & PHP application. Start your 
> 15-day FREE TRIAL of AppDynamics Pro!
> http://pubads.g.doubleclick.net/gampad/clk?id=84349831&iu=/4140/ostg.c
> lktrk _______________________________________________
> Linux-uvc-devel mailing list
> Linux-uvc-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-uvc-devel
>
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

