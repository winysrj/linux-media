Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:34181 "EHLO
	mail-1.atlantis.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbbABLcY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Jan 2015 06:32:24 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Tibor =?utf-8?q?Mi=C5=A1uth?= <tibor.misuth@gmail.com>
Subject: Re: Video resolution limited to 32x32 pixels in Skype with Syntek 1135 webcam
Date: Fri, 2 Jan 2015 12:31:29 +0100
Cc: linux-media@vger.kernel.org
References: <CAPZSoVsvxcH7aa2WJwaw0jeo7VT=dWYGgB1Lh1DJdVLKM_KUCg@mail.gmail.com>
In-Reply-To: <CAPZSoVsvxcH7aa2WJwaw0jeo7VT=dWYGgB1Lh1DJdVLKM_KUCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201501021231.29274.linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 02 January 2015 11:07:09 Tibor Mišuth wrote:
> Hello,
>
> I've installed Ubuntu 14.04 (kernel 3.13.0-43-generic) on an old Asus
> F5R laptop recently. It's equipped with an integrated Syntek 1135
> webcam for which the gspca_stk1135 module is loaded.
>
> lsusb:
> Bus 001 Device 005: ID 174f:6a31 Syntek Web Cam - Asus A8J, F3S, F5R, VX2S,
> V1S
>
> lsmod (extract):
> gspca_stk1135          13318  0
> gspca_main             27814  1 gspca_stk1135
> videodev              108503  2 gspca_stk1135,gspca_main
>
> The webcam works fine in guvcview and almost fine in cheese
> (resolutions are limited to square options, e.g. 1024x1024).
>
> Unfortunately there is an issue with Skype. It can detect the device
> /dev/video0 (once
> LD_PRELOAD=/usr/lib/i386-linux-gnu/libv4l/v4l2convert.so) but the
> resolution is limited to 32x32 pixels which is useless. I tried to set
> video size in Skype's config.xml, but then Skype didn't show anything
> (just black screen).
>
> I did a test with an external Genius USB webcam (gspca_sonixb module)
> that worked fine (resolution was 640x480 that is max for the camera).
>
> Is there any way to debug the driver (gspca_stk1135) and v4l to find
> out the root cause of the issue?

The driver supports variable resolution from 32x32 to 1280x1024 in 2 pixel 
steps. The problem is that some programs are crap and cannot handle that.

-- 
Ondrej Zary
