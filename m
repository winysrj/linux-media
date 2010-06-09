Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60750 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485Ab0FIHjc (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Jun 2010 03:39:32 -0400
Received: by iwn37 with SMTP id 37so5576469iwn.19
        for <linux-media@vger.kernel.org>; Wed, 09 Jun 2010 00:39:32 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 9 Jun 2010 09:39:31 +0200
Message-ID: <AANLkTinz0GEoEy-mXq0S9NLUbTvxrCbOWHYgQM6z0q6r@mail.gmail.com>
Subject: How to Integrate camera, mpeg decoder, colorspace conversion hardware
	into linux?
From: Manuel Lauss <manuel.lauss@googlemail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I'm looking for pointers on how to properly integrate the following
SoC functions into
Linux (media).

The SoC in question has the following components:
- camera interface
- MPEG2/4 HW decoder
- yuv->rgb conversion and scaling engine

I have prototype code which captures 2 interlaced fields from the
camera interface,
constructs a full frame in system memory using the chips DMA engine and finally
uses the scaler to convert the yuv data to rgb and scale it up to full
display resulution;
however it is one monolithic driver and one has to unload it to use
the mpeg decoder
(which also uses the scaler).

The hardware blocks work independently from each other, the scaler is
usually used
to DMA its output into one of four framebuffer windows.

The goal is to have mplayer capture analog video from the camera
interface and/or
have it feed digital video (DVB) through the mpeg decoder and display
it. Additionally,
since the scaler is indepedent from the rest, mplayer should be able
to at least use
the colorspace converter and decode other video formats in software.

Are there any drivers in the kernel already which implement this kind of scheme?

Thanks!
        Manuel Lauss
