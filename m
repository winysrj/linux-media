Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:34718 "EHLO vena.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755168AbcHSBV7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Aug 2016 21:21:59 -0400
Date: Thu, 18 Aug 2016 17:21:27 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com> (by way of Mauro
        Carvalho Chehab <mchehab@s-opensource.com>)
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 0/9] Prepare Sphinx to build media PDF books
Message-ID: <20160818172127.190fad79@lwn.net>
In-Reply-To: <cover.1471364025.git.mchehab@s-opensource.com>
References: <cover.1471364025.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 16 Aug 2016 13:25:34 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:

> I think this patch series belong to docs-next. Feel free to merge them there, if
> you agree. There's one extra patch that touches Documentation/conf.py,
> re-adding the media book to the PDF build, but IMHO this one would be better
> to be merged via the media tree, after the fixes inside the media documentation
> to fix the build.

It's now in docs-next.  I was able to build some nice-looking docs with it
without too much (additional) pain...

The conf.py patch makes me a bit nervous, in that I feel like I spent a
fair amount of time explaining docs merge conflicts to Linus during the
merge window, and would rather not do that again.  Can we keep it aside,
with the idea that one of us will put it in toward the end of the 4.9
merge window?

Meanwhile, let's see how this xelatex thing works out.  Thanks for making
all this work!

jon
