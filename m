Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:64273 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751495AbdCOVvO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Mar 2017 17:51:14 -0400
Date: Wed, 15 Mar 2017 22:50:35 +0100 (CET)
From: Stefan Wahren <stefan.wahren@i2se.com>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Eric Anholt <eric@anholt.net>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-rpi-kernel@lists.infradead.org
Message-ID: <624207385.207503.1489614635601@email.1und1.de>
In-Reply-To: <20170315110128.37e2bc5a@vento.lan>
References: <20170127215503.13208-1-eric@anholt.net>
 <20170315110128.37e2bc5a@vento.lan>
Subject: Re: [PATCH 0/6] staging: BCM2835 MMAL V4L2 camera driver
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

> Mauro Carvalho Chehab <mchehab@s-opensource.com> hat am 15. März 2017 um 15:01 geschrieben:
> 
> 
> Em Fri, 27 Jan 2017 13:54:57 -0800
> Eric Anholt <eric@anholt.net> escreveu:
> 
> > Here's my first pass at importing the camera driver.  There's a bunch
> > of TODO left to it, most of which is documented, and the rest being
> > standard checkpatch fare.
> > 
> > Unfortunately, when I try modprobing it on my pi3, the USB network
> > device dies, consistently.  I'm not sure what's going on here yet, but
> > I'm going to keep working on some debug of it.  I've unfortunately
> > changed a lot of variables (pi3 vs pi2, upstream vs downstream, vchi's
> > updates while in staging, 4.9 vs 4.4), so I probably won't figure it
> > out today.
> > 
> > Note that the "Update the driver to the current VCHI API" patch will
> > conflict with the outstanding "Add vchi_queue_kernel_message and
> > vchi_queue_user_message" series, but the fix should be pretty obvious
> > when that lands.
> > 
> > I built this against 4.10-rc1, but a merge with staging-next was clean
> > and still built fine.
> 
> I'm trying it, building from the linux-next branch of the staging
> tree. No joy.
> 
> That's what happens when I modprobe it:
> 
> [  991.841549] bcm2835_v4l2: module is from the staging directory, the quality is unknown, you have been warned.
> [  991.842931] vchiq_get_state: g_state.remote == NULL
> [  991.843437] vchiq_get_state: g_state.remote == NULL
> [  991.843940] vchiq_get_state: g_state.remote == NULL
> [  991.844444] vchiq_get_state: g_state.remote == NULL
> [  991.844947] vchiq_get_state: g_state.remote == NULL
> [  991.845451] vchiq_get_state: g_state.remote == NULL
> [  991.845954] vchiq_get_state: g_state.remote == NULL
> [  991.846457] vchiq_get_state: g_state.remote == NULL
> [  991.846961] vchiq_get_state: g_state.remote == NULL
> [  991.847464] vchiq_get_state: g_state.remote == NULL
> [  991.847969] vchiq: vchiq_initialise: videocore not initialized
> 
> [  991.847973] mmal_vchiq: Failed to initialise VCHI instance (status=-1)
> 

only a guess, but did you add the vchiq node to the device tree?

vchiq: vchiq@7e00b840 {
    compatible = "brcm,bcm2835-vchiq";
    reg = <0x7e00b840 0xf>;
    interrupts = <0 2>;
    cache-line-size = <32>;
    firmware = <&firmware>;
};

For a Raspberry Pi 3 you will need cache-line-size to be 64.

Regards
Stefan

> 
> Thanks,
> Mauro
> 
> _______________________________________________
> linux-rpi-kernel mailing list
> linux-rpi-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-rpi-kernel
