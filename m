Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6S7944j029711
	for <video4linux-list@redhat.com>; Mon, 28 Jul 2008 03:09:04 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6S78bgx032548
	for <video4linux-list@redhat.com>; Mon, 28 Jul 2008 03:08:42 -0400
Date: Mon, 28 Jul 2008 03:08:27 -0400 (EDT)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
In-Reply-To: <20080727204256.bba5eaf6.randy.dunlap@oracle.com>
Message-ID: <alpine.LFD.1.10.0807280303110.18581@bombadil.infradead.org>
References: <20080727224104.78b8298d@gaivota>
	<20080727204256.bba5eaf6.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
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

Hi Randy,

> I'd really like to get this patch that I mailed to you 2008-July-21 merged...

Your patch looks OK to me. However, this function were moved to 
v4l2-dev.c, by the V4L core changes (the changes broke videodev into two 
different files, and did some improvements there).

Do you mind to rebase your patch?

>
> ---
>
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Add kernel-doc for parameter @index:
>
> Warning(linhead//drivers/media/video/videodev.c:2090): No description found for parameter 'index'
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
> drivers/media/video/videodev.c |    2 ++
> 1 file changed, 2 insertions(+)
>
> --- linhead.orig/drivers/media/video/videodev.c
> +++ linhead/drivers/media/video/videodev.c
> @@ -2066,6 +2066,8 @@ EXPORT_SYMBOL(video_register_device);
>  *	@type: type of device to register
>  *	@nr:   which device number (0 == /dev/video0, 1 == /dev/video1, ...
>  *             -1 == first free)
> + *	@index: stream number based on parent device;
> + *		-1 if auto assign, requested number otherwise
>  *
>  *	The registration code assigns minor numbers based on the type
>  *	requested. -ENFILE is returned in all the device slots for this
>

-- 
Cheers,
Mauro Carvalho Chehab
http://linuxtv.org
mchehab@infradead.org

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
