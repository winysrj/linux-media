Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:33323 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436AbbJDODC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Oct 2015 10:03:02 -0400
Received: by igbkq10 with SMTP id kq10so46977291igb.0
        for <linux-media@vger.kernel.org>; Sun, 04 Oct 2015 07:03:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5610B12B.8090201@tresar-electronics.com.au>
References: <5610B12B.8090201@tresar-electronics.com.au>
Date: Sun, 4 Oct 2015 10:03:01 -0400
Message-ID: <CALzAhNWuOhQNQFu-baXy6QzhV3AxCknh7XeKOBjp943nz66Qyw@mail.gmail.com>
Subject: Re: Hauppauge WinTV-HVR2205 driver feedback
From: Steven Toth <stoth@kernellabs.com>
To: Richard Tresidder <rtresidd@tresar-electronics.com.au>
Cc: Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Seems the kzalloc(4 * 1048576, GFP_KERNEL) in saa7164-fw.c  was failing..
> kept getting:  kernel: modprobe: page allocation failure: order:10,
> mode:0x10c0d0

I don't think I've ever seen or heard of that in the entire history of
the driver.

Are you running on traditional x86/x86 hardware, or something embedded/custom?

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
