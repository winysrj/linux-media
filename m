Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:33867 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752485Ab1DUKGF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Apr 2011 06:06:05 -0400
Date: Thu, 21 Apr 2011 12:06:00 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Bob Liu <lliubbo@gmail.com>
Cc: linux-media@vger.kernel.org, dhowells@redhat.com,
	linux-uvc-devel@lists.berlios.de, mchehab@redhat.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	sakari.ailus@maxwell.research.nokia.com, martin_rubli@logitech.com,
	jarod@redhat.com, tj@kernel.org, arnd@arndb.de, fweisbec@gmail.com,
	agust@denx.de, gregkh@suse.de, vapier@gentoo.org
Subject: Re: [PATCH v3] media:uvc_driver: add uvc support on no-mmu arch
Message-ID: <20110421100600.GA8593@minime.bse>
References: <1303355862-17507-1-git-send-email-lliubbo@gmail.com>
 <20110421075947.GA8178@minime.bse>
 <BANLkTimHX8aYoeSU1ES0Tw0Swaz9xYLt=Q@mail.gmail.com>
 <20110421094743.GA8503@minime.bse>
 <BANLkTimO-4ubi7qUCncB9Z+wwNx1LURvfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimO-4ubi7qUCncB9Z+wwNx1LURvfQ@mail.gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Apr 21, 2011 at 05:57:31PM +0800, Bob Liu wrote:
> On Thu, Apr 21, 2011 at 5:47 PM, Daniel Glöckner <daniel-gl@gmx.net> wrote:
> > On Thu, Apr 21, 2011 at 04:20:36PM +0800, Bob Liu wrote:
> >> > on mmu systems do_mmap_pgoff contains a len = PAGE_ALIGN(len); line.
> >> > If we depend on this behavior, why not do it here as well and get rid
> >> > of the #ifdef?
> >> >
> >>
> >> If do it in do_mmap_pgoff() the whole system will be effected, I am
> >> not sure whether
> >> it's correct and needed for other subsystem.
> >
> > With "here" I was referring to uvc_queue_mmap.
> >
> 
> I am sorry, I didn't get your idea. You mean using  PAGE_ALIGN() here for both
> mmu and no-mmu arch ?

Yes, rounding size to pages also increases the chance of the following
while loop to end, should mmu do_mmap_pgoff ever have that line removed.

  Daniel
