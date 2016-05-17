Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35805 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbcEQPkE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 May 2016 11:40:04 -0400
Received: by mail-wm0-f68.google.com with SMTP id e201so5693257wme.2
        for <linux-media@vger.kernel.org>; Tue, 17 May 2016 08:40:04 -0700 (PDT)
Date: Tue, 17 May 2016 17:40:03 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: Emil Velikov <emil.l.velikov@gmail.com>,
	Cc Ma <cc.ma@mediatek.com>,
	Pascal Brand <pascal.brand@linaro.org>,
	"Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
	ML dri-devel <dri-devel@lists.freedesktop.org>,
	Dan Caprita <dan.caprita@windriver.com>,
	Zoltan Kuscsik <zoltan.kuscsik@linaro.org>,
	Joakim Bech <joakim.bech@linaro.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH v7 1/3] create SMAF module
Message-ID: <20160517154002.GS27098@phenom.ffwll.local>
References: <1462806459-8124-1-git-send-email-benjamin.gaignard@linaro.org>
 <1462806459-8124-2-git-send-email-benjamin.gaignard@linaro.org>
 <CACvgo52cHhJ0XoibSXgu2eBg1sK51_nFqtA9CmWZwtCDYa7-WQ@mail.gmail.com>
 <CA+M3ks56F61k9NPs18eYTmvNkUGmeytLQRENHVgv1ZYUGtW9Gw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+M3ks56F61k9NPs18eYTmvNkUGmeytLQRENHVgv1ZYUGtW9Gw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 17, 2016 at 03:50:41PM +0200, Benjamin Gaignard wrote:
> 2016-05-17 0:58 GMT+02:00 Emil Velikov <emil.l.velikov@gmail.com>:
> > On 9 May 2016 at 16:07, Benjamin Gaignard <benjamin.gaignard@linaro.org> wrote:
> >> + * @fd:                returned file descriptor
> >> + */
> >> +struct smaf_create_data {
> >> +       size_t length;
> >> +       unsigned int flags;
> >> +       char name[ALLOCATOR_NAME_LENGTH];
> >> +       int fd;
> > The structs here feels quite fragile. Please read up on Daniel
> > Vetter's "Botching up ioctls" [1]. Personally I find pahole quite
> > useful is such process.
> >
> if I describe the structures like this:
> /**
>  * struct smaf_create_data - allocation parameters
>  * @length: size of the allocation
>  * @flags: flags passed to allocator
>  * @name_len: length of name
>  * @name: name of the allocator to be selected, could be NULL
>  * @fd: returned file descriptor
>  */
> struct smaf_create_data {
> size_t length;
> unsigned int flags;
> size_t name_len;
> char __user *name;
> int fd;
> char padding[44];
> };
> 
> does it sound more robust for you ?
> 
> > Hopefully I haven't lost the plot with the above, if I had don't be
> > shy to point out.
> >
> > Thanks,
> > Emil
> >
> > [1] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/ioctl/botching-up-ioctls.txt

Please read this doc in it's entirety, ask on irc if you don't get certain
parts. Then come back an rework your patch.

Super short summary: _All_ the types you've used are absolute no-go in
ioctl structs.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch
