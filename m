Return-path: <mchehab@pedra>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:4735 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab1AHLCD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Jan 2011 06:02:03 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: [RFCv2 PATCH 0/5] Use control framework in cafe_ccic and s_config removal
Date: Sat,  8 Jan 2011 12:01:43 +0100
Message-Id: <1294484508-14820-1-git-send-email-hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Second version of this patch. Changes are:

- Handle the return code of the internal 'registered' op and 'unregistered'
now returns a void.
- has_new has been renamed to is_new and is documented and no longer internal.

Original cover letter:

Hi Jon, Laurent,

This patch series converts the OLPC cafe_ccic driver to the new control
framework. It turned out that this depended on the removal of the legacy
s_config subdev operation. I originally created the ov7670 controls in
s_config, but it turned out that s_config is called after v4l2_device_register_subdev,
so v4l2_device_register_subdev is unable to 'inherit' the ov7670 controls
in cafe_ccic since there aren't any yet.

Another reason why s_config is a bad idea.

So the first patch removes s_config and v4l2_i2c_new_subdev_cfg and converts
any users (cafe_ccic/ov7670 among them) to v4l2_i2c_new_subdev_board, which is
what God (i.e. Jean Delvare) intended. :-)

The second patch adds the (un)register internal ops allowing subdev drivers to
do some work after the subdevice is registered with a v4l2_device. So here the
sd->v4l2_dev pointer is set. Laurent, is this sufficient for the upcoming omap3
sub-devices?

The third patch fixes a small bug in v4l2_ctrl_handler_setup() that is required
for the ov7670 conversion. This bug does not affect any existing drivers.

The last two patches convert ov7670 and cafe_ccic to the V4L2 control framework.

This saves over a 100 lines of code and adds full support of the control API
(including extended controls) to the drivers.

This has been extensively tested on my humble OLPC laptop (and it took me 4-5
hours just to get the damn thing up and running with these drivers).

Special attention was given to the handling of gain/autogain and
exposure/autoexposure.

The way this works is that setting the gain on its own will turn off autogain
(this conforms to the current behavior of ov7670), setting autogain and gain
atomically will only set the gain if autogain is set to manual.

Ditto for exposure/autoexposure.

The only question is: is the current behavior of implicitly turning off autogain
when setting a new gain value correct? I think setting the gain in that case
should do nothing.

On the other hand, I don't know if there is any code that depends on this
behavior, so perhaps we should just leave it as is.

Jon, can you take a look and let me know if it is OK with you?

Regards,

        Hans

