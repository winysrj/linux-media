Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4QLKwSN020232
	for <video4linux-list@redhat.com>; Mon, 26 May 2008 17:20:58 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4QLKfWZ021053
	for <video4linux-list@redhat.com>; Mon, 26 May 2008 17:20:41 -0400
Date: Mon, 26 May 2008 18:20:22 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Tobias Lorenz <tobias.lorenz@gmx.net>
Message-ID: <20080526182022.0c1dea3e@gaivota>
In-Reply-To: <200805262040.47204.tobias.lorenz@gmx.net>
References: <200805072252.16704.tobias.lorenz@gmx.net>
	<20080526104130.355b6f41@gaivota>
	<200805262040.47204.tobias.lorenz@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Keith Mok <ek9852@gmail.com>, video4linux-list@redhat.com,
	v4l-dvb-maintainer@linuxtv.org
Subject: Re: [PATCH 1/2] v4l2: hardware frequency seek ioctl interface
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

On Mon, 26 May 2008 20:40:46 +0200
Tobias Lorenz <tobias.lorenz@gmx.net> wrote:

> Hi Mauro,
> 
> > The patch itself looks good. However, there are several codingstyle errors. Please run checkpatch.pl against it and send me again, having the pointed issues fixed.
> 
> Yes, I know. The errors are a result from trying to follow the coding style of these files.
> 
> This is the file list with comments on coding style and patch:
> drivers/media/video/videodev.c: has unusual coding style, but hwseek patch is now corrected
> drivers/media/video/compat_ioctl32.c: had already nice coding style, hwseek patch too
> include/linux/videodev2.h: has unusual coding style, but hwseek patch is now corrected except from one long line...
> include/media/v4l2-dev.h: has unusual coding style, but hwseek patch is now corrected

As a general rule, newer patches should follow the current CodingStyle. Yes,
I'm aware that there are several drivers not compliant with current CodingStyle
rules.

> Maybe I should send a coding style cleanup patch for these files too :-)

Yes, you can, but globally fixing CodingStyle is somewhat evil ;) This will
break any patch that somebody else is working with for that file. Also, any
patch applied during your development will break your patch. So, I generally
prefer not having such patches (or having it only at the last week before the
next open windows).
> 
> The corrected patch is still against linux-2.6.25. I hope it applies cleanly to the mercurial v4l repository.
> 
Applied fine, thanks.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
