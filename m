Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35220 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752689AbdERJFZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 05:05:25 -0400
Received: by mail-oi0-f68.google.com with SMTP id m17so6355300oik.2
        for <linux-media@vger.kernel.org>; Thu, 18 May 2017 02:05:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <dd8245f445f5e751b38126140b6ba1723f06c60b.1495097103.git.mchehab@s-opensource.com>
References: <dd8245f445f5e751b38126140b6ba1723f06c60b.1495097103.git.mchehab@s-opensource.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 18 May 2017 11:05:24 +0200
Message-ID: <CAK8P3a0Fw30dmUGY=piihxk_EwsxEfD9pJ+DD+WE537L9Tkuow@mail.gmail.com>
Subject: Re: [PATCH] [media] atomisp: don't treat warnings as errors
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, devel@driverdev.osuosl.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 18, 2017 at 10:45 AM, Mauro Carvalho Chehab
<mchehab@s-opensource.com> wrote:
> Several atomisp files use:
>          ccflags-y += -Werror
>
> As, on media, our usual procedure is to use W=1, and atomisp
> has *a lot* of warnings with such flag enabled,like:
>
> ./drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/system_local.h:62:26: warning: 'DDR_BASE' defined but not used [-Wunused-const-variable=]
>
> At the end, it causes our build to fail, impacting our workflow.
>
> So, remove this crap. If one wants to force -Werror, he
> can still build with it enabled by passing a parameter to
> make.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>

Good idea.

On a related note, I have some plans for more fine-grained and more consisten
control of warning and error messages. The same way we already use W=1
or W=12, I would like to allow E=0 E=01 etc to turn warnings of a particular
W= level into errors, and possibly even allow this on a per-file or
per-directory
basis. It depends on some infrastructure to replace scripts/Makefile.extrawarn
with a include/linux/compiler-warnings.h using _Pragma("GCC diagnostic ..."),
but that infrastructure has other benefits as well.

Would you be interested in having the equivalent of W=1 (some extra warnings)
or E=0 (default warnings become errors) enabled for drivers/media if we had
a good way of doing that?

      Arnd
