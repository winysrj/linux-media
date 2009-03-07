Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr17.xs4all.nl ([194.109.24.37]:1942 "EHLO
	smtp-vbr17.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbZCGJQh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Mar 2009 04:16:37 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: RFCv2: Finalizing the RDS interface
Date: Sat, 7 Mar 2009 10:16:45 +0100
Cc: linux-media@vger.kernel.org, Michael Schimek <mschimek@gmx.at>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	tobias.lorenz@gmx.net, belavenuto@gmail.com
References: <200903061315.42256.hverkuil@xs4all.nl> <20090307023916.GD3058@local>
In-Reply-To: <20090307023916.GD3058@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Content-Disposition: inline
Message-Id: <200903071016.45941.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Saturday 07 March 2009 03:39:19 Hans J. Koch wrote:
> On Fri, Mar 06, 2009 at 01:15:42PM +0100, Hans Verkuil wrote:
> > RFCv2: Completing the V4L2 RDS API
> > ================================
>
> [...]
>
> > The main changes in this second revision of this RFC are in the
> > handling of the US RBDS format.
>
> Good news. Comments below.
>
> [...]
>
> > Problems with this API
> > ----------------------
> >
> > As I said before, it is 90% complete, there are just a few things
> > missing:
> >
> > 1. Offset mapping
> > -----------------
> >
> > The Offset Name refers to six possible offsets as defined by the RDS
> > and RBDS standard (that is the US variant of RDS). Possible offsets
> > are: A, B, C, C', D and E (RBDS specific).
> >
> > The mapping of the values 0-7 to offsets is as follows:
> >
> > 0: block A
> > 1: block B
> > 2: block C
> > 3: block D
> > 4: block C'
> > 5: block E (MMBS specific, see below)
> > 6: invalid block E (RDS mode)
> > 7: invalid block
> >
> > This mapping comes from the saa6588 RDS decoder, but it makes sense and
> > I see no reason to change this. As long as we document it and add the
> > block defines to videodev2.h.
>
> Well, that could be done. It's not really needed, but it won't hurt
> either...

If it is to become a proper V4L2 standard, then this has to be defined 
properly as well. Before it was completely undefined in the spec what the 
offset numbers were.

> > The difference between bits 5-3 and 2-0 is that 'Received Offset'
> > refers to the offset received by the RDS decoder, while 'Offset Name'
> > is what the RDS decoder thinks it should be. This difference only
> > applies to devices that have high-level knowledge about the RDS
> > standard and can use that to correct wrongly received offsets. The only
> > driver I know that apparently can do this is the radio-cadet driver.
> > All other drivers make bits 5-3 equal to bits 2-0.
> >
> > All applications that are known to me only use bits 2-0.
> >
> > I propose that the spec is changed to mark bits 5-3 as deprecated and
> > that applications should only look at bits 2-0.
> >
> > I see no point in using bits 5-3 and making them deprecated might make
> > it possible to reuse them in the future if needed.
>
> ACK to that one. During all my RDS work I couldn't find any sense in
> making a difference between 5-3 and 2-0. You have probably noticed I
> simply make them equal in saa6588.c
>
> > 2. RBDS/MMBS support
> > --------------------
> >
> > RBDS is the US variant of RDS. There are very few differences between
> > the two, the most important ones being:
> >
> > - Different Program Information assignments
> > - Different Program Type assignments
> > - Support for MMBS (Modified Mobile Search)
> >
> > The first two are irrelevant to an RDS decoder at this level, but the
> > parser of the decoder's output will have to know whether it is
> > receiving RDS or RBDS. However, there doesn't seem to be a specific
> > marker that will tell you which of the two is being transmitted. The
> > parser will probably have to look at the transmitted country code and
> > use that to determine whether it needs to parse RDS or RBDS.
>
> Block type E is only present in RBDS and could be used to tell RDS from
> RBDS. I haven't got the docs handy ATM, but it doesn't matter much
> anyway, since most of the decoding is the same for both. I'd leave it to
> the userspace part of RDS to sort things out, no need to specify
> something in the kernel API.

You actually do need something for this. Certain chips (saa6588 among them) 
need to know whether E blocks are allowed or not and adjust their error 
checking accordingly.

> > The third is for the time-multiplexed MMBS system that is in use in the
> > US. It is really a separate protocol that can be interleaved within the
> > RDS signal and uses the E blocks. The presence of E blocks indicates
> > that RBDS is being used, but the reverse is not true since as I
> > understand it not all RBDS transmissions use MMBS.
>
> IIRC, if RBDS doesn't use E blocks, it's the same as RDS.

>From the decoder chip's point of view, yes. But the parser will see 
differences in PI and PTY assignments.

> > Not all decoders can handle MMBS, and those that do need to be told
> > that it is a valid block.
> >
> > I propose to use the v4l2_tuner struct for this. It is an obvious match
> > since the ability to read RDS is tuner related (no tuner, no RDS :-) ).
>
> I disagree. The right place is the card description. A tuner alone
> doesn't help, you need a decoder chip as well (no decoder, no RDS :-) )
>
> I already proposed a .has_rds flag that could be set to something like
>
> .has_rds = RDS_CHIP_SAA6588
>
> which could be used to automatically load the RDS decoder driver module.

