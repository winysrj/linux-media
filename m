Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032048Ab2CORlw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 13:41:52 -0400
Message-ID: <4F6229D4.8010302@redhat.com>
Date: Thu, 15 Mar 2012 14:41:40 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Gianluca Gennari <gennarone@gmail.com>
CC: linux-media@vger.kernel.org, crope@iki.fi
Subject: Re: [PATCH 0/3] cxd2820r: tweak search algorithm, enable LNA in DVB-T
 mode
References: <1331832829-4580-1-git-send-email-gennarone@gmail.com>
In-Reply-To: <1331832829-4580-1-git-send-email-gennarone@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 15-03-2012 14:33, Gianluca Gennari escreveu:
> The PCTV 290e had several issues on my mipsel-based STB (powered by a
> Broadcom 7405 SoC), running a Linux 3.1 kernel and the Enigma2 OS.
> 
> The most annoying one was that the 290e was able to tune the lone DVB-T2
> frequency existing in my area, but was not able to tune any DVB-T channel.
> 
> Following a suggestion of the original author of the driver, I tried to
> tweak the wait time in the lock loop. In fact, increasing the wait time
> from 50 to 200ms in the tuning loop was enough to get the lock on most
> channels.
> But channel change was quite slow and sometimes, doing an automatic scan,
> some frequency was not locked.
> So instead of playing with the timings I changed the behavior of the
> search algorithm as explained in the patch 1, with very good results.
> 
> With this modification, the automatic scan is 100% reliable and zapping
> is quite fast (on the STB). There is no noticeable difference when using
> Kaffeine on the PC.
> 
> But there was a further issue: a few weak channels were affected by high
> BER and badly corrupted pictures. The same channels were working fine on
> an Avermedia A867 stick (as well as other sticks).
> 
> The driver has an option to enable a "Low Noise Amplifier" (LNA) before the
> demodulator. Enabling it, the reception of weak channels improved a lot,
> as reported in the description of patch 2.

Hi Gianluca,

With regards to LNA, the better is to add a DVBv5 property for it.

The LNA is generally located at the antenna, and not at the device.

As you know, more than one device may be connected to the same antenna, 
and it is generally not a good idea to have two devices sending power to
the LNA.

So, it is better to have a way to turn it on via the usespace API.

Also, as this consumes power, the better is to do it only when the device
is actually used.

Regards,
Mauro
> 
> Finally, patch 3 is a trivial clean-up.
> 
> Best regards,
> Gianluca Gennari
> 
> Gianluca Gennari (3):
>   cxd2820r: tweak search algorithm behavior
>   em28xx-dvb: enable LNA for cxd2820r in DVB-T mode
>   cxd2820r: delete unused function cxd2820r_init_t2
> 
>  drivers/media/dvb/frontends/cxd2820r_core.c |    4 ++--
>  drivers/media/dvb/frontends/cxd2820r_priv.h |    2 --
>  drivers/media/video/em28xx/em28xx-dvb.c     |    3 ++-
>  3 files changed, 4 insertions(+), 5 deletions(-)
> 

