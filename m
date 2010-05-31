Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp6-g21.free.fr ([212.27.42.6]:39972 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754542Ab0EaW1X (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 May 2010 18:27:23 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Soc-camera and 2.6.33
References: <87fx17vmzd.fsf@free.fr>
	<Pine.LNX.4.64.1005312338280.16053@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Tue, 01 Jun 2010 00:27:14 +0200
In-Reply-To: <Pine.LNX.4.64.1005312338280.16053@axis700.grange> (Guennadi Liakhovetski's message of "Mon\, 31 May 2010 23\:51\:43 +0200 \(CEST\)")
Message-ID: <87bpbvvha5.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> Hi Robert
>
> a lot of things changed in and around soc-camera between 2.6.30 and 
> .33... E.g., previously you could load driver modules in any order, it 
> would work in any case. Now if you load your host driver (pxa) and your 
> client driver is not there yet, it should be automatically loaded. 
> However, if your user-space doesn't support this, it won't work. Can this 
> be the reason gor your problem? Otherwise, I'd suspect a problem with your 
> platform data (cf. other platforms), or, eventually with mt9m111.

I have a very tiny system :
 - udev
 - a shell (/bin/ash)
 - a libc
 - busybox (insmod/modprobe/rmmod/ls)
 - capture_example compiled as my testbed

I do :
 - insmod mt9m111.ko
 - insmod pxa_camera.ko

My userspace hasn't changed since 2.6.30 (constant executables, ARM-EABI). My
platform was converted by you in commit a48c24a696f0d93c49f913b7818e9819612b1f4e
if I remember correctly.

Any hint for me to track down my problem ?

Cheers.


-- 
Robert
