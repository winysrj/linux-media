Return-path: <linux-media-owner@vger.kernel.org>
Received: from [216.32.181.186] ([216.32.181.186]:22868 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753653Ab3CMJaI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Mar 2013 05:30:08 -0400
Received: from mail117-ch1 (localhost [127.0.0.1])	by
 mail117-ch1-R.bigfish.com (Postfix) with ESMTP id 75188C0146	for
 <linux-media@vger.kernel.org>; Wed, 13 Mar 2013 09:28:57 +0000 (UTC)
Received: from CH1EHSMHS019.bigfish.com (snatpool2.int.messaging.microsoft.com
 [10.43.68.231])	by mail117-ch1.bigfish.com (Postfix) with ESMTP id
 DF2C62A0086	for <linux-media@vger.kernel.org>; Wed, 13 Mar 2013 09:28:55
 +0000 (UTC)
Message-ID: <514046E4.2090302@btconnect.com>
Date: Wed, 13 Mar 2013 09:29:08 +0000
From: jonathan chetwynd <j.chetwynd@btconnect.com>
MIME-Version: 1.0
To: <linux-media@vger.kernel.org>
Subject: VIDIOC_ENUM_FMT bug query
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Is there any further action I can take to discover whether a webcam can 
support a format?
or to help develop a patch?

the Sandberg Nightcam2 specification lists
1280 x 960 up to 15 frames per second
but
$ v4l2-ctl --list-formats-ext lists no such format as available

regards

Jonathan Chetwynd

http://www.sandberg.it/product/NightCam-2

$ v4l2-ctl --list-formats-ext
ioctl: VIDIOC_ENUM_FMT
     Index       : 0
     Type        : Video Capture
     Pixel Format: 'S920'
     Name        : S920
         Size: Discrete 160x120
         Size: Discrete 320x240
         Size: Discrete 640x480

     Index       : 1
     Type        : Video Capture
     Pixel Format: 'BA81'
     Name        : BA81
         Size: Discrete 160x120
         Size: Discrete 320x240
         Size: Discrete 640x480

     Index       : 2
     Type        : Video Capture
     Pixel Format: 'JPEG' (compressed)
     Name        : JPEG
         Size: Discrete 160x120
         Size: Discrete 320x240
         Size: Discrete 640x480


