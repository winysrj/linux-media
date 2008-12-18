Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBIDeZao018561
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 08:40:35 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mBIDeIHc018735
	for <video4linux-list@redhat.com>; Thu, 18 Dec 2008 08:40:18 -0500
Date: Thu, 18 Dec 2008 14:40:28 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Matthieu CASTET <matthieu.castet@parrot.com>
In-Reply-To: <494A4C93.4040202@parrot.com>
Message-ID: <Pine.LNX.4.64.0812181428250.5510@axis700.grange>
References: <494A150F.6010602@parrot.com>
	<Pine.LNX.4.64.0812181219100.5510@axis700.grange>
	<494A4C93.4040202@parrot.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: soc-camera : add new flags
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

On Thu, 18 Dec 2008, Matthieu CASTET wrote:

> Guennadi Liakhovetski a écrit :
> > On Thu, 18 Dec 2008, Matthieu CASTET wrote:
> > 
> >> Our IP also allow to select if the data on the bus is transmitted on the
> >> CbYCrY order or YCbYCr order.
> >> Can new flag be added to negotiate the synchronization standard between
> >> host and sensor.
> > 
> > Different statement but the same question? If you wanted to ask about 
> > colour format then just use different YUYV / UYVY / ... fourcc codes.
> How do you differentiate color format of the bus and the color format
> output by v4l ?
> 
> In our case the bus format can be YUYV or UYVY, but the host camera IP
> can only output YUV422P/YUV420/YVU420.

This is what our recently added format conversion infrastructure is for, 
basically your camera host driver is called on camera supported format 
enumeration for each camera format and it has to decide whether it 
supports that format and to which formats it can convert it. Both in-tree 
host drivers support this.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
