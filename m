Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3941 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab2JOIuI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Oct 2012 04:50:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Alain VOLMAT <alain.volmat@st.com>
Subject: Re: Proposal for the addition of a binary V4L2 control type
Date: Mon, 15 Oct 2012 10:50:02 +0200
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"Linux Media Mailing List (linux-media@vger.kernel.org)"
	<linux-media@vger.kernel.org>
References: <E27519AE45311C49887BE8C438E68FAA01012C91166A@SAFEX1MAIL1.st.com> <201210120820.59902.hverkuil@xs4all.nl> <E27519AE45311C49887BE8C438E68FAA01012C91183C@SAFEX1MAIL1.st.com>
In-Reply-To: <E27519AE45311C49887BE8C438E68FAA01012C91183C@SAFEX1MAIL1.st.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210151050.02991.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri October 12 2012 16:33:20 Alain VOLMAT wrote:
> Hi Hans
> 
> > -----Original Message-----
> > From: Hans Verkuil [mailto:hverkuil@xs4all.nl]
> > Sent: Friday, October 12, 2012 8:21 AM
> > To: Alain VOLMAT
> > Cc: Laurent Pinchart; Linux Media Mailing List (linux-media@vger.kernel.org)
> > Subject: Re: Proposal for the addition of a binary V4L2 control type
> > 
> > On Fri October 12 2012 00:41:37 Alain VOLMAT wrote:
> > > Hi Laurent,
> > >
> > > > -----Original Message-----
> > > > From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com]
> > > > Sent: vendredi 12 octobre 2012 00:22
> > > > To: Alain VOLMAT
> > > > Cc: Linux Media Mailing List (linux-media@vger.kernel.org)
> > > > Subject: Re: Proposal for the addition of a binary V4L2 control type
> > > >
> > > > Hi Alain,
> > > >
> > > > On Thursday 11 October 2012 22:50:29 Alain VOLMAT wrote:
> > > > > Hi guys,
> > > > >
> > > > > In the context of supporting the control of our HDMI-TX via V4L2
> > > > > in our SetTopBox, we are facing interface issue with V4L2 when
> > > > > trying to set some information from the application into the H/W.
> > > > >
> > > > > As an example, in the HDCP context, an application controlling the
> > > > > HDMI-TX have the possibility to inform the transmitter that it
> > > > > should fail authentication to some identified HDMI-RX because for
> > > > > example they might be known to be "bad" HDMI receiver that cannot
> > be trusted.
> > > > > This is basically done by setting the list of key (BKSV) into the HDMI-TX
> > H/W.
> > > > >
> > > > > Currently, V4L2 ext control can be of the following type:
> > > > >
> > > > > enum v4l2_ctrl_type {
> > > > >         V4L2_CTRL_TYPE_INTEGER       = 1,
> > > > >         V4L2_CTRL_TYPE_BOOLEAN       = 2,
> > > > >         V4L2_CTRL_TYPE_MENU          = 3,
> > > > >         V4L2_CTRL_TYPE_BUTTON        = 4,
> > > > >         V4L2_CTRL_TYPE_INTEGER64     = 5,
> > > > >         V4L2_CTRL_TYPE_CTRL_CLASS    = 6,
> > > > >         V4L2_CTRL_TYPE_STRING        = 7,
> > > > >         V4L2_CTRL_TYPE_BITMASK       = 8,
> > > > > }
> > > > >
> > > > > There is nothing here than could efficiently be used to push this
> > > > > kind of long (several bytes long .. not fitting into an int64) key
> > information.
> > > > > STRING exists but actually since they are supposed to be strings,
> > > > > the
> > > > > V4L2 core code (v4l2-ctrls.c) is using strlen to figure out the
> > > > > length of data to be copied and it thus cannot be used to push this kind
> > of blob data.
> > > > >
> > > > > Would you consider the addition of a new v4l2_ctrl_type, for
> > > > > example called V4L2_CTRL_TYPE_BINARY or so, that basically would
> > > > > be pointer + length. That would be helpful to pass this kind of
> > > > > control from the application to the driver. (here I took the
> > > > > example of HDCP key blob but that isn't of course the only example we
> > can find of course).
> > > >
> > > > If I remember correctly Hans Verkuil wasn't happy with the concept of
> > binary controls.
> > 
> > That's correct. Controls should be 1) fairly elementary types and 2) have clear
> > semantics. Binary blobs are neither.
> > 
> > > > While I'm
> > > > not totally against it, I agree with him that it could open the door
> > > > to abuses. There are valid use cases though, both for binary
> > > > "strings" (such as encryption keys) and binary arrays (such as gamma
> > tables).
> > > > Completely random binary blobs are not a good idea though.
> > > >
> > > > So far we've worked around the absence of binary controls by using
> > > > custom ioctls (or even standardizing new ioctls). It might or might
> > > > not be a good solution for your problem, depending on your exact use
> > cases.
> > >
> > > Ok, at least for the HDCP keys table we could for an ioctl if that's already
> > the case in some other situations.
> > 
> > Look at the EDID ioctls in v4l2-subdev.h. The HDCP ioctls should be next to
> > them.
> > If I remember correctly you need a get ioctl to obtains the keys from a
> > receiver and a set ioctl to set the keys for a transmitter.
> 
> Well, yes, if keys goes up to the user space, yes those 2 ioctls will be needed.
> But another ioctl or control will also be needed to ENABLE & DiSABLE the HDCP / HDCP encryption I think.

Certainly. And that can be a control.

> This doesn't always have to be enable so it should be necessary to allow triggering that.
> 
> > > I can however think about some cases where passing such binary controls is
> > better than ioctl in case of it is necessary achieve several settings in an atomic
> > way (which is I believe one of the merit of ext_control). Still in the field of
> > HDMI-TX I can at least think about setting video post processing setting
> > tables & mode change at the same time for example.
> > > If one setting is already available via a control and the other one has to be
> > done via an ioctl, then it becomes hard to ensure that this is done in an
> > atomic way back at the driver level.
> > >
> > > So, in short, for HDCP keys, there might not be a problem with ioctl but for
> > other HDMI-TX settings, I'm afraid we will face problems.
> > >
> > > I am preparing some proposal for some new HDMI-TX controls (or ioctl ?)
> > for things like SPD, AVMUTE, CONTENT_TYPE etc, I guess we could discuss
> > about that problem again at that time.
> > 
> > A lot of the stuff that's in InfoFrames lends itself perfectly to controls.
> > They are both simple types and have clear semantics.
> 
> Well at least SPD data that are (product name, vendor name, type) are a group of data.
> So if this is provided via controls (ext), then it will require to the application to set all 3 controls (string, string, integer) in a same s_ext_control in order to avoid getting only a partial SPD data update.
> Or we can rely on yet another ioctl (s_spd) to pass all 3 datas at the same time.

Use controls for this. It gives you full flexibility: you can choose to update all or
only a subset of these values, and it will all work. It's a really nice match.

Regards,

	Hans

> 
> > 
> > Regards,
> > 
> > 	Hans
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
