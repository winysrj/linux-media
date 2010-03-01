Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:38618 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab0CAC4T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Feb 2010 21:56:19 -0500
Received: by bwz1 with SMTP id 1so87184bwz.21
        for <linux-media@vger.kernel.org>; Sun, 28 Feb 2010 18:56:18 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 28 Feb 2010 21:56:17 -0500
Message-ID: <829197381002281856o749e3e9al36334b8b42b34562@mail.gmail.com>
Subject: How do private controls actually work?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This might seem like a bit of a silly question, but I've been banging
my head on the wall for a while on this.

I need to add a single private control to the saa7115 driver.
However, it's not clear to me exactly how this is supposed to work.

The v4l2-ctl program will always use the extended controls interface
for private controls, since the code only uses the g_ctrl ioctl if the
class is V4L2_CTRL_CLASS_USER (and the control class for private
controls is V4L2_CID_PRIVATE_BASE).

However, if you look at the actual code in v4l2-ioctl.c, the call for
g_ext_ctrls calls check_ext_ctrls(), which fails because
"V4L2_CID_PRIVATE_BASE cannot be used as control class when using
extended controls."

The above two behaviors would seem to be conflicting.

My original plan was to implement it as a non-extended control, but
the v4l2-ctl application always sent the get call using the extended
interface.  So then I went to convert saa7115 to use the extended
control interface, but then found out that the v4l2 core wouldn't
allow an extended control to use a private control number.

To make matters worse, the G_CTRL function that supposedly passes
through calls to vidioc_g_ext_ctrl also calls check_ext_ctrl(), so if
you want to have a private control then you would need to implement
both the extended controls interface and the older g_ctrl in the
driver (presumably the idea was that you would be able to only need to
implement an extended controls interface, but that doesn't work given
the above).

I can change v4l2-ctl to use g_ctrl for private controls if we think
that is the correct approach.  But I didn't want to do that until I
knew for sure that it is correct that you can never have a private
extended control.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
