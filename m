Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:55573 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab0CAKUL (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Mar 2010 05:20:11 -0500
Received: by bwz1 with SMTP id 1so234424bwz.21
        for <linux-media@vger.kernel.org>; Mon, 01 Mar 2010 02:20:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <49ae9be6ffaaac102dc02f94f2fd047c.squirrel@webmail.xs4all.nl>
References: <829197381002281856o749e3e9al36334b8b42b34562@mail.gmail.com>
	 <201003010957.49198.laurent.pinchart@ideasonboard.com>
	 <829197381003010107m79ff65bajde4da911eafc6740@mail.gmail.com>
	 <49ae9be6ffaaac102dc02f94f2fd047c.squirrel@webmail.xs4all.nl>
Date: Mon, 1 Mar 2010 05:20:09 -0500
Message-ID: <829197381003010220w57248cb2l636a75d5bf4b19c1@mail.gmail.com>
Subject: Re: How do private controls actually work?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 1, 2010 at 4:58 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> New private controls should not use V4L2_CID_PRIVATE_BASE at all. That
> mechanism was a really bad idea. Instead a new control should be added to
> the appropriate control class and with a offset >= 0x1000. See for example
> the CX2341X private controls in videodev2.h.

So, you're suggesting that the following patch then is going to be
NAK'd and that I'm going to have to go back and convert saa7115 to
support the extended controls API, extend the em28xx driver to support
the extended controls API, and retest with all the possible
applications given how they might potentially be attempting to
implement the rather poorly documented interface?

http://kernellabs.com/hg/~dheitmueller/em28xx-test/rev/a7d50db75420

And exactly what "class" of extended controls should I use for video
decoders?  It would seem that a video decoder doesn't really fall into
any of the existing categories - "Old-style user controls", "MPEG
compression controls", "Camera controls", or "FM modulator controls".
Are we saying that now I'm also going to be introducing a whole new
class of control too?

> The EXT_G/S_CTRLS ioctls do not accept PRIVATE_BASE because I want to
> force driver developers to stop using PRIVATE_BASE. So only G/S_CTRL will
> support controls in that range for backwards compatibility.

While we're on the topic, do you see any problem with the proposed fix
for the regression you introduced?:

http://kernellabs.com/hg/~dheitmueller/em28xx-test/rev/142ae5aa9e8e

Between trying to figure out what the expected behavior is supposed to
be (given the complete lack of documentation on how private controls
are expected to be implemented in the extended controls API) and
isolating and fixing the regression, it's hard not to be a little
irritated at this situation.  This was supposed to be a very small
change - a single private control to a mature driver.  And now it
seems like I'm going to have to extend the basic infrastructure in the
decoder driver, the bridge driver, add a new class of controls, all so
I can poke one register?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
