Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8A24C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 14:53:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 996C82146E
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 14:53:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qURJbhCG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728692AbfCTOxG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 10:53:06 -0400
Received: from mail-it1-f201.google.com ([209.85.166.201]:57250 "EHLO
        mail-it1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728687AbfCTOwr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 10:52:47 -0400
Received: by mail-it1-f201.google.com with SMTP id f5so1701422ita.6
        for <linux-media@vger.kernel.org>; Wed, 20 Mar 2019 07:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=cu+3rmCpd9l5R/y3h5ye/p2bAO3sj0NL49uODSAFDdE=;
        b=qURJbhCG7KHqBQdB9/tW98IIzZBOYUsNCATGgXe4awlobm2aNwlvzelxDOnoumvmrK
         b/mIN1JLFUKKEWmVODg3dQknY4u8cwFqoBa4ozFLzZZmudKVb83CGFLq+FRv9y/TTY/5
         rSAaXeLT2zCRImT4RVHFaAYM6bwxS8DucSU4cUJk/3I0DGhDXWwcI81c67HCNpygji6O
         BQV4zKGeru6kOZ2vSpeEayFmHj/NHgdIhgoL99CR9cRbaTnADs3WAujfChTy8IoPizRb
         Mdk25Ol5EHmWTCbmZlyFv2SlYAe5UuS3bv3kmLeOg32bRFdSdDmDonpBZBZt7FJH+Ous
         ilbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=cu+3rmCpd9l5R/y3h5ye/p2bAO3sj0NL49uODSAFDdE=;
        b=fDTXswfkgYgXzK1l1vZ3sVtyine4IzaNz0uUcU6PyKZZAlfGResC/Mrm2wnXnEQFUw
         kuo0TAnZzP156ylfl97ONkLcwWz7dBZAwHT9TSxJQu27SxbUD0pZfts9tM/h1OQSvSVv
         1Gg/C7RCiFUjjJzw+TR8lrKm0WYmSlgxo1Jqkp9PxNpJsYiCOY+Uvur1lZIo50p2qtZQ
         8z7YZOE+XMTLCQP6N6QXMEe631AgjgMuqwRAoy74QEgiBsd8kyIq3Bj92g9V0NIJkOry
         LIXZfQnSRhpSTZjc+MMT0l7YGL3bIWrSWZjP3hBDOLYEiyagq4WFMHqUFfq3VwE3P6IN
         Cixw==
X-Gm-Message-State: APjAAAUANthhyAVrCtxMROwAHzRUTIDl+GxxYw4Tti4TWB4vugIvdYnw
        LMss6i44uvRkFRRYtDifdOv6JlE9gfmJXKte
X-Google-Smtp-Source: APXvYqzqObcBEgYzlcxCxTM9fSSNzVasJ/zSQwN6PhFl+/lgxd7D8DoZLa9+GTthl0M6pkpwMktv8E+fN9uDrpLf
X-Received: by 2002:a05:660c:68d:: with SMTP id n13mr4682397itk.24.1553093566394;
 Wed, 20 Mar 2019 07:52:46 -0700 (PDT)
Date:   Wed, 20 Mar 2019 15:51:33 +0100
In-Reply-To: <cover.1553093420.git.andreyknvl@google.com>
Message-Id: <a49ac1a8e6d033dafd3beab0818900bde3d55860.1553093421.git.andreyknvl@google.com>
Mime-Version: 1.0
References: <cover.1553093420.git.andreyknvl@google.com>
X-Mailer: git-send-email 2.21.0.225.g810b269d1ac-goog
Subject: [PATCH v13 19/20] vfio/type1, arm64: untag user pointers in vaddr_get_pfn
From:   Andrey Konovalov <andreyknvl@google.com>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Kees Cook <keescook@chromium.org>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Shuah Khan <shuah@kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        "=?UTF-8?q?Christian=20K=C3=B6nig?=" <christian.koenig@amd.com>,
        "David (ChunMing) Zhou" <David1.Zhou@amd.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org,
        linux-media@vger.kernel.org, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>,
        Evgeniy Stepanov <eugenis@google.com>,
        Lee Smith <Lee.Smith@arm.com>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        Jacob Bramley <Jacob.Bramley@arm.com>,
        Ruben Ayrapetyan <Ruben.Ayrapetyan@arm.com>,
        Chintan Pandya <cpandya@codeaurora.org>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Kevin Brodsky <kevin.brodsky@arm.com>,
        Szabolcs Nagy <Szabolcs.Nagy@arm.com>,
        Andrey Konovalov <andreyknvl@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

This patch is a part of a series that extends arm64 kernel ABI to allow to
pass tagged user pointers (with the top byte set to something else other
than 0x00) as syscall arguments.

vaddr_get_pfn() uses provided user pointers for vma lookups, which can
only by done with untagged pointers.

Untag user pointers in this function.

Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
---
 drivers/vfio/vfio_iommu_type1.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 73652e21efec..e556caa64f83 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -376,6 +376,8 @@ static int vaddr_get_pfn(struct mm_struct *mm, unsigned long vaddr,
 
 	down_read(&mm->mmap_sem);
 
+	vaddr = untagged_addr(vaddr);
+
 	vma = find_vma_intersection(mm, vaddr, vaddr + 1);
 
 	if (vma && vma->vm_flags & VM_PFNMAP) {
-- 
2.21.0.225.g810b269d1ac-goog

