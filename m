Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:45911 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751001AbeEDK4I (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 4 May 2018 06:56:08 -0400
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Harry Wei <harryxiyou@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Brian Warner <brian.warner@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Benoit Parrot <bparrot@ti.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Bhumika Goyal <bhumirks@gmail.com>, Sean Young <sean@mess.org>,
        Brad Love <brad@nextdimension.cc>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Markus Elfring <elfring@users.sourceforge.net>,
        Alexey Klimov <klimov.linux@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tim Harvey <tharvey@gateworks.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Yong Zhi <yong.zhi@intel.com>, Jan Kara <jack@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Kamil Rytarowski <n54@gmx.com>,
        Matthew Wilcox <mawilcox@microsoft.com>,
        linux-doc@vger.kernel.org, linux-kernel@zh-kernel.org,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: Re: [PATCH] MAINTAINERS & files: Canonize the e-mails I use at files
In-Reply-To: <85bfc919e068ea7bb1e9b533ac6f60798844a5c0.1525428104.git.mchehab+samsung@kernel.org>
References: <85bfc919e068ea7bb1e9b533ac6f60798844a5c0.1525428104.git.mchehab+samsung@kernel.org>
Date: Fri, 04 May 2018 13:58:39 +0300
Message-ID: <87in837km8.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 04 May 2018, Mauro Carvalho Chehab <mchehab+samsung@kernel.org> wrote:
> From now on, I'll start using my @kernel.org as my development e-mail.
>
> As such, let's remove the entries that point to the old
> mchehab@s-opensource.com at MAINTAINERS file.
>
> For the files written with a copyright with mchehab@s-opensource,
> let's keep Samsung on their names, using mchehab+samsung@kernel.org,
> in order to keep pointing to my employer, with sponsors the work.
>
> For the files written before I join Samsung (on July, 4 2013),
> let's just use mchehab@kernel.org.
>
> For bug reports, we can simply point to just kernel.org, as
> this will reach my mchehab+samsung inbox anyway.

I suppose this begs the question, why do we insist on adding our email
addresses all over the place? On a quick grep, there are at least 40k+
email addresses in the sources. Do we expect them all to be up-to-date
too?


BR,
Jani.

-- 
Jani Nikula, Intel Open Source Technology Center
