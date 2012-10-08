Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36797 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab2JHPH0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Oct 2012 11:07:26 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so2110870bkc.19
        for <linux-media@vger.kernel.org>; Mon, 08 Oct 2012 08:07:25 -0700 (PDT)
From: Florian Fainelli <f.fainelli@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
	dri-devel@lists.freedesktop.org
Subject: Re: Update on the CEC API
Date: Mon, 08 Oct 2012 17:06:20 +0200
Message-ID: <2013064.dUp2SJ3pm9@flexo>
In-Reply-To: <201209271633.30812.hverkuil@xs4all.nl>
References: <201209271633.30812.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thursday 27 September 2012 16:33:30 Hans Verkuil wrote:
> Hi all,
> 
> During the Linux Plumbers Conference we (i.e. V4L2 and DRM developers) had a
> discussion on how to handle the CEC protocol that's part of the HDMI 
standard.
> 
> The decision was made to create a CEC bus with CEC clients, each represented
> by a /dev/cecX device. So this is independent of the V4L or DRM APIs. 
> 
> In addition interested subsystems (alsa for the Audio Return Channel, and
> possibly networking as well for ethernet over HDMI) can intercept/send CEC
> messages as well if needed. Particularly for the CEC additions made in
> HDMI 1.4a it is no longer possible to handle the CEC protocol completely in
> userspace, but part of the intelligence has to be moved to kernelspace.

What kind of "intelligence" are you talking about? I see nothing in HDMI 1.4a 
or earlier that requires doing stuff in kernelspace besides managing control to 
the hardware, but I might be missing something.

In my opinion ARC is just a control mechanism, and can be dealt with in user-
space, since you really want to just have hints about when ARC is 
enabled/disabled to take appropriate actions on the audio outputs or your 
system.

> 
> I've started working on this API but I am still at the stage of playing
> around with it and thinking about the best way this functionality should
> be exposed. At least I managed to get the first CEC packets transferred
> today :-)
> 
> It will probably be a few weeks before I post something, but in the meantime
> if you want to use CEC and have certain requirements that need to be met,
> please let me know. If only so that I can be certain I haven't forgotten
> anything.

Here is my wish-list, if I may:
- allow for a CEC adapter to be in "detached" / "attached" mode, particularly 
useful if the hardware doing CEC can process a basic set of messages to act a 
a global wake-up source for the system

- allow for a CEC adapter to define several receive modes: unicast and 
"promiscuous", which is useful for dumping the CEC bus messages

- make the CEC adapter API asynchronous for the data path, so it is easy for a 
driver to report completion of a successfully transmitted/received CEC frame

Thank you!
--
Florian
