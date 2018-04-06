Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:51915 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755698AbeDFOsK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 6 Apr 2018 10:48:10 -0400
Date: Fri, 6 Apr 2018 11:47:58 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Geliang Tang <geliangtang@gmail.com>
Subject: Re: [PATCH 05/16] media: fsl-viu: allow building it with
 COMPILE_TEST
Message-ID: <20180406114758.7d765ebe@vento.lan>
In-Reply-To: <CAK8P3a2hehE7iPwF_ps8LYk+zRUmdm+1Oqci7PazQnE_HfmkyA@mail.gmail.com>
References: <cover.1522949748.git.mchehab@s-opensource.com>
        <24a526280e4eb319147908ccab786e2ebc8f8076.1522949748.git.mchehab@s-opensource.com>
        <CAK8P3a1a7r1FNhpRHJfyzRNHgNHOzcK1wkerYb+BR_RjWNkOUQ@mail.gmail.com>
        <20180406064718.2cdb69ea@vento.lan>
        <CAK8P3a2FQapAqxOMJNe9oBs8kBXsd7TCdsNon5Gvab3Y8LLKSA@mail.gmail.com>
        <20180406111537.04375bdf@vento.lan>
        <CAK8P3a1aO99P7RWErJRS22QQdJ6wJNgZptHOaTFx7_2NvQ1vvA@mail.gmail.com>
        <20180406112640.1441ca9f@vento.lan>
        <CAK8P3a2hehE7iPwF_ps8LYk+zRUmdm+1Oqci7PazQnE_HfmkyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 6 Apr 2018 16:37:15 +0200
Arnd Bergmann <arnd@arndb.de> escreveu:

> On Fri, Apr 6, 2018 at 4:26 PM, Mauro Carvalho Chehab
> <mchehab@s-opensource.com> wrote:
> > Em Fri, 6 Apr 2018 16:16:46 +0200
> > Arnd Bergmann <arnd@arndb.de> escreveu:
> >  
> >> On Fri, Apr 6, 2018 at 4:15 PM, Mauro Carvalho Chehab
> >> <mchehab@s-opensource.com> wrote:  
> >> > Em Fri, 6 Apr 2018 11:51:16 +0200
> >> > Arnd Bergmann <arnd@arndb.de> escreveu:
> >> >  
> >> >> On Fri, Apr 6, 2018 at 11:47 AM, Mauro Carvalho Chehab
> >> >> <mchehab@s-opensource.com> wrote:
> >> >>  
> >> >> > [PATCH] media: fsl-viu: allow building it with COMPILE_TEST
> >> >> >
> >> >> > There aren't many things that would be needed to allow it
> >> >> > to build with compile test.
> >> >> >
> >> >> > Add the needed bits.
> >> >> >
> >> >> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>  
> >> >>
> >> >> Reviewed-by: Arnd Bergmann <arnd@arndb.de>  
> >> >
> >> > Actually, in order to avoid warnings with smatch, the COMPILE_TEST
> >> > macros should be declared as:
> >> >
> >> > +#define out_be32(v, a) iowrite32be(a, (void __iomem *)v)
> >> > +#define in_be32(a)     ioread32be((void __iomem *)a)  
> >>
> >> I would just add the correct annotations, I think they've always been missing.
> >> 2 patches coming in a few minutes.  
> >
> > I corrected the annotations too. Now, it gives the same results
> > building for both arm and x86.
> >
> > If you want to double check, the full tree is at:
> >
> >         https://git.linuxtv.org/mchehab/experimental.git/log/?h=compile_test  
> 
> The __iomem annotations look good, my other patch is still needed to
> get a clean build with "make C=1" but doesn't apply cleanly on top of your
> version. I assume you'll just fix it up accordingly.

Heh, another duplicated patch:

	https://git.linuxtv.org/mchehab/experimental.git/commit/?h=compile_test&id=687520dc31a88c82c694492423c5d9c503cbdebb

That's why it didn't apply cleanly:

$ patch -p1 -i /tmp/media\:\ platform\:\ fsl-viu\:\ mark\ local\ functions\ \'static\'.patch --merge
patching file drivers/media/platform/fsl-viu.c
Hunk #1 already applied at 238.
Hunk #2 already applied at 251.
Hunk #3 already applied at 262.
Hunk #4 already applied at 806.
Hunk #5 already applied at 817.
Hunk #6 already applied at 1305.

Great minds think alike :-)

Thanks,
Mauro
