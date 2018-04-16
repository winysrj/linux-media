Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f182.google.com ([209.85.128.182]:39437 "EHLO
        mail-wr0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752511AbeDPJdm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Apr 2018 05:33:42 -0400
Received: by mail-wr0-f182.google.com with SMTP id q6so11904729wrd.6
        for <linux-media@vger.kernel.org>; Mon, 16 Apr 2018 02:33:42 -0700 (PDT)
MIME-Version: 1.0
From: david bensoussan <minipada@gmail.com>
Date: Mon, 16 Apr 2018 11:33:20 +0200
Message-ID: <CALxi_JG+=9vS_iBtFdB05eKgMt084882MSruXXqN=g7QHuUd5A@mail.gmail.com>
Subject: RPI 3 64bit (aarch64) image cropped
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
I'm currently working with a RPI 3 in 64 bit os.

I have the issue that the image captured is cropped. I don't know
where it comes from but I'm exploring all possibilities. Note that it
works perfectly on a 32 bits os with same versions of v4l, kernel,
libc and everything. The system is generated with Yocto so I'm 100%
sure the versions don't change.

I don't think the kernel plays a big role here and my knowledge about
it is not significant enough to dig into the image capture calls
easily.
I tried using musl instead of libc but results are similar. I don't
need to enable quirks to fetch the image when using it but the cropped
image is exactly the same.

Here is the system configuration:

* Kernel 4.9.52
* v4l 1.14.2
* XHV57-NBL60 usb camera with uvcvideo driver

Would you know how I could know V4l is not causing such issue?

Best regards,
David Bensoussan
