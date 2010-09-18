Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:17686 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754311Ab0IRNog (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Sep 2010 09:44:36 -0400
Subject: Re: RFC: control framework enhancements
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
In-Reply-To: <201009181419.32888.hverkuil@xs4all.nl>
References: <201009181419.32888.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 18 Sep 2010 09:44:37 -0400
Message-ID: <1284817477.2053.105.camel@morgan.silverblock.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, 2010-09-18 at 14:19 +0200, Hans Verkuil wrote:
> Hi all,
> 
> This weekend I started converting drivers to the new control framework. While
> doing that I realized that the control framework needs a few enhancements.


> Since both subdevs may have identical controls (e.g. both may have a brightness
> control), the control framework needs to be able to handle that as well.

Is it ever the case that a bridge chip and a subdev also have identical
controls (CX23880 and WM8739 maybe)?  Does your change handle that?


> In order to support this functionality I've added the following two functions:
> 
> /** v4l2_ctrl_enable() - Mark the control as enabled or disabled.
>   * @ctrl:      The control to en/disable.
>   * @enabled:   True if the control should become enabled.
>   *
>   * Enable/disable a control.
>   * Does nothing if @ctrl == NULL.
>   * Usually called if controls are to be enabled or disabled when changing
>   * to a different input or output.
>   *
>   * When a control is disabled, then it will no longer show up in the
>   * application.
>   *
>   * This function can be called regardless of whether the control handler
>   * is locked or not.
>   */
> void v4l2_ctrl_enable(struct v4l2_ctrl *ctrl, bool enabled);
> 
> /** v4l2_ctrl_handler_enable() - Mark the controls in the handler as enabled or disabled.
>   * @hdl:       The control handler.
>   * @enabled:   True if the controls should become enabled.
>   *
>   * Enable/disable the controls owned by the handler.
>   * Does nothing if @hdl == NULL.
>   * Usually called if controls are to be enabled or disabled when changing
>   * to a different input or output.
>   *
>   * When a control is disabled, then it will no longer show up in the
>   * application.
>   */
> void v4l2_ctrl_handler_enable(struct v4l2_ctrl_handler *hdl, bool enabled);
> 
> And internally I allow for duplicate control references. The first enabled
> control will win.

By duplicate reference do you mean "in a list of V4L2 control objects,
the first enabled one in the list, matching the desired V4L2_CID, wins"?

I can also offer a case where having two volume controls is useful:

WM8775 (IIRC) connected in front of a CX25841 on an ivtv board.  Due to
the way the board is wired, audio nosie performance is terrible, if only
manipulating the volume control in the CX25841.  By manipulating the
volume control in the WM8775, the audio system noise figure can be
improved.  (Highest gain setting without clipping in the WM8775 with the
CX25841 volume control to attenuate down to a pleasant listening level.)

I don't know, maybe something like that takes us down the path of
recreating the ALSA mixer interface.  So in the case of volume controls
it may be better just to create an ALSA API interface for ivtv.

The same sort of noise figure improvement mechanism can be applicable to
other signals going through a multistage process with gain controls or
clamping controls.


> If no one objects, then I want to merge this for 2.6.37.
> 
> The second enhancement is one I am not sure about. It concerns private controls.
> The basic guideline for drivers is that private controls need to be added to
> videodev2.h and documented in the spec. So private controls are well defined,
> and their control ID is fixed so they can set directly by an application.

Maybe that guideline needs revision, regardless of new control framework
changes.

A better guideline may be that applications should make every effort to
avoid hard-coding private control IDs, and to discover private controls
instead.  (I used the language "make every effort" to allow for the case
of applications designed around a specific driver.)

The whole purpose of non-private V4L2_CIDs is that they need not be
discovered, always have a well defined/understood effect, and can always
be hard-coded by general purpose video applications.  So a private
controls should not be required to meet all of those conditions -
otherwise it is a standard control.


Of course all statically defined controls, public or private, should be
documented -- says the person who doesn't plan to backfill the
documentation. ;) 

> However, there are a few cases where the ability to have the framework generate
> control IDs for you is actually quite useful.

It seems like it would be useful for developers.

Would it ever be used by non-test/non-debug applications?  In your cases
below, I think UVC cam applications are the only example.


>  Of course, if you do this then
> you can never set controls directly since you do not know the control ID.
> 
> I have identified four use-cases for this:
> 
> - Initial development and testing: it is quite handy to generate the ID while
>   you are still developing your driver.

Yes.

> - In vivi I want to create test controls to use as a test-bed for testing the
>   control framework.  Such test controls really do not belong in videodev2.h.

Hmmm.  I thought the vivi driver was intended to be a learning tool and
example.  I'd suggest heavy documentation and dire warnings in vivi
comments, if the test controls are not being added to the documentation
in some manner.


> - Legacy drivers: do we really want to add the private controls of e.g. indycam.c
>   to videodev2.h and the spec? It is a lot of work for little gain.

I agree that documenting them is probably of little worth.

The problem here is legacy applications, written around specific
drivers, that expect the undocumented private controls to always have
the same id.  Do we need to go through the work of making these old
drivers' private control ID to bounce around, when the result will be
breaking legacy applications for old hardware?


> - Drivers like UVC where controls can be generated.
> 
> The way I have implemented this is that when you create the control you pass
> a special control ID:
> 
> #define V4L2_CID_USER_AUTO      (V4L2_CTRL_CLASS_USER | 0xf000)
> #define V4L2_CID_MPEG_AUTO      (V4L2_CTRL_CLASS_MPEG | 0xf000)
> #define V4L2_CID_CAMERA_AUTO    (V4L2_CTRL_CLASS_CAMERA | 0xf000)
> #define V4L2_CID_FM_TX_AUTO     (V4L2_CTRL_CLASS_FM_TX | 0xf000)
> 
> The framework will then automatically generate a new ID.
> 
> I'm undecided about this one. It definitely has advantages, but it also requires
> extra care when reviewing drivers since this functionality shouldn't be abused.


What are the resources that are being allocated and deallocated - just
the control IDs?

Is there some phase of driver module life, to which such allocations are
restricted, e.g. only at driver probe, or not while the device node is
open?  After an application has discovered private control IDs, are more
just going to pop-up and others disappear?  Will v4l2_event s be
generated when and if they do?

Regards,
Andy

> The patches are available in my tree:
> 
> http://git.linuxtv.org/hverkuil/v4l-dvb.git?a=shortlog;h=refs/heads/ctrlfw
> 
> See the vivi patch for an example of auto-generated control IDs.
> 
> Comments?
> 
> Regards,
> 
> 	Hans
> 


