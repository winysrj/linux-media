Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4CEnUEn002107
	for <video4linux-list@redhat.com>; Mon, 12 May 2008 10:49:30 -0400
Received: from smtp-vbr1.xs4all.nl (smtp-vbr1.xs4all.nl [194.109.24.21])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4CEnIpj010903
	for <video4linux-list@redhat.com>; Mon, 12 May 2008 10:49:18 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Steven Toth <stoth@linuxtv.org>
Date: Mon, 12 May 2008 16:48:59 +0200
References: <481B1027.1040002@linuxtv.org> <481B31CC.6090606@linuxtv.org>
	<48285754.8010608@linuxtv.org>
In-Reply-To: <48285754.8010608@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805121648.59225.hverkuil@xs4all.nl>
Cc: Steven Toth <stoth@hauppauge.com>, Michael Krufky <mkrufky@linuxtv.org>,
	Linux and Kernel Video <video4linux-list@redhat.com>
Subject: Re: cx18-0: ioremap failed,
	perhaps increasing __VMALLOC_RESERVE in page.h
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

On Monday 12 May 2008 16:42:28 Steven Toth wrote:
> Steven Toth wrote:
> >>         if (cx->dev)
> >>                 cx18_iounmap(cx);
> >
> > This doesn't feel right.
>
> Hans / Andy,
>
> Any comments?
>
> - Steve


This conditional is indeed bogus. I've just removed it in my v4l-dvb 
tree.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
