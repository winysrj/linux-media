Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52460 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbbFKSyI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2015 14:54:08 -0400
Date: Thu, 11 Jun 2015 11:54:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/9] Helper to abstract vma handling in media layer
Message-Id: <20150611115407.6da5d331edaa263269e50350@linux-foundation.org>
In-Reply-To: <5579501F.6080000@xs4all.nl>
References: <cover.1433927458.git.mchehab@osg.samsung.com>
	<5579501F.6080000@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 11 Jun 2015 11:08:47 +0200 Hans Verkuil <hverkuil@xs4all.nl> wrote:

> I discovered a regression on a prerequisite patch merged in the media
> tree that until solved prevents parts of this patch series from going in.
> 
> See: http://www.mail-archive.com/linux-media@vger.kernel.org/msg89538.html
> 
> Jan is on vacation, and I don't know if I have time this weekend to dig
> into this, so the patch that caused the regression may have to be reverted
> for 4.2 and the vb2 patches in this series postponed until the regression
> problem is fixed.
> 
> Note that this is all v4l/vb2 related, the get_vaddr_frames helper is actually
> fine and could be merged, it's just the vb2 patches in this patch series that
> cannot be merged for now due to deadlocks.

OK, thanks.  I'll just keep these patches on hold (in -next) until
advised otherwise?

