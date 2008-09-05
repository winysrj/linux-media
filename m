Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m85I6ZQl011561
	for <video4linux-list@redhat.com>; Fri, 5 Sep 2008 14:06:35 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m85I5Tco026169
	for <video4linux-list@redhat.com>; Fri, 5 Sep 2008 14:05:46 -0400
Date: Fri, 5 Sep 2008 20:12:56 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
In-Reply-To: <20080905103917.GQ4941@pengutronix.de>
Message-ID: <Pine.LNX.4.64.0809051330390.5482@axis700.grange>
References: <20080905103917.GQ4941@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [soc-camera] about the y_skip_top parameter
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

On Fri, 5 Sep 2008, Sascha Hauer wrote:

> Hi all,
> 
> The y_skip_top parameter tells the cameras to effectively make the
> picture one line higher. I think this parameter was introduced to work
> around a bug in the pxa camera interface. The pxa refuses to read the
> first line of a picture. The problem with this parameter is that it is
> set to 1 in the sensor drivers and not in the pxa driver, so it's the
> sensor drivers which work around a bug in the pxa. On other
> hardware platforms (mx27 in this particular case) I cannot skip the
> first line, so I think this parameter should be set to 1 in the pxa
> driver and not the sensor drivers.
> 
> What do you think?

Hm, AFAIR, the reason was different. I was told, that "all" cameras 
corrupt the first line, that's why that parameter has been introduced. I 
don't think it was related to PXA270. In any case, why don't you just set 
this parameter to whatever you need in your hist driver .add method, for 
example, before calling camera's .init?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
