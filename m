Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:54564 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbaLUTUG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Dec 2014 14:20:06 -0500
Received: by mail-wi0-f176.google.com with SMTP id ex7so6304255wid.9
        for <linux-media@vger.kernel.org>; Sun, 21 Dec 2014 11:20:05 -0800 (PST)
Message-ID: <54971D60.2020804@googlemail.com>
Date: Sun, 21 Dec 2014 20:20:00 +0100
From: =?windows-1252?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 0/8] Fix issues in em28xx
References: <20141220124448.GG11285@n2100.arm.linux.org.uk>
In-Reply-To: <20141220124448.GG11285@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 20.12.2014 um 13:44 schrieb Russell King - ARM Linux:
> While testing a PCTV tripleSTICK 292e, a couple of issues were
> discovered.  Firstly, disconnecting the device causes a lockdep
> splat, which is addressed in the first patch.
>
> Secondly, a number of kernel messages are missing their terminating
> newline characters, and these are spread over a range of commits and
> a range of kernel versions.  Therefore, I've split the fixes up by
> offending commit, which should make backporting to stable trees
> easier.  (Some need to be applied to 3.14 and on, some to 3.15 and on,
> etc.)
>
> It isn't clear who is the maintainer for this driver; there is no
> MAINTAINERS entry.  If there is a maintainer, please ensure that they
> add themselves to this critical file.  Thanks.
>
>  drivers/media/usb/em28xx/em28xx-audio.c |  8 ++++----
>  drivers/media/usb/em28xx/em28xx-core.c  |  4 ++--
>  drivers/media/usb/em28xx/em28xx-dvb.c   | 14 +++++++-------
>  drivers/media/usb/em28xx/em28xx-input.c |  9 ++++-----
>  drivers/media/usb/em28xx/em28xx-video.c |  6 +++---
>  5 files changed, 20 insertions(+), 21 deletions(-)

Reviewed-by: Frank Schäfer <fschaefer.oss@googlemail.com>

