Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0MMd8af027650
	for <video4linux-list@redhat.com>; Thu, 22 Jan 2009 17:39:08 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n0MMcp1m030269
	for <video4linux-list@redhat.com>; Thu, 22 Jan 2009 17:38:52 -0500
Date: Thu, 22 Jan 2009 23:38:54 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
In-Reply-To: <uab9ugyqg.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0901222333120.7935@axis700.grange>
References: <uab9ugyqg.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: V4L-Linux <video4linux-list@redhat.com>
Subject: Re: [PATCH] resistor setting sequence fix on ov772x
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

Hi Morimoto-san,

On Tue, 13 Jan 2009, Kuninori Morimoto wrote:

> soc_camera framework require that resistor setting is done on set_fmt,
> and start_capture and stop_capture control only camera on/off.
> This patch modify ov772x to this style.
> 
> Signed-off-by: Kuninori Morimoto <morimoto.kuninori@renesas.com>

I'm applying this patch, but I changed the subject and the description a 
bit:

====================

Subject: [PATCH] ov772x: move configuration from start_capture() to set_fmt()

soc_camera framework requires, that camera configuration is performed in
set_fmt, and start_capture and stop_capture only turn the camera on/off.
This patch modifies ov772x to comply to this requirement.

====================

Agree? I just have no idea whether it's resistors or capacitors or 
anything else that gest set by those i2c commands:-)

One more comment to your ov772x driver: at present S_CROP is not supported 
and it would just fail if anyone attempts to crop the image. Could you 
please fix? You have to process the pixfmt == 0 case in set_fmt for this.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
