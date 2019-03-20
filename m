Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B2C9C10F05
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 14:55:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A9692146E
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 14:55:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A+JYGhZ3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728441AbfCTOy7 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 10:54:59 -0400
Received: from mail-vs1-f73.google.com ([209.85.217.73]:50823 "EHLO
        mail-vs1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728445AbfCTOwD (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 10:52:03 -0400
Received: by mail-vs1-f73.google.com with SMTP id b68so847552vsb.17
        for <linux-media@vger.kernel.org>; Wed, 20 Mar 2019 07:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=o/tjHBN+YdVOHlZBhUHSY9iDnhLS0V50uWJeHP43be4=;
        b=A+JYGhZ3fQkhscb6lUBmQ1muz6oemHopDmPki/B278rzjZ0dk/UjohSsOxEu8keiCi
         W5/VXLZ67gUh0RZN3rq5skpPYsUC7oWDq+tl+3khHwdNxCrmhkhxq7w99dcsLgc3Elx7
         dmeBy427vSPfFNaJS7DfUhAb/Fwd/EACn2TYRVMksoGnObzxZTWUPnBuSuAiS/JRvPZA
         f0EsOCj85jPSuENzq/Bg7zakYTOA4bo6fX1BKjPllZeRcF3GtXBJjjiVIF4U6HkOW9id
         X49/giQrlJvYsmuoQtVxMGCVLZT2pR3apmEVULZaKks3LsI2Ip7Pr6oRl+H4swKOnmZR
         D5tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=o/tjHBN+YdVOHlZBhUHSY9iDnhLS0V50uWJeHP43be4=;
        b=dOlzH42ly97UbdzpxJ29fLDfw/nfPsFLEvOj1BmI7W2OzCPCSmEicmvz/Xz/A+TAOX
         60Ddwm7xls/LFugiMPIP14rOmMDOusPpLKFI4tW49lWsPv2y4fPmfltIFYEC5LO/qkHX
         o5BE6Xu/zoYVAw8skZtuWntFLRGcihBf7y+3pSWYKTfp9p0wCO3fwG9T8EwFxvuqcNlz
         9Ipp2dgGqaH5twPDy4ZS1WHBXPfCLpEKJt4/7uWdlRBzW/5rGt5uDeUta7SjmhpdeVsz
         kBKemgOXS4cBQX31eQcLC5+cl7tx5m6P6HBACBlkl6GjsW6O+pwEmG5KFPomVrKNgKtM
         Cy3w==
X-Gm-Message-State: APjAAAXf5PIAy2HfINWL0DiYTMjRC0AEeP4sGpfZe+ioAIv3xqD9zXNl
        PYD+0nqFK0RXGGQGOr+SW8Nb4LiF4XQJvrul
X-Google-Smtp-Source: APXvYqyHOngs34In5uhQcXPzOfQqpf0ARHPrNyLHXpzz5ogONfScZvSMOj1YE9ihREsOQQ2kQeo8TqNX7xzilecW
X-Received: by 2002:a67:7651:: with SMTP id r78mr6363022vsc.39.1553093522664;
 Wed, 20 Mar 2019 07:52:02 -0700 (PDT)
Date:   Wed, 20 Mar 2019 15:51:20 +0100
In-Reply-To: <cover.1553093420.git.andreyknvl@google.com>
Message-Id: <e1430838d7393896ade87ffbcf109c7127881137.1553093421.git.andreyknvl@google.com>
Mime-Version: 1.0
References: <cover.1553093420.git.andreyknvl@google.com>
X-Mailer: git-send-email 2.21.0.225.g810b269d1ac-goog
Subject: [PATCH v13 06/20] mm, arm64: untag user pointers in get_vaddr_frames
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

get_vaddr_frames uses provided user pointers for vma lookups, which can
only by done with untagged pointers. Instead of locating and changing
all callers of this function, perform untagging in it.

Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
---
 mm/frame_vector.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/frame_vector.c b/mm/frame_vector.c
index c64dca6e27c2..c431ca81dad5 100644
--- a/mm/frame_vector.c
+++ b/mm/frame_vector.c
@@ -46,6 +46,8 @@ int get_vaddr_frames(unsigned long start, unsigned int nr_frames,
 	if (WARN_ON_ONCE(nr_frames > vec->nr_allocated))
 		nr_frames = vec->nr_allocated;
 
+	start = untagged_addr(start);
+
 	down_read(&mm->mmap_sem);
 	locked = 1;
 	vma = find_vma_intersection(mm, start, start + 1);
-- 
2.21.0.225.g810b269d1ac-goog

