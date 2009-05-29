Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:62500 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbZE2FgZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 May 2009 01:36:25 -0400
Received: by qw-out-2122.google.com with SMTP id 5so3815163qwd.37
        for <linux-media@vger.kernel.org>; Thu, 28 May 2009 22:36:27 -0700 (PDT)
Date: Fri, 29 May 2009 02:36:20 -0300
From: Douglas Schilling Landgraf <dougsland@gmail.com>
To: Eduardo Valentin <eduardo.valentin@nokia.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	"Nurkkala Eero.An (EXT-Offcode/Oulu)" <ext-Eero.Nurkkala@nokia.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Eduardo Valentin <eduardo.valentin@nokia.com>
Subject: Re: [PATCHv4 0 of 8] FM Transmitter (si4713) and another changes
Message-ID: <20090529023620.7497f10d@gmail.com>
In-Reply-To: <1243416955-29748-1-git-send-email-eduardo.valentin@nokia.com>
References: <1243416955-29748-1-git-send-email-eduardo.valentin@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Eduardo,

On Wed, 27 May 2009 12:35:47 +0300
Eduardo Valentin <eduardo.valentin@nokia.com> wrote:

> Hello all,
> 
>   I'm resending the FM transmitter driver and the proposed changes in
> v4l2 api files in order to cover the fmtx extended controls class.
> 
>   It is basically the same series of version #3. However I rewrote it
> to add the following comments:
> 
>   * Check kernel version for i2c helper function. Now the board data
> is passed not using i2c_board_info. This way all supported kernel
> versions can use the api. Besides that, the .s_config callback was
> added in core ops.
> 
>   * All patches are against v4l-dvb hg repository.
> 
>   Again, comments are welcome.


I have a comment, please check some headers to avoid errors. 

Instead of:

patch 05:

#include <media/linux/v4l2-device.h>
#include <media/linux/v4l2-ioctl.h>
#include <media/linux/v4l2-i2c-drv.h>
#include <media/linux/v4l2-subdev.h>

patch 06:

#include <media/linux/v4l2-device.h>
#include <media/linux/v4l2-common.h>
#include <media/linux/v4l2-ioctl.h>

Please use:

#include <media/v4l2-device.h>
#include <media/v4l2-ioctl.h>
#include <media/v4l2-i2c-drv.h>
#include <media/v4l2-subdev.h>

and

#include <media/v4l2-device.h>
#include <media/v4l2-common.h>
#include <media/v4l2-ioctl.h>

Cheers,
Douglas
