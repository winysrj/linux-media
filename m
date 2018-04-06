Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f178.google.com ([209.85.216.178]:40006 "EHLO
        mail-qt0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751434AbeDFJvS (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 6 Apr 2018 05:51:18 -0400
Received: by mail-qt0-f178.google.com with SMTP id g5so501760qth.7
        for <linux-media@vger.kernel.org>; Fri, 06 Apr 2018 02:51:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180406064718.2cdb69ea@vento.lan>
References: <cover.1522949748.git.mchehab@s-opensource.com>
 <24a526280e4eb319147908ccab786e2ebc8f8076.1522949748.git.mchehab@s-opensource.com>
 <CAK8P3a1a7r1FNhpRHJfyzRNHgNHOzcK1wkerYb+BR_RjWNkOUQ@mail.gmail.com> <20180406064718.2cdb69ea@vento.lan>
From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 6 Apr 2018 11:51:16 +0200
Message-ID: <CAK8P3a2FQapAqxOMJNe9oBs8kBXsd7TCdsNon5Gvab3Y8LLKSA@mail.gmail.com>
Subject: Re: [PATCH 05/16] media: fsl-viu: allow building it with COMPILE_TEST
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Geliang Tang <geliangtang@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 6, 2018 at 11:47 AM, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:

> [PATCH] media: fsl-viu: allow building it with COMPILE_TEST
>
> There aren't many things that would be needed to allow it
> to build with compile test.
>
> Add the needed bits.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
