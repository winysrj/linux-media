Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2295 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756104Ab0DETrm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Apr 2010 15:47:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: RFC: new V4L control framework
Date: Mon, 5 Apr 2010 21:47:47 +0200
Cc: Andy Walls <awalls@md.metrocast.net>, linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <201004041741.51869.hverkuil@xs4all.nl> <4BBA04BB.5030600@redhat.com> <201004052011.13162.hverkuil@xs4all.nl>
In-Reply-To: <201004052011.13162.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201004052147.47477.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 05 April 2010 20:11:13 Hans Verkuil wrote:
> Another option would be to set aside a range of IDs at the end of each control
> class that could be used as a 'remap' area.
> 
> For example: the IDs for user class controls go from 0x980000-0x98ffff. Of
> which anything >= 0x981000 is a private control (i.e. specific to a driver).
> We could set aside 0x98f000-0x98ffff for remapped controls.
> 
> So if you want to make a subdev's volume control available as a secondary
> control you can do something like this:
> 
> v4l2_ctrl_add_ctrl_remap(struct v4l2_ctrl_handler *hdl,
> 			 struct v4l2_ctrl_info *cinfo,
> 			 const char *fmt);
> 
> The framework will pick a new ID from the remap range and add this control
> with the name created using snprintf(fmt, sz, cinfo->name). Since this control
> is remapped as a private control it will be seen by old applications as well
> since they just iterate from V4L2_CID_PRIVATE_BASE, and the framework handles
> that transparently.
> 
> It is even possible to do this for all controls from a subdev, e.g.:
> 
> v4l2_ctrl_add_handler_remap(struct v4l2_ctrl_handler *hdl,
> 			    struct v4l2_ctrl_handler *add,
> 			    const char *fmt);
> 
> Every control in 'add' that already exists in 'hdl' would then be remapped
> and a new name is generated.

I implemented this scheme in this tree:

http://linuxtv.org/hg/~hverkuil/v4l-dvb-fw-remap/

I also hacked vivi to use this. After creating a second handler with volume,
mute and saturation controls I added this line to merge the two:

v4l2_ctrl_add_handler_remap(&dev->hdl, &dev->hdl2, "Secondary %s");

The end result is this:

$ v4l2-ctl --list-ctrls

User Controls

                     brightness (int)  : min=0 max=255 step=1 default=127 value=127 flags=slider
                       contrast (int)  : min=0 max=255 step=1 default=16 value=16 flags=slider
                     saturation (int)  : min=0 max=255 step=1 default=127 value=127 flags=slider
                            hue (int)  : min=-128 max=127 step=1 default=0 value=0 flags=slider
                         volume (int)  : min=0 max=255 step=1 default=200 value=200 flags=slider
                           mute (bool) : default=1 value=1
           integer_test_control (int)  : min=-2147483648 max=2147483647 step=1 default=0 value=0
              toggle_text_color (bool) : default=0 value=0
                       press_me (btn)  : flags=write-only
              menu_test_control (menu) : min=0 max=5 default=1 value=1
         integer64_test_control (int64): value=0
            string_test_control (str)  : min=0 max=100 step=2 value=''
               secondary_volume (int)  : min=0 max=128 step=1 default=20 value=20 flags=slider
           secondary_saturation (int)  : min=100 max=200 step=1 default=150 value=150 flags=slider

So mute was added unchanged while volume and saturation were remapped automatically.
And they showed up in xawtv as well.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
