Return-path: <linux-media-owner@vger.kernel.org>
Received: from hidayahonline.org ([67.19.146.138]:52082 "EHLO
	mail.hidayahonline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996Ab0CMCCe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Mar 2010 21:02:34 -0500
Message-ID: <4B9AF0A3.4060701@hidayahonline.org>
Date: Fri, 12 Mar 2010 20:55:47 -0500
From: Basil Mohamed Gohar <abu_hurayrah@hidayahonline.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Capturing raw JPEG stream from webcam
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I originally posted this to the video4linux mailing list, but I've since
discovered that this is the appropriate place (or so I understand) for
video4linux questions.  My question is how can I capture the raw JPEG
image stream (e.g., MJPEG) from my webcam, which reports through v4l2
that it is capable of.  I am using the gst-launch cli to gstreamer,
which confirms that my webcam has this capability:
> image/jpeg, width=(int)640, height=(int)480, framerate=(fraction){
> 30/1, 25/1, 20/1, 15/1, 10/1, 5/1 }
And, indeed, I can capture using this capability, but the framerate is
not at the specified rate, but at a much lower value (half or less). 
So, even if I specify 30fps, I get something less.  I can capture the
full 30fps when I use one of the yuv modes, though, so it's clearly
capable of delivering that framerate.

My webcam is a Logitech QuickCam Pro 5000.  The lsusb output is:
> 046d:08ce Logitech, Inc. QuickCam Pro 5000
An example command line I try is as follows:
> gst-launch-0.10 v4l2src device=/dev/video0 ! 'image/jpeg, width=640,
> height=480, framerate=30/1' ! jpegdec ! xvimagesink
Thank you in advance for any help!

-- 
      Basil Mohamed Gohar
abu_hurayrah@hidayahonline.org
http://www.basilgohar.com/blog
basilgohar on irc.freenode.net
GPG Key Fingerprint:  5AF4B362

