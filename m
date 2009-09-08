Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx02.extmail.prod.ext.phx2.redhat.com
	[10.5.110.6])
	by int-mx08.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n887U6fg027275
	for <video4linux-list@redhat.com>; Tue, 8 Sep 2009 03:30:06 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n887Tpcn027298
	for <video4linux-list@redhat.com>; Tue, 8 Sep 2009 03:29:52 -0400
Date: Tue, 8 Sep 2009 09:29:55 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
In-Reply-To: <ufxayw6mr.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0909080928570.4550@axis700.grange>
References: <ufxayw6mr.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: Re: [PATCH 0/4] tw9910 can use INTERLACE TB/BT
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

Hi Morimoto-san

On Tue, 8 Sep 2009, Kuninori Morimoto wrote:

> 
> Hi Guennadi
> 
> These patches for tw9910.
> 
> Kuninori Morimoto
>       soc-camera: tw9910: hsync_ctrl can control from platform
>       soc-camera: tw9910 driver only check Product ID
>       soc-camera: sh_mobile_ceu: Add V4L2_FIELD_INTERLACED_BT/TB support
>       soc-camera: tw9910: use V4L2_FIELD_INTERLACED_TB/BT for field
> 
> h/v position for tw9910 should be controlled from platform.
> 1st patches is for this
> (I will send MigoR patch to controll it)
> 
> tw9910 has fixed Product ID and some revision ID.
> 2nd patch change to check only Product ID.
> 
> 3rd/4th patch add INTERLACE TB/TB support for CEU and tw9910

A general comment: unless you're aiming at 2.6.31, it would be better to 
rebase your patches on the top of v4l-dvb next plus my imagebus patches.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
