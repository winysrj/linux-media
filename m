Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:54879 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753673AbdERHzQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 03:55:16 -0400
Date: Thu, 18 May 2017 09:55:14 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com
Subject: Re: [PATCH] rc-core: cleanup rc_register_device (v2)
Message-ID: <20170518075514.iqgky4yq2cbkuwhu@hardeman.nu>
References: <149380584051.16088.1242474111722854646.stgit@zeus.hardeman.nu>
 <20170517200957.GA1531@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170517200957.GA1531@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 17, 2017 at 09:09:57PM +0100, Sean Young wrote:
>Hi David,
>
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
>I've looked at this patch and I don't see what problem it solves;
>what user-space interaction is problematic?

It's a preparatory patch, the next patch ("rc-core: cleanup
rc_register_device pt2") is the one which removes the dev->initialized
hack (which currently papers over the fact that device_add() is called
before userspace is actually ready to accept sysfs interaction).

Does that answer your question?

//David
