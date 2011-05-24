Return-path: <mchehab@pedra>
Received: from casper.infradead.org ([85.118.1.10]:34837 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932466Ab1EXOKh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 May 2011 10:10:37 -0400
Message-ID: <4DDBBC29.80009@infradead.org>
Date: Tue, 24 May 2011 11:09:45 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>
Subject: Re: [ANNOUNCE] experimental alsa stream support at xawtv3
References: <4DDAC0C2.7090508@redhat.com> <201105240850.35032.hverkuil@xs4all.nl> <4DDB5C6B.6000608@redhat.com>
In-Reply-To: <4DDB5C6B.6000608@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 24-05-2011 04:21, Hans de Goede escreveu:
> Hi,
 
> My I suggest that we instead just copy over the single get_media_devices.c
> file to xawtv, and not install the not so much a lib lib ?

If we do that, then all other places where the association between an alsa device
and a video4linux node is needed will need to copy it, and we'll have a fork.
Also, we'll keep needing it at v4l-utils, as it is now needed by the new version
of v4l2-sysfs-path tool.

Btw, this lib were created due to a request from the vlc maintainer that something
like that would be needed. After finishing it, I decided to add it at xawtv in order
to have an example about how to use it.

> Mauro, I plan to do a new v4l-utils release soon (*), maybe even today. I
> consider it unpolite to revert other peoples commits, so I would prefer for you
> to revert the install libv4l2util.a patch yourself. But if you don't (or don't
> get around to doing it before I do the release), I will revert it, as this
> clearly needs more discussion before making it into an official release
> tarbal (we can always re-introduce the patch after the release).

I'm not a big fan or exporting the rest of stuff at libv4l2util.a either, but I
think that at least the get_media_devices stuff should be exported somewhere,
maybe as part of libv4l.

Anyway, as you're releasing today a new v4l-utils, I agree that it is too early
to add such library, as it is still experimental. I'm not considering make any
new xawtv release those days, so I'm OK to postpone it.

I'll commit a few patches commenting the install procedure for now, re-adding it
after the release, for those that want to experiment it with xawtv with the new
support.

Cheers,
Mauro
