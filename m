Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6IEChwG005961
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 10:12:43 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m6IECUh1025372
	for <video4linux-list@redhat.com>; Fri, 18 Jul 2008 10:12:31 -0400
Date: Fri, 18 Jul 2008 16:12:44 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
In-Reply-To: <4880A22B.1050002@teltonika.lt>
Message-ID: <Pine.LNX.4.64.0807181603250.14224@axis700.grange>
References: <4880A22B.1050002@teltonika.lt>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: [RFC] Rename soc_camera to camera_bus
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

On Fri, 18 Jul 2008, Paulius Zaleckas wrote:

> I suggest to rename soc_camera to camera_bus or something similar.
> This should be done, because soc_camera framework can (IMHO should)
> be used with USB webcams (not uvc), SoC camera interfaces, PCI device (like
> cafe) and any other devices where it is possible to control camera
> bus and i2c separately.

It is not the first time this idea appears, I certainly would be pleased 
if this interface could find wider application in USB- and PCI-camera 
drivers, and I also think it should be quite possible. As for the name - 
let's be pragmatic once again. Personally, I have nothing against any 
other reasonable name, camera_bus sounds good too, but let's wait until 
the first such (USB or PCI) driver appears, then we will politely ask the 
submitter to prepare a patch to rename the interface and all internal 
functions, structs, etc.:-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
