Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1Q7O86i013322
	for <video4linux-list@redhat.com>; Tue, 26 Feb 2008 02:24:08 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m1Q7NZni025413
	for <video4linux-list@redhat.com>; Tue, 26 Feb 2008 02:23:36 -0500
Date: Tue, 26 Feb 2008 08:23:35 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
To: eric miao <eric.y.miao@gmail.com>
In-Reply-To: <f17812d70802251649p73c7fa2p881b1710ebad5f81@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0802260817110.3846@axis700.grange>
References: <Pine.LNX.4.64.0802251304320.4430@axis700.grange>
	<f17812d70802251649p73c7fa2p881b1710ebad5f81@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] soc-camera: deactivate cameras when not used
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

On Tue, 26 Feb 2008, eric miao wrote:

> Do you have a git tree or patch series (maybe a mbox patch aggregate)
> that I can apply? Also let me know the baseline to apply, I guess it
> should apply happily on top of linux-v4l2's current head, but I'm not
> sure

v4l-dvb/devel contains most of my patches. This is the only patch missing 
there ATM. Are you looking at testing it? What I forgot about, is that so 
far only the two mt9m001 and mt9v022 Micron cameras are supported by the 
API. But writing new drivers shouldn't be very difficult. Let me know if 
you need help with that.

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
