Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DF47C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 14:54:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DB092146E
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 14:54:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KRMkdxMD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728467AbfCTOwK (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 10:52:10 -0400
Received: from mail-yw1-f74.google.com ([209.85.161.74]:51568 "EHLO
        mail-yw1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728471AbfCTOwK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 10:52:10 -0400
Received: by mail-yw1-f74.google.com with SMTP id s11so3361691ywa.18
        for <linux-media@vger.kernel.org>; Wed, 20 Mar 2019 07:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=MRHHZYm6qbbddi64ikktRuAjn8BoXK8Gf7bv/2tC2r0=;
        b=KRMkdxMD5r/ER0b2EYOaeTinlF21JbEs5hD7NF/4KuqBnnQC7/Ye6Qw9DCv6nYaIx6
         4U2cUzqhytwW3z5B4iRPFCCYHJA/xIASnuuJbgU+DFTxxvtbMCxk2YOQuO+k3FhjQZxT
         +HNaP52fISwxZzgGzVRKuYbp7Q8oH3K6BetnL7BXKag5ZZAYsbr0n35Pp3LUj50J49dx
         O5jbTLSzQ9if52c7p/5fn1S3OpB1gYH1iUyL2wrB6P1nRrgD/9GDVY3gp4qdOHpbJY1p
         i3H4A9ArVAT2nkBdJ2JerrQkq4TGT69QXIEYb6sDErAg40bUbxmWd7KaeWagNV837y9+
         Oy3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=MRHHZYm6qbbddi64ikktRuAjn8BoXK8Gf7bv/2tC2r0=;
        b=j3wY0B8a44oA3JlII0xtVLFi1kPspSljxRqeoppE/HkjKIPFpq7VY+8bOVlCJGEPBF
         8bMuCO55OgRASF3IhIMCJPO4yMypNHRBzjmsPdg11QQgwecJVd8gobDMMwnvoRzpgZss
         L4RSLBDES3Aw7Wf8uPQJACzP+HF+deIL38EAAAeT3YIu3A9bwhkF7T2wocrNT25cnURQ
         WIGQ9WU0YXOrzm0J5WEh7xLnlZDc8xciAZwOOqFNND40YsaJ0vqrBwbXo1bNY7uXhyf0
         dKIyFWXSg+8pLdd7yEP1Xp9gIWBKaDcrwCJqMHosWHLxEMJiMuhM7s57pXDMJCHLLYTx
         NtSg==
X-Gm-Message-State: APjAAAVLPVZK4jO/SwJEVpCwCcNjNlSeQl647xY4wNChpSHGoHp32/Ie
        zSHfid1LXI4Q4qPRghaHMiR8/qQpEZLFB5Gx
X-Google-Smtp-Source: APXvYqwr9m8YxgeUDBeeozt2hDgx245cPvqj3jehL0crcqpJn0rfr3qEPeO8cHwuraZTKRyiRzSC54VlM7fEpP7b
X-Received: by 2002:a81:7acf:: with SMTP id v198mr2201203ywc.16.1553093528977;
 Wed, 20 Mar 2019 07:52:08 -0700 (PDT)
Date:   Wed, 20 Mar 2019 15:51:22 +0100
In-Reply-To: <cover.1553093420.git.andreyknvl@google.com>
Message-Id: <dc4aa5f958ea98ff0add6350ec238acdc6523779.1553093421.git.andreyknvl@google.com>
Mime-Version: 1.0
References: <cover.1553093420.git.andreyknvl@google.com>
X-Mailer: git-send-email 2.21.0.225.g810b269d1ac-goog
Subject: [PATCH v13 08/20] fs, arm64: untag user pointers in fs/userfaultfd.c
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

userfaultfd_register() and userfaultfd_unregister() use provided user
pointers for vma lookups, which can only by done with untagged pointers.

Untag user pointers in these functions.

Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
---
 fs/userfaultfd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 89800fc7dc9d..a3b70e0d9756 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1320,6 +1320,9 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 		goto out;
 	}
 
+	uffdio_register.range.start =
+		untagged_addr(uffdio_register.range.start);
+
 	ret = validate_range(mm, uffdio_register.range.start,
 			     uffdio_register.range.len);
 	if (ret)
@@ -1507,6 +1510,8 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
 	if (copy_from_user(&uffdio_unregister, buf, sizeof(uffdio_unregister)))
 		goto out;
 
+	uffdio_unregister.start = untagged_addr(uffdio_unregister.start);
+
 	ret = validate_range(mm, uffdio_unregister.start,
 			     uffdio_unregister.len);
 	if (ret)
-- 
2.21.0.225.g810b269d1ac-goog

