Return-path: <linux-media-owner@vger.kernel.org>
Received: from blatinox.fr ([51.254.120.209]:41268 "EHLO vps202351.ovh.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750943AbdJBAwr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 1 Oct 2017 20:52:47 -0400
Date: Sun, 1 Oct 2017 20:52:20 -0400
From: =?UTF-8?B?SsOpcsOpbXk=?= Lefaure <jeremy.lefaure@lse.epita.fr>
To: "Tobin C. Harding" <me@tobin.cc>
Cc: alsa-devel@alsa-project.org, nouveau@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, dm-devel@redhat.com,
        brcm80211-dev-list@cypress.com, devel@driverdev.osuosl.org,
        linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org,
        amd-gfx@lists.freedesktop.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        linux-acpi@vger.kernel.org, linux-video@atrey.karlin.mff.cuni.cz,
        intel-wired-lan@lists.osuosl.org, linux-media@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, ecryptfs@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-raid@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net,
        intel-gvt-dev@lists.freedesktop.org, devel@acpica.org,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-integrity@vger.kernel.org
Subject: Re: [PATCH 00/18] use ARRAY_SIZE macro
Message-ID: <20171001205220.10b78086@blatinox-laptop.localdomain>
In-Reply-To: <20171001220131.GA11812@eros>
References: <20171001193101.8898-1-jeremy.lefaure@lse.epita.fr>
        <20171001220131.GA11812@eros>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2 Oct 2017 09:01:31 +1100
"Tobin C. Harding" <me@tobin.cc> wrote:

> > In order to reduce the size of the To: and Cc: lines, each patch of the
> > series is sent only to the maintainers and lists concerned by the patch.
> > This cover letter is sent to every list concerned by this series.  
> 
> Why don't you just send individual patches for each subsystem? I'm not a maintainer but I don't see
> how any one person is going to be able to apply this whole series, it is making it hard for
> maintainers if they have to pick patches out from among the series (if indeed any will bother
> doing that).
Yeah, maybe it would have been better to send individual patches.

>From my point of view it's a series because the patches are related (I
did a git format-patch from my local branch). But for the maintainers
point of view, they are individual patches.

As each patch in this series is standalone, the maintainers can pick
the patches they want and apply them individually. So yeah, maybe I
should have sent individual patches. But I also wanted to tie all
patches together as it's the same change.

Anyway, I can tell to each maintainer that they can apply the patches
they're concerned about and next time I may send individual patches.

Thank you for your answer,
Jérémy
