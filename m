Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16F38C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 14:53:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D02A1206BA
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 14:53:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TRw7Yj5B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbfCTOwf (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 10:52:35 -0400
Received: from mail-vs1-f74.google.com ([209.85.217.74]:44815 "EHLO
        mail-vs1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728627AbfCTOwe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 10:52:34 -0400
Received: by mail-vs1-f74.google.com with SMTP id z187so851731vsc.11
        for <linux-media@vger.kernel.org>; Wed, 20 Mar 2019 07:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=75Sme861PZA/tNUQAzLBE6PJQCb9DBJI65KsoGIZxyY=;
        b=TRw7Yj5BILFy1o0Gjs1P7PG7K0bXvmZQkYhNUVzGU7eBwuMllGXuOholy2EFVltyM4
         Eq2uq+97Zf6uwJS8d1ZdNFpiTnL8SNlpOD4sWLxmZFbN853Lcc52HrY3CkqYjTrkgvv3
         P6+/fIjezdNUVDfMCm7BsfzV0JBhv6f1w4D1u9PxEoZJ5VL6MOfN4r5Co6Q9TCpikOXk
         ufVXz2a0Bri+ZzG/0QUwT0FF9pQ83mZbCp5f+6lD7JfSPjUlslIphqktlFrt8/uqaCtx
         xvHcpr2f1Cv9vpNRpKRy3dnpc0Pr4AZKm48fkJGsVCh95A9tTuAmJvWLp4Ouo2pSZNMk
         pVyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=75Sme861PZA/tNUQAzLBE6PJQCb9DBJI65KsoGIZxyY=;
        b=lWgMsWazDQrFRTZhZlsBu1UKCAOF0ZMKvp/EhUUOrMspSKioP3HmMfb0Ah4oUib/pY
         9vGw30h3ezRgrvWncVQv6G/IQ2hvdDrKWOViTq0x+vEUnMOhfaTFOMnHYC0410PjsoBN
         f4Xeab5+Yj4v9TRF1gO2uPdvnPgmdQorfk0kEqLJHWlMEIavEPZVEj38SfmN7AtLcqSj
         fauD1hsHVYZKLqN7UztFQxvbjWq7FnGD0sfprnTIwfQB0D1yPuGZ7EPR4YyFD/mpoSpV
         MLZuC15H1AIjxR4iRsjF4KBh8GVTuKg/F64oJqWvKpTlI5BKGWsGwpUkqVO+o0uD6J7Y
         W63Q==
X-Gm-Message-State: APjAAAVjyvS/u2qNwa843uOD1Gdc5pDpEWVSalLgLan+oCbY4nVLVjlp
        SCRSDN0lxHNORGLaQQ24bTnL/NkbVjwhVAKh
X-Google-Smtp-Source: APXvYqzSD9kzbCxXB1NhkO2CDkCTaQO/WiJog4chzbyr47Ky/uMyCpQjT2x0YU1fYyYTJNw37CTZ8G4iAZNpW0Wl
X-Received: by 2002:a1f:c507:: with SMTP id v7mr16491493vkf.18.1553093553224;
 Wed, 20 Mar 2019 07:52:33 -0700 (PDT)
Date:   Wed, 20 Mar 2019 15:51:29 +0100
In-Reply-To: <cover.1553093420.git.andreyknvl@google.com>
Message-Id: <038360a0a9dc0abaaaf3ad84a2d07fd544abce1a.1553093421.git.andreyknvl@google.com>
Mime-Version: 1.0
References: <cover.1553093420.git.andreyknvl@google.com>
X-Mailer: git-send-email 2.21.0.225.g810b269d1ac-goog
Subject: [PATCH v13 15/20] drm/radeon, arm64: untag user pointers in radeon_ttm_tt_pin_userptr
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

radeon_ttm_tt_pin_userptr() uses provided user pointers for vma
lookups, which can only by done with untagged pointers.

Untag user pointers in this function.

Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
---
 drivers/gpu/drm/radeon/radeon_ttm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
index 9920a6fc11bf..872a98796117 100644
--- a/drivers/gpu/drm/radeon/radeon_ttm.c
+++ b/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -497,9 +497,10 @@ static int radeon_ttm_tt_pin_userptr(struct ttm_tt *ttm)
 	if (gtt->userflags & RADEON_GEM_USERPTR_ANONONLY) {
 		/* check that we only pin down anonymous memory
 		   to prevent problems with writeback */
-		unsigned long end = gtt->userptr + ttm->num_pages * PAGE_SIZE;
+		unsigned long userptr = untagged_addr(gtt->userptr);
+		unsigned long end = userptr + ttm->num_pages * PAGE_SIZE;
 		struct vm_area_struct *vma;
-		vma = find_vma(gtt->usermm, gtt->userptr);
+		vma = find_vma(gtt->usermm, userptr);
 		if (!vma || vma->vm_file || vma->vm_end < end)
 			return -EPERM;
 	}
-- 
2.21.0.225.g810b269d1ac-goog

