Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:36863 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab3IPWKB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Sep 2013 18:10:01 -0400
Received: by mail-wi0-f180.google.com with SMTP id hj3so4154118wib.7
        for <linux-media@vger.kernel.org>; Mon, 16 Sep 2013 15:09:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <523769B0.6070908@sca-uk.com>
References: <523769B0.6070908@sca-uk.com>
Date: Mon, 16 Sep 2013 18:09:59 -0400
Message-ID: <CAGoCfiwVPGKSYOObirz+X3_AN6S1LL5Eff9kcWswcHx-msguiA@mail.gmail.com>
Subject: Re: Canvassing for Linux support for Startech PEXHDCAP
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Steve Cookson <it@sca-uk.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 16, 2013 at 4:27 PM, Steve Cookson <it@sca-uk.com> wrote:
> Here is the spec:
>
> http://www.startech.com/AV/Converters/Video/PCI-Express-HD-Video-Capture-Card-1080p-HDMI-DVI-VGA-Component~PEXHDCAP#tchspcs
>
> But the main spec points (for me at least) are
>
> - It's based on the Mstar MST3367CMK chip as are many similar cards,
> - It's PCIe connection
> - It has inputs of:
> --- Component Video (YPbPr)
> --- DVI-I   (plus a vga adaptor)
> --- HDMI
> --- Stereo Audio
> - Maximum Digital Resolution: 1080p30
> - TV input resolution: 1080i/p, 720p, 576i/p, 480i/p
> - PC input resolution: 1920x1080, 1440x900, 1280x1024, 1280x960, 1280x720,
> 1024x768, 800x600
> - MPEG4/H.264 hardware compression.

To be clear, this card is a *raw* capture card.  It does not have any
hardware compression for H.264.  It's done entirely in software.

Aside from the mstar video decoder (for which there is no public
documentation), you would also need a driver for the saa7160 chip,
which there have been various half-baked drivers floating around but
nothing upstream, and none of them currently support HD capture
(AFAIK).

As always, a driver *can* be written, but it would be a rather large
project (probably several weeks of an engineer working full time on
it, assuming the engineer has experience in this area).  In this case
it's worse because a significant amount of reverse engineering would
be required.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
