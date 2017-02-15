Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f180.google.com ([74.125.82.180]:33220 "EHLO
        mail-ot0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751358AbdBOTVA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Feb 2017 14:21:00 -0500
Received: by mail-ot0-f180.google.com with SMTP id 73so122574533otj.0
        for <linux-media@vger.kernel.org>; Wed, 15 Feb 2017 11:20:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <572edbb2-a542-01a7-9ba0-20cee18a3217@xs4all.nl>
References: <CADR1r6hbvri8qMYP2S7Pe9sxGsjh5iE2zWTUybYwcoRsbpgXFA@mail.gmail.com>
 <572edbb2-a542-01a7-9ba0-20cee18a3217@xs4all.nl>
From: Martin Herrman <martin.herrman@gmail.com>
Date: Wed, 15 Feb 2017 20:20:58 +0100
Message-ID: <CADR1r6gvOXYpz2Qa5HnuSYmyz9pv6e9-tbRQ6PgtK8pqWWHo6A@mail.gmail.com>
Subject: Re: Cine CT V6.1 code change request
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2017-02-15 8:55 GMT+01:00 Hans Verkuil <hverkuil@xs4all.nl>:

Hi Hans,

Thanks for the quick response!

> I'm not sure what this media_build directory is. It certainly is
> outdated. The latest media_build is here: https://git.linuxtv.org/media_build.git/

And thanks for sharing!

> Can you show that line and the surrounding lines? I.e. the whole menu
> entry?

Of course, here it is:

if STAGING
menu "Media devices in staging"

config STAGING_BROKEN
bool "Enable drivers that are known to not compile"
default n
--- help ---
 Say N here, except if you will be fixing the drivers
 compilation.

menuconfig STAGING_MEDIA

> Most likely because the media build you use is outdated.

I cloned the latest repository and build it, all went fine, however.. (read on)

> Which driver?

This is my device:

02:00.0 Multimedia controller: Digital Devices GmbH Octopus DVB Adapter
Subsystem: Digital Devices GmbH Cine CT V6.1 DVB adapter
Flags: bus master, fast devsel, latency 0, IRQ 32
Memory at fbcf0000 (64-bit, non-prefetchable) [size=64K]
Capabilities: [50] Power Management version 3
Capabilities: [70] MSI: Enable+ Count=1/2 Maskable- 64bit+
Capabilities: [90] Express Endpoint, MSI 00
Capabilities: [100] Vendor Specific Information: ID=0000 Rev=0 Len=00c <?>
Kernel driver in use: ddbridge
Kernel modules: ddbridge

I am using the following modules:

[htpc@htpc ~]$ lsmod | grep dd
tda18212dd             20480  2
stv0367dd              24576  2
ddbridge               90112  29
cxd2099                20480  1 ddbridge
dvb_core              102400  1 ddbridge

The ddbridge and cxd2099 are in the latest media_build, but the
stv0367dd and tda18212dd are missing (however, the stv0367 and
tda18212 are available). How hard is it to add these two?

Regards,

Martin

> Regards,
>
>         Hans
>
