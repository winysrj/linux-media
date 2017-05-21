Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:35881 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750803AbdEUIeu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 21 May 2017 04:34:50 -0400
Date: Sun, 21 May 2017 09:34:48 +0100
From: Sean Young <sean@mess.org>
To: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com
Subject: Re: [PATCH] rc-core: cleanup rc_register_device (v2)
Message-ID: <20170521083448.GA29040@gofer.mess.org>
References: <149380584051.16088.1242474111722854646.stgit@zeus.hardeman.nu>
 <20170520111040.GA15600@gofer.mess.org>
 <20170521064509.iuou3gzqdv37znan@hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170521064509.iuou3gzqdv37znan@hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, May 21, 2017 at 08:45:09AM +0200, David Härdeman wrote:
> On Sat, May 20, 2017 at 12:10:40PM +0100, Sean Young wrote:
> >On Wed, May 03, 2017 at 12:04:00PM +0200, David Härdeman wrote:
> >> The device core infrastructure is based on the presumption that
> >> once a driver calls device_add(), it must be ready to accept
> >> userspace interaction.
> >> 
> >> This requires splitting rc_setup_rx_device() into two functions
> >> and reorganizing rc_register_device() so that as much work
> >> as possible is performed before calling device_add().
> >> 
> >> Version 2: switch the order in which rc_prepare_rx_device() and
> >> ir_raw_event_prepare() gets called so that dev->change_protocol()
> >> gets called before device_add().
> >
> >With this patch applied, when I plug in an iguanair usb device, I get.
> 
> I'm not surprised that changes to rc_register_device() might require
> some driver-specific fixes as well.

No, it means that if any driver generates IR early enough after
rc_register_device(), you will get this.

> I haven't looked at this yet, and I'm going on vacation in a few hours,
> so I'll probably take a look in a week...

I'm currently testing and reviewing all the pending rc patches for v4.13,
if I have time left I might fix it up.

Thanks
Sean
