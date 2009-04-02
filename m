Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:47048 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757533AbZDBOcT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Apr 2009 10:32:19 -0400
Received: from steven-toths-macbook-pro.local
 (ool-45721e5a.dyn.optonline.net [69.114.30.90]) by mta5.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KHH001DB9PCNV80@mta5.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Thu, 02 Apr 2009 10:32:01 -0400 (EDT)
Date: Thu, 02 Apr 2009 10:31:59 -0400
From: Steven Toth <stoth@linuxtv.org>
Subject: Re: Broken ioctls for the mpeg encoder on the HVR-1800
In-reply-to: <e3538fbd0904012216g48da5006hb170974530bdcea3@mail.gmail.com>
To: Joseph Yasi <joe.yasi@gmail.com>
Cc: linux-media@vger.kernel.org
Message-id: <49D4CC5F.9030101@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <e3538fbd0904012216g48da5006hb170974530bdcea3@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Joseph Yasi wrote:
> Hello,
> 
> With the cx23885 driver that shipped with 2.6.29, as well as the
> latest hg driver, the analog mpeg encoder device for the HVR-1800 does
> not respond to the VIDIOC_QUERYCAP ioctl, returning ENOTTY.  This
> ioctl previously worked with the driver in 2.6.28.  The preview device
> does respond to the ioctl properly, and I am able to tune and set the
> input via the preview device.  I can also capture MPEG using a simple
> cat /dev/video1 > out.mpg.  Are the ioctls supposed to work on the
> mpeg device, or should it be tuned via the preview device only?

Most of the ioctls I tested were against the preview device, although some do 
work on the encoder device itself (bitrate etc).

- Steve
