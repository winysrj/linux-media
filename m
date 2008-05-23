Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx2.redhat.com (mx2.redhat.com [10.255.15.25])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with SMTP id m4NJ8lVf030588
	for <video4linux-list@redhat.com>; Fri, 23 May 2008 15:08:47 -0400
Received: from smtp-vbr15.xs4all.nl (smtp-vbr15.xs4all.nl [194.109.24.35])
	by mx2.redhat.com (8.13.8/8.13.8) with SMTP id m4NJ7Qjs005302
	for <video4linux-list@redhat.com>; Fri, 23 May 2008 15:07:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Fri, 23 May 2008 21:05:30 +0200
References: <20080522223700.2f103a14@core>
In-Reply-To: <20080522223700.2f103a14@core>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805232105.30577.hverkuil@xs4all.nl>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] video4linux: Push down the BKL
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

On Thursday 22 May 2008 23:37:00 Alan Cox wrote:
> For most drivers the generic ioctl handler does the work and we
> update it and it becomes the unlocked_ioctl method. Older drivers use
> the usercopy method so we make it do the work. Finally there are a
> few special cases.
>
> Signed-off-by: Alan Cox <alan@redhat.com>

Here is my Ack for the ivtv/cx18 parts of this patch:

Acked-by: Hans Verkuil <hverkuil@xs4all.nl>

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
