Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:59081 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab0CAI4f (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Mar 2010 03:56:35 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: How do private controls actually work?
Date: Mon, 1 Mar 2010 09:57:47 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <829197381002281856o749e3e9al36334b8b42b34562@mail.gmail.com>
In-Reply-To: <829197381002281856o749e3e9al36334b8b42b34562@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003010957.49198.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Devin,

On Monday 01 March 2010 03:56:17 Devin Heitmueller wrote:
> This might seem like a bit of a silly question, but I've been banging
> my head on the wall for a while on this.
> 
> I need to add a single private control to the saa7115 driver.
> However, it's not clear to me exactly how this is supposed to work.
> 
> The v4l2-ctl program will always use the extended controls interface
> for private controls, since the code only uses the g_ctrl ioctl if the
> class is V4L2_CTRL_CLASS_USER (and the control class for private
> controls is V4L2_CID_PRIVATE_BASE).
> 
> However, if you look at the actual code in v4l2-ioctl.c, the call for
> g_ext_ctrls calls check_ext_ctrls(), which fails because
> "V4L2_CID_PRIVATE_BASE cannot be used as control class when using
> extended controls."
> 
> The above two behaviors would seem to be conflicting.

I don't think it should matter which API (the base one or the extended one) 
you use for controls, be they private, standard or whatever. I don't see a 
reason for disallowing some controls to be used through one or the other API.

> My original plan was to implement it as a non-extended control, but
> the v4l2-ctl application always sent the get call using the extended
> interface.  So then I went to convert saa7115 to use the extended
> control interface, but then found out that the v4l2 core wouldn't
> allow an extended control to use a private control number.
> 
> To make matters worse, the G_CTRL function that supposedly passes
> through calls to vidioc_g_ext_ctrl also calls check_ext_ctrl(), so if
> you want to have a private control then you would need to implement
> both the extended controls interface and the older g_ctrl in the
> driver (presumably the idea was that you would be able to only need to
> implement an extended controls interface, but that doesn't work given
> the above).
> 
> I can change v4l2-ctl to use g_ctrl for private controls if we think
> that is the correct approach.  But I didn't want to do that until I
> knew for sure that it is correct that you can never have a private
> extended control.

Do we have extended *controls* ? All I see today is two APIs to access 
controls, a base *control API* and an extended *control API*. G_CTRL/S_CTRL 
should always be available to userspace. If you want to set a single control, 
the extended API isn't required.

-- 
Regards,

Laurent Pinchart
