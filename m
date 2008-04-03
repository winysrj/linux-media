Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m33ITQgU012741
	for <video4linux-list@redhat.com>; Thu, 3 Apr 2008 14:29:26 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m33ITAxv031559
	for <video4linux-list@redhat.com>; Thu, 3 Apr 2008 14:29:10 -0400
Date: Thu, 3 Apr 2008 15:28:41 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Brandon Philips <brandon@ifup.org>
Message-ID: <20080403152841.25f03a23@gaivota>
In-Reply-To: <20080403180341.GD14369@plankton.ifup.org>
References: <20080401195050.470c8edb@gaivota>
	<20080403180341.GD14369@plankton.ifup.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com
Subject: Re: [GIT PATCHES] V4L/DVB fixes for 2.6.25-rc8
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

On Thu, 3 Apr 2008 11:03:41 -0700
Brandon Philips <brandon@ifup.org> wrote:

> On 19:50 Tue 01 Apr 2008, Mauro Carvalho Chehab wrote:
> > Cyrill Gorcunov (1):
> >       V4L/DVB (7461): bttv: fix missed index check
> 
> Why didn't his other change "bttv: Bt832 - fix possible NULL pointer
> deref" 6d5fc5ba9017 go in?

AFAIK, this is not so relevant, since there are very few old boards with bt832
inside (if you take a look the driver was made on 2002). Anyway, it doesn't
hurt to add this patch on the next pull request. I'll schedule it.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
