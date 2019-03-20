Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EC91C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 14:52:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB4AF21873
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 14:52:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UEIrebSo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728246AbfCTOwp (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 10:52:45 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:43512 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728254AbfCTOwo (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 10:52:44 -0400
Received: by mail-pg1-f202.google.com with SMTP id u2so2645754pgi.10
        for <linux-media@vger.kernel.org>; Wed, 20 Mar 2019 07:52:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=f9ERttYki6e1riSpYQlVbWsSBMZZ5wUdNGpNySk9y5Q=;
        b=UEIrebSocaYvFV95VdsGvR0rHtsKUFScYsCVqiArhFekiKhlWYwiMy63Q0mC7IZj9p
         3mqU7Dbhm6OqOVB4ThhETYV9ikDo0pqEW49iSRluDE7bkzQRnUB022yUHTxms2owX+51
         Hl02fMI+fjjQXXTnP9hJUKytXL22/eMlF/bW9F6Y2oo6WfEnYpRt49Ftd9iSm88pEvyR
         KMbIbd0h7q6Pew5AmmXiW7TnoUcvWa8wf/gj7ZnzJQoLjgL/IjA++G9JudTdsHLO21Cq
         CbofADar+N5IG2433ecku3GOiSdWNlbt2i7KcQfTHs/DmBtW8hG6MdXe8FPq3GsM/Hb6
         HDrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=f9ERttYki6e1riSpYQlVbWsSBMZZ5wUdNGpNySk9y5Q=;
        b=EnuWGenJa1wdkUbGka+Iq7t0rHF+vjWguDJW26gKlqFBO/g9wP2LPEzhiECll4Xrbq
         q6pw9+Gfl30gMBAVVuunmtl8S27gKIXGJc291TcxGJu6GC08cyIxVghHV/Q/kd7ReZuT
         gJRzC4DgURfjZChRu76srugViQhx21EjYdggfXIua0h7KhXl4103Qwc1ODC4Aa2Y4Zxv
         7r6/CBPiB7G0IwuzYlZYsw8IADNh60s0tSjFxxrHLMMRzvqTqoxlB2rOM40+GP4UYE6C
         RCcoiyET4IzK4nqtcf/1Uqt7oOpT8UDpk6zUDU89XrDPdVxPTc6k+nTIPMtR98dckauH
         M5Bw==
X-Gm-Message-State: APjAAAX5H2zf5sqdjmY24chvDRKrwPhrenwtkSugj3chgEcQewQD2lyN
        QQIIOp+78lpVrOjdjP6veOE7erIQ3MflsMzh
X-Google-Smtp-Source: APXvYqw7j6q1fx3m56nHOtW1Q2mzw9Sw141YoRGaaXVbYutXBT4BRu1TSW8d2p37GhTJbzzsOqgRxlx9WtXnbKVc
X-Received: by 2002:a63:2ac2:: with SMTP id q185mr3933319pgq.119.1553093563022;
 Wed, 20 Mar 2019 07:52:43 -0700 (PDT)
Date:   Wed, 20 Mar 2019 15:51:32 +0100
In-Reply-To: <cover.1553093420.git.andreyknvl@google.com>
Message-Id: <665632a911273ab537ded9acb78f4bafd91cbc19.1553093421.git.andreyknvl@google.com>
Mime-Version: 1.0
References: <cover.1553093420.git.andreyknvl@google.com>
X-Mailer: git-send-email 2.21.0.225.g810b269d1ac-goog
Subject: [PATCH v13 18/20] tee/optee, arm64: untag user pointers in check_mem_type
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

check_mem_type() uses provided user pointers for vma lookups (via
__check_mem_type()), which can only by done with untagged pointers.

Untag user pointers in this function.

Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
---
 drivers/tee/optee/call.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tee/optee/call.c b/drivers/tee/optee/call.c
index a5afbe6dee68..e3be20264092 100644
--- a/drivers/tee/optee/call.c
+++ b/drivers/tee/optee/call.c
@@ -563,6 +563,7 @@ static int check_mem_type(unsigned long start, size_t num_pages)
 	int rc;
 
 	down_read(&mm->mmap_sem);
+	start = untagged_addr(start);
 	rc = __check_mem_type(find_vma(mm, start),
 			      start + num_pages * PAGE_SIZE);
 	up_read(&mm->mmap_sem);
-- 
2.21.0.225.g810b269d1ac-goog

