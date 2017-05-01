Return-path: <linux-media-owner@vger.kernel.org>
Received: from vader.hardeman.nu ([95.142.160.32]:40691 "EHLO hardeman.nu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964833AbdEANbV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 May 2017 09:31:21 -0400
Date: Mon, 1 May 2017 15:31:19 +0200
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com
Subject: Re: [PATCH] ir-lirc-codec: let lirc_dev handle the lirc_buffer (v2)
Message-ID: <20170501133119.nusofm7ddgdx3ww2@hardeman.nu>
References: <149350094837.3873.17474877144956140933.stgit@zeus.hardeman.nu>
 <20170501122221.GA11985@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170501122221.GA11985@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 01, 2017 at 01:22:21PM +0100, Sean Young wrote:
>On Sat, Apr 29, 2017 at 11:22:28PM +0200, David Härdeman wrote:
>> ir_lirc_register() currently creates its own lirc_buffer before
>> passing the lirc_driver to lirc_register_driver().
>> 
>> When a module is later unloaded, ir_lirc_unregister() gets called
>> which performs a call to lirc_unregister_driver() and then free():s
>> the lirc_buffer.
>> 
>> The problem is that:
>> 
>> a) there can still be a userspace app holding an open lirc fd
>>    when lirc_unregister_driver() returns; and
>> 
>> b) the lirc_buffer contains "wait_queue_head_t wait_poll" which
>>    is potentially used as long as any userspace app is still around.
>> 
>> The result is an oops which can be triggered quite easily by a
>> userspace app monitoring its lirc fd using epoll() and not closing
>> the fd promptly on device removal.
>
>You're right, the rbuf is freed too early. Good catch! I missed this one.
>
>However, when I test your patch it does not work.
>
>[sean@bigcore bin]$ ./ir-ctl -d /dev/lirc1 -r
>/dev/lirc1: read returned 2 bytes
>
>The lirc_buffer is no longer has a chunk size of 4.

Thanks. I just tested that /dev/lirc0 returned something, but not the
actual data which was returned. I'll spin a v3.

-- 
David Härdeman
