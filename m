Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:41926 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754165AbbCFJRf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Mar 2015 04:17:35 -0500
Message-ID: <54F97099.7050601@xs4all.nl>
Date: Fri, 06 Mar 2015 10:17:13 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>, linux-media@vger.kernel.org
CC: Hans Verkuil <hans.verkuil@cisco.com>,
	Davidlohr Bueso <dbueso@suse.com>
Subject: Re: Use of mmap_sem in __qbuf_userptr()
References: <20150305142735.GA16869@quack.suse.cz>
In-Reply-To: <20150305142735.GA16869@quack.suse.cz>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jan,

On 03/05/2015 03:27 PM, Jan Kara wrote:
>   Hello,
> 
>   so after a long pause I've got back to my simplification patches around
> get_user_pages(). After the simplification done by commit f035eb4e976ef5
> (videobuf2: fix lockdep warning) it seems unnecessary to take mmap_sem
> already when calling __qbuf_userptr(). As far as I understand what
> __qbuf_userptr() does, the only thing where mmap_sem is needed is for
> get_userptr and possibly put_userptr memops. So it should be possible to
> push mmap_sem locking down into these memops, shouldn't it? Or am I missing
> something in __qbuf_userptr() for which mmap_sem is also necessary?

No, you are correct. The mmap_sem can be pushed down, either to __qbuf_userptr
or all the way to the videobuf2-dma/vmalloc get/put_userptr ops.

> If I'm right, I can prepare patches to do that (and then on top of those
> rebase patches which will make v4l2 core use some mm helper functions so
> they don't have to care about details of mm locking, vmas, etc.).

That would be really nice.

Regards,

	Hans

