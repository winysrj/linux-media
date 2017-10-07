Return-path: <linux-media-owner@vger.kernel.org>
Received: from ms.lwn.net ([45.79.88.28]:39662 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751258AbdJGQem (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 7 Oct 2017 12:34:42 -0400
Date: Sat, 7 Oct 2017 10:34:40 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/17] kernel-doc: add supported to document nested
 structs/
Message-ID: <20171007103440.35393957@lwn.net>
In-Reply-To: <cover.1507116877.git.mchehab@s-opensource.com>
References: <cover.1507116877.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed,  4 Oct 2017 08:48:38 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:

> Right now, it is not possible to document nested struct and nested unions.
> kernel-doc simply ignore them.
> 
> Add support to document them.

So I've finally found some time to actually look at these; sorry for being
so absent from the discussion.  I plead $EXCUSES...

Some overall impressions:

 - Seems like something we want.
 - I love hacking all the cruft out of kernel-doc; I've been meaning to
   do that for a bit.
 - It would sure be nice to restore proper man-page generation rather than
   documenting a hack with a perl script.  Someday.

I have one real complaint, though: with these patches applied, a "make
htmldocs" generates about 5500 (!) more warnings than it did before.  Over
the last couple of months, I put a bit of focused time into reducing
warnings, and managed to get rid of 20-30 of them.  Now I feel despondent.

I really don't want to add that much noise to the docs build; I think it
will defeat any hope of cleaning up the warnings we already have.  I
wonder if we could suppress warnings about nested structs by default, and
add a flag or envar to turn them back on for those who want them?

In truth, now that I look, the real problem is that the warnings are
repeated many times - as in, like 100 times:

> ./include/net/cfg80211.h:4115: warning: Function parameter or member 'wext.ibss' not described in 'wireless_dev'
> ./include/net/cfg80211.h:4115: warning: Function parameter or member 'wext.ibss' not described in 'wireless_dev'
<107 instances deleted...>
> ./include/net/cfg80211.h:4115: warning: Function parameter or member 'wext.ibss' not described in 'wireless_dev'

That's not something that used to happen, and is certainly not helpful.
Figuring that out would help a lot.  Can I get you to take a look at
what's going on here?

Thanks,

jon
