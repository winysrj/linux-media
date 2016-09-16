Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:51083 "EHLO vena.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964888AbcIPQC1 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 16 Sep 2016 12:02:27 -0400
Date: Fri, 16 Sep 2016 10:02:26 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jani Nikula <jani.nikula@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 0/3] doc-rst:c-domain: fix some issues in the
 c-domain
Message-ID: <20160916100226.055683ed@lwn.net>
In-Reply-To: <1473232378-11869-1-git-send-email-markus.heiser@darmarit.de>
References: <1473232378-11869-1-git-send-email-markus.heiser@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed,  7 Sep 2016 09:12:55 +0200
Markus Heiser <markus.heiser@darmarit.de> wrote:

> according to your remarks I fixed the first and second patch. The third patch is
> resend unchanged;

OK, I've applied the first two, finally.

> > Am 06.09.2016 um 14:28 schrieb Jonathan Corbet <corbet@lwn.net>:
> >
> > As others have pointed out, we generally want to hide the difference
> > between functions and macros, so this is probably one change we don't
> > want.  
> 
> I read "probably", so there might be a chance to persuade you ;)
> 
> I'm not a friend of *information hiding* and since the index is sorted
> alphabetical it does no matter if the entry is 'FOO (C function)' or 'FOO (C
> macro)'. The last one has the right information e.g. for someone how is looking
> for a macro. FOO is a function-like macro and not a function, if the author
> describes the macro he might use the word "macro FOO" but in the index it is
> tagged as C function.

Information hiding is the only way we can maintain the kernel and stay
sane.  I have a hard time imagining why somebody would be looking for a
macro in particular; the whole idea is that they really shouldn't have to
care.  So my inclination is to leave this one out, sorry.

Thanks,

jon
