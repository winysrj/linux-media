Return-path: <mchehab@pedra>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:3852 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab1AYUyO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Jan 2011 15:54:14 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [RFC PATCH 2/3] v4l2-ctrls: add v4l2_ctrl_auto_cluster to simplify autogain/gain scenarios
Date: Tue, 25 Jan 2011 21:53:52 +0100
Cc: linux-media@vger.kernel.org
References: <1295694361-23237-1-git-send-email-hverkuil@xs4all.nl> <201101231713.33776.hverkuil@xs4all.nl> <4D3F346B.9000102@redhat.com>
In-Reply-To: <4D3F346B.9000102@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101252153.52847.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday, January 25, 2011 21:36:59 Hans de Goede wrote:
> Hi,
> 
> On 01/23/2011 05:13 PM, Hans Verkuil wrote:
> > On Sunday, January 23, 2011 16:15:03 Hans de Goede wrote:
> 
> <snip>
> 
> >> This is what the UVC spec for example mandates and what the current UVC driver
> >> does. Combining this with an app which honors the update and the read only
> >> flag (try gtk-v4l), results in a nice experience. User enables auto exposure
> >> ->  exposure control gets grayed out, put exposure back manual ->  control
> >> is ungrayed.
> >>
> >> So this new auto_cluster behavior would be a behavioral change (for both the
> >> uvc driver and several gspca drivers), and more over an unwanted one IMHO
> >> setting one control should not change another as a side effect.
> >
> > Actually, I've been converting a whole list of subdev drivers recently (soc_camera,
> > ov7670) and they all behaved like this. So I didn't change anything.
> 
> Hmm, interesting.
> 
> > There is nothing preventing other drivers from doing something different.
> >
> > That said, changing the behavior to your proposal may not be such a bad idea.
> 
> Yes and AFAIK this is what we agreed on when we discussed auto control a
> couple of months ago.
> 
> > But then I need the OK from all driver authors involved, since this would
> > mean a change of behavior for them.
> >
> > The good news is that once they use the new framework function I only need
> > to change what that function does and I don't need to change any of those
> > drivers.
> >
> > So I will proceed for now by converting those drivers to use this new function,
> > and at the same time I can contact the authors and ask what their opinion is
> > of this change. I'm hoping for more feedback as well from what others think.
> >
> 
> Yes, contacting the authors to discuss this further sounds like a good idea.
> 
> > BTW, if I understand the gspca code correctly then it seems that if an e.g.
> > autogain control is set to 1, then the gain control effectively disappears.
> > I think queryctrl will just never return it. That can't be right.
> 
> Erm, it should not disappear, but just get disabled. But this may have
> (accidentally) changed with the drivers which were converted to the new
> control framework.

gspca doesn't use the control framework at all. Or are you talking about a
gspca-internal change in control handling?

> Anyways, we should discuss this with involved driver
> authors and agree on a standard way to handle this. Once we have agreement
> on how to handle this converting the drivers should be relatively easy.

Yes, I'll continue working on this.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
