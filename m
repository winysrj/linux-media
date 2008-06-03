Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m53LP0el025197
	for <video4linux-list@redhat.com>; Tue, 3 Jun 2008 17:25:00 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m53LOntt007881
	for <video4linux-list@redhat.com>; Tue, 3 Jun 2008 17:24:49 -0400
Date: Tue, 3 Jun 2008 18:24:37 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Tobias Lorenz <tobias.lorenz@gmx.net>
Message-ID: <20080603182437.3feb1bdf@gaivota>
In-Reply-To: <200805311700.25686.tobias.lorenz@gmx.net>
References: <200805072253.23219.tobias.lorenz@gmx.net>
	<200805262230.26492.tobias.lorenz@gmx.net>
	<20080526183027.7e05f64f@gaivota>
	<200805311700.25686.tobias.lorenz@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Keith Mok <ek9852@gmail.com>, video4linux-list@redhat.com,
	v4l-dvb-maintainer@linuxtv.org
Subject: Re: [PATCH 1/6] si470x: unplugging fixed
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

On Sat, 31 May 2008 17:00:25 +0200
Tobias Lorenz <tobias.lorenz@gmx.net> wrote:

> Hi Mauro,
> 
> > Hmm... The patch didn't apply at Mercurial tree. Not sure why, but I suspect
> > that there are some patches at Mercurial that aren't present at 2.6.25. Please,
> > always generate patches against the latest development version at -hg (or,
> > alternatively, against my -git tree).
> 
> That's true. The last patch to the driver in mercurial, introduced a lot of changes with buffer access functions:
> "be_16_to_cpu(get_unaligned..." -> "get_unaligned_be16("
> 
> Anyway, I downloaded the current mercurial versions and recreated this patchset for it.
> I upload it with the next postings...

Ok, I'll wait for you to send me the hole series again.
> 
> Bye,
> 
> Toby




Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
