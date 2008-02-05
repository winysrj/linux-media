Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m159qUen030172
	for <video4linux-list@redhat.com>; Tue, 5 Feb 2008 04:52:30 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.1/8.13.1) with SMTP id m159pxEq001529
	for <video4linux-list@redhat.com>; Tue, 5 Feb 2008 04:51:59 -0500
Date: Tue, 5 Feb 2008 10:52:01 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
To: Brandon Philips <brandon@ifup.org>
In-Reply-To: <0810f250d078bf6159de.1202176996@localhost>
Message-ID: <Pine.LNX.4.64.0802051050530.5546@axis700.grange>
References: <0810f250d078bf6159de.1202176996@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: v4l-dvb-maintainer@linuxtv.org, video4linux-list@redhat.com,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 1 of 3] Backed out changeset d002378ff8c2
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

On Mon, 4 Feb 2008, Brandon Philips wrote:

> # HG changeset patch
> # User Brandon Philips <brandon@ifup.org>
> # Date 1202175426 28800
> # Node ID 0810f250d078bf6159de69569828c07cb54f4389
> # Parent  d002378ff8c2d8e8bf3842d8f05469dd68398fc6
> Backed out changeset d002378ff8c2
> 
> This change had a number of issues:
>  - Adding an undiscussed control
>  - Adding an unrelated mailimport change
>  - Adding an unrelated kconfig change
> 
> diff --git a/linux/drivers/media/video/Kconfig b/linux/drivers/media/video/Kconfig
> --- a/linux/drivers/media/video/Kconfig
> +++ b/linux/drivers/media/video/Kconfig

Brandon, you wanted -p1 style patches - same for 2/3 and 3/3.

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
