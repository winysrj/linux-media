Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2509 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbaEFSbT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 May 2014 14:31:19 -0400
Message-ID: <53692A6E.3040807@xs4all.nl>
Date: Tue, 06 May 2014 20:31:10 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Ren=E9?= <poisson.rene@neuf.fr>,
	Video 4 Linux <linux-media@vger.kernel.org>
Subject: Re: Media build failure, missing module
References: <48E23AB5DEA342678DA681A91751703E@ci5fish>
In-Reply-To: <48E23AB5DEA342678DA681A91751703E@ci5fish>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/06/2014 08:10 PM, René wrote:
> Hi there,
> 
> On a newly install OpenMandriva distribution I tried to build the last 
> version of the media tree.
> However the build failed with the following sequence of messages.

The archive ./build downloads is missing a file for some reason. It may be
a few days before it is fixed since the maintainer of that file is attending
a conference. I've told Mauro that it is broken.

In the meantime this should work, although it will be slow since it has to clone
the git tree:

./build --main-git

Regards,

	Hans

> 
> ...
> patch -s -f -N -p1 -i ../backports/pr_fmt.patch
> The text leading up to this was:
> --------------------------
> |diff --git a/drivers/media/usb/gspca/dtcs033.c 
> b/drivers/media/usb/gspca/dtcs033.c
> |index 5e42c71..ba01a3e 100644
> |--- a/drivers/media/usb/gspca/dtcs033.c
> |+++ b/drivers/media/usb/gspca/dtcs033.c
> --------------------------
> No file to patch.  Skipping patch.
> 1 out of 1 hunk ignored
> make[2]: *** [apply_patches] Error 1
> make[2]: Leaving directory `/home/software/media_build/linux'
> make[1]: *** [allyesconfig] Error 2
> make[1]: Leaving directory `/home/software/media_build/v4l'
> make: *** [allyesconfig] Error 2
> can't select all drivers at ./build line 490.
> 
> The reason being the dtcs033 source code is absent in the tree:
> # ls linux/drivers/media/usb/gspca
> autogain_functions.c  finepix.c  jl2005bcd.c  m5602/      ov519.c 
> pac7311.c     sn9c2028.h  spca500.c  spca561.c  stk1135.c  t613.c 
> w996Xcf.c
> benq.c                gl860/     jpeg.h       Makefile    ov534_9.c 
> pac_common.h  sn9c20x.c   spca501.c  sq905.c    stk1135.h  topro.c 
> xirlink_cit.c
> conex.c               gspca.c    Kconfig      mars.c      ov534.c    se401.c 
> sonixb.c    spca505.c  sq905c.c   stv0680.c  tv8532.c  zc3xx.c
> cpia1.c               gspca.h    kinect.c     mr97310a.c  pac207.c   se401.h 
> sonixj.c    spca506.c  sq930x.c   stv06xx/   vc032x.c  zc3xx-reg.h
> etoms.c               jeilinj.c  konica.c     nw80x.c     pac7302.c 
> sn9c2028.c    spca1528.c  spca508.c  stk014.c   sunplus.c  vicam.c
> 
> Removing dtcs033 patch from backports/pr_fmt.patch (last one) allows to 
> build media sucessfully.
> 
> René
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

