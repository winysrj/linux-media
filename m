Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262Ab1KDKN7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Nov 2011 06:13:59 -0400
Message-ID: <4EB3BAE4.2080303@redhat.com>
Date: Fri, 04 Nov 2011 08:13:56 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Hans De Goede <hdegoede@redhat.com>
Subject: Re: [GIT PULL FOR v3.2] Compilation fixes
References: <201111041039.58290.hverkuil@xs4all.nl>
In-Reply-To: <201111041039.58290.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 04-11-2011 07:39, Hans Verkuil escreveu:
> Mauro,
> 
> This fixes two compilation problems when using the media_build system.
> 
> Both gspca and the solo driver have a header with the same name, and that
> clashes when using media_build.

This the kind of patch that doesn't make much sense upstream. Granted, the
files weren't properly named, but there's not requirement upstream that
denies naming two different files with the same name.

Btw, looking at both, it seems that they can be merged: both defines the jpeg
header. The basic difference is that, while gspca jpeg header can have a size of
either 556 or 589 bytes, the one at solo6x10 has 575 bytes.

IMHO, the proper fix is to make solo6x10 driver to use the gspca jpeg.h header.
Assuming that this driver would find his way out of staging, then the jpeg.h
file should also be moved to another place, like include/linux/media, as I
don't think that solo6x10 driver should be a gspca sub-driver.

Hans G, what do you think?

> And the solo driver uses an incorrect Makefile construct, which (somewhat
> mysteriously) skips the compilation of 90% of all media drivers.

Hmm.. probably they're using "=" or ":=" instead of "+=". While this works at 
leaf Makefiles, this breaks compilation when there's just one Makefile, or
when you add another thing to be compiled there. This is something that requires
a fix.

> 
> Hopefully this pull request makes it to patchwork as well.
> 
> Regards,
> 
>         Hans
> 
> 
> The following changes since commit bd90649834a322ff70925db9ac37bf7a461add52:
> 
>   staging/Makefile: Don't compile a media driver there (2011-11-02 09:17:00 -0200)
> 
> are available in the git repository at:
>   git://linuxtv.org/hverkuil/media_tree.git fixes
> 
> Hans Verkuil (2):
>       solo6x10: rename jpeg.h to solo6x10-jpeg.h
>       solo6x10: fix broken Makefile
> 
>  drivers/staging/media/solo6x10/Makefile            |    2 +-
>  .../media/solo6x10/{jpeg.h => solo6x10-jpeg.h}     |    0
>  drivers/staging/media/solo6x10/v4l2-enc.c          |    2 +-
>  3 files changed, 2 insertions(+), 2 deletions(-)
>  rename drivers/staging/media/solo6x10/{jpeg.h => solo6x10-jpeg.h} (100%)

