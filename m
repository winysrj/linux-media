Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3PBulBC024811
	for <video4linux-list@redhat.com>; Fri, 25 Apr 2008 07:56:47 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m3PBuYXH013552
	for <video4linux-list@redhat.com>; Fri, 25 Apr 2008 07:56:34 -0400
Date: Fri, 25 Apr 2008 13:56:39 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: 604hcl@telenet.be
In-Reply-To: <Pine.LNX.4.64.0804251054570.6045@axis700.grange>
Message-ID: <Pine.LNX.4.64.0804251319420.6045@axis700.grange>
References: <W876112100223131209109949@nocme1bl6.telenet-ops.be>
	<Pine.LNX.4.64.0804251054570.6045@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: mt9v022 kernel driver
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

On Fri, 25 Apr 2008, Guennadi Liakhovetski wrote:

> The first problem I see there, is that you don't set the fmt.type field. 
> See http://lwn.net/Articles/203924/ for a nice V4L2 tutorial.

After fixing this one, and also intialization of the v4l2_format struct, 
the test programme works for me (TM), so, it looks like there are some 
unfixed bugs in the BSP, that you're using. Best would be if you could try 
to switch to the v4l-dvb git-tree devel branch. Also notice, that in your 
copy of the test application, amount of data written to the file should be 
double for the BYR2 (V4L2_PIX_FMT_SBGGR16) format - 2 bytes per pixel.

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
