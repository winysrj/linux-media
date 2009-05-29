Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:56403 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbZE2GIu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 May 2009 02:08:50 -0400
Date: Fri, 29 May 2009 09:03:59 +0300
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: ext Douglas Schilling Landgraf <dougsland@gmail.com>
Cc: "Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCHv4 0 of 8] FM Transmitter (si4713) and another changes
Message-ID: <20090529060359.GC12102@esdhcp037198.research.nokia.com>
Reply-To: eduardo.valentin@nokia.com
References: <1243416955-29748-1-git-send-email-eduardo.valentin@nokia.com> <20090529023620.7497f10d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090529023620.7497f10d@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Douglas,

On Fri, May 29, 2009 at 07:36:20AM +0200, ext Douglas Schilling Landgraf wrote:
> Hello Eduardo,
> 
> On Wed, 27 May 2009 12:35:47 +0300
> Eduardo Valentin <eduardo.valentin@nokia.com> wrote:
> 
> > Hello all,
> > 
> >   I'm resending the FM transmitter driver and the proposed changes in
> > v4l2 api files in order to cover the fmtx extended controls class.
> > 
> >   It is basically the same series of version #3. However I rewrote it
> > to add the following comments:
> > 
> >   * Check kernel version for i2c helper function. Now the board data
> > is passed not using i2c_board_info. This way all supported kernel
> > versions can use the api. Besides that, the .s_config callback was
> > added in core ops.
> > 
> >   * All patches are against v4l-dvb hg repository.
> > 
> >   Again, comments are welcome.
> 
> 
> I have a comment, please check some headers to avoid errors. 
> 
> Instead of:
> 
> patch 05:
> 
> #include <media/linux/v4l2-device.h>
> #include <media/linux/v4l2-ioctl.h>
> #include <media/linux/v4l2-i2c-drv.h>
> #include <media/linux/v4l2-subdev.h>
> 
> patch 06:
> 
> #include <media/linux/v4l2-device.h>
> #include <media/linux/v4l2-common.h>
> #include <media/linux/v4l2-ioctl.h>
> 
> Please use:
> 
> #include <media/v4l2-device.h>
> #include <media/v4l2-ioctl.h>
> #include <media/v4l2-i2c-drv.h>
> #include <media/v4l2-subdev.h>
> 
> and
> 
> #include <media/v4l2-device.h>
> #include <media/v4l2-common.h>
> #include <media/v4l2-ioctl.h>

Right, I'll re send it.

Thanks for reviewing.

> 
> Cheers,
> Douglas

-- 
Eduardo Valentin
