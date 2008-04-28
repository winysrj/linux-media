Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3SEN972026841
	for <video4linux-list@redhat.com>; Mon, 28 Apr 2008 10:23:09 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m3SEMtfT031877
	for <video4linux-list@redhat.com>; Mon, 28 Apr 2008 10:22:56 -0400
Date: Mon, 28 Apr 2008 16:23:00 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Stefan Herbrechtsmeier <hbmeier@hni.uni-paderborn.de>
In-Reply-To: <4811F4EE.9060409@hni.uni-paderborn.de>
Message-ID: <Pine.LNX.4.64.0804281604400.7897@axis700.grange>
References: <4811F4EE.9060409@hni.uni-paderborn.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com
Subject: Re: pxa_camera with one buffer don't work
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

On Fri, 25 Apr 2008, Stefan Herbrechtsmeier wrote:

> Hi,
> 
> is it normal, that the pxa_camera driver don`t work with one buffer?. The
> DQBUF blocks if only one buffer is in the query.

Well, in v4l2-apps/test/capture_example.c we see:

	if (req.count < 2) {
		fprintf (stderr, "Insufficient buffer memory on %s\n",
			 dev_name);
		exit (EXIT_FAILURE);
	}

so, they seem to refuse to run with fewer than 2 buffers. But if I remove 
this restriction and enforce 1 buffer, it works. 2.5 times slower, but 
works. Can there be a problem with your application? What kernel sources 
are you using? Try using the latest v4l-dvb/devel git.

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
