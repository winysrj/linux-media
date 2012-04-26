Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:50459 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757782Ab2DZPy7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Apr 2012 11:54:59 -0400
Received: by wejx9 with SMTP id x9so846785wej.19
        for <linux-media@vger.kernel.org>; Thu, 26 Apr 2012 08:54:58 -0700 (PDT)
MIME-Version: 1.0
Reply-To: whittenburg@gmail.com
Date: Thu, 26 Apr 2012 10:54:58 -0500
Message-ID: <CABcw_O=n34Y1jCbSzgBkDr-ZnFMTnycvTAWw9kAwUEtXnU3dOg@mail.gmail.com>
Subject: omap3isp: isp_video_mbus_to_pix causes WARN_ON
From: Chris Whittenburg <whittenburg@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm using a 3.0.17 kernel on a dm3730 with a custom 8-bit grayscale sensor.

When using a simple gstreamer pipeline to test:

gst-launch -v v4l2src device=/dev/video2 !
'video/x-raw-gray,bpp=(int)8,framerate=(fraction)10/1,width=640,height=480'
! fakesink

I get lots of calls to isp_video_try_format for unrelated formats like
YU12, YV12, BGR3, and RGB3.  I assume this is gstreamer's fault, since
I implemented isp_video_enum_format which only returns
V4L2_PIX_FMT_GREY.

Anyway, isp_video_try_format makes calls to isp_video_pix_to_mbus for
each of these formats, and since they aren't in the list of
isp_format_info formats, WARN_ON gets called.

Is this expected?  What would be the best way to resolve it?

Thanks.
