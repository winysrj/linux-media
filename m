Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1E2wk5t000505
	for <video4linux-list@redhat.com>; Wed, 13 Feb 2008 21:58:46 -0500
Received: from wr-out-0506.google.com (wr-out-0506.google.com [64.233.184.225])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m1E2wOUF023233
	for <video4linux-list@redhat.com>; Wed, 13 Feb 2008 21:58:24 -0500
Received: by wr-out-0506.google.com with SMTP id 70so407915wra.7
	for <video4linux-list@redhat.com>; Wed, 13 Feb 2008 18:58:21 -0800 (PST)
Date: Wed, 13 Feb 2008 18:58:03 -0800
From: Brandon Philips <brandon@ifup.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Message-ID: <20080214025803.GB15895@plankton.ifup.org>
References: <20080213143235.b037fd32.akpm@linux-foundation.org>
	<20080213233420.1db4fba5@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080213233420.1db4fba5@gaivota>
Cc: Stelian Pop <stelian@popies.net>,
	Andrew Morton <akpm@linux-foundation.org>, tridge@samba.org,
	video4linux-list@redhat.com
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

On 23:34 Wed 13 Feb 2008, Mauro Carvalho Chehab wrote:
> On Wed, 13 Feb 2008 14:32:35 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > In file included from drivers/media/video/meye.h:261,
> >                  from drivers/media/video/meye.c:41:
> > include/linux/meye.h:61:1: warning: "V4L2_CID_SHARPNESS" redefined
> > In file included from include/linux/videodev.h:15,
> >                  from drivers/media/video/meye.c:32:
> > include/linux/videodev2.h:879:1: warning: this is the location of the previous definition
> 
> Thanks, I'm ware about it. 
> 
> We should have a patch probably tomorrow to fix the
> name conflicts. The weird is the the two controls have the same meaning, but
> probably with different value ranges. So, we shold take some care to handle
> this one.

The current range on meye's sharpness control is 0-63 with 32 as
default.  This is fine since the new v4l2-spec says the SHARPNESS
control's range is implementation specific.  

The question is whether a 0 value disables the sharpness filter and if
increasing numbers increase the sharpness filter.

We can probably assume it does but, I will CC the owners of the driver
and find out.  Stelian?  Tridge?

Thanks,

	Brandon

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
