Return-path: <mchehab@pedra>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62441 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756067Ab0JISZ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Oct 2010 14:25:27 -0400
Received: by iwn6 with SMTP id 6so1647980iwn.19
        for <linux-media@vger.kernel.org>; Sat, 09 Oct 2010 11:25:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20101008214407.GI5165@redhat.com>
References: <20101008214407.GI5165@redhat.com>
Date: Sat, 9 Oct 2010 14:23:15 -0400
Message-ID: <AANLkTimezuonksK=wW1PAkW40oo-KPRMrVdoNxymK69f@mail.gmail.com>
Subject: Re: [GIT PULL REQUEST] IR patches for 2.6.37-rc1
From: Jarod Wilson <jarod@wilsonet.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-media@vger.kernel.org, mchehab@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Oct 8, 2010 at 5:44 PM, Jarod Wilson <jarod@redhat.com> wrote:
> Hey Mauro,
>
> I've queued up some lirc fixes and a couple of patches that add a new
> ir-core driver for the Nuvoton w836x7hg Super I/O integrated CIR
> functionality. All but the Kconfig re-sorting patch have been posted to
> linux-media for review, but I'm hoping they can all get merged in time for
> the 2.6.37-rc1 window, and any additional review feedback can be taken
> care of with follow-up patches.
>
> The following changes since commit b9a1211dff08aa73fc26db66980ec0710a6c7134:
>
>  V4L/DVB: Staging: cx25821: fix braces and space coding style issues (2010-10-07 15:37:27 -0300)

Minor update to the pull req to fully wire up compat ioctls and fixup
some error messages in lirc_dev:

The following changes since commit 81d64d12e11a3cca995e6c752e4bd2898959ed0a:

  V4L/DVB: cx231xx: remove some unused functions (2010-10-07 21:05:52 -0300)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/jarod/linux-2.6-lirc.git staging

Jarod Wilson (7):
      IR: add driver for Nuvoton w836x7hg integrated CIR
      nuvoton-cir: add proper rx fifo overrun handling
      IR/Kconfig: sort hardware entries alphabetically
      IR/lirc: further ioctl portability fixups
      staging/lirc: ioctl portability fixups
      lirc: wire up .compat_ioctl to main ioctl handler
      lirc_dev: fixup error messages w/missing newlines

 drivers/media/IR/Kconfig             |   27 +-
 drivers/media/IR/Makefile            |    1 +
 drivers/media/IR/ir-lirc-codec.c     |   13 +-
 drivers/media/IR/lirc_dev.c          |   35 +-
 drivers/media/IR/nuvoton-cir.c       | 1237 ++++++++++++++++++++++++++++++++++
 drivers/media/IR/nuvoton-cir.h       |  408 +++++++++++
 drivers/staging/lirc/lirc_it87.c     |   20 +-
 drivers/staging/lirc/lirc_ite8709.c  |    6 +-
 drivers/staging/lirc/lirc_parallel.c |   35 +-
 drivers/staging/lirc/lirc_serial.c   |   24 +-
 drivers/staging/lirc/lirc_sir.c      |   24 +-
 drivers/staging/lirc/lirc_zilog.c    |    3 +
 include/media/lirc_dev.h             |    4 +-
 13 files changed, 1759 insertions(+), 78 deletions(-)
 create mode 100644 drivers/media/IR/nuvoton-cir.c
 create mode 100644 drivers/media/IR/nuvoton-cir.h


-- 
Jarod Wilson
jarod@wilsonet.com
