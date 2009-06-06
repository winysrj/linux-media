Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:42093 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703AbZFFRtx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Jun 2009 13:49:53 -0400
Date: Sat, 6 Jun 2009 10:49:54 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
To: Andy Walls <awalls@radix.net>
cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Eduardo Valentin <eduardo.valentin@nokia.com>,
	"\\\\\\ext Mauro Carvalho Chehab\\\\\\" <mchehab@infradead.org>,
	"\\\\\\Nurkkala Eero.An (EXT-Offcode/Oulu)\\\\\\"
	<ext-Eero.Nurkkala@nokia.com>,
	"\\\\\\ext Douglas Schilling Landgraf\\\\\\" <dougsland@gmail.com>,
	Linux-Media <linux-media@vger.kernel.org>
Subject: Re: [PATCHv5 1 of 8] v4l2_subdev i2c: Add v4l2_i2c_new_subdev_board
 i2c helper function
In-Reply-To: <1244301548.3149.27.camel@palomino.walls.org>
Message-ID: <Pine.LNX.4.58.0906061036090.32713@shell2.speakeasy.net>
References: <1243582408-13084-1-git-send-email-eduardo.valentin@nokia.com>
 <1243582408-13084-2-git-send-email-eduardo.valentin@nokia.com>
 <200906061359.19732.hverkuil@xs4all.nl>  <200906061449.46720.hverkuil@xs4all.nl>
 <1244301548.3149.27.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 6 Jun 2009, Andy Walls wrote:
> +Alternatively, you can create the unsigned short array dynamically:
> +
> +struct v4l2_subdev *sd = v4l2_i2c_subdev(v4l2_dev, adapter,
> +	       "module_foo", "chipid", 0, V4L2_I2C_ADDRS(0x10, 0x12));
>
> Strictly speaking, that's not "dynamically" in the sense of the
> generated machine code - everything is going to come from the local
> stack and the initialized data space.  The compiler will probably be
> smart enough to generate an unnamed array in the initialized data space
> anyway, avoiding the use of local stack for the array. :)

No such luck, gcc will create an array on the stack and then initialize it
with a series of move word instructions.  It isn't even smart enough to
turn:

        movw    $1, (%esp)
        movw    $2, 2(%esp)
        movw    $3, 4(%esp)
        movw    $-1, 6(%esp)

into:
	movl	$0x00020001, (%esp)
	movl	$0xffff0003, 4(%esp)

Now, if you use a different syntax, and change this:

#define V4L2_I2C_ADDRS(addr, addrs...) \
        ((const unsigned short []){ addr, ## addrs, -1 })
#define bar(addrs...)   _bar(V4L2_I2C_ADDRS(addrs))

into this:

#define bar(addr, addrs...) \
        ({ const unsigned short _a[] = {addr, ## addrs, -1}; _bar(_a); })

If all the values are constants, then for the latter method only gcc will
will create an array in the initialized data segment and use that.
