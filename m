Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:35455 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751125AbdFBNIz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 2 Jun 2017 09:08:55 -0400
MIME-Version: 1.0
From: Ajay kumar <ajaynumb@gmail.com>
Date: Fri, 2 Jun 2017 18:38:53 +0530
Message-ID: <CAEC9eQNW1hHrn2p9Tu-WR3Kft62x71383HjwbJQSiq_iWebsnw@mail.gmail.com>
Subject: Support for RGB/YUV 10, 12 BPC(bits per color/component) image data
 formats in kernel
To: LKML <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I have tried searching for RGB/YUV 10, 12 BPC formats in videodev2.h,
media-bus-format.h and drm_fourcc.h
I could only find RGB 10BPC support in drm_fourcc.h.
I guess not much support is present for formats with (BPC > 8) in the kernel.

Are there any plans to add fourcc defines for such formats?
Also, I wanted to how to define fourcc code for those formats?

Thanks,
Ajay Kumar
