Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45246 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbcCAWuT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Mar 2016 17:50:19 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "handre93 ." <handre93@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: Xilinx-HLS Driver Problem
Date: Wed, 02 Mar 2016 00:50:26 +0200
Message-ID: <1615549.5IX4gSOLzY@avalon>
In-Reply-To: <CADF4=SYrxTJDNR_vLKA0wUygu+Xk+3wexRNxiNbm7Jj-wavOqA@mail.gmail.com>
References: <CADF4=SYrxTJDNR_vLKA0wUygu+Xk+3wexRNxiNbm7Jj-wavOqA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello André,

On Monday 22 February 2016 13:45:34 handre93 . wrote:
> Hello,
> 
> I am sorry to bother you but I've seem to encounter an error on a driver
> which has your mail as a contact for help i think. If you could help me I
> would be truly thanked, if not could you please direct me to the a person
> of interest, as I, myself cannot fix the error.
> 
> The error is the following:
> On the xilinx-hls.c the function called "v4l2_sudev_get_try_format" as a
> different format than the one in previous versions of the linux kernel,
> producing the following error:

Are you using a mainline kernel ? If so, which version ? Have you applied any 
modification to it ?

I've CC'ed the linux-media mailing list on this reply, could you please send 
future community help requests to the mailing list ? You can of course feel 
free to CC me if it relates to a driver I maintain.

> scripts/kconfig/conf --silentoldconfig Kconfig
> 
> > CHK include/config/kernel.release
> > CHK include/generated/uapi/linux/version.h
> > CHK include/generated/utsrelease.h
> > make[1]: `include/generated/mach-types.h' is up to date.
> > CHK include/generated/bounds.h
> > CHK include/generated/timeconst.h
> > CHK include/generated/asm-offsets.h
> > CALL scripts/checksyscalls.sh
> > CHK include/generated/compile.h
> > GZIP kernel/config_data.gz
> > CHK kernel/config_data.h
> > CC drivers/media/platform/xilinx/xilinx-hls.o
> > drivers/media/platform/xilinx/xilinx-hls.c: In function
> > '__xhls_get_pad_format':
> > drivers/media/platform/xilinx/xilinx-hls.c:199:3: warning: passing
> > argument 1 of 'v4l2_subdev_get_try_format' from incompatible pointer type
> > [enabled by default]
> > In file included from drivers/media/platform/xilinx/xilinx-hls.c:24:0:
> > include/media/v4l2-subdev.h:772:1: note: expected 'struct v4l2_subdev
> > *' but argument is of type 'struct v4l2_subdev_fh
> > *'drivers/media/platform/xilinx/xilinx-hls.c:199:3: warning: passing
> > argument 2 of 'v4l2_subdev_get_try_format' makes pointer from integer
> > without a cast [enabled by default]In file included from
> > drivers/media/platform/xilinx/xilinx-hls.c:24:0:include/media/v4l2-subdev.
> > h:772:1: note: expected 'struct v4l2_subdev_pad_config *' but argument is
> > of type 'unsigned int'drivers/media/platform/xilinx/xilinx-hls.c:199:3:
> > error: too few arguments to function 'v4l2_subdev_get_try_format'In file
> > included from
> > drivers/media/platform/xilinx/xilinx-hls.c:24:0:include/media/v4l2-subdev
> > .h:772:1: note: declared heredrivers/media/platform/xilinx/xilinx-hls.c:
> > In function 'xhls_open':drivers/media/platform/xilinx/xilinx-hls.c:254:2:
> > warning: passing argument 1 of 'v4l2_subdev_get_try_format' from
> > incompatible pointer type [enabled by default]In file included from
> > drivers/media/platform/xilinx/xilinx-hls.c:24:0:include/media/v4l2-subdev.
> > h:772:1: note: expected 'struct v4l2_subdev *' but argument is of type
> > 'struct v4l2_subdev_fh
> > *'drivers/media/platform/xilinx/xilinx-hls.c:254:2: error: too few
> > arguments to function 'v4l2_subdev_get_try_format'In file included from
> > drivers/media/platform/xilinx/xilinx-hls.c:24:0:include/media/v4l2-subdev.
> > h:772:1: note: declared
> > heredrivers/media/platform/xilinx/xilinx-hls.c:257:2: warning: passing
> > argument 1 of 'v4l2_subdev_get_try_format' from
> > incompatible pointer type [enabled by default]In file included from
> > drivers/media/platform/xilinx/xilinx-hls.c:24:0:include/media/v4l2-subdev.
> > h:772:1: note: expected 'struct v4l2_subdev *' but argument is of type
> > 'struct v4l2_subdev_fh
> > *'drivers/media/platform/xilinx/xilinx-hls.c:257:2: warning: passing
> > argument 2 of 'v4l2_subdev_get_try_format' makes pointer from integer
> > without a cast [enabled by default]In file included from
> > drivers/media/platform/xilinx/xilinx-hls.c:24:0:include/media/v4l2-subdev.
> > h:772:1: note: expected 'struct v4l2_subdev_pad_config *' but argument is
> > of type 'int'drivers/media/platform/xilinx/xilinx-hls.c:257:2: error: too
> > few arguments to function 'v4l2_subdev_get_try_format'In file included
> > from
> > drivers/media/platform/xilinx/xilinx-hls.c:24:0:include/media/v4l2-subdev
> > .h:772:1: note: declared heredrivers/media/platform/xilinx/xilinx-hls.c:
> > At top level:drivers/media/platform/xilinx/xilinx-hls.c:279:2: warning:
> > initialization from incompatible pointer type [enabled by
> > default]drivers/media/platform/xilinx/xilinx-hls.c:279:2: warning: (near
> > initialization for 'xhls_pad_ops.get_fmt') [enabled by
> > default]drivers/media/platform/xilinx/xilinx-hls.c:280:2: warning:
> > initialization from incompatible pointer type [enabled by
> > default]drivers/media/platform/xilinx/xilinx-hls.c:280:2: warning: (near
> > initialization for 'xhls_pad_ops.set_fmt') [enabled by default]make[4]:
> > ***
> > [drivers/media/platform/xilinx/xilinx-hls.o] Error 1
> > make[3]: *** [drivers/media/platform/xilinx] Error 2
> > make[2]: *** [drivers/media/platform] Error 2
> > make[1]: *** [drivers/media] Error 2
> > make: *** [drivers] Error
> 
> Thank you very much in advance, and sorry to bother you,
> André

-- 
Regards,

Laurent Pinchart

