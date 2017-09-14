Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f171.google.com ([209.85.216.171]:46514 "EHLO
        mail-qt0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751568AbdINMIV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Sep 2017 08:08:21 -0400
Received: by mail-qt0-f171.google.com with SMTP id s18so6715404qta.3
        for <linux-media@vger.kernel.org>; Thu, 14 Sep 2017 05:08:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3c161e9269135a918672423d25b961e6801b5be9.1505389446.git.mchehab@s-opensource.com>
References: <129c5ae599d0502a3fe8c3f09a174ef33879a021.1505389446.git.mchehab@s-opensource.com>
 <3c161e9269135a918672423d25b961e6801b5be9.1505389446.git.mchehab@s-opensource.com>
From: Michael Ira Krufky <mkrufky@linuxtv.org>
Date: Thu, 14 Sep 2017 08:08:20 -0400
Message-ID: <CAOcJUbysoLFeuHG6WT4nkzfTWPS9RKUPZek6Ub6aRyedUvh21A@mail.gmail.com>
Subject: Re: [RFC 3/5] media: get rid of get_property() callback
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Max Kellermann <max.kellermann@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Shuah Khan <shuah@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Sep 14, 2017 at 7:44 AM, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:
> Only lg2160 implement gets_property, but there's no need for that,
> as no other driver calls this callback, as get_frontend() does the
> same, and set_frontend() also calls lg2160 get_frontend().
>
> So, get rid of it.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Reviewed-by: Michael Ira Krufky <mkrufky@linuxtv.org>
