Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55629 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab2LDRJZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 Dec 2012 12:09:25 -0500
Received: by mail-lb0-f174.google.com with SMTP id gi11so3574299lbb.19
        for <linux-media@vger.kernel.org>; Tue, 04 Dec 2012 09:09:23 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 4 Dec 2012 12:09:23 -0500
Message-ID: <CAOcJUbyE4+9WA8ZwANMVnuqZ-5betp8e0cNJ6inaj-7WTw4TBg@mail.gmail.com>
Subject: [PULL] au0828: remove forced dependency of VIDEO_AU0828 on VIDEO_V4L2
 | git://linuxtv.org/mkrufky/hauppauge voyager-digital
From: Michael Krufky <mkrufky@linuxtv.org>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 4, 2012 at 11:29 AM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Tue, Dec 4, 2012 at 11:25 AM, Michael Krufky <mkrufky@linuxtv.org> wrote:
>> Do you have any issues with these two patches as-is?  Any suggestions?
>>  If not, is it OK with you if I request that Mauro merge this for v3.9
>> ?
>
> I have no specific issues with the patch as-is.
>
> Reviewed-by: Devin Heitmueller <dheitmueller@kernellabs.com>
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com

Thank you, Devin.

Mauro, please merge:

The following changes since commit 72567f3cfafe31c1612efe52e2893e960cc8dd00:

  au0828: update model matrix entries for 72261, 72271 & 72281
(2012-11-28 09:46:24 -0500)

are available in the git repository at:

  git://linuxtv.org/mkrufky/hauppauge voyager-digital

for you to fetch changes up to c67f6580bfa7922572a883437413f6480db05ef2:

  au0828: break au0828_card_setup() down into smaller functions
(2012-12-04 10:46:38 -0500)

----------------------------------------------------------------
Michael Krufky (2):
      au0828: remove forced dependency of VIDEO_AU0828 on VIDEO_V4L2
      au0828: break au0828_card_setup() down into smaller functions

 drivers/media/usb/Kconfig               |    2 +-
 drivers/media/usb/au0828/Kconfig        |   17 ++++++++++++++---
 drivers/media/usb/au0828/Makefile       |    6 +++++-
 drivers/media/usb/au0828/au0828-cards.c |   16 +++++++++++++---
 drivers/media/usb/au0828/au0828-core.c  |   13 ++++++++++++-
 drivers/media/usb/au0828/au0828-i2c.c   |    4 ++++
 drivers/media/usb/au0828/au0828.h       |    2 ++
 7 files changed, 51 insertions(+), 9 deletions(-)

Cheers,

Mike Krufky
