Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9GJO3dV016551
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 15:24:03 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m9GJO0LK032132
	for <video4linux-list@redhat.com>; Thu, 16 Oct 2008 15:24:01 -0400
Date: Thu, 16 Oct 2008 21:23:59 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Antonio Ospite <ospite@studenti.unina.it>
In-Reply-To: <20081016102701.1bcb2c59.ospite@studenti.unina.it>
Message-ID: <Pine.LNX.4.64.0810162114030.8422@axis700.grange>
References: <u63nt9mvx.wl%morimoto.kuninori@renesas.com>
	<20081016102701.1bcb2c59.ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [PATCH] Add ov772x driver
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

On Thu, 16 Oct 2008, Antonio Ospite wrote:

> On Thu, 16 Oct 2008 13:28:52 +0900
> Kuninori Morimoto <morimoto.kuninori@renesas.com> wrote:
> 
> > This patch adds ov772x driver that use soc_camera framework.
> 
> Hi, this sensor is used also in some usb cameras (Playstation Eye, for
> instance), and this code can be reused to improve the previously posted
> ov534 driver.
> 
> The question is: is there any mechanism to share sensor code between
> usb and i2c drivers or we have to copy and paste?

Well, this is not the first time this idea / question appears... I think, 
it might be possible to re-use soc-camera sensor drivers with USB-cameras, 
at least with those, that export their internal i2c bus to the system. 
Then, as Magnus Damm noticed, you have to register your USB driver as a 
soc-camera host driver, and you will have to register the sensor as a 
normal i2c device with the i2c subsystem. That's about it:-) Hans Verkuil 
will, probably, notice, that soc-camera is not universal enough for many 
video applications, but it might well be enough for the cideo part of a 
simple USB web-camera, I think. OTOH, Hans is working on a new API, that 
should unify the host / device interface in v4l applications, at which 
time soc-camera drivers will have to be converted, as well as multiple 
other currently existing APIs.

Just out of curiosity, I would be interested to see a USB camera driver, 
using the soc-camera framework:-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
