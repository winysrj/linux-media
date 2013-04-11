Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:56755 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743Ab3DKH4Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Apr 2013 03:56:24 -0400
Received: from [127.0.0.1] ([80.88.22.144]) by smtp.web.de (mrweb101) with
 ESMTPSA (Nemesis) id 0LshKH-1UbV0x25G5-012oPD for
 <linux-media@vger.kernel.org>; Thu, 11 Apr 2013 09:56:22 +0200
Message-ID: <51666CA2.6080709@web.de>
Date: Thu, 11 Apr 2013 09:56:18 +0200
From: =?ISO-8859-1?Q?Andr=E9_Weidemann?= <Andre.Weidemann@web.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: uvcvideo: Dropping payload (out of sync)
References: <51650142.2060404@web.de>
In-Reply-To: <51650142.2060404@web.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10.04.2013 08:05, André Weidemann wrote:
> Hi,
>
> I ran into a problem while trying to get a "Microsoft LifeCam
> Studio(TM)" (045e:0772) to work with uvccapture on a Raspberry PI
> running Kernel 3.6.11 under Debian Wheezy.
>
> I started grabbing a picture with:
> /usr/bin/uvccapture -x1920 -y1080 -o/media/ramdisk/webcam.jpg -q80
>
> [1]
> http://ftp.de.debian.org/debian/pool/main/u/uvccapture/uvccapture_0.5.orig.tar.gz
>
> [2]
> http://ftp.de.debian.org/debian/pool/main/u/uvccapture/uvccapture_0.5-2.debian.tar.gz
>
>
> Grabbing a picture takes between 20 seconds and 1-2 minutes.
> Unfortuantely the captured image is heavily distorted.

For anyone who may also run into this problem here is a solution...

It seems the problem is hardware related to the Raspberry Pi. The 
solution can be found here:

https://github.com/raspberrypi/linux/issues/238
https://github.com/P33M/linux

André
