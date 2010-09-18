Return-path: <mchehab@pedra>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:2555 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874Ab0IRMTr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 18 Sep 2010 08:19:47 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: RFC: control framework enhancements
Date: Sat, 18 Sep 2010 14:19:32 +0200
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201009181419.32888.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi all,

This weekend I started converting drivers to the new control framework. While
doing that I realized that the control framework needs a few enhancements.

The first one is missing functionality: some drivers use different subdevs
for different inputs. The vino driver is one of those (it uses either the
indycam subdev or the saa7191 subdev). Changing input means that the controls
also change. This functionality is part of the V4L2 spec, in fact.

If it was just the very old vino driver, then I might have ignored this, but
I know that the TI dm6467 evaluation board has similar behavior.

So we need a way to enable or disable controls. Changing inputs would then just
disable all the controls of the subdev controlling the old input and enable all
controls of the subdev controlling the new input.

Since both subdevs may have identical controls (e.g. both may have a brightness
control), the control framework needs to be able to handle that as well.

In order to support this functionality I've added the following two functions:

/** v4l2_ctrl_enable() - Mark the control as enabled or disabled.
  * @ctrl:      The control to en/disable.
  * @enabled:   True if the control should become enabled.
  *
  * Enable/disable a control.
  * Does nothing if @ctrl == NULL.
  * Usually called if controls are to be enabled or disabled when changing
  * to a different input or output.
  *
  * When a control is disabled, then it will no longer show up in the
  * application.
  *
  * This function can be called regardless of whether the control handler
  * is locked or not.
  */
void v4l2_ctrl_enable(struct v4l2_ctrl *ctrl, bool enabled);

/** v4l2_ctrl_handler_enable() - Mark the controls in the handler as enabled or disabled.
  * @hdl:       The control handler.
  * @enabled:   True if the controls should become enabled.
  *
  * Enable/disable the controls owned by the handler.
  * Does nothing if @hdl == NULL.
  * Usually called if controls are to be enabled or disabled when changing
  * to a different input or output.
  *
  * When a control is disabled, then it will no longer show up in the
  * application.
  */
void v4l2_ctrl_handler_enable(struct v4l2_ctrl_handler *hdl, bool enabled);

And internally I allow for duplicate control references. The first enabled
control will win.

If no one objects, then I want to merge this for 2.6.37.

The second enhancement is one I am not sure about. It concerns private controls.
The basic guideline for drivers is that private controls need to be added to
videodev2.h and documented in the spec. So private controls are well defined,
and their control ID is fixed so they can set directly by an application.

However, there are a few cases where the ability to have the framework generate
control IDs for you is actually quite useful. Of course, if you do this then
you can never set controls directly since you do not know the control ID.

I have identified four use-cases for this:

- Initial development and testing: it is quite handy to generate the ID while
  you are still developing your driver.
- In vivi I want to create test controls to use as a test-bed for testing the
  control framework.  Such test controls really do not belong in videodev2.h.
- Legacy drivers: do we really want to add the private controls of e.g. indycam.c
  to videodev2.h and the spec? It is a lot of work for little gain.
- Drivers like UVC where controls can be generated.

The way I have implemented this is that when you create the control you pass
a special control ID:

#define V4L2_CID_USER_AUTO      (V4L2_CTRL_CLASS_USER | 0xf000)
#define V4L2_CID_MPEG_AUTO      (V4L2_CTRL_CLASS_MPEG | 0xf000)
#define V4L2_CID_CAMERA_AUTO    (V4L2_CTRL_CLASS_CAMERA | 0xf000)
#define V4L2_CID_FM_TX_AUTO     (V4L2_CTRL_CLASS_FM_TX | 0xf000)

The framework will then automatically generate a new ID.

I'm undecided about this one. It definitely has advantages, but it also requires
extra care when reviewing drivers since this functionality shouldn't be abused.

The patches are available in my tree:

http://git.linuxtv.org/hverkuil/v4l-dvb.git?a=shortlog;h=refs/heads/ctrlfw

See the vivi patch for an example of auto-generated control IDs.

Comments?

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG, part of Cisco
