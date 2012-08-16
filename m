Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:54364 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974Ab2HPBMN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Aug 2012 21:12:13 -0400
Received: by lbbgj3 with SMTP id gj3so1204065lbb.19
        for <linux-media@vger.kernel.org>; Wed, 15 Aug 2012 18:12:11 -0700 (PDT)
Message-ID: <502C48DC.9090303@iki.fi>
Date: Thu, 16 Aug 2012 04:11:56 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hiroshi DOYU <hdoyu@nvidia.com>
CC: htl10@users.sourceforge.net, linux-media@vger.kernel.org,
	Joe Perches <joe@perches.com>
Subject: noisy dev_dbg_ratelimited()   [Re: small regression in mediatree/for_v3.7-3
 - media_build]
References: <1344991485.62541.YahooMailClassic@web29404.mail.ird.yahoo.com> <502AF5E3.7080405@iki.fi>
In-Reply-To: <502AF5E3.7080405@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hiroshi,

I see you have added dev_dbg_ratelimited() recently, commit 
6ca045930338485a8cdef117e74372aa1678009d .

However it seems to be noisy as expected similar behavior than normal 
dev_dbg() without a ratelimit.

I looked ratelimit.c and there is:
printk(KERN_WARNING "%s: %d callbacks suppressed\n", func, rs->missed);

What it looks my eyes it will print those "callbacks suppressed" always 
because KERN_WARNING.

On 08/15/2012 04:05 AM, Antti Palosaari wrote:
> On 08/15/2012 03:44 AM, Hin-Tak Leung wrote:
>> --- On Wed, 15/8/12, Antti Palosaari <crope@iki.fi> wrote:
>>
>>> On 08/15/2012 02:39 AM, Hin-Tak Leung
>>> wrote:
>>>> There seems to be a small regression on
>>> mediatree/for_v3.7-3
>>>> - dmesg/klog get flooded with these:
>>>>
>>>> [201145.140260] dvb_frontend_poll: 15 callbacks
>>> suppressed
>>>> [201145.586405] usb_urb_complete: 88 callbacks
>>> suppressed
>>>> [201150.587308] usb_urb_complete: 3456 callbacks
>>> suppressed
>>>>
>>>> [201468.630197] usb_urb_complete: 3315 callbacks
>>> suppressed
>>>> [201473.632978] usb_urb_complete: 3529 callbacks
>>> suppressed
>>>> [201478.635400] usb_urb_complete: 3574 callbacks
>>> suppressed
>>>>
>>>> It seems to be every 5 seconds, but I think that's just
>>> klog skipping repeats and collapsing duplicate entries. This
>>> does not happen the last time I tried playing with the TV
>>> stick :-).
>>>
>>> That's because you has dynamic debugs enabled!
>>> modprobe dvb_core; echo -n 'module dvb_core +p' >
>>> /sys/kernel/debug/dynamic_debug/control
>>> modprobe dvb_usbv2; echo -n 'module dvb_usbv2 +p' >
>>> /sys/kernel/debug/dynamic_debug/control
>>>
>>> If you don't add dvb_core and dvb_usbv2 modules to
>>> /sys/kernel/debug/dynamic_debug/control you will not see
>>> those.
>>>
>>> I have added ratelimited version for those few debugs that
>>> are flooded normally. This suppressed is coming from
>>> ratelimit - it does not print all those similar debugs.
>>
>> I did not enable it - it is as shipped :-).
>>
>> # grep 'CONFIG_DYNAMIC' /boot/config*
>> /boot/config-3.4.6-2.fc17.x86_64:CONFIG_DYNAMIC_FTRACE=y
>> /boot/config-3.4.6-2.fc17.x86_64:CONFIG_DYNAMIC_DEBUG=y
>> /boot/config-3.5.0-2.fc17.x86_64:CONFIG_DYNAMIC_FTRACE=y
>> /boot/config-3.5.0-2.fc17.x86_64:CONFIG_DYNAMIC_DEBUG=y
>> /boot/config-3.5.1-1.fc17.x86_64:CONFIG_DYNAMIC_FTRACE=y
>> /boot/config-3.5.1-1.fc17.x86_64:CONFIG_DYNAMIC_DEBUG=y
>>
>> Now I wonder why I didn't have those usb_urb_complete messages before?
>> The last time I played with mediatree was with 3.4.4-5.fc17.x86_64,
>> and with the mediatree2/dvb_core branch - and I did not have these then.
>
> Yeah, you are correct. There is something wrong now. I see also those
> ratelimited debugs even didn't ordered...
>
> I think dev_dbg_ratelimited() is very new, there is no other users... I
> have to find out whats wrong.

regards
Antti

-- 
http://palosaari.fi/
