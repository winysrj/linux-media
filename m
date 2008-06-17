Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5HAkl4a029867
	for <video4linux-list@redhat.com>; Tue, 17 Jun 2008 06:46:47 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m5HAkZG8022801
	for <video4linux-list@redhat.com>; Tue, 17 Jun 2008 06:46:36 -0400
Date: Tue, 17 Jun 2008 12:46:15 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Veda N <veda74@gmail.com>
Message-ID: <20080617104614.GA781@daniel.bse>
References: <a5eaedfa0806170205r12eed4edl30e2653a918e4cad@mail.gmail.com>
	<20080617092439.GA631@daniel.bse>
	<a5eaedfa0806170239ye9951acv1cc9361b1d43abbe@mail.gmail.com>
	<20080617094510.GA726@daniel.bse>
	<a5eaedfa0806170322v382f5b98o22f2b94830585f7c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5eaedfa0806170322v382f5b98o22f2b94830585f7c@mail.gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: v4l2_pix_format doubts
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

On Tue, Jun 17, 2008 at 03:52:25PM +0530, Veda N wrote:
> I think you got confused by RGB and YUV.

I don't think so

> The device is capable of giving RGB and YUV data. This is done by a
> setting in the sensor register.

That's what I wanted to know

> Now, i know what i should set the pix->pixelformat, but what about
> other members of the
> v4l2_pix_format structure.

for 640x480
width = 640
height = 480

If you tell me pix->pixelformat, I can tell you the minimum bytesperline.
It may be larger if your hardware requires padding of lines.

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
