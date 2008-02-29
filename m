Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m1TNAOGb003469
	for <video4linux-list@redhat.com>; Fri, 29 Feb 2008 18:10:24 -0500
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m1TN9qKq019152
	for <video4linux-list@redhat.com>; Fri, 29 Feb 2008 18:09:52 -0500
Date: Sat, 1 Mar 2008 00:09:48 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: eric miao <eric.y.miao@gmail.com>
In-Reply-To: <f17812d70802290725o77db19daic50aee0380a1dc59@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0803010001550.11511@axis700.grange>
References: <f17812d70802282018i92090d6gc6114da677c07280@mail.gmail.com>
	<fq8v17$bm9$1@ger.gmane.org>
	<f17812d70802290725o77db19daic50aee0380a1dc59@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: video4linux-list@redhat.com,
	Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Subject: Re: [RFC] move sensor control out of kernel
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

On Fri, 29 Feb 2008, eric miao wrote:
> The soc-camera is pretty good. Yet it doesn't solve the issue of
> complicated sensor control. mt9m001.c and mt9v022.c are two
> good examples, but are all too simple. I have a sensor driver here
> with more than 4000 lines of code.

mt9xxxx drivers also only implement a subset of camera capabilities. The 
approach taken with these two drivers was to implement a minimal 
functional control subset in the kernel, so that "standard" user-space 
applications like xawtv, mplayer, etc. can work with them out of the box, 
and provide access to camera registers over the .get_register / 
.set_register interface for applications requiring finer camera tuning. It 
has disadvantages, of course. But it avoids kernel bloat, nevertheless 
providing reasonable functionality, reduces (kernel) development costs, 
etc. Maybe this interface should be made standard and at least removed 
from under #ifdef CONFIG_VIDEO_ADV_DEBUG?

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
