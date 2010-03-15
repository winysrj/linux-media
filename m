Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:39400 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935701Ab0COJh6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Mar 2010 05:37:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Basil Mohamed Gohar <abu_hurayrah@hidayahonline.org>
Subject: Re: Capturing raw JPEG stream from webcam
Date: Mon, 15 Mar 2010 10:40:03 +0100
Cc: linux-media@vger.kernel.org
References: <4B9AF0A3.4060701@hidayahonline.org>
In-Reply-To: <4B9AF0A3.4060701@hidayahonline.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201003151040.04057.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Basil,

On Saturday 13 March 2010 02:55:47 Basil Mohamed Gohar wrote:
> I originally posted this to the video4linux mailing list, but I've since
> discovered that this is the appropriate place (or so I understand) for
> video4linux questions.  My question is how can I capture the raw JPEG
> image stream (e.g., MJPEG) from my webcam, which reports through v4l2
> that it is capable of.  I am using the gst-launch cli to gstreamer,
> 
> which confirms that my webcam has this capability:
> > image/jpeg, width=(int)640, height=(int)480, framerate=(fraction){
> > 30/1, 25/1, 20/1, 15/1, 10/1, 5/1 }
> 
> And, indeed, I can capture using this capability, but the framerate is
> not at the specified rate, but at a much lower value (half or less).
> So, even if I specify 30fps, I get something less.  I can capture the
> full 30fps when I use one of the yuv modes, though, so it's clearly
> capable of delivering that framerate.
> 
> My webcam is a Logitech QuickCam Pro 5000.  The lsusb output is:
> > 046d:08ce Logitech, Inc. QuickCam Pro 5000
> 
> An example command line I try is as follows:
> > gst-launch-0.10 v4l2src device=/dev/video0 ! 'image/jpeg, width=640,
> > height=480, framerate=30/1' ! jpegdec ! xvimagesink

Have you tried disabling auto-exposure ? The camera is allowed to reduce the 
frame rate in low-light conditions if auto-exposure is turned on.

-- 
Regards,

Laurent Pinchart