You are confusing two different things: whether a driver can do RDS is 
indeed part of the card description. But this discusses the V4L2 API that 
you need to enable/disable MMBS support and to discover whether any 
RDS/MMBS packets are being transmitted at all.

I've chosen v4l2_tuner for this because RDS decoders always come in 
combination with a tuner. Sometimes they are actually integrated into the 
tuner.

All these v4l2_tuner changes only apply to cards that have an RDS decoder 
and are used to control that decoder.

> > The v4l2_tuner capability field needs two additional caps:
> >
> > V4L2_TUNER_CAP_RDS
> > V4L2_TUNER_CAP_MMBS
> >
> > And we can enable MMBS support by adding a flag to the audmode field:
> >
> > V4L2_TUNER_MODE_FL_MMBS 	0x100
> >
> > We should also add new subband flags V4L2_TUNER_SUB_RDS and
> > V4L2_TUNER_SUB_MMBS so we can report if RDS and MMBS are present. Note
> > that MMBS blocks always appear in multiples of 4, so that can be used
> > internally to see whether these are bit errors or real MMBS E-blocks.
>
> All of this is card specific, not tuner specific.
>
> > 3. Signal strength
> > ------------------
> >
> > In my initial proposal I also added an rds_signal field to obtain the
> > signal strength of the RDS signal. I've decided not to do so at this
> > time. If there is interest in this, then it can be added later.
>
> Unfortunately, this is decoder chip specific. And "signal strength"
> doesn't help at all. What you need is a chip independent "RDS quality". I
> thought about using the ratio good/bad blocks for that purpose. Dunno if
> that's a good idea, though.

That's why I left this alone for now. These same problems also occur with 
the existing signal field as used by tuners.

> > 4. Add RDS device capability
> > ----------------------------
> >
> > Any driver that can do RDS/RBDS should also set the
> > V4L2_CAP_RDS_CAPTURE capability.
>
> ACK.
>
> > 5. Flushing of pending data
> > ---------------------------
> >
> > Changing frequencies or inputs should flush all pending RDS packets.
> > This prevents RDS data from the previous frequency from being mixed in
> > with the RDS data from the new frequency.
>
> Hmm, yes. That would make things easier. But it could also simply be done
> in userspace. The data rate is so low, you'll never have a problem to
> read everything out of /dev/radioX after you change rx frequency.

It's a trivial thing to do in a driver. Why complicated things for 
userspace?

> > 6. RDS encoder
> > --------------
> >
> > The spec should make a note that anyone who wants to add RDS encoder
> > support to v4l2 should contact the linux-media mailinglist to discuss
> > this.
>
> That's a nice idea, ACK.
>
> > 7. Raw RDS format
> > -----------------
>
> Isn't the current RDS format raw enough? Everything I ever found in any
> RDS docs can be encoded in these 3-byte groups. And any RDS driver should
> be able to pack its infos into these 24 bits...

Apparently there is some sort of poor-man's rds support in the cx88 devices 
that can output raw samples.

>
> > There has been a discussion on what to do if a device can only output
> > the raw RDS samples (similar to raw VBI for video). Should that be
> > needed, then we have to add VIDIOC_G/S/TRY_FMT support for RDS. In that
> > case, the default for an RDS-capable radio device will be this
> > 'SLICED_RDS' format.
> >
> >
> >
> > With these changes I think the RDS API is pretty complete and can
> > become an official V4L2 API.
>
> I'm glad to see there's still something going on with RDS...

I've been doing a lot of cleanups lately and this was one of those loose 
ends in the spec. I got hold of an RDS card and started playing with it to 
see what was missing. So part of the reason is to finish the spec, and part 
of the reason is also that I suspect this might become more important with 
embedded linux devices like handhelds that want to support RDS.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
