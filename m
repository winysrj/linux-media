Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:13694 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934915AbZJNQjW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Oct 2009 12:39:22 -0400
Received: by ey-out-2122.google.com with SMTP id 9so7138eyd.19
        for <linux-media@vger.kernel.org>; Wed, 14 Oct 2009 09:38:15 -0700 (PDT)
Message-ID: <4AD5FE72.80803@gmail.com>
Date: Wed, 14 Oct 2009 13:38:10 -0300
From: Guilherme Longo <grlongo.ireland@gmail.com>
MIME-Version: 1.0
To: =?UTF-8?B?T251ciBLw7zDp8O8aw==?= <onur@delipenguen.net>,
	linux-media@vger.kernel.org
Subject: (V4L2_PIX_FMT_SBGGR8) wierd behavior trying to get image from buffer!
References: <4ACDF829.3010500@xfce.org>	<37219a840910080545v72165540v622efd43574cf085@mail.gmail.com>	<4ACDFED9.30606@xfce.org>	<829197380910080745j3015af10pbced2a7e04c7595b@mail.gmail.com>	<4ACE2D5B.4080603@xfce.org>	<829197380910080928t30fc0ecas7f9ab2a7d8437567@mail.gmail.com>	<4ACF03BA.4070505@xfce.org>	<829197380910090629h64ce22e5y64ce5ff5b5991802@mail.gmail.com>	<4ACF714A.2090209@xfce.org>	<829197380910090826r5358a8a2p7a13f2915b5adcd8@mail.gmail.com>	<4AD5D5F2.9080102@xfce.org>	<20091014093038.423f3304@pedra.chehab.org>	<4AD5EEA0.2010709@xfce.org>	<4AD5E813.2070406@gmail.com> <20091014185733.45a84258.onur@delipenguen.net>
In-Reply-To: <20091014185733.45a84258.onur@delipenguen.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

You guys with more experience could tell me why this strange behavior 
with my app.

First of all, I built my app from a code well known in the Video For 
Linux spec. It is a capture example.

1º - Why is this  /* Buggy driver paranoia. */?
            min = fmt.fmt.pix.width * 2;

        if (fmt.fmt.pix.bytesperline < min)
                fmt.fmt.pix.bytesperline = min;
        min = fmt.fmt.pix.bytesperline * fmt.fmt.pix.height;
        if (fmt.fmt.pix.sizeimage < min)
                fmt.fmt.pix.sizeimage = min;

2º - I am using libv4l, and using the V4L2_PIX_FMT_SBGGR8 pixelformat in order 
to get 640x480 of resolution. Otherwise I get only 160x120!

This is where the problem lies, I can´t get a good image, I am actually 
getting no more than fuzzy image. So I presumed that I am geting smth else 
from the buffer instead of the data I should get. I started checking the parameters and plz, 
have a look at this wierd response: 

fmt.fmt.pix.width:        640   <- Fine
fmt.fmt.pix.height:       480   <- Fine
fmt.fmt.pix.bytesperline: 1920  <- How comes ? It is 3 times more, in the SBGGR8 pixelformat each pixel is 1 byte!
fmt.fmt.pix.sizeimage:    921600 <- The image is (fmt.fmt.pix.bytesperline * fmt.fmt.pix.height)

I believe that this sizeimage should be set to 307200, representing 640 * 480.


Is there someone familiar with this problem and how to solve it??
Great regards.
Guilherme Longo


 


