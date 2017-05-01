Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:41746 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750728AbdEARr2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 May 2017 13:47:28 -0400
Date: Mon, 1 May 2017 19:47:25 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com
Subject: Re: [PATCH 2/6] rc-core: cleanup rc_register_device
Message-ID: <20170501174725.hkqw4tqbq5m4bthf@hardeman.nu>
References: <149332488240.32431.6597996407440701793.stgit@zeus.hardeman.nu>
 <149332524306.32431.8964878481747905258.stgit@zeus.hardeman.nu>
 <20170501164953.GA14836@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170501164953.GA14836@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 01, 2017 at 05:49:53PM +0100, Sean Young wrote:
>On Thu, Apr 27, 2017 at 10:34:03PM +0200, David H�rdeman wrote:
>> The device core infrastructure is based on the presumption that
>> once a driver calls device_add(), it must be ready to accept
>> userspace interaction.
>> 
>> This requires splitting rc_setup_rx_device() into two functions
>> and reorganizing rc_register_device() so that as much work
>> as possible is performed before calling device_add().
>> 
>
>With this patch applied, I'm no longer getting any scancodes from
>my rc devices.
>
>David, please can you test your patches before submitting. I have to go
>over them meticulously because I cannot assume you've tested them.

I did test this patch and I just redid the tests, both with rc-loopback
and with a mceusb receiver. I'm seeing scancodes on the input device as
well as pulse-space readings on the lirc device in both tests.

I did the tests with only this patch applied and the lirc-use-after-free
(v3). What hardware did you test with?

Meanwhile, I'll try rebasing my patches to the latest version of the
media-master git tree and test again.

-- 
David H�rdeman
