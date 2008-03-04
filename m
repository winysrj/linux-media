Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m24EQ23T004691
	for <video4linux-list@redhat.com>; Tue, 4 Mar 2008 09:26:02 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m24EPUDu029672
	for <video4linux-list@redhat.com>; Tue, 4 Mar 2008 09:25:30 -0500
Date: Tue, 4 Mar 2008 11:25:19 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Carl Karsten <carl@personnelware.com>
Message-ID: <20080304112519.6f4c748c@gaivota>
In-Reply-To: <47C8A0C9.4020107@personnelware.com>
References: <47C8A0C9.4020107@personnelware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: [patch] vivi: registered as /dev/video%d
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

Carl,

On Fri, 29 Feb 2008 18:18:17 -0600
Carl Karsten <carl@personnelware.com> wrote:

> Now that vivi can be something other than /dev/video0, it should tell us what it 
>   is.  This works for n_devs>1.
> 
> sudo modprobe vivi n_devs=3
> 
> [115041.616401] vivi: V4L2 device registered as /dev/video0
> [115041.616445] vivi: V4L2 device registered as /dev/video1
> [115041.616481] vivi: V4L2 device registered as /dev/video2
> [115041.616486] Video Technology Magazine Virtual Video Capture Board 
> successfully loaded.

Please, re-send your patches, adding your SOB. Please numberate them with something like 
[PATCH 1/3] for me to apply at the proper order.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
