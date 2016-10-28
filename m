Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:44722 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1756495AbcJ1OJJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Oct 2016 10:09:09 -0400
Date: Fri, 28 Oct 2016 17:08:29 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Felipe Sanches <juca@members.fsf.org>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/1] media: Drop FSF's postal address from the source
 code files
Message-ID: <20161028140829.GX9460@valkosipuli.retiisi.org.uk>
References: <1477658633-2536-1-git-send-email-sakari.ailus@linux.intel.com>
 <CAK6XL6DFk_cX_C09pKTEaydaP3m+PCg03-gPeT-BTg-+mvsS-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK6XL6DFk_cX_C09pKTEaydaP3m+PCg03-gPeT-BTg-+mvsS-Q@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Felipe,

On Fri, Oct 28, 2016 at 11:47:02AM -0200, Felipe Sanches wrote:
> but why?

Much of this information is outdated. There's some reasoning behind this in
the patch adding the check in scripts/checkpatch.pl:

commit 4783f894d0f3bfb107cf3b1d9aed1f1a0672ee1d
Author: Josh Triplett <josh@joshtriplett.org>
Date:   Tue Nov 12 15:10:12 2013 -0800

    checkpatch.pl: check for the FSF mailing address
    
    Kernel maintainers reject new instances of the GPL boilerplate paragraph
    directing people to write to the FSF for a copy of the GPL, since the FSF
    has moved in the past and may do so again.
    
    Make this an error for new code, but just a --strict CHK in --file mode;
    anyone interested in doing tree-wide cleanups of this form can enable this
    test explicitly.
    
    Signed-off-by: Josh Triplett <josh@joshtriplett.org>
    Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Acked-by: Joe Perches <joe@perches.com>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

The address can be found in COPYING in the root of the kernel tree.

> 
> 2016-10-28 10:43 GMT-02:00 Sakari Ailus <sakari.ailus@linux.intel.com>:
> > Drop the FSF's postal address from the source code files that typically
> > contain mostly the license text. The patch has been created with the
> > following command without manual edits:
> >
> > git grep -l "675 Mass Ave\|59 Temple Place\|51 Franklin St" -- \
> >         drivers/media/ include/media|while read i; do i=$i perl -e '
> > open(F,"< $ENV{i}");
> > $a=join("", <F>);
> > $a =~ s/[ \t]*\*\n.*You should.*\n.*along with.*\n.*(\n.*USA.*$)?\n//m
> >         && $a =~ s/(^.*)Or, (point your browser to) /$1To obtain the license, $2\n$1/m;
> > close(F);
> > open(F, "> $ENV{i}");
> > print F $a;
> > close(F);'; done
> >
> > Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> > ---
> > Hi,
> >
> > I found this in a few places and decided to remove them all. The script
> > could be useful elsewhere, too.
> >
> > The actual patch can be found here, it appears to be too large to be
> > accepted by vger:
> >
> > <URL:http://git.retiisi.org.uk/?p=~sailus/linux.git;a=commitdiff;h=refs/heads/fsf-address>

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
