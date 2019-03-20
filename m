Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 859C3C4360F
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 14:53:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55F7D206BA
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 14:53:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cS/GWV3n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728199AbfCTOxt (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 10:53:49 -0400
Received: from mail-vs1-f74.google.com ([209.85.217.74]:36658 "EHLO
        mail-vs1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728618AbfCTOwb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 10:52:31 -0400
Received: by mail-vs1-f74.google.com with SMTP id j72so876416vsd.3
        for <linux-media@vger.kernel.org>; Wed, 20 Mar 2019 07:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=m8A/eWnO1t/szRUY+Sf0prGvVhEq1OhdUwg16kciR9Y=;
        b=cS/GWV3n1i5lKwRxDER3D1j30wbKLrIjlKCprX6vTMe8cTVCKT78AfLte355OG84/3
         9+SHdUMKMpHe6+iOH3VzHT8pjZaRW6z5pqFcAKCDTvZf0KT3SG8dydvzjoFsqtcRHpO+
         s7SFViAVxLm68wpAwuS47+5QK7VNwFMa5b5lxPhRs6N/VfdBIHBgFKkHSvd9I7PtKYIh
         RebKnvIoWsQx14IlpHTag2G1jk9EWaN7+3KeAj9wdOKQHYUJVkQSYeiCwVLs53b9gTS2
         jR0wtaevF8SL4RJoxbCrc5cwPvE9OCqov4p9AQcvaLAPdf8xImWPv+ch+hRrKoxeSje1
         7BOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=m8A/eWnO1t/szRUY+Sf0prGvVhEq1OhdUwg16kciR9Y=;
        b=kbtu6gVm1XSlaJk75UUl5Dp7GcPzIjl8V5DZZKOUZdkfyrlx969TW/EIAdBAYo5ifu
         fnJrw1xnCUlx6lRAmVkxO4p2sbEovtRZj+fDICe61R3AbAZmvlWIVdNbC082ijynJRjp
         wv4aS4e4W3fq5dFyvkdnVxTAY1NioBy/Q/sn2ZPMw5fkOq9SeiiX297IZzEYrku/agFy
         9M3oU5wJFodXFp+H9MjuswSsz7rHM/QI2plJk2KRX/Np5nb0bLL9vTEcYh2tEwrBqlok
         zZ//UHhcEQNWGKx1GwudI1EZ58cuueu9hmcsjC572/DKhUc9YFAcG4Ah7mCHixUxoh2i
         xqbQ==
X-Gm-Message-State: APjAAAXvpavtHpGeyNrSGV8xC8SXVbXiREdN3dCO5Yhus4hA/sW8qLJF
        GrRFbQ7sqFaHmUHqSVn7L5khltdoXH8cE6sC
X-Google-Smtp-Source: APXvYqw58aZo87dG3fwjMiai1M3z5FY5q/6ly8PoJSCWFGZ15x+DIhLzfcwRQ16QrQdSY5QNXUz25VoApSfh8lGu
X-Received: by 2002:a1f:c507:: with SMTP id v7mr16491398vkf.18.1553093549995;
 Wed, 20 Mar 2019 07:52:29 -0700 (PDT)
Date:   Wed, 20 Mar 2019 15:51:28 +0100
In-Reply-To: <cover.1553093420.git.andreyknvl@google.com>
Message-Id: <017804b2198a906463d634f84777b6087c9b4a40.1553093421.git.andreyknvl@google.com>
Mime-Version: 1.0
References: <cover.1553093420.git.andreyknvl@google.com>
X-Mailer: git-send-email 2.21.0.225.g810b269d1ac-goog
Subject: [PATCH v13 14/20] drm/amdgpu, arm64: untag user pointers in amdgpu_ttm_tt_get_user_pages
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

amdgpu_ttm_tt_get_user_pages() uses provided user pointers for vma
lookups, which can only by done with untagged pointers.

Untag user pointers in this function.

Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
index 73e71e61dc99..891b027fa33b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -751,10 +751,11 @@ int amdgpu_ttm_tt_get_user_pages(struct ttm_tt *ttm, struct page **pages)
 		 * check that we only use anonymous memory to prevent problems
 		 * with writeback
 		 */
-		unsigned long end = gtt->userptr + ttm->num_pages * PAGE_SIZE;
+		unsigned long userptr = untagged_addr(gtt->userptr);
+		unsigned long end = userptr + ttm->num_pages * PAGE_SIZE;
 		struct vm_area_struct *vma;
 
-		vma = find_vma(mm, gtt->userptr);
+		vma = find_vma(mm, userptr);
 		if (!vma || vma->vm_file || vma->vm_end < end) {
 			up_read(&mm->mmap_sem);
 			return -EPERM;
-- 
2.21.0.225.g810b269d1ac-goog

