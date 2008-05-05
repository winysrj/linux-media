Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m45JgiH0001193
	for <video4linux-list@redhat.com>; Mon, 5 May 2008 15:42:44 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m45JgR4V018916
	for <video4linux-list@redhat.com>; Mon, 5 May 2008 15:42:27 -0400
Date: Mon, 5 May 2008 21:42:20 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: 604hcl@telenet.be
In-Reply-To: <W4018854147541210000621@nocme1bl6.telenet-ops.be>
Message-ID: <Pine.LNX.4.64.0805052140500.5648@axis700.grange>
References: <W4018854147541210000621@nocme1bl6.telenet-ops.be>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: phycore_im27 platform + mt9v022 camera
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

On Mon, 5 May 2008, 604hcl@telenet.be wrote:

> I've been trying to capture an image from my mt9v022 camera with the 
> video4linux example code. The code stops working in the start_capturing 
> method. Right after the VIDIOC_STREAMON ioctl, the system freezes 
> completely.
> 
> Maybe some of you have an idea of the reason for this? I have attached 
> modified code of the example

Your test programme runs through without problem here - same hardware, 
current v4l-dvb/devel git tree.

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
