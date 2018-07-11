Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([46.235.227.227]:52912 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387885AbeGKXEg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Jul 2018 19:04:36 -0400
Message-ID: <194d834fe937714051adc9490b29762dcc10b2de.camel@collabora.com>
Subject: Re: [PATCH] libv4l: fixup lfs mismatch in preload libraries
From: Ezequiel Garcia <ezequiel@collabora.com>
To: Baruch Siach <baruch@tkos.co.il>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Peter Korsgaard <peter@korsgaard.com>
Date: Wed, 11 Jul 2018 19:57:53 -0300
In-Reply-To: <878t6h5zqn.fsf@tkos.co.il>
References: <20180711132251.13172-1-ezequiel@collabora.com>
         <20180711115505.5b93de93@coco.lan> <878t6h5zqn.fsf@tkos.co.il>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2018-07-11 at 22:38 +0300, Baruch Siach wrote:
> Hi Mauro,
> 
> Added Peter's updated address to Cc.
> 
> Mauro Carvalho Chehab writes:
> > Em Wed, 11 Jul 2018 10:22:51 -0300
> > Ezequiel Garcia <ezequiel@collabora.com> escreveu:
> > 
> > > From: Peter Korsgaard <jacmet@sunsite.dk>
> > > 
> > > Ensure that the lfs variants are not transparently used instead
> > > of the !lfs
> > > ones so both can be wrapped, independently of any custom
> > > CFLAGS/CPPFLAGS.
> > > 
> > > Without this patch, the following assembler errors appear
> > > during cross-compiling with Buildroot:
> > > 
> > > /tmp/ccc3gdJg.s: Assembler messages:
> > > /tmp/ccc3gdJg.s:67: Error: symbol `open64' is already defined
> > > /tmp/ccc3gdJg.s:130: Error: symbol `mmap64' is already defined
> > > 
> > > Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
> > > Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> > > ---
> > >  lib/libv4l1/v4l1compat.c  | 3 +++
> > >  lib/libv4l2/v4l2convert.c | 3 +++
> > >  2 files changed, 6 insertions(+)
> > > 
> > > diff --git a/lib/libv4l1/v4l1compat.c b/lib/libv4l1/v4l1compat.c
> > > index cb79629ff88f..e5c9e56261e2 100644
> > > --- a/lib/libv4l1/v4l1compat.c
> > > +++ b/lib/libv4l1/v4l1compat.c
> > > @@ -19,6 +19,9 @@
> > >  # Foundation, Inc., 51 Franklin Street, Suite 500, Boston,
> > > MA  02110-1335  USA
> > >   */
> > >  
> > > +/* ensure we see *64 variants and they aren't transparently used
> > > */
> > > +#undef _LARGEFILE_SOURCE
> > > +#undef _FILE_OFFSET_BITS
> > 
> > Hmm... shouldn't this be autodetected? I didn't check anything,
> > but I would be expecting that different distros (and BSD) may be
> > doing different things here, specially if they use different gcc
> > versions or even different libc implementations.
> 
> See Peter's explanation here:
> 
>   http://lists.busybox.net/pipermail/buildroot/2017-December/210067.h
> tml
> 
> 

Nice, thanks for Ccing the real Peter and for adding the link to the
discussion.

Regards,
Eze
