Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:43177 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728267AbeKJHFE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Nov 2018 02:05:04 -0500
Date: Fri, 9 Nov 2018 22:22:40 +0100
From: Peter Seiderer <ps.report@gmx.net>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v4l-utils] Add missing linux/bpf_common.h
Message-ID: <20181109222240.74c3bc22@gmx.net>
In-Reply-To: <20181109121038.al23ts654c6vwwbl@gofer.mess.org>
References: <20181105203047.15258-1-ps.report@gmx.net>
        <20181106103856.66uhadykgsw2dqs3@gofer.mess.org>
        <20181106224358.2a1ea449@gmx.net>
        <20181107120544.zxfbbgibp5ubexn7@gofer.mess.org>
        <20181108221338.7e91416d@gmx.net>
        <20181109121038.al23ts654c6vwwbl@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Sean,

On Fri, 9 Nov 2018 12:10:38 +0000, Sean Young <sean@mess.org> wrote:

> Hi Peter,
> 
> On Thu, Nov 08, 2018 at 10:13:38PM +0100, Peter Seiderer wrote:
> > Thanks, works for the buildroot use case (disabling
> > bpf support unconditionally)...
> > 
> > The reason to provide copies of the linux kernel headers in  v4l-utils
> > is to be independent of old(-er) headers provided by toolchains?
> > 
> > If so a copy of bpf_common.h is still needed (and the fallback, for
> > out of linux kernel usage, define for __NR_bpf in bpf.h enhanced for
> > all supported archs)?  
> 
> I have seen this problem on debian 7. Why do we care about compiling
> on something that ancient?

It is not about compiling on what system, it is about which toolchain 
is used (for cross-compile), and the initial failure comes from
the buildroot [1] embedded system autobuild tests...

Personally I do not care about these toolchains (but the buildroot
people think it is worth to do automatic build tests with them) and
can live with the disabling of the bpf support....

Regards,
Peter
 
[1] https://buildroot.org/

> 
> 
> Sean
