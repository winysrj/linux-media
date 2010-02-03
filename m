Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:48654 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757333Ab0BCP5V (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Feb 2010 10:57:21 -0500
Received: by bwz19 with SMTP id 19so141633bwz.28
        for <linux-media@vger.kernel.org>; Wed, 03 Feb 2010 07:57:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B68C35F.1080902@redhat.com>
References: <829197381002021451g5aaa8013kd5ae2124534ba5ba@mail.gmail.com>
	 <4B68C35F.1080902@redhat.com>
Date: Wed, 3 Feb 2010 10:57:20 -0500
Message-ID: <829197381002030757k1cea81b7vb214b87cffc213aa@mail.gmail.com>
Subject: Re: Any saa711x users out there?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 2, 2010 at 7:29 PM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> The better is to allow enabling/disabling the anti-alias via ctrl.
> Whatever default is chosen, the driver may adjust the control default
> at the board initialization, or even blocking the control when the
> other mode of operation is broken.
>
> I have here a few devices with saa7113 and saa7114. I think I have
> also one device with saa7111, but I need to check. If I'm right, it will
> take some time for me to prepare the saa7111 environment. The saa7113/7114
> devices are easier to setup, as they are usb.

I actually am not very familiar with how custom controls work for v4l
devices in terms of board specific configuration, as I'm more familiar
with the way that you can provide a config struct during dvb_attach()
for DVB devices.  I've obviously seen how they can be set from
userland, but have never dug into the specific as to how a bridge
would set the parameters.

I actually have a test tree here which includes the change (as well as
a couple of unrelated em28xx fixes I'm working on).

http://www.kernellabs.com/hg/~dheitmueller/em28xx-test

The change in that tree just flips on the Anti-alias filter bit in the
saa7115_misc_init struct, so it ends up being applied for
7113/7114/7115.  However, I'm wondering if it makes sense to just have
it on by default for all three boards (which is a *much* simpler
change than adding a custom control and making sure it gets set
properly by the bridge in all the various cases such as surviving a
powerdown/powerup of the chip).

BTW, the tree above just forces the bit on for all three boards - I'm
not proposing that should be the final fix, but it is enough to allow
people to evaluate the effects of the change.

I've got a PVR-350 board with a saa7115 which I will do some testing
on.  If I see the artifacts on that board without the change, that
bolsters the argument that the current default may just be wrong in
general.

Mauro, the hg logs suggest that you added the saa7115 support (and in
fact appear to have introduced the issue in question).  Do you
remember what board you were using when you added the support?  Also,
how did you arrive at the defaults that you used?  Were they based on
some sort of i2c bus trace, or did you just set them by reading the
datasheet?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
