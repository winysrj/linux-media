Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m7D5w7Bu004310
	for <video4linux-list@redhat.com>; Wed, 13 Aug 2008 01:58:07 -0400
Received: from smtp-vbr9.xs4all.nl (smtp-vbr9.xs4all.nl [194.109.24.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m7D5vr12025397
	for <video4linux-list@redhat.com>; Wed, 13 Aug 2008 01:57:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Cody Pisto" <cpisto@gmail.com>
Date: Wed, 13 Aug 2008 07:57:51 +0200
References: <191a06830808120940n7acb2beey926d2a11ca9cebba@mail.gmail.com>
	<200808121925.11275.hverkuil@xs4all.nl>
	<191a06830808121929h716cb1c6i765b05b05768d66d@mail.gmail.com>
In-Reply-To: <191a06830808121929h716cb1c6i765b05b05768d66d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808130757.51249.hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com
Subject: Re: compat_ioctl32.c
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

On Wednesday 13 August 2008 04:29:12 Cody Pisto wrote:
> On Tue, Aug 12, 2008 at 11:25 AM, Hans Verkuil <hverkuil@xs4all.nl> 
wrote:
> > On Tuesday 12 August 2008 18:40:45 Cody Pisto wrote:
> >> Hi,
> >>
> >> I'm attempting to add support for 3 ioctls to compat_ioctl32.c so
> >> that the 32 bit version of SageTV works properly on 64 bit
> >> kernels.
> >>
> >> The 3 ioctls are:
> >>
> >> VIDIOC_ENCODER_CMD
> >> VIDIOC_S_AUDIO
> >> VIDIOC_S_EXT_CTRLS
> >>
> >> I *think* I have successfully added VIDIOC_ENCODER_CMD and
> >> VIDIOC_S_AUDIO by simply adding them to the big switch statement
> >> in v4l_compat_ioctl32() because the structures they pass as
> >> arguments don't contain any pointers or otherwise non 32bit types.
> >> (struct v4l2_encoder_cmd and struct v4l2_audio respectively)
> >>
> >> However VIDIOC_S_EXT_CTRLS doesn't look to be so simple. The
> >> structure it passes (struct v4l2_ext_controls) contains a pointer
> >> to another structure (struct v4l2_ext_control) that contains an
> >> __s64 and another pointer (void *). So after trying to wrap my
> >> head around whats going on in compat_ioctl32.c, it looks like I
> >> will need to define both a struct v4l2_ext_controls32 and struct
> >> v4l2_ext_control32, and also VIDIOC_S_EXT_CTRLS32. My question is,
> >> do I need to implement some kind of get/put_ext_controls32
> >
> > Yes.
> >
> >> and/or
> >> get/put_ext_control32
> >
> > Perhaps, see below.
> >
> >> like many of the existing compatible ioctls
> >> have, or should things just work with the native_ioctl() ? Any
> >> pointers on how to implement those get/put functions if needed
> >> would be greatly appreciated.
> >>
> >> Im guessing the structures should look like this:
> >>
> >> struct v4l2_ext_control32 {
> >>         __u32 id;
> >>         __u32 reserved2[2];
> >>         union {
> >>                 __s32 value;
> >> #ifndef CONFIG_X86_64
> >
> > ^^^^^^^^^^
> >
> > Why this? __s64 is perfectly acceptable on any architecture, also
> > 32 bit.
> >
> >>                 __s64 value64;
> >> #endif
> >>                 compat_caddr_t reserved; /* actually void * */
> >>         };
> >> } __attribute__ ((packed));
> >>
> >> struct v4l2_ext_controls32 {
> >>         __u32 ctrl_class;
> >>         __u32 count;
> >>         __u32 error_idx;
> >>         __u32 reserved[2];
> >>         compat_caddr_t controls; /* actually struct
> >> v4l2_ext_control32 * */ };
> >>
> >> And I figure I will have to implement something like the while
> >> loop in get_v4l2_window32 that iterates over the controls and
> >> copy_in_user()'s them?
> >
> > The v4l2_ext_controls definitely needs a put/get function. And I
> > also think you need a loop like in get_v4l2_window32. The void * in
> > v4l2_ext_control is luckily unused at the moment and you should
> > ignore it. If that pointer is ever used in the future, then that
> > will be very difficult to implement in compat_ioctl32.c. In any
> > case, you do not need a v4l2_ext_control32 here, since it's all
> > fixed size (except for the pointer, but that's unused).
>
> OK, after much trial and error and testing, I ended up with this,
> that works well for the 32 bit binaries I needed to get working:
>
> struct v4l2_ext_controls32 {
>        __u32 ctrl_class;
>        __u32 count;
>        __u32 error_idx;
>        __u32 reserved[2];
>        compat_caddr_t controls; /* actually struct v4l2_ext_control32
> * */ };
>
> static int get_v4l2_ext_controls32(struct v4l2_ext_controls *kp,
> struct v4l2_ext_controls32 __user *up)
> {
>         if (!access_ok(VERIFY_READ, up, sizeof(struct
> v4l2_ext_controls32)) || get_user(kp->ctrl_class, &up->ctrl_class) ||
> get_user(kp->count, &up->count) ||
>                 get_user(kp->error_idx, &up->error_idx) ||
>                 copy_from_user(kp->reserved, up->reserved, 2 *
> sizeof(__u32))) return -EFAULT;
>         if (kp->count) {
>                 struct v4l2_ext_control __user *ucontrols;
>                 struct v4l2_ext_control __user *kcontrols;
>                 int n = kp->count;
>                 compat_caddr_t p;
>
>                 if (get_user(p, &up->controls))
>                         return -EFAULT;
>                 ucontrols = compat_ptr(p);
>                 kcontrols = compat_alloc_user_space(n * sizeof(struct
> v4l2_ext_control));
>                 kp->controls = kcontrols;
>                 while (--n >= 0) {
>                         if (copy_in_user(&kcontrols->id,
> &ucontrols->id, sizeof(__u32)))
>                                 return -EFAULT;
>                         if (copy_in_user(&kcontrols->reserved2,
> &ucontrols->reserved2, 2 * sizeof(__u32)))
>                                 return -EFAULT;
>                         if (copy_in_user(&kcontrols->value,
> &ucontrols->value, sizeof(ucontrols->value)))
>                                 return -EFAULT;
>                         ucontrols++;
>                         kcontrols++;
>                 }
>         } else {
>                 kp->controls = NULL;
>         }
>         return 0;
> }
>
> static int put_v4l2_ext_controls32(struct v4l2_ext_controls *kp,
> struct v4l2_ext_controls32 __user *up)
> {
>         if (!access_ok(VERIFY_WRITE, up, sizeof(struct
> v4l2_ext_controls32)) || put_user(kp->ctrl_class, &up->ctrl_class) ||
> put_user(kp->count, &up->count) ||
>                 put_user(kp->error_idx, &up->error_idx) ||
>                 copy_to_user(up->reserved, kp->reserved, 2 *
> sizeof(__u32))) return -EFAULT;
>         return 0;
> }
>
> I have a complete patch that enables this bit of code to work, how
> should I initiate the process of getting it into the mainline
> video4linux source?

You can post it to this mailinglist, just make sure you add a 
Signed-off-by line. 
(http://www.linuxtv.org/v4lwiki/index.php/How_to_submit_patches)

I'll review it. One obvious thing that I will look at is if you also 
added support for VIDIOC_G_AUDIO, VIDIOC_TRY_ENCODER_CMD, 
VIDIOC_G_EXT_CTRLS and VIDIOC_TRY_EXT_CTRLS. Then it is a complete set 
of ioctls that are added.

Thanks for working on this! Much appreciated!

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
