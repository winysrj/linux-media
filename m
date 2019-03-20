Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36FADC43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 14:54:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 072742146E
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 14:54:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JN7peWS7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728597AbfCTOw2 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 10:52:28 -0400
Received: from mail-qt1-f201.google.com ([209.85.160.201]:42504 "EHLO
        mail-qt1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728590AbfCTOw1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 10:52:27 -0400
Received: by mail-qt1-f201.google.com with SMTP id n10so2670562qtk.9
        for <linux-media@vger.kernel.org>; Wed, 20 Mar 2019 07:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=BhVJ8uqyuZN/RhYo8e4D2Wo6j82d4Ue7nF7755mNwHM=;
        b=JN7peWS7Nez+2uGYBenvD1URtgpAIqAee70ib/k/sIrShjHTRTOTS60cMewca4/dl+
         dG9NPJL3RBHz+jByCPy9VsQpiotQxDiag9Y5aB1mow2uCgebTPUHJtgOnmaSI9Vr/YIx
         hQI/v/gR0GvyO5deZUXNGQI2iRQRxhpRf4qspE3jPUxJjXOAuD/wl6/iqPcyOgYmtLKK
         MWpwP9BARDOkmKwS67XX82wJzNDDELNK9gdSeTBhBvMrWdTjib0F+nJEJKUwKFoB/pDB
         SXeryLoUidHqjz93zv8BQ7DsI9WVz5TfwJy9iV6N2sA8iMykCz2Q8F38PNgxFh8B+8WB
         8apg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BhVJ8uqyuZN/RhYo8e4D2Wo6j82d4Ue7nF7755mNwHM=;
        b=e9Tp910NzONY4EIbUMQqxEDqjaP9flvUEq73iY5oDafHrBJ5MZcJmiMvrw9slwBeln
         IMeD/tM+BF7easeVcNG9jE+QIKasSw6BMRR01up/3nss9Vhvmbhc3C69kmOC+t75HhZ2
         QSDq7ZDR55x5ELs0cVlSzLhaR01WhuAjSCDANspWU4+CX5tZBwsmtAREoDwzkb92qple
         beF+YmQR3vGwzMJwdPvwEdvSkuUEvXe8Wh0N3PrgU7tFzbyUGYygVSpj3D4FGonKye3j
         b3tfiiQ0MRiJAZUG9l1tqgJKykqFEoC5guIXXkuVK/NZCo2BdlDBkVlstQJpGzO1mHFE
         kcEg==
X-Gm-Message-State: APjAAAWiBw2shNk2ffjznU1zy20IEW+3rOaz/Ga55qOXZ5ey6IcC/kJx
        UnTASsnhNuaphq8/cXz9UPGuWbr/wup6BqjP
X-Google-Smtp-Source: APXvYqwzO9qScb+3DLKygLOG3z91c2IWDiaev09n3TsGmqkOq4NcQ5CsSt3t0f+AffnIIDyplmnedU704klPsHau
X-Received: by 2002:a05:620a:15fa:: with SMTP id p26mr919440qkm.51.1553093546857;
 Wed, 20 Mar 2019 07:52:26 -0700 (PDT)
Date:   Wed, 20 Mar 2019 15:51:27 +0100
In-Reply-To: <cover.1553093420.git.andreyknvl@google.com>
Message-Id: <09d6b8e5c8275de85c7aba716578fbcb3cbce924.1553093421.git.andreyknvl@google.com>
Mime-Version: 1.0
References: <cover.1553093420.git.andreyknvl@google.com>
X-Mailer: git-send-email 2.21.0.225.g810b269d1ac-goog
Subject: [PATCH v13 13/20] bpf, arm64: untag user pointers in stack_map_get_build_id_offset
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

stack_map_get_build_id_offset() uses provided user pointers for vma
lookups, which can only by done with untagged pointers.

Untag user pointers in this function for doing the lookup and
calculating the offset, but save as is in the bpf_stack_build_id
struct.

Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
---
 kernel/bpf/stackmap.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 950ab2f28922..bb89341d3faf 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -320,7 +320,9 @@ static void stack_map_get_build_id_offset(struct bpf_stack_build_id *id_offs,
 	}
 
 	for (i = 0; i < trace_nr; i++) {
-		vma = find_vma(current->mm, ips[i]);
+		u64 untagged_ip = untagged_addr(ips[i]);
+
+		vma = find_vma(current->mm, untagged_ip);
 		if (!vma || stack_map_get_build_id(vma, id_offs[i].build_id)) {
 			/* per entry fall back to ips */
 			id_offs[i].status = BPF_STACK_BUILD_ID_IP;
@@ -328,7 +330,7 @@ static void stack_map_get_build_id_offset(struct bpf_stack_build_id *id_offs,
 			memset(id_offs[i].build_id, 0, BPF_BUILD_ID_SIZE);
 			continue;
 		}
-		id_offs[i].offset = (vma->vm_pgoff << PAGE_SHIFT) + ips[i]
+		id_offs[i].offset = (vma->vm_pgoff << PAGE_SHIFT) + untagged_ip
 			- vma->vm_start;
 		id_offs[i].status = BPF_STACK_BUILD_ID_VALID;
 	}
-- 
2.21.0.225.g810b269d1ac-goog

