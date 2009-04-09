Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:37943 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764658AbZDIKpu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Apr 2009 06:45:50 -0400
Date: Thu, 9 Apr 2009 07:45:34 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Tobi <listaccount@e-tobi.net>
Cc: linux-media@vger.kernel.org
Subject: Re: Userspace issue with DVB driver includes
Message-ID: <20090409074534.2cf32df0@pedra.chehab.org>
In-Reply-To: <49DDA100.1030205@e-tobi.net>
References: <49DDA100.1030205@e-tobi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 09 Apr 2009 09:17:20 +0200
Tobi <listaccount@e-tobi.net> wrote:

> Hello!
> 
> I think it was the change from asm/types.h to linux/types.h:
> 
> -#include <asm/types.h>
> +#include <linux/types.h>
> 
> ...which somehow broke the VDR build with recent DVB driver releases (see
> snippet A below).
> 
> The common workaround/solution to this seems to be to add a
> "-D__KERNEL_STRICT_NAMES".
> 
> But this feels wrong to me.
> 
> Reordering the includes and making sure <sys/*> is included before
> <linux/*> solves this issue too.
> 
> But ideally the include order shouldn't matter at all.
> 
> So my question is: How to deal with this? What's the recommended way for
> userspace applications to include linux/dvb headers?
> 
> Here's a small example, that fails to compile with 2.6.29:
> 
> // #include <sys/types.h>
> // #define __KERNEL_STRICT_NAMES
> 
> #include <linux/dvb/frontend.h>
> #include <linux/dvb/video.h>
> 
> int main()
> {
>     return 0;
> }
> 
> Two workarounds to this problem are to define __KERNEL_STRICT_NAMES or
> including <sys/*> before the linux/dvb includes.
> 
> Any comments, suggestions?

Hi Tobi,

I suspect that this were the upstream change that affected your work, right?
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b852d36b86902abb272b0f2dd7a56dd2d17ea88c

There are two changesets that will likely fix this issue:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=85efde6f4e0de9577256c5f0030088d3fd4347c1
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=9adfbfb611307060db54691bc7e6d53fdc12312b

Could you please try to apply they on 2.6.29 and see if those will solve the
issue? If so, then we should probably add those on 2.6.29.2. 

Anyway, in order to keep v4l-dvb aligned with upstream, I'll backport the above
changesets into the development tree.

> 
> Please see also:
> 
> http://www.linuxtv.org/pipermail/linux-dvb/2009-March/031934.html
> 
> bye,
> 
> Tobias
> 
> --- snippet A ---
> 
> In file included from /usr/include/netinet/in.h:24,
>                  from /usr/include/arpa/inet.h:23,
>                  from config.h:13,
>                  from channels.h:13,
>                  from device.h:13,
>                  from dvbdevice.h:15,
>                  from dvbdevice.c:10:
> /usr/include/stdint.h:41: error: conflicting declaration 'typedef long int
> int64_t'
> /usr/include/linux/types.h:98: error: 'int64_t' has a previous declaration
> as 'typedef __s64 int64_t'
> /usr/include/stdint.h:56: error: conflicting declaration 'typedef long
> unsigned int uint64_t'
> /usr/include/linux/types.h:96: error: 'uint64_t' has a previous
> declaration as 'typedef __u64 uint64_t'
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




Cheers,
Mauro
