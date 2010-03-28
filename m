Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f222.google.com ([209.85.219.222]:57125 "EHLO
	mail-ew0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab0C1K5g (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Mar 2010 06:57:36 -0400
Received: by ewy22 with SMTP id 22so1544667ewy.37
        for <linux-media@vger.kernel.org>; Sun, 28 Mar 2010 03:57:35 -0700 (PDT)
Received: from joro by silent with local (Exim 4.71)
	(envelope-from <gtellalov@bigfoot.com>)
	id 1Nvq5p-0001LR-5r
	for linux-media@vger.kernel.org; Sun, 28 Mar 2010 13:51:45 +0300
Date: Sun, 28 Mar 2010 13:51:45 +0300
From: George Tellalov <gtellalov@bigfoot.com>
To: linux-media@vger.kernel.org
Subject: Hauppauge WinTV HVR-900H
Message-ID: <20100328105145.GA2427@joro.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello linux-media,

I've recently bought an HVR-900H usb hybrid tuner (marketed as 900-without-h)
and discovered that it's been unsupported for a while now. Nevertheless
some work is being done there:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg16498.html
I've tried the patch (with linux 2.6.32) and I got as far as the firmware
being uploaded, but when I tried playing some TV it crashed the kernel.
I'm willing to help speeding up the driver development, so I was wondering if
there's anything I can start with (like testing). Hopefully I'll be able to do
some development later on, but I've got a lot of reading ahead before this could
happen.

Oh, yes - the device id is 2040:6600.

Regards
George
