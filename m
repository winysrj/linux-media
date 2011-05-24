Return-path: <mchehab@pedra>
Received: from nm3-vm0.bullet.mail.ird.yahoo.com ([77.238.189.213]:25434 "HELO
	nm3-vm0.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754582Ab1EXRb4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2011 13:31:56 -0400
Message-ID: <583195.8777.qm@web29520.mail.ird.yahoo.com>
Date: Tue, 24 May 2011 18:26:00 +0100 (BST)
From: Emil Meier <emil276me@yahoo.com>
Subject: Re: [ANNOUNCE] experimental alsa stream support at xawtv3
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


--- On Tue, 24/5/11, Devin Heitmueller <dheitmueller@kernellabs.com> wrote:

> From: Devin Heitmueller <dheitmueller@kernellabs.com>
> Subject: Re: [ANNOUNCE] experimental alsa stream support at xawtv3
> To: "Hans Verkuil" <hverkuil@xs4all.nl>
> Cc: "Mauro Carvalho Chehab" <mchehab@redhat.com>, "Linux Media Mailing List" <linux-media@vger.kernel.org>
> Date: Tuesday, 24 May, 2011, 16:57
> On Tue, May 24, 2011 at 2:50 AM, Hans
> 
> Oh, and how is it expected to handle informing the
> application about
> device contention between DVB and V4L?  Some devices
> share the tuner
> and therefore you cannot use both the V4L and DVB device at
> the same
> time.  Other products have two independent input paths
> on the same
> board, allowing both to be used simultaneously (the
> HVR-1600 is a
> popular example of this).  Sysfs isn't going to tell
> you this
> information, which is why in the MC API we explicitly added
> the notion
> of device groups (so the driver author can explicitly state
> the
> relationships).
> 
> Today MythTV users accomplish this by manually specifying
> "Input
> Groups".  I say that's what they do, but in reality
> they don't realize
> that they need to configure MythTV this way until they
> complain that
> MythTV recordings fail when trying to record programs on
> both inputs,
> at which point an advanced user points it out to
> them.  End users
> shouldn't have to understand the internal architecture of
> their
> capture card just to avoid weird crashy behavior (which is
> what often
> happens if you try to use both devices simultaneously since
> almost no
> hybrid drivers do proper locking).

Are there mechanisms for device-locking in the v4l api? With my 2 hybrid saa7134 cards I have observed exactly this issues in Mythtv and also in xawtv and kaffeine....
At the moment I disable one device via additional card definitions and modprobe-parameters, so that the other one is "alone" and only one app gets control over the tuner. 

But this driver (saa7134) seams not even lock the /dev/video0 correctly, as starting xawtv twice renders the card inoperable and forces rebooting to get the card working again...
 
Is there a good starting point to implement the locking?

> I am in favor of this finally getting some attention, but
> the reality
> is that sysfs isn't going to cut it.  It just doesn't
> expose enough
> information about the underlying hardware layout.
> 
> Devin
> 
> -- 
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
Emil

