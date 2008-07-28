Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6SFQ7Tt011021
	for <video4linux-list@redhat.com>; Mon, 28 Jul 2008 11:26:07 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6SFPtGL025926
	for <video4linux-list@redhat.com>; Mon, 28 Jul 2008 11:25:56 -0400
Date: Mon, 28 Jul 2008 12:25:18 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Message-ID: <20080728122518.77cea66e@gaivota>
In-Reply-To: <20080728081813.423ac50c.randy.dunlap@oracle.com>
References: <20080727224104.78b8298d@gaivota>
	<20080727204256.bba5eaf6.randy.dunlap@oracle.com>
	<alpine.LFD.1.10.0807280303110.18581@bombadil.infradead.org>
	<20080728081813.423ac50c.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-dvb-maintainer@linuxtv.org, Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCHES for 2.6.27] V4L/DVB updates
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Mon, 28 Jul 2008 08:18:13 -0700
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> On Mon, 28 Jul 2008 03:08:27 -0400 (EDT) Mauro Carvalho Chehab wrote:
> 
> > Hi Randy,
> > 
> > > I'd really like to get this patch that I mailed to you 2008-July-21 merged...
> > 
> > Your patch looks OK to me. However, this function were moved to 
> > v4l2-dev.c, by the V4L core changes (the changes broke videodev into two 
> > different files, and did some improvements there).
> > 
> > Do you mind to rebase your patch?
> 
> What tree contains v4l2-dev.c?
> It's not in today's linux-next.  Shouldn't it be, or is it for after 2.6.27?

I've changed my procedures to generate my trees, to avoid needing to rebase all
branches (the idea is to have just for_linus rebased).

Due to that change, only yesterday I fixed the updates for linux-next (also,
I've applied the pending patches only yesterday, including the ones that
touched on V4L core). Probably, that's the reason why linux-next is not
updated. Let's see if tomorrow's version will be ok.

At the meantime, you can use my -git tree:

http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=summary

Cheers,
Mauro.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
