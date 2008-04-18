Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3I5tHBX017722
	for <video4linux-list@redhat.com>; Fri, 18 Apr 2008 01:55:17 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m3I5t5rD015401
	for <video4linux-list@redhat.com>; Fri, 18 Apr 2008 01:55:05 -0400
Date: Fri, 18 Apr 2008 07:55:03 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?GB2312?B?t+v2zg==?= <fengxin215@gmail.com>
In-Reply-To: <998e4a820804172245i473cd822yf09c5cdb799e9cd5@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0804180753430.3639@axis700.grange>
References: <998e4a820804040811l748bd5b7tedf7a50521ff449e@mail.gmail.com>
	<Pine.LNX.4.64.0804090104190.4987@axis700.grange>
	<998e4a820804081827j5379efdfw3a95dd1731e02e42@mail.gmail.com>
	<Pine.LNX.4.64.0804091616470.5671@axis700.grange>
	<998e4a820804092242i8ead476nf7e4db3712bc881@mail.gmail.com>
	<Pine.LNX.4.64.0804100749310.3693@axis700.grange>
	<998e4a820804101854l77e702d9j78d16afc59d807a@mail.gmail.com>
	<Pine.LNX.4.64.0804132124100.6622@axis700.grange>
	<998e4a820804161747m6d8377b1k7481aaff7d081259@mail.gmail.com>
	<Pine.LNX.4.64.0804171824130.6716@axis700.grange>
	<998e4a820804172245i473cd822yf09c5cdb799e9cd5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com
Subject: Re: question for soc-camera driver
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

On Fri, 18 Apr 2008, ·ëöÎ wrote:

> 2008/4/18 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> >
> >  How exactly are you counting lost frames? I just tried several
> >  configurations - with different number of buffers, writing in tmpfs and
> >  over nfs, without load and under a ping flood. And I'm counting FIFO
> >  overrun interrupts. At most I'm getting 1-3 overruns with dropped frames
> >  in the beginning, and only if I write over NFS.
> >
> >  If your system is using drivers, that block interrupts for a considerable
> >  amount of time, of course DMA done interrupts will be missed, FIFO will
> >  overflow and frames will be dropped. I don't think you can avoid this
> >  under such conditions. As I suggested before - you can use more buffers,
> >  put the frame read-out in a separate thread. As a test try writing to
> >  RAM-based tmpfs and see if frames get dropped then too.
> 
> I write in tmpfs.But some frame is dropped.If I request more
> buffers,the number of dropped frames is reduced.Now I request 20
> buffers and write 100 frames.the 52,53,56,57 is dropped.

...and you didn't reply how you're counting frames - this could help me 
understand why you're losing them.

Thanks
Guennadi
---
Guennadi Liakhovetski

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
