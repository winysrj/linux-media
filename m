Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr3.xs4all.nl ([194.109.24.23]:4177 "EHLO
	smtp-vbr3.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbZCUItt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Mar 2009 04:49:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Trent Piepho <xyzzy@speakeasy.org>
Subject: Re: [REVIEWv2] bttv v4l2_subdev conversion
Date: Sat, 21 Mar 2009 09:49:21 +0100
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
References: <200903192124.52524.hverkuil@xs4all.nl> <Pine.LNX.4.58.0903202236080.28292@shell2.speakeasy.net>
In-Reply-To: <Pine.LNX.4.58.0903202236080.28292@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903210949.21924.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 21 March 2009 06:56:18 Trent Piepho wrote:
> On Thu, 19 Mar 2009, Hans Verkuil wrote:
> > Please note that the somewhat awkward i2c address lists are temporary.
>
> This should be mentioned in the patch description.  No one in the future
> wondering why these address lists are here is going to find this email
> message.  I know they're supposed to go away.  There's still stuff in the
> bttv driver that Gerd declared obsolete and going away a half dozen years
> ago.

OK.

> > Without autoprobing the autoload module option has become obsolete. A
> > warning is generated if it is set, but it is otherwise ignored.
>
> It seems like one could still disable loading modules for that bttv might
> think it needs.  When you're testing modules that have not been
> installed, any calls to request_module() will load the wrong version and
> cause all sorts of breakage.  It should still be possible to disable any
> attempts by the driver to do that.

The idea is to either let the driver use the card definition info and 
probing to detect the audio chip, or to tell it which one to load 
explicitly. That's sufficient in my opinion.

> > diff -r 7191463177cd -r 68050e782acb
> > linux/drivers/media/video/bt8xx/bttv-cards.c ---
> > a/linux/drivers/media/video/bt8xx/bttv-cards.c	Thu Mar 19 20:53:32 2009
> > +0100 +++ b/linux/drivers/media/video/bt8xx/bttv-cards.c	Thu Mar 19
> > 21:15:53 2009 +0100 @@ -97,12 +97,12 @@
> >  static unsigned int tuner[BTTV_MAX]  = { [ 0 ... (BTTV_MAX-1) ] =
> > UNSET }; static unsigned int svhs[BTTV_MAX]   = { [ 0 ... (BTTV_MAX-1)
> > ] = UNSET }; static unsigned int remote[BTTV_MAX] = { [ 0 ...
> > (BTTV_MAX-1) ] = UNSET }; +static unsigned int msp3400[BTTV_MAX];
> > +static unsigned int tda7432[BTTV_MAX];
> > +static unsigned int tvaudio[BTTV_MAX];
> > +static unsigned int saa6588[BTTV_MAX];
>
> Are any of these audio chips mutually exclusive?  Does the driver even
> support having more than one of them for the same card?  It looks like it
> doesn't.  In that case you could replace some/all of these options with a
> "audio chip type" option where 0 is none, 1 is tvaudio, 2 is msp3400,
> etc. I think that's nicer than adding lots of new options and if you
> can't have multiple audio chips, why allow one to specify that?

Yeah, this is a better solution.

>
> > +			0x22 >> 1,
> > +			I2C_CLIENT_END
> > +		};
> > +
> > +		btv->sd_saa6588 = v4l2_i2c_new_probed_subdev(&btv->c.i2c_adap,
> > +				"saa6588", "saa6588", addrs);
>
> Why do you save the the subdev returned here?  AFAICS it's not ever used
> anywhere.  You said that v4l2 subdevs automatically go away when the
> device they are attacked to is removed, right?  So we don't need the
> pointer to free it.

I'll remove it. I'll probably put it back in a future patch when I'll start 
working on RDS. Currently you can read from a radio device in bttv and it 
will allow that even when there is no rds on board. I intended to use this 
pointer later in the radio fops to test whether reading is allowed.

But it's better to do this in the actual RDS patch.

> > --- a/linux/drivers/media/video/bt8xx/bttv.h	Thu Mar 19 20:53:32 2009
> > +0100 +++ b/linux/drivers/media/video/bt8xx/bttv.h	Thu Mar 19 21:15:53
> > 2009 +0100 @@ -242,6 +242,7 @@
> >  	unsigned int msp34xx_alt:1;
> >
> >  	unsigned int no_video:1; /* video pci function is unused */
> > +	unsigned int has_saa6588:1;
>
> How about not adding this?  It's unused and I just removed a bunch of
> unused fields from here.  Add it when someone can actually make use of
> it.

No. If you add a new card definition and that card has a saa6588, then this 
bit should be available for you. Otherwise I just know that people will 
just skip that chip ('Hey! I can't set it! Oh, I'll skip it then...') 
instead of asking for adding saa6588 support.

The only reason it's not used is that the one board that can have it has to 
test for it dynamically as it is an add-on.

Looking at it I should add a comment, though.

> >  	unsigned int tuner_type;  /* tuner chip type */
> >  	unsigned int tda9887_conf;
> >  	unsigned int svhs, dig;
> > +	unsigned int has_saa6588:1;
>
> You're better off not using a bitfield here.  Because of padding, it
> still takes 32 bits (or more, depending on the alignment of
> bttv_pll_info) in the struct but takes more code to use.

Mauro wants a bitfield, he gets a bitfield. I'm not going back-and-forth on 
this. Personally I don't care one way or the other.

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
