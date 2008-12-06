Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mB6DfN25019100
	for <video4linux-list@redhat.com>; Sat, 6 Dec 2008 08:41:23 -0500
Received: from smtp-vbr6.xs4all.nl (smtp-vbr6.xs4all.nl [194.109.24.26])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mB6De8NZ029478
	for <video4linux-list@redhat.com>; Sat, 6 Dec 2008 08:40:08 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Sat, 6 Dec 2008 14:40:03 +0100
References: <200812061123.46313.hverkuil@xs4all.nl>
	<20081206110335.494a2ee3@pedra.chehab.org>
In-Reply-To: <20081206110335.494a2ee3@pedra.chehab.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812061440.03846.hverkuil@xs4all.nl>
Cc: v4l <video4linux-list@redhat.com>
Subject: Re: v4l2-compat-ioctl32.c weirdness
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

On Saturday 06 December 2008 14:03:35 Mauro Carvalho Chehab wrote:
> Hi Hans,
>
> On Sat, 6 Dec 2008 11:23:46 +0100
>
> Hans Verkuil <hverkuil@xs4all.nl> wrote:
> > Hi Mauro,
> >
> > Can you take a look at v4l2-compat-ioctl32.c, do_video_ioctl()?
>
> The compat32 code has several issues. Part of the code were generated
> by some guys with non x86 architectures, like sparc64 (all userspace
> is 32 bits - 64 bits is only in kernel), ia64 and ppc.
>
> > This code can't be right:
> >
> >         case VIDIOC_S_INPUT:
> >         case VIDIOC_OVERLAY:
> >         case VIDIOC_STREAMON:
> >         case VIDIOC_STREAMOFF:
> >                 err = get_user(karg.vx, (u32 __user *)up);
> >                 compatible_arg = 1;
> >                 break;
>
> This is there since the beginning. I never tried to take a look on
> it, but the code looks ok on my eyes.

If compatible_arg == 1 then the karg union is never used. The code 
doesn't make any sense that I can see.

> This code is very complex and it is not obvious to determine what it
> is doing.
>
> If you take a look on S_INPUT definition, you'll see:
>
> #define VIDIOC_S_INPUT          _IOWR('V', 39, int)
>
> the _IOWR macro uses the third argument to evaluate it to something
> like: some_magic_number + sizeof(int)
>
> On 32 bit systems, "int" is evaluated as "s32", while, on 64 bits,
> this become "s64".

No. Type int remains 32 bits on all archs that I am aware of. 
Type 'long' becomes 64 bit on 64-bit architectures.

> So, the same ioctl is evaluated to different magic numbers if you are
> using 32 or 64 bits versions.
>
> For sure, the module needs to do some compat stuff for this.
>
> It should be pointed also this piece of code:
>
>         case VIDIOC_S_INPUT32: realcmd = cmd = VIDIOC_S_INPUT; break;
>
> Where a 32 bits magic number is converted into a 64 bits one.

I'm pretty sure that VIDIOC_S_INPUT32 == VIDIOC_S_INPUT. That's 
definitely the case for intel 32 and 64 bit archs (just tested it).

> > In addition, karg.vx is an unsigned long, which does not match the
> > 'int' I think it should be.
>
> No, it shouldn't. Userspace do something like:
>
> 	r = ioctl (fd, request, arg);
>
> The "arg" is defined as "unsigned long". I'm not sure if the size of
> "unsigned long" is the same on userspace and kernelspace on all
> supported architectures.

No, long is different depending on the archs. But it is not an issue 
what arg is, it is what arg points to. And that's an int which is 
always AFAIK 32 bits. And even if it differs, then karg.vx should still 
be an int so it has the size that is native to the architecture.

> > Either compatible_arg should be 0, or these cases can be removed
> > since they are handled in a standard manner.
>
> compatible_arg is related to pointer handling, since you need to
> change the register data segment on 32 bit calls. In this case,
> you're not passing a pointer, so, you don't need to enable DS special
> handling.

It's an 'int *'. So yes, I'm passing a pointer. Personally I think that 
any ioctl that passes an 'int *' needs no special handling.

> > I also do not understand why there is special handling for
> > ENUMINPUT and ENUMSTD.
>
> Take a look on this:
>
> struct v4l2_input {
>         __u32        index;             /*  Which input */
>         __u8         name[32];          /*  Label */
>         __u32        type;              /*  Type of input */
>         __u32        audioset;          /*  Associated audios
> (bitfield) */ __u32        tuner;             /*  Associated tuner */
> v4l2_std_id  std;
>         __u32        status;
>         __u32        reserved[4];
> };
>
> If I'm calculating right, the struct size should be 74 on 32 bits.
> However, 74 is not multiple of 64 bits. An extra padding of 4 bytes
> is added by the compiler, since the struct is not packed.

Yuck. That definitely needs a comment.

> The compat code should just copy each field.
>
> I didn't check ENUMSTD but probably you have some padding there also.
>
> > And this looks extremely weird:
> >
> > static inline int get_v4l2_input32(struct v4l2_input *kp, struct
> > v4l2_input __user *up)
> > {
> >         if (copy_from_user(kp, up, sizeof(struct v4l2_input) - 4))
> >                 return -EFAULT;
> >         return 0;
> > }
> >
> > No comments to enlighten the reader of what's going on here.
>
> Ah, the extra 4 padding bytes ;)
>
> To better document it, I would do, instead, something like:
>
> struct v4l2_input_32 {
>         __u32        index;             /*  Which input */
>         __u8         name[32];          /*  Label */
>         __u32        type;              /*  Type of input */
>         __u32        audioset;          /*  Associated audios
> (bitfield) */ __u32        tuner;             /*  Associated tuner */
> v4l2_std_id  std;
>         __u32        status;
>         __u32        reserved[4];
> }  __attribute__ ((packed));
>
> copy_from_user(kp, up, sizeof(struct v4l2_input_32))

That would be better.

But all this still doesn't explain why we handle VIDIOC_ENUMINPUT. We 
should never see this, only VIDIOC_ENUMINPUT32. And if we get 
VIDIOC_ENUMINPUT, then we can just handle it natively since there is 
nothing to convert.

Is this just buggy code, or is there some hidden reason for it?

Regards,

	Hans

> > I'm trying to add the missing ioctls to this source, but I first
> > like to understand what is going on in the first place.
>
> True.
>
> Cheers,
> Mauro



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
