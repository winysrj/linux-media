Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34476 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbcEQV37 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 May 2016 17:29:59 -0400
Received: by mail-wm0-f67.google.com with SMTP id n129so8020720wmn.1
        for <linux-media@vger.kernel.org>; Tue, 17 May 2016 14:29:57 -0700 (PDT)
Date: Tue, 17 May 2016 23:29:56 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Emil Velikov <emil.l.velikov@gmail.com>
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Cc Ma <cc.ma@mediatek.com>,
	Pascal Brand <pascal.brand@linaro.org>,
	"Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
	ML dri-devel <dri-devel@lists.freedesktop.org>,
	Dan Caprita <dan.caprita@windriver.com>,
	Zoltan Kuscsik <zoltan.kuscsik@linaro.org>,
	Joakim Bech <joakim.bech@linaro.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH v7 1/3] create SMAF module
Message-ID: <20160517212956.GV27098@phenom.ffwll.local>
References: <1462806459-8124-1-git-send-email-benjamin.gaignard@linaro.org>
 <1462806459-8124-2-git-send-email-benjamin.gaignard@linaro.org>
 <CACvgo52cHhJ0XoibSXgu2eBg1sK51_nFqtA9CmWZwtCDYa7-WQ@mail.gmail.com>
 <CA+M3ks56F61k9NPs18eYTmvNkUGmeytLQRENHVgv1ZYUGtW9Gw@mail.gmail.com>
 <CACvgo508W=BxwMkkOP5EswnDqnjfcWmvX1cShbie1nF3-8brTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACvgo508W=BxwMkkOP5EswnDqnjfcWmvX1cShbie1nF3-8brTw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 17, 2016 at 08:04:59PM +0100, Emil Velikov wrote:
> On 17 May 2016 at 14:50, Benjamin Gaignard <benjamin.gaignard@linaro.org> wrote:
> > Hello Emil,
> >
> > thanks for your review.
> > I have understand most of your remarks and I'm fixing them
> > but some points aren't obvious for me...
> >
> Sure thing. Thanks for being honest.
> 
> >
> > No because a device could attach itself on the buffer and the
> > allocator will only
> > be selected at the first map_attach call.
> > The goal is to delay the allocation until all devices are attached to
> > select the best allocator.
> >
> I see. Makes sense.
> 
> 
> >>> +static long smaf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> >>> +{
> >>> +       switch (cmd) {
> >>> +       case SMAF_IOC_CREATE:
> >>> +       {
> >>> +               struct smaf_create_data data;
> >>> +               struct smaf_handle *handle;
> >>> +
> >>> +               if (copy_from_user(&data, (void __user *)arg, _IOC_SIZE(cmd)))
> >>> +                       return -EFAULT;
> >>> +
> >>> +               handle = smaf_create_handle(data.length, data.flags);
> >> We want to sanitise the input data.{length,flags} before sending it
> >> deeper in the kernel.
> >
> > Sorry but can you elaborate little more here ?
> > I don't understand your expectations.
> >
> You want to determine which flags are 'considered useful' at this
> stage, and reject anything else. As-is you inject any flags that the
> user gives you directly into the 'guts' of the kernel. This is not
> good from security and future expandability POV.
> 
> About the length you want a similar thing. size_t is unsigned (great),
> although ideally you'll want to check/determine if one cannot exploit
> it, integer overflow being the more common suspect. This may be quite
> hard to track, so I'd stick with the flags checking at least.
> 
> 
> > It is useless the add this function in this .h file I will remove it
> > and fix the comment in structure defintion
> 
> I've seen both approaches - description next to the declaration or
> definition. I'd rather not pick sides, as people might throw rotten
> fruit at me ;-)
> 
> 
> >>> +/**
> >>> + * struct smaf_create_data - allocation parameters
> >>> + * @length:    size of the allocation
> >>> + * @flags:     flags passed to allocator
> >>> + * @name:      name of the allocator to be selected, could be NULL
> Just occurred to - you might want to comment what the user should
> expect if NULL. Any at random one will be used or otherwise. Very
> quick description on the heuristics used might be good as well.
> 
> >> Is it guaranteed to be null terminated ? If so one should mentioned it
> >> otherwise your userspace should be fixed.
> >> Same comments apply for smaf_info::name.
> >
> > I have used strncpy everywhere to avoid this problem but maybe it is not enough
> >
> According to the man page
> 
> "The strncpy() function is similar, except that at most n bytes of src
> are copied.  Warning: If there is no null byte among the first n bytes
> of src, the string placed in dest will _not_ be null-terminated."
> 
> Annotation is mine obviously. I believe that after the strncpy 'name'
> is/was assumed (used as) a NULL terminated string.
> 
> >>
> >>
> >>> + * @fd:                returned file descriptor
> >>> + */
> >>> +struct smaf_create_data {
> >>> +       size_t length;
> >>> +       unsigned int flags;
> >>> +       char name[ALLOCATOR_NAME_LENGTH];
> >>> +       int fd;
> >> The structs here feels quite fragile. Please read up on Daniel
> >> Vetter's "Botching up ioctls" [1]. Personally I find pahole quite
> >> useful is such process.
> >>
> > if I describe the structures like this:
> > /**
> >  * struct smaf_create_data - allocation parameters
> >  * @length: size of the allocation
> >  * @flags: flags passed to allocator
> >  * @name_len: length of name
> >  * @name: name of the allocator to be selected, could be NULL
> >  * @fd: returned file descriptor
> >  */
> > struct smaf_create_data {
> > size_t length;
> > unsigned int flags;
> > size_t name_len;
> > char __user *name;
> > int fd;
> > char padding[44];
> > };
> >
> > does it sound more robust for you ?
> >
> Seems like you changed 'name' from fixed size array to char *. Which
> actually gets us slightly further away from robust.
> 
> As Daniel said, please read through the hole file.
> 
> Here is a (slightly incomplete) gist of it all:
> - you want to to use __[us]{8,16,32,64} and __kernel_size_t types everywhere

Please don't use __kernel_size_t, it's only for backwards compat if you
already botched an ioctl definition ;-)

Also I recomened you only use 32/64bit sized types, otherwise aligning
stuff gets more complicated. Maybe u8 for strings.

Also you must align everything to its own size explicitly by adding
padding fields. And if you have a 64 bit value anywhere, you must align
the entire struct to 64bits too, otherwise just align to 32bits.

This is a bit more than what's required, but it's much harder to screw up
that way.
-Daniel

> - each member of the struct must be the same offset for both 32bit and
> 64bit builds. ^^ helps with that
> - double check for gaps in the struct - I think you have a few
> - each struct should have it's old 'flags' which you'll use to
> indicate the capability of the ioctl and thus the size of struct used.
> i.e. it's for future use.
> 
> Obviously the other two structs need similar polish.
> 
> Here is how you can check things with pahole:
>  - Create a simple C file that includes the header and has an instance
> of each struct - it doesn't have to be use any of them.
>  - Compile for 32 and 64 bit with -g -O0. Compare the struct layout -
> it should be identical in both cases.
> 
> Hope that makes things a bit clearer.
> 
> Emil
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
