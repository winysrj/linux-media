Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:60208 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019Ab0D3TfE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Apr 2010 15:35:04 -0400
Received: by pvg7 with SMTP id 7so346245pvg.19
        for <linux-media@vger.kernel.org>; Fri, 30 Apr 2010 12:35:02 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 29 Apr 2010 16:24:16 +0530
Message-ID: <o2g75026db31004290354u8fc403a0n47115d96ea55c3e5@mail.gmail.com>
Subject: UVC Webcam
From: Gijo Prems <gijoprems@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I have some queries related to linux uvc client driver(uvcvideo) and
general uvc webcam functionality.

1. There is a wDelay (during probe-commit) parameter which camera
exposes to the host signifying the delay (Latency) inside the camera.
Does the UVC driver on Linux Host expose this parameter to the
application if they require it?
And what would be the use case of this parameter?

2. How the audio and video sync (lipsync) would happen on host side?

3. How buffers are allocated on the host side?
Which parameter from camera needs to be set to signify the correct
buffer allocation?

4. Are there any parameters in USB audio class which allocate the
buffers and handles the latency at host?

It would be great if someone could put some thoughts on these.

-Gijo
