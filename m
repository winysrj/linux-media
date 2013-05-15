Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f51.google.com ([209.85.216.51]:61247 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756609Ab3EOKkz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 May 2013 06:40:55 -0400
Received: by mail-qa0-f51.google.com with SMTP id ii15so891727qab.10
        for <linux-media@vger.kernel.org>; Wed, 15 May 2013 03:40:54 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 15 May 2013 16:10:54 +0530
Message-ID: <CAPrYoTGjMQtTu5VTTY802YaFy8-zR-aEd=27ZKqcF60FAsR-JA@mail.gmail.com>
Subject: Doubt regarding DMA / VMALLOC memory ops
From: Chetan Nanda <chetannanda@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am new to V4L2 kernel framework. And currently trying to understand V4L2
kernel sub-system.
In videobuf2 sub-system, before calling 'vb2_queue_init(q)',  q's mem_ops is
being initialized (depending on type of buffer) as

q->mem_ops = &vb2_vmalloc_memops;
or
q->mem_ops = &vb2_dma_contig_memops

What is the purpose of these memory operations?
If user space is allocating the buffer (physically contiguous) via some other
kernel driver (hwmem - for android). Even then do we need to set mem_ops =
vb2_dma_contig_memops?


Thanks,
Chetan Nanda
