Return-path: <mchehab@pedra>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2608 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab1AWQNs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Jan 2011 11:13:48 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [RFC PATCH 2/3] v4l2-ctrls: add v4l2_ctrl_auto_cluster to simplify autogain/gain scenarios
Date: Sun, 23 Jan 2011 17:13:33 +0100
Cc: linux-media@vger.kernel.org
References: <1295694361-23237-1-git-send-email-hverkuil@xs4all.nl> <ad0ec022eea20f19d3936a10268d429b1be57980.1295693790.git.hverkuil@xs4all.nl> <4D3C45F7.4040103@redhat.com>
In-Reply-To: <4D3C45F7.4040103@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101231713.33776.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sunday, January 23, 2011 16:15:03 Hans de Goede wrote:
> Hi,
> 
> On 01/22/2011 12:06 PM, Hans Verkuil wrote:
> > It is a bit tricky to handle autogain/gain type scenerios correctly. Such
> > controls need to be clustered and the V4L2_CTRL_FLAG_UPDATE should be set on
> > the non-auto controls. If you set a non-auto control without setting the
> > auto control at the same time, then the auto control should switch to manual
> > mode. And usually the non-auto controls must be marked volatile, but this should
> > only be in effect if the auto control is set to auto.
> >
> > The chances of drivers doing all these things correctly are pretty remote.
> > So a new v4l2_ctrl_auto_cluster function was added that takes care of these
> > issues.
> 
> I like the concept of this, but I'm not so happy with the automatically put
> the auto control in manual mode. We've discussed this before and iirc we
> came to the conclusion then that the proper thing to do is to mark the
> controls as read only, when the related auto control is in auto mode.
> 
> This is what the UVC spec for example mandates and what the current UVC driver
> does. Combining this with an app which honors the update and the read only
> flag (try gtk-v4l), results in a nice experience. User enables auto exposure
> -> exposure control gets grayed out, put exposure back manual -> control
> is ungrayed.
> 
> So this new auto_cluster behavior would be a behavioral change (for both the
> uvc driver and several gspca drivers), and more over an unwanted one IMHO
> setting one control should not change another as a side effect.

Actually, I've been converting a whole list of subdev drivers recently (soc_camera,
ov7670) and they all behaved like this. So I didn't change anything.

There is nothing preventing other drivers from doing something different.

That said, changing the behavior to your proposal may not be such a bad idea.
But then I need the OK from all driver authors involved, since this would
mean a change of behavior for them.

The good news is that once they use the new framework function I only need
to change what that function does and I don't need to change any of those
drivers.

So I will proceed for now by converting those drivers to use this new function,
and at the same time I can contact the authors and ask what their opinion is
of this change. I'm hoping for more feedback as well from what others think.

BTW, if I understand the gspca code correctly then it seems that if an e.g.
autogain control is set to 1, then the gain control effectively disappears.
I think queryctrl will just never return it. That can't be right.

I tried to test it but while my zc3xx-based webcam has autogain there is
interestingly enough no corresponding manual gain control.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
