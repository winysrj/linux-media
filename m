Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0DLL37H018010
	for <video4linux-list@redhat.com>; Tue, 13 Jan 2009 16:21:03 -0500
Received: from mail-bw0-f20.google.com (mail-bw0-f20.google.com
	[209.85.218.20])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n0DLKnmF008494
	for <video4linux-list@redhat.com>; Tue, 13 Jan 2009 16:20:49 -0500
Received: by bwz13 with SMTP id 13so689929bwz.3
	for <video4linux-list@redhat.com>; Tue, 13 Jan 2009 13:20:48 -0800 (PST)
Message-ID: <63386a3d0901131320idcc7f7fxbf2ca43c6f105d0d@mail.gmail.com>
Date: Tue, 13 Jan 2009 22:20:48 +0100
From: "Linus Walleij" <linus.ml.walleij@gmail.com>
To: video4linux-list@redhat.com
In-Reply-To: <A24693684029E5489D1D202277BE894416429FA0@dlee02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <A24693684029E5489D1D202277BE894416429FA0@dlee02.ent.ti.com>
Subject: Re: [REVIEW PATCH 10/14] OMAP: CAM: Add ISP gain tables
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

2009/1/13 Aguirre Rodriguez, Sergio Alberto <saaguirre@ti.com>:

> +++ b/drivers/media/video/isp/bluegamma_table.h
(...)
> +0,
> +0,
> +1,
> +2,
> +3,
> +3,

That's a lot of magic numbers, what do I need to know to understand them?

Can you add some comment with some references, some statement like
"obtained by calibating with a sensor in a certain controlled environment"
or a mathematic formula used or whatever makes it a little bit more clear?

Yours,
Linus Walleij

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
