Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:48279 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751092AbdEUGpM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 21 May 2017 02:45:12 -0400
Date: Sun, 21 May 2017 08:45:09 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com
Subject: Re: [PATCH] rc-core: cleanup rc_register_device (v2)
Message-ID: <20170521064509.iuou3gzqdv37znan@hardeman.nu>
References: <149380584051.16088.1242474111722854646.stgit@zeus.hardeman.nu>
 <20170520111040.GA15600@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170520111040.GA15600@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, May 20, 2017 at 12:10:40PM +0100, Sean Young wrote:
>On Wed, May 03, 2017 at 12:04:00PM +0200, David Härdeman wrote:
>> The device core infrastructure is based on the presumption that
>> once a driver calls device_add(), it must be ready to accept
>> userspace interaction.
>> 
>> This requires splitting rc_setup_rx_device() into two functions
>> and reorganizing rc_register_device() so that as much work
>> as possible is performed before calling device_add().
>> 
>> Version 2: switch the order in which rc_prepare_rx_device() and
>> ir_raw_event_prepare() gets called so that dev->change_protocol()
>> gets called before device_add().
>
>With this patch applied, when I plug in an iguanair usb device, I get.

I'm not surprised that changes to rc_register_device() might require
some driver-specific fixes as well.

I haven't looked at this yet, and I'm going on vacation in a few hours,
so I'll probably take a look in a week...


-- 
David Härdeman
