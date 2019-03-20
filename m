Return-Path: <SRS0=I/aX=RX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57854C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 14:54:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27D512184E
	for <linux-media@archiver.kernel.org>; Wed, 20 Mar 2019 14:54:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JCUhTsom"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728261AbfCTOyb (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Mar 2019 10:54:31 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:38266 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728500AbfCTOwN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Mar 2019 10:52:13 -0400
Received: by mail-pf1-f202.google.com with SMTP id j10so2772915pff.5
        for <linux-media@vger.kernel.org>; Wed, 20 Mar 2019 07:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=JtqBUblhyywi4YhvTkJHhe/ifq9XLr2+qZst5mD5EtU=;
        b=JCUhTsom3sv4Qp9BgYwbkXDdkciE1//Hw4N0DNNMC4xTTSQ4lLZpC9fonlZAwhGa5s
         GNZfPO7WKhbqfkLhUEXh2Q2IsqhkYYT63boD5rJQKFDull6EmJ/3UNaGEyGsIksVaOC8
         tVa6dAYXJVSE0a/Y3iEyW9RkRqD5ULEHrrYNKdC8hIFFIscPITax04Ehb6yZo3/Kv5gE
         4GrdjKthKOiZlqCKJ11zuUzlpowQXS31kWI1psH6mvXWAsMM/BUWqqUj3E1L86ZSFVnv
         UTo+HsA5H9AlfhMDC0xK9OSBVfCenoUTzBKRmg/WwAJv8lBEwyEQzOI3ORQRTNGew37R
         fDYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=JtqBUblhyywi4YhvTkJHhe/ifq9XLr2+qZst5mD5EtU=;
        b=ttIdyn1TaPmULMz+zX73jAneEuHP+SZgomU8tPLHr9YznbdsbieGmL0VHPA80gAgVw
         5ColKsTj8L4kBMz6tMqGuw0ggBX+zz4MvMATVrVi1/gu1nh/9dAPElV8NSoPSVETSalV
         /mkeaYeOkcePgBbYER7Q8R8FbGGeGqFHT+3WVNVvM6hvFh4V4wWVOZ2bwcnIh9a7/SKx
         ugG6L2PkMOk73Nr1eQdJDqHqVIS5kDgoVyiydeqN2O2WGskni0xmJCZsr87fIK4fcTnR
         UAqjMqSn0IQlYVUloGsgeG6foFWwHxjW69PZw3vh35q9LSQpNpMRGJcQitsRDJu5Np2d
         pdDQ==
X-Gm-Message-State: APjAAAV56UWXrrD3Fy+PeD8uUwhpuGlo8hQ9thJS1krGbTxWUAvlrStn
        X83qv36XbUDNrbkGlu64qaUNByL80L9wgqC+
X-Google-Smtp-Source: APXvYqxTeQTCrSfKvGumpNCKTbPirWsdeFkFdjLvtHz5QB/GJ2l6iQCjaYJVOq8eYP8TPKdTa2JL6S1R/puOA8Yr
X-Received: by 2002:a63:1e10:: with SMTP id e16mr1614319pge.103.1553093532279;
 Wed, 20 Mar 2019 07:52:12 -0700 (PDT)
Date:   Wed, 20 Mar 2019 15:51:23 +0100
In-Reply-To: <cover.1553093420.git.andreyknvl@google.com>
Message-Id: <2280b62096ce1fa5c9e9429d18f08f82f4be1b0b.1553093421.git.andreyknvl@google.com>
Mime-Version: 1.0
References: <cover.1553093420.git.andreyknvl@google.com>
X-Mailer: git-send-email 2.21.0.225.g810b269d1ac-goog
Subject: [PATCH v13 09/20] net, arm64: untag user pointers in tcp_zerocopy_receive
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

tcp_zerocopy_receive() uses provided user pointers for vma lookups, which
can only by done with untagged pointers.

Untag user pointers in this function.

Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
---
 net/ipv4/tcp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 6baa6dc1b13b..855a1f68c1ea 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1761,6 +1761,8 @@ static int tcp_zerocopy_receive(struct sock *sk,
 	if (address & (PAGE_SIZE - 1) || address != zc->address)
 		return -EINVAL;
 
+	address = untagged_addr(address);
+
 	if (sk->sk_state == TCP_LISTEN)
 		return -ENOTCONN;
 
-- 
2.21.0.225.g810b269d1ac-goog

