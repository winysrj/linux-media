Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9T3I4cv026281
	for <video4linux-list@redhat.com>; Tue, 28 Oct 2008 23:18:04 -0400
Received: from mail-gx0-f12.google.com (mail-gx0-f12.google.com
	[209.85.217.12])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9T3HNv5022893
	for <video4linux-list@redhat.com>; Tue, 28 Oct 2008 23:17:23 -0400
Received: by gxk5 with SMTP id 5so5241702gxk.3
	for <video4linux-list@redhat.com>; Tue, 28 Oct 2008 20:17:23 -0700 (PDT)
Message-ID: <68cac7520810282017i454905a5y561ad9f0b1a0e876@mail.gmail.com>
Date: Wed, 29 Oct 2008 01:17:22 -0200
From: "Douglas Schilling Landgraf" <dougsland@gmail.com>
To: "Alexey Klimov" <klimov.linux@gmail.com>, david@identd.dyndns.org
In-Reply-To: <20081028180552.GA2677@tux>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <208cbae30810161146g69d5d04dq4539de378d2dba7f@mail.gmail.com>
	<208cbae30810190758x2f0c70f5m5856ce9ea84b26ae@mail.gmail.com>
	<30353c3d0810191711y7be7c7f2i83d6a3a8ff46b6a0@mail.gmail.com>
	<20081028180552.GA2677@tux>
Cc: video4linux-list@redhat.com
Subject: Re: [patch] radio-mr800: remove warn- and err- messages
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

Hello guys,

On Tue, Oct 28, 2008 at 4:05 PM, Alexey Klimov <klimov.linux@gmail.com> wrote:
> Hello, all
>
> Here is new patch, reformatted. Also KBUILD_MODNAME added.
>
> radio-mr800: remove warn-, err- and info-messages
>
> Patch removes warn(), err() and info() statements in radio/radio-mr800.c,
> and place dev_warn, dev_info in right places.
> Printk changed on pr_info and pr_err macro.
>
> Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>

Seems sane to my eyes.

Cheers,
Douglas

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
