Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37400 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab1IFSlG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2011 14:41:06 -0400
Received: by bke11 with SMTP id 11so5685075bke.19
        for <linux-media@vger.kernel.org>; Tue, 06 Sep 2011 11:41:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E666417.9090706@redhat.com>
References: <1315322996-10576-1-git-send-email-mchehab@redhat.com>
	<4E663EE2.3050403@redhat.com>
	<CAGoCfiz9YAHYNJdEAT51fyfLY8RS_TcRpzKzLYCdNFCc3JcbEA@mail.gmail.com>
	<4E666417.9090706@redhat.com>
Date: Tue, 6 Sep 2011 14:41:03 -0400
Message-ID: <CAGoCfiy9QK1vcrDSBw7J382LXAdE+YzN3SdAu+fCkD-6-8M8=g@mail.gmail.com>
Subject: Re: [PATCH 01/10] alsa_stream: port changes made on xawtv3
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 6, 2011 at 2:19 PM, Hans de Goede <hdegoede@redhat.com> wrote:
> I think that what should be done is contact the debian / ubuntu maintainers,
> get any interesting fixes they have which the kl version misses merged,
> and then just declare the kl version as being the new official upstream
> (with the blessing of the debian / ubuntu guys, and if possible also
> with the blessing of the original authors).

It has always been my intention to get the Debian/Ubuntu patches
merged (as well as other distros).  My thoughts behind renaming were
oriented around the notion that that there are more distros out there
than just Fedora/Ubuntu/Debian, but that may be something that isn't
really a concern.  Also, I had no idea whether the distros would
actually switch over to the Kernel Labs version as the official
upstream source, so providing it under a different name would in
theory allow both packages to be available in parallel.

>From a practical standpoint, the Ubuntu folks have the original tvtime
tarball and all their changes in one patch, which is clearly a bunch
of patches that are mashed together probably in their build system.  I
need to reach out to them to find where they have an actual SCM tree
or the individual patches.  They've got a bunch of patches which would
be good to get into a single tree (autobuild fixes, cross-compilation,
locale updates, etc).

> This would require kl git to be open to others for pushing, or we
> could move the tree to git.linuxtv.org (which I assume may be
> easier then for you to make the necessary changes to give
> others push rights on kl.org).

Kernel Labs has never really had any real interest in "owning" tvtime.
 I just setup the hg tree in an effort to get all the distro patches
in one place and have something that builds against current kernels
(and on which I can add improvements/fixes without users having to
deal with patches).  At the time there was also nobody who clearly had
the desire to serve as an official maintainer.

In the long term I have no real issue with the LinuxTV group being the
official maintainer of record.  I've got lots of ideas and things I
would like to do to improve tvtime, but in practice I've done a pretty
crappy job of maintaining the source (merging patches, etc) at this
point.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
