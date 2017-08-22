Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.ispras.ru ([83.149.199.45]:51968 "EHLO mail.ispras.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750962AbdHVQ0Z (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Aug 2017 12:26:25 -0400
From: Anton Volkov <avolkov@ispras.ru>
Subject: Possible memory leak in cafe_ccic.ko
To: corbet@lwn.net
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>
Message-ID: <9aac6eca-e553-0b49-d5ce-e49029b52fdc@ispras.ru>
Date: Tue, 22 Aug 2017 19:26:23 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

While searching for races in the Linux kernel I've come across 
"drivers/media/platform/marvell-ccic/cafe_ccic.ko" module. Here are 
questions that I came up with while analyzing results. Lines are given 
using the info from Linux v4.12.

Consider the following case:

Thread 1:                  Thread 2:
                            mcam_v4l_release
                            ->mcam_free_dma_bufs
                                cam->dma_bufs[i] = NULL
                                cam->nbufs = 0
cafe_pci_resume                (mcam-core.c: line 413)
->mccic_resume
   ->mcam_read_setup
     ->mcam_alloc_dma_bufs
       cam->dma_bufs[i] =
          dma_alloc_coherent()
          (mcam-core.c: line 381)

It looks like mcam_v4l_release() doesn't really shut the device down. In 
this case cafe_pci_resume() leaks memory for cam->dma_bufs[i] after 
mcam_v4l_release() freed and poisoned them. Is this feasible from your 
point of view?

Thank you for your time.

-- Anton Volkov
Linux Verification Center, ISPRAS
web: http://linuxtesting.org
e-mail: avolkov@ispras.ru
