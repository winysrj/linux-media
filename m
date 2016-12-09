Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33906 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932822AbcLICNf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Dec 2016 21:13:35 -0500
Received: by mail-wm0-f66.google.com with SMTP id g23so889960wme.1
        for <linux-media@vger.kernel.org>; Thu, 08 Dec 2016 18:13:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1757661.3qrq6qFaV4@avalon>
References: <1480944299-3349-1-git-send-email-evgeni.raikhel@intel.com>
 <1480944299-3349-3-git-send-email-evgeni.raikhel@intel.com> <1757661.3qrq6qFaV4@avalon>
From: Daniel Johnson <teknotus@gmail.com>
Date: Thu, 8 Dec 2016 18:13:12 -0800
Message-ID: <CA+nDE0g12muYyze_hvJkLvNA7f+Jv8ux9b4w=peVdfNWEekong@mail.gmail.com>
Subject: Re: [PATCH 2/2] uvcvideo: Document Intel SR300 Depth camera INZI format
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: evgeni.raikhel@gmail.com,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Evgeni Raikhel <evgeni.raikhel@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> In addition to my previous comments, wouldn't it make more sense to create a
> multiplanar format for this instead of bundling the two separate images into a
> single plane ?

Unfortunately that would break userspace at this point as multiple
libraries are already depending on a patch that implements the INZI
format in this way. I first released a work in progress patch in March
of 2015. It was integrated into a Robot Operating System module
shortly after that, and Intel has included it in librealsense since
January, and also in the firmware for their new Joule module. Since
people using this have mostly had to patch their own kernel to use it
that might not be a deal breaker. I had initially held back on
upstreaming it because I was trying to work out some details of the
image formats. Two depth formats seemed the same, and I was trying to
figure out what was different enough about them to justify having two
formats. I've never had access to any intel documentation beyond what
is public on their website, and many details are missing.

For reference I got an early RealSense camera when only windows was
supported, and figured out some rudimentary support for Linux over a
year before intel released their own support. A manager hiring for
Intel's open source library told me over the phone that they were in
fact using my blog posts to help them develop it so it wasn't
surprising that the patch they distributed with the library included
my comments. It was surprising that they didn't mention me as the
author of the patch.

I could rebase my original patch on the current development kernel and
submit it if that helps. I can reformat the useful bits from my blog
posts as documentation on how 3d cameras work. I wrote a C hotplug
utility to let the kernel know about non standard camera controls. I
also have a partially finished kernel driver for the SR300, and F200
cameras for things like retrieving the calibration to turn depth
images into point clouds, putting the camera into firmware update
mode, etc that intel's library does with libusb. I think there should
be a standard v4l2 api for 3d cameras because as it is now userspace
programs have to be written differently for each vendor. Really all
they need are some calibration matrices, and distortion coefficients.
Precise time synchronization between /dev/videoX nodes would also be
really helpful. These two things would be helpful for other cameras as
well for things like stitching 360 degree video.

Here are links to my blog series.
http://solsticlipse.com/2015/01/09/intel-real-sense-camera-on-linux.html
http://solsticlipse.com/2015/02/10/intel-real-sense-on-linux-part-2-3d-camera-controls.html
http://solsticlipse.com/2015/03/31/intel-real-sense-3d-on-linux-macos.html
http://solsticlipse.com/2016/09/26/long-road-to-ubiquitous-3d-cameras.html
