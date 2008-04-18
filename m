Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3I5k6Rq014504
	for <video4linux-list@redhat.com>; Fri, 18 Apr 2008 01:46:06 -0400
Received: from po-out-1718.google.com (po-out-1718.google.com [72.14.252.158])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3I5jtYr010972
	for <video4linux-list@redhat.com>; Fri, 18 Apr 2008 01:45:56 -0400
Received: by po-out-1718.google.com with SMTP id a23so277126poh.1
	for <video4linux-list@redhat.com>; Thu, 17 Apr 2008 22:45:55 -0700 (PDT)
Message-ID: <998e4a820804172245i473cd822yf09c5cdb799e9cd5@mail.gmail.com>
Date: Fri, 18 Apr 2008 13:45:54 +0800
From: "=?GB2312?B?t+v2zg==?=" <fengxin215@gmail.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0804171824130.6716@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
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

2008/4/18 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> On Thu, 17 Apr 2008, ·ëöÎ wrote:
>
>  > 2008/4/14 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
>  > >>  I found the problem with reversed frame order. The same problem led to
>  > >>  corrupted frames. Please try the patch below on the top of the previous
>  > >>  one. With it I have no more problems with the test application with any
>  > >>  number of buffers.
>  >
>  > 2008/4/14 ·ëöÎ <fengxin215@gmail.com>:
>
> > >  I test it and It is good.But some frames is dropped,like
>  > >  1,2,3,4,5,8,9,10,11,14,15,16,17,18,21,22.The frame 6,7,12,13,19,20 is
>  > >  dropped.I request 4 buffers now.
>  >
>  > Will you improve soc-camera driver for the lost frames?
>
>  How exactly are you counting lost frames? I just tried several
>  configurations - with different number of buffers, writing in tmpfs and
>  over nfs, without load and under a ping flood. And I'm counting FIFO
>  overrun interrupts. At most I'm getting 1-3 overruns with dropped frames
>  in the beginning, and only if I write over NFS.
>
>  If your system is using drivers, that block interrupts for a considerable
>  amount of time, of course DMA done interrupts will be missed, FIFO will
>  overflow and frames will be dropped. I don't think you can avoid this
>  under such conditions. As I suggested before - you can use more buffers,
>  put the frame read-out in a separate thread. As a test try writing to
>  RAM-based tmpfs and see if frames get dropped then too.

I write in tmpfs.But some frame is dropped.If I request more
buffers,the number of dropped frames is reduced.Now I request 20
buffers and write 100 frames.the 52,53,56,57 is dropped.

Thanks fengxin

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
