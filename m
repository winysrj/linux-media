Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8D00C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 14:55:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98D6A2186A
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 14:55:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fBgfxh9G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728323AbfCTOvs (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 10:51:48 -0400
Received: from mail-vk1-f202.google.com ([209.85.221.202]:45981 "EHLO
        mail-vk1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728316AbfCTOvr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 10:51:47 -0400
Received: by mail-vk1-f202.google.com with SMTP id w71so1038217vkd.12
        for <linux-media@vger.kernel.org>; Wed, 20 Mar 2019 07:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=20ADMBvUHCnrZbwN97RAJ/EQy38heFRI/sJcSeCbm08=;
        b=fBgfxh9GgamRMHg2ccGZFUoBByz4GOt4sfGHL3tpn3ZQ1767xayTeCcyI3yXs2mSPo
         9L9Z+nWnCgS1IkEZKl0L10t99Kxoazx3+kM5cwGHIxLejwB/C6WPwJK7TADmWr+R7zyk
         SVEtWmrnvfwXlM1zlGyhZQZOBAu3t9jHBJl+/8o9qgFuWwu995t1w8VbhpR252WdIqRb
         sE8Ml1x7tGBmVRlYQ2buPK+l8HSNYgOfT1+UtDa9CPF/KYM3j84TJNM8Ny+6EFQlptxm
         +USjsypvXQxVHDirJ+TCg6zJChaLRFAlYddXbqGYhP/AQ/lMXeTl1LdpntucdrWI+Hfw
         RS9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=20ADMBvUHCnrZbwN97RAJ/EQy38heFRI/sJcSeCbm08=;
        b=AePXQwICoYv5pa8+LAOUYJ9CYZvFiMzkje4hwNS4fz+6e6UKMxLVE46eQIaoEjPIKS
         H3h8MOVXsmpEag5ger1DS87oCXFVqIYxqvz48mGSDhOQ+66EAC4U8L0fLWxEBqTNAhQZ
         qmxcNnXOc62SVgazNzufFMiXxNz8MPjGhxpU32Yb88ks96gfUx9am8rRZNiUi+9RZjOz
         8uDtIehZufpy2aWhefnXpFrQIBuWMnnjSENbb43NntzKeNHTlut10t8jdMh/1DY7ONEH
         XNGoimNpHbKEmLVGXnCVpcC2rR4wXTAvZYN8EBVZJj3Exi2bm5zkiqL2qi+UnjO7iuDx
         +1+Q==
X-Gm-Message-State: APjAAAWTActAp9G42KTgLco27TtJKHzyICMbwppEulYpnbxJiosmpfiz
        1U3ZbFHg2YYmCOU2BmV+MPm1eeTDS0cEbcll
X-Google-Smtp-Source: APXvYqwYZ0q0Kqz4Z5cFxviM/RSvP8v992XNq+tHsBzIasT+5NuCnNNfSRat/OKpd5fkXdzMwZGbNS7t4SMgCBo4
X-Received: by 2002:a1f:2a48:: with SMTP id q69mr16477241vkq.7.1553093506075;
 Wed, 20 Mar 2019 07:51:46 -0700 (PDT)
Date:   Wed, 20 Mar 2019 15:51:15 +0100
In-Reply-To: <cover.1553093420.git.andreyknvl@google.com>
Message-Id: <7747d94301bcb30de0026e9434a1e1879f84aae7.1553093421.git.andreyknvl@google.com>
Mime-Version: 1.0
References: <cover.1553093420.git.andreyknvl@google.com>
X-Mailer: git-send-email 2.21.0.225.g810b269d1ac-goog
Subject: [PATCH v13 01/20] uaccess: add untagged_addr definition for other arches
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

To allow arm64 syscalls to accept tagged pointers from userspace, we must
untag them when they are passed to the kernel. Since untagging is done in
generic parts of the kernel, the untagged_addr macro needs to be defined
for all architectures.

Define it as a noop for architectures other than arm64.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
---
 include/linux/mm.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 76769749b5a5..4d674518d392 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -99,6 +99,10 @@ extern int mmap_rnd_compat_bits __read_mostly;
 #include <asm/pgtable.h>
 #include <asm/processor.h>
 
+#ifndef untagged_addr
+#define untagged_addr(addr) (addr)
+#endif
+
 #ifndef __pa_symbol
 #define __pa_symbol(x)  __pa(RELOC_HIDE((unsigned long)(x), 0))
 #endif
-- 
2.21.0.225.g810b269d1ac-goog

