Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1E1YnEq031916
	for <video4linux-list@redhat.com>; Wed, 13 Feb 2008 20:34:49 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1E1YRw7016001
	for <video4linux-list@redhat.com>; Wed, 13 Feb 2008 20:34:28 -0500
Date: Wed, 13 Feb 2008 23:34:20 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20080213233420.1db4fba5@gaivota>
In-Reply-To: <20080213143235.b037fd32.akpm@linux-foundation.org>
References: <20080213143235.b037fd32.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: x86_64 allmodconfig
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

On Wed, 13 Feb 2008 14:32:35 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> In file included from drivers/media/video/meye.h:261,
>                  from drivers/media/video/meye.c:41:
> include/linux/meye.h:61:1: warning: "V4L2_CID_SHARPNESS" redefined
> In file included from include/linux/videodev.h:15,
>                  from drivers/media/video/meye.c:32:
> include/linux/videodev2.h:879:1: warning: this is the location of the previous definition

Thanks, I'm ware about it. 

We should have a patch probably tomorrow to fix the
name conflicts. The weird is the the two controls have the same meaning, but
probably with different value ranges. So, we shold take some care to handle
this one.



Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
