Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13D26C4360F
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 14:52:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB6912146E
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 14:52:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aEInHw6B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728436AbfCTOwB (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 10:52:01 -0400
Received: from mail-yw1-f74.google.com ([209.85.161.74]:47133 "EHLO
        mail-yw1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728419AbfCTOwA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 10:52:00 -0400
Received: by mail-yw1-f74.google.com with SMTP id c188so3391380ywf.14
        for <linux-media@vger.kernel.org>; Wed, 20 Mar 2019 07:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=LfpjTjIWpAUqgBuBr+ROlRDq3TWjVWHbA3wqyLv7Gqg=;
        b=aEInHw6BmCYYrnLC9PZfamaP8mF0QEG6bCjPXX9eR1nz2FAxuz8AakcoBGofdWpDDO
         ecVj+WVvAcyIM/4jHbYKbWN9FEhIYhxx/aKOkZgY6J++xI42I0q0BxFc8HG1MgmsuX4p
         FgBukYgteSls5KRVIf9LdhyXrtbiuThjGHXpsr95ebbSY1J3++E89dF2htIPvvI1/DzR
         SYS+4UXKzfCBY88MgyuqrkPh/UK28DK8ANz0pzTScNriptvjxadnhKInYAl8KyI7hS2W
         ag76Sj+PtN/agIm/Cl1LRWjUtui4zCqqh5CFVGbEGTMZA2YuLM4VLbRUKwjvD9UBYhzt
         x9aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LfpjTjIWpAUqgBuBr+ROlRDq3TWjVWHbA3wqyLv7Gqg=;
        b=f+RvGdTS1irx/dAUrYkXEfDhxZlM2zDDV3qSQdU+nrO6KKzla4rWDYUttA+DANmGts
         jHqBnlvXAcUMEmL6Xx9r+6pjoz0XE/8o3hUJPGXOxZzVgIezjROFg5qT9nUXrkc63wUi
         NaRTmumYzG2qDUuTlPhmU7x6/U6XZAUjNtQs4mic+/D0arNYcggEX43lSbUhWClsyYRx
         1MRe3LSjOLvI4k7ZsFgK4OAj5g4cXMkxkNv0RNV/wYWPodoUV3CSsv4wExlQ+6nMVW6d
         gzm2ergC73Hzy4AdeRgiQxbfDbhmaJf7mHRrlKfOJc1DFFhlKsJCfnjbMONS7IgNssWe
         Dx7w==
X-Gm-Message-State: APjAAAXODFNvYfMgEsgkjiS3xuifJwbeSMu2gkS2c/4WAbmwuCUxuygX
        +ccWeIv/Xiw+OrZA7dpEeessTH8i5B7lLFJS
X-Google-Smtp-Source: APXvYqxWvfeu7/LSMKKYKhkYxK38R+2YVgnBYPzEJZ3bjv+W/V6SCf9AmAnMy/L0N0KnMLwcoOG80tlOQ6HUd2Ol
X-Received: by 2002:a81:994d:: with SMTP id q74mr2209556ywg.18.1553093519515;
 Wed, 20 Mar 2019 07:51:59 -0700 (PDT)
Date:   Wed, 20 Mar 2019 15:51:19 +0100
In-Reply-To: <cover.1553093420.git.andreyknvl@google.com>
Message-Id: <a8766f523b5b46b7fa55a87ef55cd3fe6ab2d345.1553093421.git.andreyknvl@google.com>
Mime-Version: 1.0
References: <cover.1553093420.git.andreyknvl@google.com>
X-Mailer: git-send-email 2.21.0.225.g810b269d1ac-goog
Subject: [PATCH v13 05/20] mm, arm64: untag user pointers in mm/gup.c
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

mm/gup.c provides a kernel interface that accepts user addresses and
manipulates user pages directly (for example get_user_pages, that is used
by the futex syscall). Since a user can provided tagged addresses, we need
to handle this case.

Add untagging to gup.c functions that use user addresses for vma lookups.

Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
---
 mm/gup.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/gup.c b/mm/gup.c
index f84e22685aaa..3192741e0b3a 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -686,6 +686,8 @@ static long __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 	if (!nr_pages)
 		return 0;
 
+	start = untagged_addr(start);
+
 	VM_BUG_ON(!!pages != !!(gup_flags & FOLL_GET));
 
 	/*
@@ -848,6 +850,8 @@ int fixup_user_fault(struct task_struct *tsk, struct mm_struct *mm,
 	struct vm_area_struct *vma;
 	vm_fault_t ret, major = 0;
 
+	address = untagged_addr(address);
+
 	if (unlocked)
 		fault_flags |= FAULT_FLAG_ALLOW_RETRY;
 
-- 
2.21.0.225.g810b269d1ac-goog

