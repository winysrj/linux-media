Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx05.extmail.prod.ext.phx2.redhat.com
	[10.5.110.9])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o2NM5Lkr032464
	for <video4linux-list@redhat.com>; Tue, 23 Mar 2010 18:05:21 -0400
Received: from mail-gy0-f174.google.com (mail-gy0-f174.google.com
	[209.85.160.174])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o2NM5BtT013394
	for <video4linux-list@redhat.com>; Tue, 23 Mar 2010 18:05:11 -0400
Received: by gyg8 with SMTP id 8so4067484gyg.33
	for <video4linux-list@redhat.com>; Tue, 23 Mar 2010 15:05:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BA93119.2080301@pillar.it>
References: <4BA75D27.10807@pillar.it>
	<9c4b1d601003220735i5af4be8bo8dc64138bb359f9b@mail.gmail.com>
	<4BA7A993.2080008@pillar.it>
	<9c4b1d601003221135x461bae9w756b7c49c542b93d@mail.gmail.com>
	<4BA93119.2080301@pillar.it>
Date: Tue, 23 Mar 2010 19:05:10 -0300
Message-ID: <9c4b1d601003231505p7bcb0dfdic57ac6067246552e@mail.gmail.com>
Subject: Re: Set Frequency Problem
From: Adrian Pardini <pardo.bsso@gmail.com>
To: Sanfelici Claudio <sanfelici@pillar.it>
Cc: Linux and Kernel Video <video4linux-list@redhat.com>
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

On 23/03/2010, Sanfelici Claudio <sanfelici@pillar.it> wrote:
> Hi !
> I was writing the C code for you and... I've solved the problem.
> In the Video for Linux two Api Specification, in the VIDIOC_G/S_INPUT
> section you can read:
> "It is ggod pratice to select an input before querying or negotiating any
> other parameters."
>
> So, if I call VIODIOC_S_INPUT everytime before call the VIDIOC_S_FREQUENCY
> it works!
>
> Has it sense?
>

Not for me. (N.B i'm no expert in v4l). Looking at xawtv sources (file
libng/plugins/drv0-v4l2.c) it does the following:

---
static void
v4l2_setfreq(void *handle, unsigned long freq)
{
    struct v4l2_handle *h = handle;
    struct v4l2_frequency f;

    if (ng_debug)
        fprintf(stderr,"v4l2: freq: %.3f\n",(float)freq/16);
    memset(&f,0,sizeof(f));
    f.type = V4L2_TUNER_ANALOG_TV;
    f.frequency = freq;
    xioctl(h->fd, VIDIOC_S_FREQUENCY, &f, 0);
}
---

I think you are missing something or your driver is somehow broken,
but a lot of cheap (and not so) cards have an saa7130/7134 and work
fine.

> Thank you !

You are welcome just keep in mind that this list is deprecated, most
of the people is at linux-media@vger.kernel.org


> P.S. about my second question? the way to start video overlay?

i have no clue. The best advice I can give you is to grab the sources
of some app (xawvt is a good starting point) and see how it works.
Isn't free software wonderful?




-- 
Adrian.
http://elesquinazotango.com.ar
http://www.noalcodigodescioli.blogspot.com/

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
