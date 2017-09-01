Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:32942 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752005AbdIAQfV (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Sep 2017 12:35:21 -0400
Received: by mail-wr0-f174.google.com with SMTP id k94so1917531wrc.0
        for <linux-media@vger.kernel.org>; Fri, 01 Sep 2017 09:35:20 -0700 (PDT)
Received: from [192.168.1.5] ([37.248.155.247])
        by smtp.gmail.com with ESMTPSA id g106sm766171wrd.4.2017.09.01.09.35.18
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Sep 2017 09:35:19 -0700 (PDT)
To: linux-media@vger.kernel.org
From: Rafal <fatwildcat@gmail.com>
Subject: v4l2_ioctl vidioc_s_fmt/vidioc_try_fmt pix <--> pix_mp conversion
Message-ID: <f4dba9e7-0ce9-1ba9-fd75-679709661e9d@gmail.com>
Date: Fri, 1 Sep 2017 18:35:17 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Could somebody explain to me some strange behavior of v4l2_ioctl call?

When a device supports |V4L2_CAP_VIDEO_OUTPUT_MPLANE capability but does 
not support ||V4L2_CAP_VIDEO_OUTPUT, the |v4l2_ioctl function converts 
VIDIOC_S_FMT ioctl call: for example, when the specified buffer type is 
V4L2_BUF_TYPE_VIDEO_OUTPUT, it is changed to 
V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE. But the num_planes value is not 
checked after the ioctl call, like after VIDIOC_G_FMT ioctl call is 
made. Device may change the num_planes value in call, especially since 
number of planes is determined by pixelformat. For example, V4L2 
distinguishes single-plane variant of YUV420 format 
(V4L2_PIX_FMT_YUV420) from multi-plane one (V4L2_PIX_FMT_YUV420M). If 
the number of planes is not checked, program may select multi-plane 
variant, which will not handle correctly. Shouldn't the library check 
the number of planes after ioctl call?


Rafal
