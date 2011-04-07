Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39290 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab1DGRdB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Apr 2011 13:33:01 -0400
Received: by bwz15 with SMTP id 15so2187549bwz.19
        for <linux-media@vger.kernel.org>; Thu, 07 Apr 2011 10:33:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=r5nY6ZnQhNiYH8XrYuVdv-9Qu3Q@mail.gmail.com>
References: <BANLkTi=r5nY6ZnQhNiYH8XrYuVdv-9Qu3Q@mail.gmail.com>
From: William Huang <chekgiau@gmail.com>
Date: Fri, 8 Apr 2011 01:32:40 +0800
Message-ID: <BANLkTik60Bzd2fwmEq7b4SpSOWkz+0k8=A@mail.gmail.com>
Subject: V4L/DVB (13598): videobuf_dma_contig_user_get() for non-aligned offsets
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi all,

I have a question about the following videobuf_dma_contig_user_get()
fix to 2.6.33:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blobdiff;f=drivers/media/video/videobuf-dma-contig.c;h=22c01097e8a821f95c04ae9d8ae9432623381d46;hp=d25f28461da1fcaac4b5d74ad8d6cac65e286b4f;hb=31bedfa5068936b15a388842be1d03cdd1bdfb07;hpb=0d94e29459d372b6c5dda964a8b35a8d40050ca7

By including offset into the calculation of mem->size, doesn't that
impact the correctness of the sequent bound checking?

         if ((vb->baddr + mem->size) > vma->vm_end)
                 goto out_up;

Perhaps the fix should have been accompanied by the following change
to the above lines to avoid double counting of the non-align offset?

         if (PAGE_ALIGN(vb->baddr + vb->size) > vma->vm_end)
                 goto out_up;

Thanks,
William Huang
