Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:41264 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbZBUM4i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Feb 2009 07:56:38 -0500
Date: Sat, 21 Feb 2009 09:56:07 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Jean Delvare <khali@linux-fr.org>, urishk@yahoo.com,
	linux-media@vger.kernel.org
Subject: Re: Minimum kernel version supported by v4l-dvb
Message-ID: <20090221095607.2e8c038b@pedra.chehab.org>
In-Reply-To: <200902211345.40411.hverkuil@xs4all.nl>
References: <43235.62.70.2.252.1234947353.squirrel@webmail.xs4all.nl>
	<200902210828.50666.hverkuil@xs4all.nl>
	<20090221085801.5954e00b@pedra.chehab.org>
	<200902211345.40411.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 21 Feb 2009 13:45:40 +0100
Hans Verkuil <hverkuil@xs4all.nl> wrote:

> > tda9840 support is provided by tda9840.ko, but there's no
> > request_module() or any other reference (except for the above comment) to
> > it at bttv driver. I believe that this is not an isolated case.
> 
> The tda9840 is handled by tvaudio. Other than tda9875 and msp3400 all these 
> audio variants are all handled by that module. tvaudio was developed at the 
> time as a sort of 'catch-all' module and is currently only used by bttv.
> 
> If you look at the code you'll se that tda9840.c can only be used with 
> saa7146, ditto tea6420.c. So these give no conflicts.

Ok.

> > I suspect that there are other cases where no doc is provided on kernel
> > and the only source of information is provided by googling at the net or
> > by taking a look on each card at bttv-gallery to see what chips are
> > inside of each bttv board.
> >
> > So, at least for bttv, IMO, we should: do an i2c scan, on bttv driver,
> > for tvaudio and the other audio modules. If found, then we load the
> > proper driver.
> >
> > We'll still have another problem: There are conflicting addresses. For
> > example, address 0xb0 (8bit notation) is used on tvaudio for tda9874 and
> > on tda9875. I have no idea what boards need tvaudio and what boards need
> > tda9875 module. So, simply probing for 0xb0 won't be enough.
> 
> Luckily the two chips can be told apart from one another. Suggestion: move 
> the support for tda9874 from tvaudio.c to tda9875.c and let that one handle 
> both. They are very similar and that shouldn't be difficult. That will 
> solve this conflict in an elegant manner.
> 
> I see one more conflict between msp3400 and tea6300. It should be possible 
> to implement i2c detect support in msp3400 since that chip can detect what 
> chip it is, and if no msp3400 is found after all we fall back to tvaudio.

Seems the better solution for me also.

> > During the conversion of bttv to V4L2, I've mapped the i2c addresses of
> > the audio modules I found at:
> >
> > 	linux/include/media/i2c-addr.h
> >
> > For cx88, the issue is simpler, since cx88 has its own audio decoder. I
> > dunno why some PV boards have a separate audio processor[1]. Anyway, for
> > cx88, we can add the autodetection code just for that device, and just
> > for tvaudio.
> 
> Are you sure cx88 requires that tvaudio is loaded for some cards? There is 
> no mention about tvaudio and cx88 anywhere, neither source nor 
> documentation, nor google for that matter.

Yes, I'm sure. It were reported by one user at #v4l irc channel. I think some
emails were exchanged also (not sure if they were in priv or not). On that
time, I asked him to submit a patch creating a separate entry for that PV
variant, but he didn't. After some time, we lost contact with him.

> > This will be great, provided that we can do the autoprobing for the audio
> > modules as required by a few drivers like bttv.
> 
> You cannot expect that a user can modprobe an i2c driver and it will 
> magically appear. That's going away. You can change the driver so that it 
> will load the module and let it probe for a series of i2c addresses. There 
> is also an option to let the i2c driver do additional checks (Jean knows 
> more about the details).

We need one solution. For sure it is better if the i2c adapter to do such probing.

Cheers,
Mauro
