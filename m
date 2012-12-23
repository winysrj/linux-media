Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:54213 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab2LWRsz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Dec 2012 12:48:55 -0500
Received: by mail-we0-f175.google.com with SMTP id z53so3018550wey.20
        for <linux-media@vger.kernel.org>; Sun, 23 Dec 2012 09:48:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CADDKRnB=KYBuue10BnPpiRD=rrrATgxt-DfgLHmK-cqRAvJsUQ@mail.gmail.com>
References: <CADDKRnB=KYBuue10BnPpiRD=rrrATgxt-DfgLHmK-cqRAvJsUQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 23 Dec 2012 09:43:01 -0800
Message-ID: <CA+55aFzXShkx-QCohNABW+S=43f9K8iyy=vFyGPpG7Tx7=VrgA@mail.gmail.com>
Subject: Re: [v3.8-rc1] Multimedia regression, ioctl(17,..)-API changed ?
To: =?ISO-8859-1?Q?J=F6rg_Otte?= <jrg.otte@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jörg - does current git work for you? It has a patch from Rafael that
just reverts the insane error code, and fixed something very similar
for him.

(I just pushed out, so it might take a few minutes to mirror out to
the public sites).

              Linus

On Sun, Dec 23, 2012 at 8:46 AM, Jörg Otte <jrg.otte@gmail.com> wrote:
> With kernel v3.8 all multimedia programs under KDE4 don't work (Kubuntu 12.04).
> They alltogether ( at least Dragonplayer (Mediaplayer), Knotify4
> (system-sound),
> System-Settings-Multimedia,..) are looping forever producing 100% CPU-usage
> and must be killed.
