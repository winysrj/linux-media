Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:41283 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932363AbdBHOAk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 8 Feb 2017 09:00:40 -0500
Date: Wed, 8 Feb 2017 13:37:41 +0000
From: Sean Young <sean@mess.org>
To: Vincent McIntyre <vincent.mcintyre@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [regression] dvb_usb_cxusb (was Re: ir-keytable: infinite loops,
 segfaults)
Message-ID: <20170208133741.GA4405@gofer.mess.org>
References: <CAEsFdVPeL0APCPCA3BLscTY=yDbqH1Fgi77xu1L-VMQ9TWy99Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEsFdVPeL0APCPCA3BLscTY=yDbqH1Fgi77xu1L-VMQ9TWy99Q@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vincent,

On Wed, Feb 08, 2017 at 10:30:30PM +1100, Vincent McIntyre wrote:
> Hi
> 
> I have been working with Sean on figuring out the protocol used by a
> dvico remote.
> I thought the patch he sent was at fault but I backed it out and tried again.
> 
> I've attached a full dmesg but the core of it is when dvb_usb_cxusb
> tries to load:
> 
> [    7.858907] WARNING: You are using an experimental version of the
> media stack.
>                 As the driver is backported to an older kernel, it doesn't offer
>                 enough quality for its usage in production.
>                 Use it with care.
>                Latest git patches (needed if you report a bug to
> linux-media@vger.kernel.org):
>                 47b037a0512d9f8675ec2693bed46c8ea6a884ab [media]
> v4l2-async: failing functions shouldn't have side effects
>                 79a2eda80c6dab79790c308d9f50ecd2e5021ba3 [media]
> mantis_dvb: fix some error codes in mantis_dvb_init()
>                 c2987aaf0c9c2bcb0d4c5902d61473d9aa018a3d [media]
> exynos-gsc: Avoid spamming the log on VIDIOC_TRY_FMT
> [    7.861968] dvb_usb_af9035 1-4:1.0: prechip_version=83
> chip_version=02 chip_type=9135
> [    7.887476] dvb_usb_cxusb: disagrees about version of symbol
> dvb_usb_generic_rw
> [    7.887477] dvb_usb_cxusb: Unknown symbol dvb_usb_generic_rw (err -22)

-snip-

This is a problem with media_build. I'm not familiar with media_build, I
did try it out last night (for the first time) and got the same issue on
Ubuntu 16.04. I haven't been able to figure out what the problem is yet.

I'll have a look again tonight or tomorrow night. In the mean time, if
anyone else knows then that would be great. :)


Sean
