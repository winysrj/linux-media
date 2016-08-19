Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:42007
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752067AbcHSNYc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 09:24:32 -0400
Date: Fri, 19 Aug 2016 10:24:27 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 0/9] Prepare Sphinx to build media PDF books
Message-ID: <20160819102427.29f41d3c@vento.lan>
In-Reply-To: <20160818172127.190fad79@lwn.net>
References: <cover.1471364025.git.mchehab@s-opensource.com>
        <20160818172127.190fad79@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 18 Aug 2016 17:21:27 -0600
Jonathan Corbet <corbet@lwn.net> escreveu:

> On Tue, 16 Aug 2016 13:25:34 -0300
> Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:
> 
> > I think this patch series belong to docs-next. Feel free to merge them there, if
> > you agree. There's one extra patch that touches Documentation/conf.py,
> > re-adding the media book to the PDF build, but IMHO this one would be better
> > to be merged via the media tree, after the fixes inside the media documentation
> > to fix the build.
> 
> It's now in docs-next.  I was able to build some nice-looking docs with it
> without too much (additional) pain...

Good!

> The conf.py patch makes me a bit nervous, in that I feel like I spent a
> fair amount of time explaining docs merge conflicts to Linus during the
> merge window, and would rather not do that again.  Can we keep it aside,
> with the idea that one of us will put it in toward the end of the 4.9
> merge window?

Yeah, sure. I'm actually planning to pull from your docs-next branch
at the media master tree before starting picking other patches on it,
and wait for your pull request before sending mine on the next merge
tree.

> Meanwhile, let's see how this xelatex thing works out.  Thanks for making
> all this work!

Anytime!

Thanks,
Mauro
