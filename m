Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55884 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292AbbEKOrN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 May 2015 10:47:13 -0400
Date: Mon, 11 May 2015 15:47:07 +0100
From: Mel Gorman <mgorman@suse.de>
To: Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org, linux-media@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	dri-devel@lists.freedesktop.org, Pawel Osciak <pawel@osciak.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH 2/9] mm: Provide new get_vaddr_frames() helper
Message-ID: <20150511144707.GP2462@suse.de>
References: <1430897296-5469-1-git-send-email-jack@suse.cz>
 <1430897296-5469-3-git-send-email-jack@suse.cz>
 <20150508144922.GO2462@suse.de>
 <20150511140019.GD25034@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20150511140019.GD25034@quack.suse.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 11, 2015 at 04:00:19PM +0200, Jan Kara wrote:
> > > +int get_vaddr_frames(unsigned long start, unsigned int nr_frames,
> > > +		     bool write, bool force, struct frame_vector *vec)
> > > +{
> > > +	struct mm_struct *mm = current->mm;
> > > +	struct vm_area_struct *vma;
> > > +	int ret = 0;
> > > +	int err;
> > > +	int locked = 1;
> > > +
> > 
> > bool locked.
>   It cannot be bool. It is passed to get_user_pages_locked() which expects
> int *.
> 

My bad.

> > > +int frame_vector_to_pages(struct frame_vector *vec)
> > > +{
> > 
> > I think it's probably best to make the relevant counters in frame_vector
> > signed and limit the maximum possible size of it. It's still not putting
> > any practical limit on the size of the frame_vector.
>
>   I don't see a reason why counters in frame_vector should be signed... Can
> you share your reason?  I've added a check into frame_vector_create() to
> limit number of frames to INT_MAX / sizeof(void *) / 2 to avoid arithmetics
> overflow. Thanks for review!
> 

Only that the return value of frame_vector_to_pages() returns int where
as the potential range that is converted is unsigned int. I don't think
there are any mistakes dealing with signed/unsigned but I don't see any
advantage of using unsigned either and limiting it to INT_MAX either.
It's not a big deal.

-- 
Mel Gorman
SUSE Labs
