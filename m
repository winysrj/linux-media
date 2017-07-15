Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34539 "EHLO mail.kapsi.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751156AbdGOJy3 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Jul 2017 05:54:29 -0400
Subject: Re: rc-core: how to use hid (hardware) decoder?
To: Sean Young <sean@mess.org>
Cc: LMML <linux-media@vger.kernel.org>
References: <a45b045a-e476-9967-db28-4bd9d7359696@iki.fi>
 <20170715090525.rp473q3m7wrhgcgf@gofer.mess.org>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <be1344ee-fcb1-9a4c-22d0-e07c57bdd755@iki.fi>
Date: Sat, 15 Jul 2017 12:54:26 +0300
MIME-Version: 1.0
In-Reply-To: <20170715090525.rp473q3m7wrhgcgf@gofer.mess.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/15/2017 12:05 PM, Sean Young wrote:
> Hello,
> 
> On Fri, Jul 14, 2017 at 04:14:05AM +0300, Antti Palosaari wrote:
>> Moikka!
>> Some remote controller receivers uses HID interface. I looked rc-core
>> implementation, but failed to find how it could be used for hid. I need
>> somehow get scancodes and keycodes out from rc-core and write those to
>> hardware which then generate hid events. Also, I am not sure if kernel
>> keycodes are same than HID codes, but if not then those should be translated
>> somehow.
>>
>> There is rc_g_keycode_from_table() function, which could be used to dump
>> current scancode:keycode mapping, but calling it in a loop millions of times
>> is not surely correctly :]
> 
> Possibly you could use rc_map_get() to get the entire array. However you
> would be limited to rc keymaps which are compiled into the kernel.
> 
> It be good to expose an interface to userspace which allows you to read and
> write the mapping from IR protocol + scancode to hid usage codes; you could
> then have an ir-keytable-like tool to change the keymap.

That was just the plan. I added callback to ir_update_mapping() in order 
to get info and new rc_map every-time when it was changed. Then driver 
configures hid table accordingly.

I ran some issues:
* HID has very limited set of keys used for remote controllers compared 
to linux. So mapping from Linux remote controller to HID went hard.

* NEC 16/24/32 mess. rc_map used by rc-core was typed as NEC16, even 
there was NEC24 scancodes. So more self-made heuristics as hw wants NEC32.

So I given it up. I can configure that remote both polling mode via 
rc-core and HID. rc-core gives much more flexibility, mainly due to 
limited keymap of HID (hw supports only HID page 7, keyboard).

regards
Antti

-- 
http://palosaari.fi/
