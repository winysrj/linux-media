Return-path: <mchehab@pedra>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1532 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755593Ab0IRPTR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Sep 2010 11:19:17 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Andy Walls <awalls@md.metrocast.net>
Subject: Re: RFC: control framework enhancements
Date: Sat, 18 Sep 2010 17:18:53 +0200
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <201009181419.32888.hverkuil@xs4all.nl> <1284817477.2053.105.camel@morgan.silverblock.net>
In-Reply-To: <1284817477.2053.105.camel@morgan.silverblock.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009181718.53858.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday, September 18, 2010 15:44:37 Andy Walls wrote:
> On Sat, 2010-09-18 at 14:19 +0200, Hans Verkuil wrote:
> > Hi all,
> > 
> > This weekend I started converting drivers to the new control framework. While
> > doing that I realized that the control framework needs a few enhancements.
> 
> 
> > Since both subdevs may have identical controls (e.g. both may have a brightness
> > control), the control framework needs to be able to handle that as well.
> 
> Is it ever the case that a bridge chip and a subdev also have identical
> controls (CX23880 and WM8739 maybe)?  Does your change handle that?

Yes, that is definitely possible. Right now the first created control 'wins'.
So if the cx23880 has a volume control and wm8739 has one as well, then the
cx23880 is always the one that is used. Once we have device nodes to access
subdevs as well, then the wm8739 would become available through that device
node.

With the new enable/disable functionality it becomes possible to let the
cx23880 driver disable its own volume control in favor of the wm8739. It
can be toggled at will.

> 
> 
> > In order to support this functionality I've added the following two functions:
> > 
> > /** v4l2_ctrl_enable() - Mark the control as enabled or disabled.
> >   * @ctrl:      The control to en/disable.
> >   * @enabled:   True if the control should become enabled.
> >   *
> >   * Enable/disable a control.
> >   * Does nothing if @ctrl == NULL.
> >   * Usually called if controls are to be enabled or disabled when changing
> >   * to a different input or output.
> >   *
> >   * When a control is disabled, then it will no longer show up in the
> >   * application.
> >   *
> >   * This function can be called regardless of whether the control handler
> >   * is locked or not.
> >   */
> > void v4l2_ctrl_enable(struct v4l2_ctrl *ctrl, bool enabled);
> > 
> > /** v4l2_ctrl_handler_enable() - Mark the controls in the handler as enabled or disabled.
> >   * @hdl:       The control handler.
> >   * @enabled:   True if the controls should become enabled.
> >   *
> >   * Enable/disable the controls owned by the handler.
> >   * Does nothing if @hdl == NULL.
> >   * Usually called if controls are to be enabled or disabled when changing
> >   * to a different input or output.
> >   *
> >   * When a control is disabled, then it will no longer show up in the
> >   * application.
> >   */
> > void v4l2_ctrl_handler_enable(struct v4l2_ctrl_handler *hdl, bool enabled);
> > 
> > And internally I allow for duplicate control references. The first enabled
> > control will win.
> 
> By duplicate reference do you mean "in a list of V4L2 control objects,
> the first enabled one in the list, matching the desired V4L2_CID, wins"?

Right.
 
> I can also offer a case where having two volume controls is useful:
> 
> WM8775 (IIRC) connected in front of a CX25841 on an ivtv board.  Due to
> the way the board is wired, audio nosie performance is terrible, if only
> manipulating the volume control in the CX25841.  By manipulating the
> volume control in the WM8775, the audio system noise figure can be
> improved.  (Highest gain setting without clipping in the WM8775 with the
> CX25841 volume control to attenuate down to a pleasant listening level.)
> 
> I don't know, maybe something like that takes us down the path of
> recreating the ALSA mixer interface.  So in the case of volume controls
> it may be better just to create an ALSA API interface for ivtv.
> 
> The same sort of noise figure improvement mechanism can be applicable to
> other signals going through a multistage process with gain controls or
> clamping controls.

I don't think this new feature will help much with this case. You either
have a smarter ivtv volume handling algorithm where ivtv implements a
volume control whose implementation manipulated both the cx25841 and wm8775
volume controls in turn, or you let the user do it manually using the subdev
device node once that becomes available. But the latter is hardly user
friendly.

> 
> 
> > If no one objects, then I want to merge this for 2.6.37.
> > 
> > The second enhancement is one I am not sure about. It concerns private controls.
> > The basic guideline for drivers is that private controls need to be added to
> > videodev2.h and documented in the spec. So private controls are well defined,
> > and their control ID is fixed so they can set directly by an application.
> 
> Maybe that guideline needs revision, regardless of new control framework
> changes.
> 
> A better guideline may be that applications should make every effort to
> avoid hard-coding private control IDs, and to discover private controls
> instead.  (I used the language "make every effort" to allow for the case
> of applications designed around a specific driver.)

That depends. The cx2341x MPEG private controls definitely need to be hardcoded.
It makes perfect sense to make a custom application that controls all these
MPEG settings directly.

The same will be true for control handling in embedded systems.

