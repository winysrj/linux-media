Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:42595 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab0EMP6v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 13 May 2010 11:58:51 -0400
Received: by fg-out-1718.google.com with SMTP id 19so2573569fgg.1
        for <linux-media@vger.kernel.org>; Thu, 13 May 2010 08:58:50 -0700 (PDT)
Message-ID: <4BEC21B9.4010605@googlemail.com>
Date: Thu, 13 May 2010 17:58:49 +0200
From: Frank Schaefer <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: gspca-sonixj: ioctl VIDIOC_DQBUF blocks for 3s and retuns EIO
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm not sure if I'm hitting a bug or this is the expected driver behavior:
With a Microsoft LifeCam VX-3000 (045e:00f5) and gspca-sonixj, ioctl
VIDIOC_DQBUF intermittently blocks for exactly 3 seconds and then
returns EIO.
I noticed that it strongly depends on the captured scenery: when it's
changing much, everything is fine.
But when for example capturing the wall under constant (lower) light
conditions, I'm getting this error nearly permanently.

It's a JPEG-device, so I guess the device stops sending data if the
picture doesn't change and that's how it should be.
But is the long blocking + EIO the way drivers should handle this
situtation ?

Regards,
Frank Schaefer

