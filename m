Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:53481
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751787AbdFGSXp (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Jun 2017 14:23:45 -0400
Date: Wed, 7 Jun 2017 15:23:38 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Matthias Schwarzott <zzam@gentoo.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: Unknown symbol put_vaddr_frames when using media_build
Message-ID: <20170607152338.5fd9d304@vento.lan>
In-Reply-To: <6ea4c402-9523-2345-9dd3-0fb041f07f27@gentoo.org>
References: <6ea4c402-9523-2345-9dd3-0fb041f07f27@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 9 May 2017 06:56:25 +0200
Matthias Schwarzott <zzam@gentoo.org> escreveu:

> Hi!
> 
> Whenever I compile the media drivers using media_build against a recent
> kernel, I get this message when loading them:
> 
> [    5.848537] media: Linux media interface: v0.10
> [    5.881440] Linux video capture interface: v2.00
> [    5.881441] WARNING: You are using an experimental version of the
> media stack.
> ...
> [    6.166390] videobuf2_memops: Unknown symbol put_vaddr_frames (err 0)
> [    6.166394] videobuf2_memops: Unknown symbol get_vaddr_frames (err 0)
> [    6.166396] videobuf2_memops: Unknown symbol frame_vector_destroy (err 0)
> [    6.166398] videobuf2_memops: Unknown symbol frame_vector_create (err 0)
> 
> That means I am not able to load any drivers being based on
> videobuf2_memops without manual actions.
> 
> I used kernel 4.11.0, but it does not matter which kernel version
> exactly is used.
> 
> My solution for that has been to modify mm/Kconfig of my kernel like
> this and then enable FRAME_VECTOR in .config

Well, if you build your Kernel with VB2 compiled, you'll have it.

> diff --git a/mm/Kconfig b/mm/Kconfig
> index 9b8fccb969dc..cfa6a80d1a0a 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -701,7 +701,7 @@ config ZONE_DEVICE
>           If FS_DAX is enabled, then say Y.
> 
>  config FRAME_VECTOR
> -       bool
> +       tristate "frame vector"
> 
>  config ARCH_USES_HIGH_VMA_FLAGS
>         bool
> 
> But I do not like that solution.
> I would prefer one of these solutions:
> 
> 1. Have media_build apply its fallback the same way as for older kernels
> that do not even have the the FRAME_VECTOR support.
> 
> 2. Get the above patch merged (plus description etc.).
> 
> What do you think?

(1) is probably simpler, but you would need to play with the building
system in order to identify if the current Kernel has it enabled or not.
That could be tricky.

I suspect people won't accept (2), as it doesn't make sense upstream.
> 
> Regards
> Matthias



Thanks,
Mauro
