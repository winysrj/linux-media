Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1EADC43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 14:54:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6DCC2184E
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 14:54:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DgQCTHAw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728670AbfCTOy6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 10:54:58 -0400
Received: from mail-qk1-f201.google.com ([209.85.222.201]:42342 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728281AbfCTOwG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 10:52:06 -0400
Received: by mail-qk1-f201.google.com with SMTP id 77so19291872qkd.9
        for <linux-media@vger.kernel.org>; Wed, 20 Mar 2019 07:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=/AfMcWXUpr8qOV9jNlH+KOvJdLIB2O2rWZvj+eGhaHk=;
        b=DgQCTHAwsx9nOdP43FdX5LVEo87GnIfu0WmZk1NYabcIGCtKnsiekk4mOZRYJIhI1U
         rvCehvhBc06o8DcFgsseTvDqXb0bAW+gvKfeVD4L0KGfj2wOOOXK/fMnySAD9d5mCKCu
         3Xy6ZFurPUHQ7qTNFw0+B5iut5R52YvqgYU/a0JEMSrKC9jRWo3AU420WBXrCWxeTOM5
         YeoFqgkUOZ10TFamvrA+SuUuvAxE8e7foqYee5urs8q1dYqDp/xiKxBavemBAmX/sEHw
         DPuDEUNXQvvEZmE9YUfwESNhCqe00SvlS+lCubr0KgJlNbkXCmKhNkb8zOctNt9/cPVR
         Rukg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/AfMcWXUpr8qOV9jNlH+KOvJdLIB2O2rWZvj+eGhaHk=;
        b=lAoC5q0CQoC0/uakPjbfXpwzSyPQ2qnXpjJt/WZlO19xBcU+aKW4Gd+zE3epbmdjPP
         kQfo48e2uHmJsl2yvpiE2JtibJqWGOQqSvEFkhvR04Lvm/AWv9Z6qAkMKKY8Ao2AeXxG
         gjPg6yRKGJCSK5lGH+Byr3cQfe5gBL6jjDrQ/ToIsuFlvxIIVDvmDbFKV7UkL/f/Uaf8
         Mssn0upiB1AgLskJAMClJ2wLkHLvD59NKBZHiljg5sWaUav6xt4q4xzp7Qu/ClWV6kAq
         ZV3SnNGIdCh4pHt8cZEnmOXqmt3bEDWPOLMo1soKyI8PPoC0HRq5XaBLjhVer6EClAt6
         Tpsg==
X-Gm-Message-State: APjAAAXpbGo7FuxHQWFRRDJtvWb/C8NO/TRdr9SnavDR5Y0EcbsqmyKG
        Yc/mqNaV93CTF/gVztJrg2m+2LursmHZkM5O
X-Google-Smtp-Source: APXvYqy+ZGj1oA4MFc9JnMXadH7vhqJKC4uAMJ0YAN7IR5yuNOlRtTgk0L4VAoRYkahPatQ5yAXGf8UXWvJkE4CW
X-Received: by 2002:ac8:38b7:: with SMTP id f52mr14823448qtc.7.1553093525814;
 Wed, 20 Mar 2019 07:52:05 -0700 (PDT)
Date:   Wed, 20 Mar 2019 15:51:21 +0100
In-Reply-To: <cover.1553093420.git.andreyknvl@google.com>
Message-Id: <9f7d95da28b1fd5e601cbe43e81ee646e1ca6880.1553093421.git.andreyknvl@google.com>
Mime-Version: 1.0
References: <cover.1553093420.git.andreyknvl@google.com>
X-Mailer: git-send-email 2.21.0.225.g810b269d1ac-goog
Subject: [PATCH v13 07/20] fs, arm64: untag user pointers in copy_mount_options
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

In copy_mount_options a user address is being subtracted from TASK_SIZE.
If the address is lower than TASK_SIZE, the size is calculated to not
allow the exact_copy_from_user() call to cross TASK_SIZE boundary.
However if the address is tagged, then the size will be calculated
incorrectly.

Untag the address before subtracting.

Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
---
 fs/namespace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index c9cab307fa77..c27e5713bf04 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2825,7 +2825,7 @@ void *copy_mount_options(const void __user * data)
 	 * the remainder of the page.
 	 */
 	/* copy_from_user cannot cross TASK_SIZE ! */
-	size = TASK_SIZE - (unsigned long)data;
+	size = TASK_SIZE - (unsigned long)untagged_addr(data);
 	if (size > PAGE_SIZE)
 		size = PAGE_SIZE;
 
-- 
2.21.0.225.g810b269d1ac-goog

