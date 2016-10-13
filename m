Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:36863 "EHLO
        mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755235AbcJMF6h (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Oct 2016 01:58:37 -0400
Received: by mail-qk0-f172.google.com with SMTP id o68so113528516qkf.3
        for <linux-media@vger.kernel.org>; Wed, 12 Oct 2016 22:57:20 -0700 (PDT)
MIME-Version: 1.0
From: Rajil Saraswat <rajil.s@gmail.com>
Date: Thu, 13 Oct 2016 00:57:19 -0500
Message-ID: <CAFoaQoACFuK7uZ-PC+9GSE+sfubo_0HmOdWH9cqV7EBL3Coo0Q@mail.gmail.com>
Subject: ivtv kernel panic
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I have a system with 4GB ram and two Hauppauge PVR-500 cards (each
with a daughter card). With kernel 4.0.9 both the cards were working
fine. However, after upgrading to 8GB ram, the kernel paniced with an
error, "Random memory could be DMA written".

I upgraded to kernel 4.2.21 which is latest stable release for gentoo.
The system again panicked on bootup. However, if i disable the
following module options
(https://www.mythtv.org/wiki/Hauppauge_PVR-350)  the system boots up
fine.

options ivtv enc_mpg_buffers=16 enc_yuv_buffers=20 enc_pcm_buffers=640 debug=3

Any idea how can i use these options?

Thanks
Rajil
