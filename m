Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:53208 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752067AbeC2N2l (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Mar 2018 09:28:41 -0400
Received: by mail-wm0-f67.google.com with SMTP id l9so10857708wmh.2
        for <linux-media@vger.kernel.org>; Thu, 29 Mar 2018 06:28:41 -0700 (PDT)
To: Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans de Goede <hdegoede@redhat.com>
Subject: Wrong use of GFP_DMA32 in drivers/media/platform/vivid/vivid-osd.c
Message-ID: <6472767d-4b7f-818d-7b4a-682cc7423002@redhat.com>
Date: Thu, 29 Mar 2018 15:28:39 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans, et. al.,

While debugging another GFP_DMA32 problem I did a quick
grep for GFP_DMA32 on the kernel, this result stood out:

drivers/media/platform/vivid/vivid-osd.c
373:    dev->video_vbase = kzalloc(dev->video_buffer_size, GFP_KERNEL | GFP_DMA32);

Because it is making the same mistake as I was, you cannot use
GDP_DMA32 with kmalloc and friends, it will end up being
ignored. If you need memory below 4G you must call alloc_pages
for get_free_pages with GFP_DMA32 to get it.

Regards,

Hans
