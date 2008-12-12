Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBC35Nws002439
	for <video4linux-list@redhat.com>; Thu, 11 Dec 2008 22:05:23 -0500
Received: from mail-qy0-f21.google.com (mail-qy0-f21.google.com
	[209.85.221.21])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBC359eN014279
	for <video4linux-list@redhat.com>; Thu, 11 Dec 2008 22:05:09 -0500
Received: by qyk14 with SMTP id 14so1440222qyk.3
	for <video4linux-list@redhat.com>; Thu, 11 Dec 2008 19:05:09 -0800 (PST)
Date: Fri, 12 Dec 2008 01:05:02 -0200
From: Douglas Schilling Landgraf <dougsland@gmail.com>
To: Alexey Klimov <klimov.linux@gmail.com>
Message-ID: <20081212010502.2f9abd58@gmail.com>
In-Reply-To: <1228856144.20449.17.camel@tux.localhost>
References: <1227054989.2389.33.camel@tux.localhost>
	<30353c3d0811200753h113ede02xc8708cd2dee654b3@mail.gmail.com>
	<1227410369.16932.31.camel@tux.localhost>
	<30353c3d0811240635t3649fa2bk5f5982c4d3d6e87c@mail.gmail.com>
	<1227787210.11477.7.camel@tux.localhost>
	<30353c3d0811292119y226c5af3tb63dbf130da59c69@mail.gmail.com>
	<208cbae30812051604t6d74a0cbr4177262324563688@mail.gmail.com>
	<20081206080555.6764076d@pedra.chehab.org>
	<1228786534.4367.17.camel@tux.localhost>
	<30353c3d0812090602m6c0f67feje2493fae7bed6850@mail.gmail.com>
	<1228856144.20449.17.camel@tux.localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, David Ellingsworth <david@identd.dyndns.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] dsbr100: fix unplug oops
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

Hello Alexey,

On Tue, 09 Dec 2008 23:55:43 +0300
Alexey Klimov <klimov.linux@gmail.com> wrote:

> This patch corrects unplug procedure. Patch adds
> usb_dsbr100_video_device_release, new macros - videodev_to_radio,
> mutex lock and a lot of safety checks.
> Struct video_device videodev is embedded in dsbr100_device structure.
> Video_device_alloc and memcpy calls removed.
> 
> Signed-off-by: Alexey Klimov <klimov.linux@gmail.com>
> 

  I've double check your patch and tested several times. Worked fine.
  Congrats to you and David.

  Acked-by: Douglas Schilling Landgraf <dougsland@linuxtv.org>

Thanks,
Douglas

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
