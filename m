Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:36156 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729915AbeGZOS1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Jul 2018 10:18:27 -0400
Received: by mail-qk0-f194.google.com with SMTP id a132-v6so907945qkg.3
        for <linux-media@vger.kernel.org>; Thu, 26 Jul 2018 06:01:41 -0700 (PDT)
MIME-Version: 1.0
References: <CAOcJUby=JgT4pju8oo6rX_AB2pz8-zid-0TwOad3pUpP5_iG5g@mail.gmail.com>
In-Reply-To: <CAOcJUby=JgT4pju8oo6rX_AB2pz8-zid-0TwOad3pUpP5_iG5g@mail.gmail.com>
From: Michael Ira Krufky <mkrufky@linuxtv.org>
Date: Thu, 26 Jul 2018 09:01:29 -0400
Message-ID: <CAOcJUbytVC6LeMPrn9_dmz4a+GTetSzV8jkNdeag3Urh-nL0UQ@mail.gmail.com>
Subject: [GIT PULL] [RESEND] urgent em28xx bug fixes for immediate merge
To: linux-media <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        mchehab+samsung@kernel.org, Brad Love <brad@nextdimension.cc>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

...previous email failed to indicate `em28xx` branch.  My bad.  Please merge.

The following changes since commit 7ba2eb72f843fb79de1857a39f9a7e8006f8133b:

  media: dib0700: add code comment (2018-07-25 14:55:59 -0400)

are available in the Git repository at:

  ssh://mkrufky@linuxtv.org:/home/mkrufky/git/dvb.git em28xx

for you to fetch changes up to f7869d3cd1705c1d7f883d364a1fe52085d219c4:

  em28xx: Remove duplicate PID (2018-07-26 07:42:52 -0400)

----------------------------------------------------------------
Brad Love (3):
      em28xx: Fix dual transport stream operation
      em28xx: Fix DualHD disconnect oops
      em28xx: Remove duplicate PID

 drivers/media/usb/em28xx/em28xx-cards.c | 6 +++---
 drivers/media/usb/em28xx/em28xx-dvb.c   | 4 +++-
 2 files changed, 6 insertions(+), 4 deletions(-)
On Thu, Jul 26, 2018 at 8:27 AM Michael Ira Krufky <mkrufky@linuxtv.org> wrote:
>
> This is a resend of https://patchwork.linuxtv.org/patch/51227/ - I
> forgot to include an email subject in the pull request :-/
>
> Hello Mauro,
>
> The following three patches from Brad Love are urgently needed for
> merge ASAP.  One just removes a duplicated PID, so it's not as
> important but should be merged ASAP nonetheless.  The other two fix an
> OOPS along with broken dual transport streaming operation.  Please
> merge ASAP.
>
> The following changes since commit 7ba2eb72f843fb79de1857a39f9a7e8006f8133b:
>
>   media: dib0700: add code comment (2018-07-25 14:55:59 -0400)
>
> are available in the Git repository at:
>
>   ssh://linuxtv.org:/home/mkrufky/git/dvb.git
>
> for you to fetch changes up to f7869d3cd1705c1d7f883d364a1fe52085d219c4:
>
>   em28xx: Remove duplicate PID (2018-07-26 07:42:52 -0400)
>
> ----------------------------------------------------------------
> Brad Love (3):
>       em28xx: Fix dual transport stream operation
>       em28xx: Fix DualHD disconnect oops
>       em28xx: Remove duplicate PID
>
>  drivers/media/usb/em28xx/em28xx-cards.c | 6 +++---
>  drivers/media/usb/em28xx/em28xx-dvb.c   | 4 +++-
>  2 files changed, 6 insertions(+), 4 deletions(-)
