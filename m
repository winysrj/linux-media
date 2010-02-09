Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx02.extmail.prod.ext.phx2.redhat.com
	[10.5.110.6])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o1994GTO015893
	for <video4linux-list@redhat.com>; Tue, 9 Feb 2010 04:04:16 -0500
Received: from mail-pz0-f175.google.com (mail-pz0-f175.google.com
	[209.85.222.175])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o19940l2025077
	for <video4linux-list@redhat.com>; Tue, 9 Feb 2010 04:04:00 -0500
Received: by pzk5 with SMTP id 5so7409895pzk.29
	for <video4linux-list@redhat.com>; Tue, 09 Feb 2010 01:04:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <51268.13527.qm@web65506.mail.ac4.yahoo.com>
References: <fe6fd5f61002010303y48f5d51m3f4c0e5f21698825@mail.gmail.com>
	<51268.13527.qm@web65506.mail.ac4.yahoo.com>
Date: Tue, 9 Feb 2010 10:03:59 +0100
Message-ID: <fe6fd5f61002090103x7f096792ma9cac3b88f924f28@mail.gmail.com>
Subject: Re: Problem of memory
From: Carlos Lavin <carlos.lavin@vista-silicon.com>
To: video4linux-list <video4linux-list@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Thanks for your answer, but I wouldn't want to modify the chain of
functions. I will like can call to my driver for allocate memory instead of
soc_camera_mmap, is it possible avoid soc_camera in this function and to
call a my driver for the allocate memory?,and if your answer is yes , how do
I do it?
Your solution is good but I have modify functions of the kernel, and I don't
want it, if it is posible...
Can anybody help me?


2010/2/1 Michael Williamson <michael_h_williamson@yahoo.com>

>
>
> --- On Mon, 2/1/10, Carlos Lavin <carlos.lavin@vista-silicon.com> wrote:
>
> > From: Carlos Lavin <carlos.lavin@vista-silicon.com>
> > Subject: Problem of memory
> > To: "video4linux-list" <video4linux-list@redhat.com>
> > Date: Monday, February 1, 2010, 5:03 AM
> > hello, I have a problem, I am
> > developing a video driver for imx27 in version
> > 2.6.30, I need to work in this version, I work with the
> > soc-camera subsytem.
> > the problem is that I need to reserve memory for my
> > buffers, but the
> > function DMA_ALLOC_COHERENT says error: ENOMEN. This
> > problem is in that I
> > haven't enough memory to my buffers, then I am thinking
> > that I can reserve
> > memory for this buffers in the __init of driver... but, how
> > can I do it?
> > In my aplication, I call to mmap(), this function reserve
> > memory for the
> > buffers and also calls soc_camera_mmap for to call at
> > dma_alloc_coherent.
> > How can I do for that the driver reserve memory and the
> > aplication knows
> > where is this memory? how can I resolver this problem?,
> > also I have thought
> > that I could reserve memory without call to soc-camera
> > subsytem in the mmap,
> > only in this function, is it possible? can someone help me?
> > thanks.
>
> Hi, I have no expertise writing kernel modules, but I offer
> this possible solution, anyway.
> What about a global variable for the buffer? Then the memory space
> would be allocated when the module is loaded.
>
> -Mike
>
>
>
>
>
>
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