The problem is perhaps with the naming. Instead of calling it 'private' the
name 'hardware-specific' is perhaps better. It's not private as in hiding
something, but more that you cannot make a generic control for this because
the control only makes sense for this particular hardware.
 
> The whole purpose of non-private V4L2_CIDs is that they need not be
> discovered, always have a well defined/understood effect, and can always
> be hard-coded by general purpose video applications.  So a private
> controls should not be required to meet all of those conditions -
> otherwise it is a standard control.

I think that we should perhaps consider three types of controls:

1) standard controls: well-defined, generic (i.e. not hardware specific) controls.
2) hw specific controls: well-defined, but specific to particular hardware.
3) private controls: specific to a driver, have to be discovered and cannot be
   hard-coded. This is basically what the original idea behind private controls was.

This is basically what my patch does: it creates this clear separation between
the three types.

> 
> 
> Of course all statically defined controls, public or private, should be
> documented -- says the person who doesn't plan to backfill the
> documentation. ;) 
> 
> > However, there are a few cases where the ability to have the framework generate
> > control IDs for you is actually quite useful.
> 
> It seems like it would be useful for developers.
> 
> Would it ever be used by non-test/non-debug applications?  In your cases
> below, I think UVC cam applications are the only example.

Applications wouldn't use this directly, it is the driver that requests it.

> 
> 
> >  Of course, if you do this then
> > you can never set controls directly since you do not know the control ID.
> > 
> > I have identified four use-cases for this:
> > 
> > - Initial development and testing: it is quite handy to generate the ID while
> >   you are still developing your driver.
> 
> Yes.
> 
> > - In vivi I want to create test controls to use as a test-bed for testing the
> >   control framework.  Such test controls really do not belong in videodev2.h.
> 
> Hmmm.  I thought the vivi driver was intended to be a learning tool and
> example.  I'd suggest heavy documentation and dire warnings in vivi
> comments, if the test controls are not being added to the documentation
> in some manner.

It's pretty obvious in the code, but yes, it needs to be clearly documented.

> 
> 
> > - Legacy drivers: do we really want to add the private controls of e.g. indycam.c
> >   to videodev2.h and the spec? It is a lot of work for little gain.
> 
> I agree that documenting them is probably of little worth.
> 
> The problem here is legacy applications, written around specific
> drivers, that expect the undocumented private controls to always have
> the same id.  Do we need to go through the work of making these old
> drivers' private control ID to bounce around, when the result will be
> breaking legacy applications for old hardware?

Generally the private control IDs are not available in public headers.
A quick grep shows that only meye.h and matroxfb.h (!) have a public header.

> 
> 
> > - Drivers like UVC where controls can be generated.
> > 
> > The way I have implemented this is that when you create the control you pass
> > a special control ID:
> > 
> > #define V4L2_CID_USER_AUTO      (V4L2_CTRL_CLASS_USER | 0xf000)
> > #define V4L2_CID_MPEG_AUTO      (V4L2_CTRL_CLASS_MPEG | 0xf000)
> > #define V4L2_CID_CAMERA_AUTO    (V4L2_CTRL_CLASS_CAMERA | 0xf000)
> > #define V4L2_CID_FM_TX_AUTO     (V4L2_CTRL_CLASS_FM_TX | 0xf000)
> > 
> > The framework will then automatically generate a new ID.
> > 
> > I'm undecided about this one. It definitely has advantages, but it also requires
> > extra care when reviewing drivers since this functionality shouldn't be abused.
> 
> 
> What are the resources that are being allocated and deallocated - just
> the control IDs?

To implement this the only change is that struct v4l2_ctrl_ref gets an extra
u32 id field. Effectively there is no impact on performance or memory usage.

> Is there some phase of driver module life, to which such allocations are
> restricted, e.g. only at driver probe, or not while the device node is
> open?  After an application has discovered private control IDs, are more
> just going to pop-up and others disappear?  Will v4l2_event s be
> generated when and if they do?

Controls of this type are just like any other, except that you pass a special
control ID that causes the framework to determine a free control ID for you
(there are a few subtleties here, but basically that's what happens).

Controls can be added at any time, although other than UVC no driver should
do this except at initialization time.

Controls cannot be removed, except at the end when the device instance is freed.
But controls can be disabled/enabled on the fly according to the spec:

"Drivers may enumerate different controls after switching the current video input
or output, tuner or modulator, or audio input or output. Different in the sense
of other bounds, another default and current value, step size or other menu items.
A control with a certain custom ID can also change name and type."

I intend to add events in the near future telling apps when a control changes
value, and when controls are enabled/disabled/added.

Regards,

	Hans

> 
> Regards,
> Andy
> 
> > The patches are available in my tree:
> > 
> > http://git.linuxtv.org/hverkuil/v4l-dvb.git?a=shortlog;h=refs/heads/ctrlfw
> > 
> > See the vivi patch for an example of auto-generated control IDs.
> > 
> > Comments?
> > 
> > Regards,
> > 
> > 	Hans
> > 
> 
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
