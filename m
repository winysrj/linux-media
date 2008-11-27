Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mARJKOhh009329
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 14:20:24 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mARJJqAI001049
	for <video4linux-list@redhat.com>; Thu, 27 Nov 2008 14:19:53 -0500
Date: Thu, 27 Nov 2008 20:20:06 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: morimoto.kuninori@renesas.com
In-Reply-To: <u1vwx24iu.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0811272015530.8230@axis700.grange>
References: <u1vwx24iu.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: Re: Question about ov772x driver
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

On Thu, 27 Nov 2008, morimoto.kuninori@renesas.com wrote:

> 
> Hi all.
> 
> This is question mail about ov772x driver.
> I have 2 questiones.
> 
> 1) 
> 
> I think ov772x driver was added to linux/kernel/git/mchehab/v4l-dvb.git in 2008-10-24.
> but now , v4l-dvb.git doesn't have ov772x driver. 
> I can find it in only linux/kernel/git/mchehab/linux-next.git
> 
> Therefore I tried to search information what this mchehab/linux-next.git is ?
> sorry but I could not.
> What is the purpose of mchehab/linux-next.git ?
> 
> Does ov772x driver will be merged to v4l-dvb when 2.6.29 is released ? or not ?

I hope so. I pushed it to Mauro and hoped to get it into 2.6.28 as this 
was a new driver submission and so could not cause any regressions, but 
that didn't happen. In any case it should get into 2.6.29.

> 2)
> 
> I tried to send folloing 2 patches for ov772x driver
> 
> o 2008-11-12 "Change power on/off sequence on ov772x" v2
> o 2008-11-18 "Add ov7725 ov7720 support to ov772x driver"
> 
> Does these patches are ignored ? or only slowly response ?
> Should I send these again ?

No, these patches didn't get lost or ignored - they are in my soc-camera 
queue for 2.6.29.

I probably have to start acking patches that I'm going to pull through my 
tree, sorry.

Also, you might want to cc me on any soc-camera related patch, although, I 
do read v4l, but a cc gets your mail sooner and with a better chance to 
not be overseen.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
