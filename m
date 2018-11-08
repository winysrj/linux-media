Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:54661 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726182AbeKIGu6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Nov 2018 01:50:58 -0500
Date: Thu, 8 Nov 2018 22:13:38 +0100
From: Peter Seiderer <ps.report@gmx.net>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v4l-utils] Add missing linux/bpf_common.h
Message-ID: <20181108221338.7e91416d@gmx.net>
In-Reply-To: <20181107120544.zxfbbgibp5ubexn7@gofer.mess.org>
References: <20181105203047.15258-1-ps.report@gmx.net>
        <20181106103856.66uhadykgsw2dqs3@gofer.mess.org>
        <20181106224358.2a1ea449@gmx.net>
        <20181107120544.zxfbbgibp5ubexn7@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Sean,

On Wed, 7 Nov 2018 12:05:45 +0000, Sean Young <sean@mess.org> wrote:

> Hi Peter,
> 
> On Tue, Nov 06, 2018 at 10:43:58PM +0100, Peter Seiderer wrote:
> > On Tue, 6 Nov 2018 10:38:56 +0000, Sean Young <sean@mess.org> wrote:
> >   
> > > On Mon, Nov 05, 2018 at 09:30:47PM +0100, Peter Seiderer wrote:  
> > > > Copy from [1], needed by bpf.h.
> > > >
> > > > [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/include/uapi/linux/bpf_common.h?h=v4.19  
> > >
> > > So bpf.h does include this file, but we don't use anything from it in
> > > v4l-utils.
> > >  
> > 
> > Maybe alternative fix is to remove the include (or not if your want
> > the headers to be in sync with the kernel ones, but then they should
> > be complete enough to be used for compile)?
> >   
> > > This include file is for the original BPF, which has been around for a
> > > long time. So why is this include file missing, i.e. what problem are you
> > > trying to solve?  
> > 
> > A buildroot autobuild failure (see [1] for details) with older toolchains
> > not providing this header...
> >   
> > >
> > > Lastely, the file should be included in the sync-with-kernel target so
> > > it does not get out of sync -- should it really be necessary to add the
> > > file.  
> > 
> > O.k, can do it on next patch iteration...
> > 
> > Regards,
> > Peter
> > 
> > [1] http://lists.busybox.net/pipermail/buildroot/2018-November/234840.html  
> 
> So here libelf was not detected, hence ir-keytable should have been built
> without BPF support, but it is still including bpf.h despite it not
> being used.
> 
> I've just sent a patch for better support for building without BPF,
> see here:
> 	https://patchwork.linuxtv.org/patch/52841/
> 
> 
> Would you mind seeing if that works for you?

Thanks, works for the buildroot use case (disabling
bpf support unconditionally)...

The reason to provide copies of the linux kernel headers in  v4l-utils
is to be independent of old(-er) headers provided by toolchains?

If so a copy of bpf_common.h is still needed (and the fallback, for
out of linux kernel usage, define for __NR_bpf in bpf.h enhanced for
all supported archs)?

Regards,
Peter

> 
> 
> Thanks,
> 
> Sean
