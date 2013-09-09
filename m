Return-path: <linux-media-owner@vger.kernel.org>
Received: from ni.piap.pl ([195.187.100.4]:42496 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751966Ab3IIK40 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 Sep 2013 06:56:26 -0400
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Date: Mon, 09 Sep 2013 12:47:45 +0200
MIME-Version: 1.0
Message-ID: <m3d2oifezy.fsf@t19.piap.pl>
Content-Type: text/plain
Subject: SOLO6x10 MPEG4/H.264 encoder driver
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

I'm trying to move to Linux 3.11 and I noticed you've made some
significant changes to the SOLO6x10 driver. While I don't yet have
the big picture, I can see some regressions here:

- the driver doesn't even try to work on big endian systems (I'm using
  IXP4xx-based system which is BE). For instance, you're now using
  bitfields for frame headers (struct vop_header) and this is well known
  to fail (unless you have a different struct for each endianness).

  This is actually what I have fixed with commit
  c55564fdf793797dd2740a67c35a2cedc133c9ff in 2011, and you brought the
  old buggy version back with dcae5dacbce518513abf7776cb450b7bd95d722b.

- you removed my dynamic building of MPEG4/H.264 VOP headers (the same
  commit c55564fdf793797dd2740a67c35a2cedc133c9ff) and replaced it with
  precomputed static binary headers, one for each PAL/NTSC/D1/CIF
  combination. While I don't strictly object the precomputed data,
  perhaps you could consider adding some tool to optionally calculate
  them, as required by the license. For now, It seems it's practically
  impossible to make modifications to the header data, without, for
  example, extracting the code from older driver version.

- what was the motivation behind renaming all (C language) files in
  drivers/staging/media/solo6x10 to solo6x10-* (commits
  dad7fab933622ee67774a9219d5c18040d97a5e5 and
  7bce33daeaca26a3ea3f6099fdfe4e11ea46cac6, essentially a reversion of
  my commit ae69b22c6ca7d1d7fdccf0b664dafbc777099abe)? I'm under
  impression that a driver file names don't need (and shouldn't) contain
  the driver name if the directory is already named after the driver.

  This is also the case with b3c7d453a00b7dadc2a7435f68b012371ccc3a3e:

  > [media] solo6x10: rename jpeg.h to solo6x10-jpeg.h
  >
  >  This header clashes with the jpeg.h in gspca when doing a compatibility
  >  build using the media_build system.

  What is this media_build system and why is it forcing code in
  different directories to have unique file names?


I appreciate the switch to VB2 and other improvements (though I can't
test them yet), but perhaps it could be done without causing major
breakage?

I'm thinking about a correct course of action now. I need the driver
functional so I'll revert the struct vop_header thing again, any
thoughts?
-- 
Krzysztof Halasa

Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
