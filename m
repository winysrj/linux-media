Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4442 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab3IILYC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Sep 2013 07:24:02 -0400
Message-ID: <522DAFC6.9020608@xs4all.nl>
Date: Mon, 09 Sep 2013 13:23:50 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: =?UTF-8?B?S3J6eXN6dG9mIEhhxYJhc2E=?= <khalasa@piap.pl>
CC: linux-media@vger.kernel.org, ismael.luceno@corp.bluecherry.net
Subject: Re: SOLO6x10 MPEG4/H.264 encoder driver
References: <m3d2oifezy.fsf@t19.piap.pl>
In-Reply-To: <m3d2oifezy.fsf@t19.piap.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Krzysztof,

I've CC-ed Ismael, the solo maintainer.

On 09/09/2013 12:47 PM, Krzysztof Hałasa wrote:
> Hi Hans,
> 
> I'm trying to move to Linux 3.11 and I noticed you've made some
> significant changes to the SOLO6x10 driver. While I don't yet have
> the big picture, I can see some regressions here:

The big picture behind all the changes is a push to get this driver out of
staging. It turned out that the driver in the kernel had diverged substantially
from the driver maintainer internally by bluecherry, and the work I did
merged those two forks as best as I could, cleaned up the code and ensured that
all the latest internal frameworks were used.

The only thing preventing the driver from being moved out of staging is the
motion detection functionality. I've been working on that, but it didn't
make 3.12.

> 
> - the driver doesn't even try to work on big endian systems (I'm using
>   IXP4xx-based system which is BE). For instance, you're now using
>   bitfields for frame headers (struct vop_header) and this is well known
>   to fail (unless you have a different struct for each endianness).
> 
>   This is actually what I have fixed with commit
>   c55564fdf793797dd2740a67c35a2cedc133c9ff in 2011, and you brought the
>   old buggy version back with dcae5dacbce518513abf7776cb450b7bd95d722b.

The problem was that the bluecherry driver had many changes as well in the
same area, and that I could not test it on a big endian system.

I hadn't realized the problems this would cause on big endian systems, if I
had I would have attempted to merge your changes.

> - you removed my dynamic building of MPEG4/H.264 VOP headers (the same
>   commit c55564fdf793797dd2740a67c35a2cedc133c9ff) and replaced it with
>   precomputed static binary headers, one for each PAL/NTSC/D1/CIF
>   combination. While I don't strictly object the precomputed data,
>   perhaps you could consider adding some tool to optionally calculate
>   them, as required by the license. For now, It seems it's practically
>   impossible to make modifications to the header data, without, for
>   example, extracting the code from older driver version.

I took the latest bluecherry code as the basis for the changes, merging what
I could from the kernel code. Unfortunately this was very hard to do backport,
so I decided to take bluecherry's code.

> - what was the motivation behind renaming all (C language) files in
>   drivers/staging/media/solo6x10 to solo6x10-* (commits
>   dad7fab933622ee67774a9219d5c18040d97a5e5 and
>   7bce33daeaca26a3ea3f6099fdfe4e11ea46cac6, essentially a reversion of
>   my commit ae69b22c6ca7d1d7fdccf0b664dafbc777099abe)? I'm under
>   impression that a driver file names don't need (and shouldn't) contain
>   the driver name if the directory is already named after the driver.

Two reasons: first of all this is the convention within drivers/media,
secondly the backwards compatibility build system that allows people to
compile the latest media code for older kernels requires unique filenames.

>   This is also the case with b3c7d453a00b7dadc2a7435f68b012371ccc3a3e:
> 
>   > [media] solo6x10: rename jpeg.h to solo6x10-jpeg.h
>   >
>   >  This header clashes with the jpeg.h in gspca when doing a compatibility
>   >  build using the media_build system.
> 
>   What is this media_build system and why is it forcing code in
>   different directories to have unique file names?

See http://git.linuxtv.org/media_build.git and here:
http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_Device_Drivers

> 
> 
> I appreciate the switch to VB2 and other improvements (though I can't
> test them yet), but perhaps it could be done without causing major
> breakage?

It's a staging driver, so by definition unstable. That said, I do apologize
for missing the big-endian problems.

> I'm thinking about a correct course of action now. I need the driver
> functional so I'll revert the struct vop_header thing again, any
> thoughts?

That sounds reasonable. Please post it to the mailinglist so it can be
reviewed by Ismael and I'd be happy to take it in.

Regards,

	Hans
