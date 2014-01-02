Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:52901 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaABJni convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Jan 2014 04:43:38 -0500
Received: by mail-ig0-f177.google.com with SMTP id uy17so33238851igb.4
        for <linux-media@vger.kernel.org>; Thu, 02 Jan 2014 01:43:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <24AEC8CA92A64D49B27AF3710E3431292ADCA3C2@HASMSX103.ger.corp.intel.com>
References: <24AEC8CA92A64D49B27AF3710E3431292ADCA3C2@HASMSX103.ger.corp.intel.com>
From: Paulo Assis <pj.assis@gmail.com>
Date: Thu, 2 Jan 2014 09:43:14 +0000
Message-ID: <CAPueXH6CnuR3QRbc+wPrby62u_xZOZrgNqmpsjSA8octuP-5qg@mail.gmail.com>
Subject: Re: [linux-uvc-devel] Closing Bulk Stream in V4L2 UVC Linux driver
To: "Ayoub, Hani" <hani.ayoub@intel.com>
Cc: "linux-uvc-devel@lists.sourceforge.net"
	<linux-uvc-devel@lists.sourceforge.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
guvcview just handles this like any other V4L2 device. You should look
at the driver in this case, and check what it does when a
VIDIOC_STREAMOFF is received.

Regards,
Paulo

PS: adding linux media to CC


2014/1/1 Ayoub, Hani <hani.ayoub@intel.com>:
> Hi,
>
> I’m trying to bring up a device which sends data using BULK transfer using
> V4L2 UVC Linux driver (Ubuntu 12.04).
>
> Using guvcview, I can see that the device transfer data successfully and I
> can see a stream. However, that works fine ONLY the first time I run
> guvcview after I plug-in the device, closing the app and re-launching it
> does not show any pictures… to get a good stream I have to re-plug-in the
> device to the USB 3.0 port.
>
>
>
> Via USB analyzer, I can see that when closing the application (closing the
> device) an “AltSet 1” (alternateSetting set 1) is sent although it’s
> prohibited by spec (UVC 1.1 section 2.4.3) – so the device ignores it, this
> (I think) is the reason why the stream doesn’t work when re-launching the
> application.
>
>
>
> My question is: how should I properly close the stream in BULK? Is there any
> way to “patch” V4L or the application to make closing the device works fine?
>
> There are some similar discussions in the web, but I think there’s no real
> answer (some references below)
>
>
>
> References:
>
> ·         Thread1
>
> ·         Thread2
>
> ·         Thread3
>
> ·         Thread4
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
> ------------------------------------------------------------------------------
> Rapidly troubleshoot problems before they affect your business. Most IT
> organizations don't have a clear picture of how application performance
> affects their revenue. With AppDynamics, you get 100% visibility into your
> Java,.NET, & PHP application. Start your 15-day FREE TRIAL of AppDynamics
> Pro!
> http://pubads.g.doubleclick.net/gampad/clk?id=84349831&iu=/4140/ostg.clktrk
> _______________________________________________
> Linux-uvc-devel mailing list
> Linux-uvc-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-uvc-devel
>
