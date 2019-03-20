Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A870DC10F05
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 14:53:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 799BC206BA
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 14:53:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sexMIu8a"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728727AbfCTOxd (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 10:53:33 -0400
Received: from mail-yw1-f74.google.com ([209.85.161.74]:38312 "EHLO
        mail-yw1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728638AbfCTOwh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 10:52:37 -0400
Received: by mail-yw1-f74.google.com with SMTP id i203so3416660ywa.5
        for <linux-media@vger.kernel.org>; Wed, 20 Mar 2019 07:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=JYfYaqFkvasJC562WHpti4tYqqXwAjMl9KNYEduKdaE=;
        b=sexMIu8avs3PQT75uBvPTQ7a6BwfzDpDtEim0BHpT2lZIdVCSQQNJCOv1y+KBVjuwz
         NX0TZsiakkaHgGM438rpKshO2lygtlHGBjF9I7HIZlISq6IjvdJBMN68/khgYyArgEAc
         8tbatLWytzPpO7bRWCVSIFqMId8s/P66Z59No3RuANZfIft4UrNO78pUbAaCEl8oBE2Q
         qNCkyYahb1b1Pv7Y/SBLJD0dj0RxnH2fWpp5qHUGdBZK+/bAoxPvBHDVj/4wKQ82tyl8
         DVhiys3Wu1xJZ38zAN40H2K69ZFtxYiDzY02fAJ60bAOEsljjjp1FIjebecLuWwY+E7M
         Zatw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=JYfYaqFkvasJC562WHpti4tYqqXwAjMl9KNYEduKdaE=;
        b=GuaK9DcY9lWbsnXM+9uGVcH+SZTaxFb/vVYePD4aEP+zRXnyijBQjj9tTW+mKO0hcK
         sNxqkHE5SpjsZ9Q+BSCmBQ8IZv7QBlM+jLDh6fT1bb+4nu6TCzuhw0TPa9ZFj9D+GitH
         v+siKqCl1vezy7BtbEbOmk4PzJiiFXZRfiuVoS0IXTKN1FwhPXevyV1i7/VdY9+GzIVn
         sN/9f6rsdt3Bhk4FGW1yZcjiGVg7FyImVzsANbp18jdA0tg52Fzh6eN9g1CgbkJvKGOr
         nHK+hyMX+nmFMciWmTirSJlnEC4lhP6kp8yp0BYLVEzNQnF2mqtsGuLz/gYDgQVOCmI8
         SGiw==
X-Gm-Message-State: APjAAAXa4Hcq3svHANtbI5pnsaxLJJcshYhadtpFg3CbTDzMkc1ut56N
        1Qv4b/AI8XFudLXwT+QBg3kQ2JQJ9/IvSdfv
X-Google-Smtp-Source: APXvYqz/OFC1PuPZodVHMFKw9kUzVJMyrdAYISJ9xGPWIvonfiJf4upSDw3KUidiP9gNNGgKCiqyzVAdZse9Ion/
X-Received: by 2002:a25:bb8c:: with SMTP id y12mr2095179ybg.89.1553093556448;
 Wed, 20 Mar 2019 07:52:36 -0700 (PDT)
Date:   Wed, 20 Mar 2019 15:51:30 +0100
In-Reply-To: <cover.1553093420.git.andreyknvl@google.com>
Message-Id: <1e2824fd77e8eeb351c6c6246f384d0d89fd2d58.1553093421.git.andreyknvl@google.com>
Mime-Version: 1.0
References: <cover.1553093420.git.andreyknvl@google.com>
X-Mailer: git-send-email 2.21.0.225.g810b269d1ac-goog
Subject: [PATCH v13 16/20] IB/mlx4, arm64: untag user pointers in mlx4_get_umem_mr
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

mlx4_get_umem_mr() uses provided user pointers for vma lookups, which can
only by done with untagged pointers.

Untag user pointers in this function.

Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
---
 drivers/infiniband/hw/mlx4/mr.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index 395379a480cb..9a35ed2c6a6f 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -378,6 +378,7 @@ static struct ib_umem *mlx4_get_umem_mr(struct ib_udata *udata, u64 start,
 	 * again
 	 */
 	if (!ib_access_writable(access_flags)) {
+		unsigned long untagged_start = untagged_addr(start);
 		struct vm_area_struct *vma;
 
 		down_read(&current->mm->mmap_sem);
@@ -386,9 +387,9 @@ static struct ib_umem *mlx4_get_umem_mr(struct ib_udata *udata, u64 start,
 		 * cover the memory, but for now it requires a single vma to
 		 * entirely cover the MR to support RO mappings.
 		 */
-		vma = find_vma(current->mm, start);
-		if (vma && vma->vm_end >= start + length &&
-		    vma->vm_start <= start) {
+		vma = find_vma(current->mm, untagged_start);
+		if (vma && vma->vm_end >= untagged_start + length &&
+		    vma->vm_start <= untagged_start) {
 			if (vma->vm_flags & VM_WRITE)
 				access_flags |= IB_ACCESS_LOCAL_WRITE;
 		} else {
-- 
2.21.0.225.g810b269d1ac-goog

