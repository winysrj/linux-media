Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9OIhu27006643
	for <video4linux-list@redhat.com>; Fri, 24 Oct 2008 14:43:56 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m9OIeWeW019186
	for <video4linux-list@redhat.com>; Fri, 24 Oct 2008 14:40:39 -0400
Date: Fri, 24 Oct 2008 20:40:47 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Magnus Damm <magnus.damm@gmail.com>
In-Reply-To: <aec7e5c30810222026g4622aafcrf70cde31bcb0c602@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0810242035130.7996@axis700.grange>
References: <uhc77mucm.wl%morimoto.kuninori@renesas.com>
	<aec7e5c30810222026g4622aafcrf70cde31bcb0c602@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: khali@linux-fr.org, V4L <video4linux-list@redhat.com>, i2c@lm-sensors.org,
	mchehab@infradead.org
Subject: Re: [i2c] [PATCH v7] Add ov772x driver
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

Magnus,

thanks for the Acked-by, but, unfortunately, as the contents of the driver 
has changed in -v8 (0x38 instead of 0x40), I cannot use this for the new 
version. If you want, you can re-test and re-send for -v8. You might also 
consider using Tested-by instead-of Acked-by (see 
Documentation/SubmittingPatches) - decide for yourself whichever you 
prefer. I'll push it now, but if you're fast enough, maybe Mauro will pick 
up your *-by on the way to Linus.

Thanks
Guennadi

On Thu, 23 Oct 2008, Magnus Damm wrote:

> On Mon, Oct 20, 2008 at 7:09 PM, Kuninori Morimoto
> <morimoto.kuninori@renesas.com> wrote:
> > This patch adds ov772x driver that use soc_camera framework.
> > It was tested on SH Migo-r board.
> >
> > Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>
> > ---
> > PATCH v6 -> v7
> 
> This works just fine on my Migo-R board as well. Much better than my
> old soc_camera_platform hack.
> 
> Acked-by: Magnus Damm <damm@igel.co.jp>
> 
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
