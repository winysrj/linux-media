Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38592 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbbGQU0x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jul 2015 16:26:53 -0400
Date: Fri, 17 Jul 2015 13:26:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Jan Kara <jack@suse.com>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-samsung-soc@vger.kernel.org, linux-mm@kvack.org,
	Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/9] mm: Provide new get_vaddr_frames() helper
Message-Id: <20150717132651.18aee9571f267200b9ad15f4@linux-foundation.org>
In-Reply-To: <55A8D7AC.3060709@xs4all.nl>
References: <1436799351-21975-1-git-send-email-jack@suse.com>
	<1436799351-21975-3-git-send-email-jack@suse.com>
	<55A8D7AC.3060709@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 17 Jul 2015 12:23:40 +0200 Hans Verkuil <hverkuil@xs4all.nl> wrote:

> On 07/13/2015 04:55 PM, Jan Kara wrote:
> > From: Jan Kara <jack@suse.cz>
> > 
> > Provide new function get_vaddr_frames().  This function maps virtual
> > addresses from given start and fills given array with page frame numbers of
> > the corresponding pages. If given start belongs to a normal vma, the function
> > grabs reference to each of the pages to pin them in memory. If start
> > belongs to VM_IO | VM_PFNMAP vma, we don't touch page structures. Caller
> > must make sure pfns aren't reused for anything else while he is using
> > them.
> > 
> > This function is created for various drivers to simplify handling of
> > their buffers.
> > 
> > Acked-by: Mel Gorman <mgorman@suse.de>
> > Acked-by: Vlastimil Babka <vbabka@suse.cz>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> 
> I'd like to see an Acked-by from Andrew or mm-maintainers before I merge this.

I think I already acked this but it got lost.

Acked-by: Andrew Morton <akpm@linux-foundation.org>
