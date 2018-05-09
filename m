Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56432 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934857AbeEIM6C (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 9 May 2018 08:58:02 -0400
Date: Wed, 9 May 2018 14:57:56 +0200
From: Jan Kara <jack@suse.cz>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Jani Nikula <jani.nikula@linux.intel.com>,
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
Message-ID: <20180509125756.zj5ngtjm6fji52gf@quack2.suse.cz>
References: <85bfc919e068ea7bb1e9b533ac6f60798844a5c0.1525428104.git.mchehab+samsung@kernel.org>
 <87in837km8.fsf@intel.com>
 <20180504083355.0c891ab3@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180504083355.0c891ab3@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri 04-05-18 08:33:55, Mauro Carvalho Chehab wrote:
> Em Fri, 04 May 2018 13:58:39 +0300
> Jani Nikula <jani.nikula@linux.intel.com> escreveu:
> 
> > On Fri, 04 May 2018, Mauro Carvalho Chehab <mchehab+samsung@kernel.org> wrote:
> > > From now on, I'll start using my @kernel.org as my development e-mail.
> > >
> > > As such, let's remove the entries that point to the old
> > > mchehab@s-opensource.com at MAINTAINERS file.
> > >
> > > For the files written with a copyright with mchehab@s-opensource,
> > > let's keep Samsung on their names, using mchehab+samsung@kernel.org,
> > > in order to keep pointing to my employer, with sponsors the work.
> > >
> > > For the files written before I join Samsung (on July, 4 2013),
> > > let's just use mchehab@kernel.org.
> > >
> > > For bug reports, we can simply point to just kernel.org, as
> > > this will reach my mchehab+samsung inbox anyway.  
> > 
> > I suppose this begs the question, why do we insist on adding our email
> > addresses all over the place? On a quick grep, there are at least 40k+
> > email addresses in the sources. Do we expect them all to be up-to-date
> > too?
> 
> That's a good question.
> 
> The usual use case is that the e-mail allows people to contact developers
> if needed. Such contact could simply due to something like handling SPDX
> or other license-related issues or for troubleshooting.
> 
> There's also another reason (with IMHO, is more relevant): just the name
> may not be enough to uniquely identify the author of some code. While
> that might happen on occidental Countries, this is a way more relevant
> for Asian Countries. For example, there are very few surnames on
> some Countries there[1], and common names are usually... common. So, it
> is not hard to find several people with exactly the same name working at
> the same company. I've seen e-mails from those people that are things like
> john.doe51@some.company, john.doe69@some.company, ...
> 
> [1] For example: https://en.wikipedia.org/wiki/List_of_Korean_surnames.
> 
> The e-mail is a way to uniquely identify a person. If we remove it,
> then we may need to add another thing instead (like parents names,
> security number or whatever), with would be weird, IMO. 
> 
> As we all use e-mails to uniquely identify contributors submissions,
> IMHO, the best is to keep using e-mails. The side effect is that
> we should keep those emails updated.

Understood but e-mails in code get stale eventually as people rarely update
those. So I think having a contact email in MAINTAINERS and git logs is
enough for practical purposes.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
