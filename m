Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61535 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233Ab1EXO5Y (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2011 10:57:24 -0400
Received: by eyx24 with SMTP id 24so2204713eyx.19
        for <linux-media@vger.kernel.org>; Tue, 24 May 2011 07:57:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201105240850.35032.hverkuil@xs4all.nl>
References: <4DDAC0C2.7090508@redhat.com>
	<201105240850.35032.hverkuil@xs4all.nl>
Date: Tue, 24 May 2011 10:57:22 -0400
Message-ID: <BANLkTikFROSj8LBeCs=Ep1R-HFEEFGOYZw@mail.gmail.com>
Subject: Re: [ANNOUNCE] experimental alsa stream support at xawtv3
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, May 24, 2011 at 2:50 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Monday, May 23, 2011 22:17:06 Mauro Carvalho Chehab wrote:
>> Due to the alsa detection code that I've added at libv4l2util (at v4l2-utils)
>> during the weekend, I decided to add alsa support also on xawtv3, basically
>> to provide a real usecase example. Of course, for it to work, it needs the
>> very latest v4l2-utils version from the git tree.
>
> Please, please add at the very least some very big disclaimer in libv4l2util
> that the API/ABI is likely to change. As mentioned earlier, this library is
> undocumented, has not gone through any peer-review, and I am very unhappy with
> it and with the decision (without discussion it seems) to install it.
>
> Once you install it on systems it becomes much harder to change.

I share Hans' concern on this.  This is an API that seems pretty
immature, and I worry that it's adoption will cause lots of problems
as people expect it to work with a wide variety of tuners.

For example, how does the sysfs approach handle PCI boards that have
multiple video and audio devices?  The sysfs layout will effectively
be:

PCI DEVICE
-> video0
-> video1
-> alsa hw:1,0
-> alsa hw:1,1

The approach taken in this library will probably help with the simple
cases such as a USB tuner that only has a single video device, audio
device, and VBI device.  But it's going to fall flat on its face when
it comes to devices that have multiple capture sources (since sysfs
will represent this as a tree with all the nodes on the same level).

Oh, and how is it expected to handle informing the application about
device contention between DVB and V4L?  Some devices share the tuner
and therefore you cannot use both the V4L and DVB device at the same
time.  Other products have two independent input paths on the same
board, allowing both to be used simultaneously (the HVR-1600 is a
popular example of this).  Sysfs isn't going to tell you this
information, which is why in the MC API we explicitly added the notion
of device groups (so the driver author can explicitly state the
relationships).

Today MythTV users accomplish this by manually specifying "Input
Groups".  I say that's what they do, but in reality they don't realize
that they need to configure MythTV this way until they complain that
MythTV recordings fail when trying to record programs on both inputs,
at which point an advanced user points it out to them.  End users
shouldn't have to understand the internal architecture of their
capture card just to avoid weird crashy behavior (which is what often
happens if you try to use both devices simultaneously since almost no
hybrid drivers do proper locking).

I am in favor of this finally getting some attention, but the reality
is that sysfs isn't going to cut it.  It just doesn't expose enough
information about the underlying hardware layout.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
