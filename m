Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55352 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944Ab1EXRq7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2011 13:46:59 -0400
Received: by eyx24 with SMTP id 24so2309649eyx.19
        for <linux-media@vger.kernel.org>; Tue, 24 May 2011 10:46:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <583195.8777.qm@web29520.mail.ird.yahoo.com>
References: <583195.8777.qm@web29520.mail.ird.yahoo.com>
Date: Tue, 24 May 2011 13:46:57 -0400
Message-ID: <BANLkTimcgdddXX3oJcot1vTTk+4_AaBo3g@mail.gmail.com>
Subject: Re: [ANNOUNCE] experimental alsa stream support at xawtv3
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Emil Meier <emil276me@yahoo.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, May 24, 2011 at 1:26 PM, Emil Meier <emil276me@yahoo.com> wrote:
> Are there mechanisms for device-locking in the v4l api? With my 2 hybrid saa7134 cards I have observed exactly this issues in Mythtv and also in xawtv and kaffeine....
> At the moment I disable one device via additional card definitions and modprobe-parameters, so that the other one is "alone" and only one app gets control over the tuner.

There is currently no infrastructure for doing this in the core
framework.  It varies on based on the bridge.  For example, the
saa7164 bridge driver won't let you do it (by design it returns
-EBUSY), but I believe almost all of the others will.  And of course
with no locking the net result is completely unpredictable results as
you attempt to issue a tuning request on one side while the other side
is already in use.

Worth noting that at least in MythTV you can work around the issue in
userland by putting both the V4L and DVB device into the same input
group.  That prevents MythTV from attempting to use both devices at
the same time.

> But this driver (saa7134) seams not even lock the /dev/video0 correctly, as starting xawtv twice renders the card inoperable and forces rebooting to get the card working again...

Probably worth noting that it is actually legal to have multiple
callers open a V4L2 device.  The EBUSY condition only occurs when
initiating streaming.  This is why you can have an application like
mplayer playing the video while at the same time using a command line
tool to change the channel.

That said, if the card is rendered inoperable until reboot, then
you've hit some sort of bug.

> Is there a good starting point to implement the locking?

Not really:  there isn't really any locking framework today which
spans both DVB and V4L.

There are really two different aspects to this problem:

The first is applications being able to tell what DVB and V4L devices
are related so that they know that they cannot even attempt to use
them at the same time.  This is necessary for stuff like MythTV so
that it's scheduler can know a conflict exists ahead of time instead
of waiting until actually attempting to do the record.

The second aspect is making sure that you simply can never actually
use both devices at the same time.  This is really about reliability -
locking to ensure that two callers don't screw up the state of the
tuner.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
