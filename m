Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7U9GMvM029024
	for <video4linux-list@redhat.com>; Sat, 30 Aug 2008 05:16:22 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7U9GA34002669
	for <video4linux-list@redhat.com>; Sat, 30 Aug 2008 05:16:10 -0400
Date: Sat, 30 Aug 2008 06:15:35 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Dean A." <dean@sensoray.com>
Message-ID: <20080830061535.2142b311@mchehab.chehab.org>
In-Reply-To: <tkrat.fe10464e74816cea@sensoray.com>
References: <tkrat.fe10464e74816cea@sensoray.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: greg@kroah.com, video4linux-list@redhat.com, dean@sensoray.com,
	v4l-dvb-maintainer@linuxtv.org
Subject: Re: [PATCH] s2255drv:  adds JPEG compression quality control
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

On Fri, 29 Aug 2008 11:33:19 -0700 (PDT)
"Dean A." <dean@sensoray.com> wrote:

> From: Dean Anderson <dean@sensoray.com>
> 
> adds VIDIOC_S_JPEGCOMP and VIDIOC_G_JPEGCOMP ioctls for
> controlling JPEG compression quality.
> 
> Signed-off-by: Dean Anderson <dean@sensoray.com>

Applied, thanks.
> --- /usr/src/v4l-dvb-3cca4cda1e3f/linux/drivers/media/video/s2255drv.c.orig	2008-08-29 11:19:08.000000000 -0700
> +++ /usr/src/v4l-dvb-3cca4cda1e3f/linux/drivers/media/video/s2255drv.c	2008-08-29 11:28:10.000000000 -0700

Please, next time generate it with -p1 format, otherwise it will break my scripts.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
