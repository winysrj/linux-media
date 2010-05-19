Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f216.google.com ([209.85.219.216]:33231 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab0ESKnn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 May 2010 06:43:43 -0400
Received: by ewy8 with SMTP id 8so2564333ewy.28
        for <linux-media@vger.kernel.org>; Wed, 19 May 2010 03:43:42 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 19 May 2010 12:43:42 +0200
Message-ID: <AANLkTimd2wwGe_cHhDPiRZkzEsIrtn7AwaIWFfMBbgl5@mail.gmail.com>
Subject: konicawc webcam driver
From: Patryk Biela <patryk.biela@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have a problem with usb camera driver. It's konicawc. It was working
in previous kernels 2.4 for sure and perhaps in 2.6. Now in the latest
kernel it doesn't work.
The file is /drivers/media/video/usbvideo/konicawc.c
I couldn't find anyone in MAINTAINERS for this driver.

The error message is "Lost sync on frames" the same as here
https://lists.linux-foundation.org/pipermail/bugme-new/2004-August/010977.html
There is a patch but it seems it's already applied in current source.

If it could help.I can try older version to find out when this driver broke.

-- 
Patryk Biela
