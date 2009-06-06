Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1983 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296AbZFFPvV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Jun 2009 11:51:21 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@radix.net>
Subject: Re: [PATCHv5 1 of 8] v4l2_subdev i2c: Add v4l2_i2c_new_subdev_board i2c helper function
Date: Sat, 6 Jun 2009 17:51:03 +0200
Cc: Eduardo Valentin <eduardo.valentin@nokia.com>,
	"\\\"ext Mauro Carvalho Chehab\\\"" <mchehab@infradead.org>,
	"\\\"Nurkkala Eero.An (EXT-Offcode/Oulu)\\\""
	<ext-Eero.Nurkkala@nokia.com>,
	"\\\"ext Douglas Schilling Landgraf\\\"" <dougsland@gmail.com>,
	Linux-Media <linux-media@vger.kernel.org>
References: <1243582408-13084-1-git-send-email-eduardo.valentin@nokia.com> <200906061449.46720.hverkuil@xs4all.nl> <1244301548.3149.27.camel@palomino.walls.org>
In-Reply-To: <1244301548.3149.27.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906061751.03552.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 06 June 2009 17:19:08 Andy Walls wrote:
> On Sat, 2009-06-06 at 14:49 +0200, Hans Verkuil wrote:
> > > I propose to change the API as follows:
> > >
> > > #define V4L2_I2C_ADDRS(addr, addrs...) \
> > > 	((const unsigned short []){ addr, ## addrs, I2C_CLIENT_END })
> > >
> > > Comments? If we decide to go this way, then I need to know soon so
> > > that I can make the changes before the 2.6.31 window closes.
> >
> > I've done the initial conversion to the new API (no _cfg or _board
> > version yet) in my ~hverkuil/v4l-dvb-subdev tree. It really simplifies
> > things and if nobody objects then I'd like to get this in before
> > 2.6.31.
>
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

'on the fly' is perhaps a better term...

> Anyway, the macro looks fine to me.
>
> But...
>
>
> @@ -100,16 +100,16 @@ int cx18_i2c_register(struct cx18 *cx, u
>
> 	if (hw == CX18_HW_TUNER) {
> 		/* special tuner group handling */
> -		sd = v4l2_i2c_new_probed_subdev(&cx->v4l2_dev,
> -				adap, mod, type, cx->card_i2c->radio);
> +		sd = v4l2_i2c_subdev(&cx->v4l2_dev,
> +				adap, mod, type, 0, cx->card_i2c->radio);
>
>
> Something happened with readability for maintenance purposes.  We're in
> cx18_i2c_register(), we're probing, we're allocating new objects, and
> we're registering with two subsystems (i2c and v4l).  However, all we
> see on the surface is
>
>     "foo = v4l2_i2c_subdev(blah, blah, blah, ... );"
>
> The ALSA subsystem at least uses "_create" for object constructor type
> functions.  The v4l2 subdev framework has sophisticated constructors for
> convenience.  I know "new" wasn't strcitly correct, as the function does
> probe, create, & register an object.  However, the proposed name does
> not make it obvious that it's a constructor, IMO.

Hmm, I should probably just leave this as v4l2_i2c_new_subdev since that 
corresponds to the i2c core's i2c_new_device call.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
