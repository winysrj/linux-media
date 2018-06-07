Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:43377 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753028AbeFGMH1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 7 Jun 2018 08:07:27 -0400
Received: by mail-lf0-f65.google.com with SMTP id n15-v6so14273288lfn.10
        for <linux-media@vger.kernel.org>; Thu, 07 Jun 2018 05:07:26 -0700 (PDT)
Received: from ?IPv6:2a02:228:1c01:100:b09d:4562:3f35:a4d0? ([2a02:228:1c01:100:b09d:4562:3f35:a4d0])
        by smtp.gmail.com with ESMTPSA id p28-v6sm5895106lja.13.2018.06.07.05.07.24
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 Jun 2018 05:07:24 -0700 (PDT)
To: linux-media@vger.kernel.org
From: Torleiv Sundre <torleiv@huddly.com>
Subject: Bug: media device controller node not removed when uvc device is
 unplugged
Message-ID: <fc69c83d-fbd6-d955-2e07-3960c052cb49@huddly.com>
Date: Thu, 7 Jun 2018 14:07:24 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Every time I plug in a UVC camera, a media controller node is created at 
/dev/media<N>.

In Ubuntu 17.10, running kernel 4.13.0-43, the media controller device 
node is removed when the UVC camera is unplugged.

In Ubuntu 18.10, running kernel 4.15.0-22, the media controller device 
node is not removed. For every time I plug the device, a new device node 
with incremented minor number is created, leaving me with a growing list 
of media controller device nodes. If I repeat for long enough, I get the 
following error:
"media: could not get a free minor"
I also tried building a kernel from mainline, with the same result.

I'm running on x86_64.

Torleiv Sundre
