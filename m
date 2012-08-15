Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:37340 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750735Ab2HOBF6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 21:05:58 -0400
Received: by lagy9 with SMTP id y9so557162lag.19
        for <linux-media@vger.kernel.org>; Tue, 14 Aug 2012 18:05:54 -0700 (PDT)
Message-ID: <502AF5E3.7080405@iki.fi>
Date: Wed, 15 Aug 2012 04:05:39 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: htl10@users.sourceforge.net
CC: linux-media@vger.kernel.org
Subject: Re: small regression in mediatree/for_v3.7-3 - media_build
References: <1344991485.62541.YahooMailClassic@web29404.mail.ird.yahoo.com>
In-Reply-To: <1344991485.62541.YahooMailClassic@web29404.mail.ird.yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/15/2012 03:44 AM, Hin-Tak Leung wrote:
> --- On Wed, 15/8/12, Antti Palosaari <crope@iki.fi> wrote:
>
>> On 08/15/2012 02:39 AM, Hin-Tak Leung
>> wrote:
>>> There seems to be a small regression on
>> mediatree/for_v3.7-3
>>> - dmesg/klog get flooded with these:
>>>
>>> [201145.140260] dvb_frontend_poll: 15 callbacks
>> suppressed
>>> [201145.586405] usb_urb_complete: 88 callbacks
>> suppressed
>>> [201150.587308] usb_urb_complete: 3456 callbacks
>> suppressed
>>>
>>> [201468.630197] usb_urb_complete: 3315 callbacks
>> suppressed
>>> [201473.632978] usb_urb_complete: 3529 callbacks
>> suppressed
>>> [201478.635400] usb_urb_complete: 3574 callbacks
>> suppressed
>>>
>>> It seems to be every 5 seconds, but I think that's just
>> klog skipping repeats and collapsing duplicate entries. This
>> does not happen the last time I tried playing with the TV
>> stick :-).
>>
>> That's because you has dynamic debugs enabled!
>> modprobe dvb_core; echo -n 'module dvb_core +p' >
>> /sys/kernel/debug/dynamic_debug/control
>> modprobe dvb_usbv2; echo -n 'module dvb_usbv2 +p' >
>> /sys/kernel/debug/dynamic_debug/control
>>
>> If you don't add dvb_core and dvb_usbv2 modules to
>> /sys/kernel/debug/dynamic_debug/control you will not see
>> those.
>>
>> I have added ratelimited version for those few debugs that
>> are flooded normally. This suppressed is coming from
>> ratelimit - it does not print all those similar debugs.
>
> I did not enable it - it is as shipped :-).
>
> # grep 'CONFIG_DYNAMIC' /boot/config*
> /boot/config-3.4.6-2.fc17.x86_64:CONFIG_DYNAMIC_FTRACE=y
> /boot/config-3.4.6-2.fc17.x86_64:CONFIG_DYNAMIC_DEBUG=y
> /boot/config-3.5.0-2.fc17.x86_64:CONFIG_DYNAMIC_FTRACE=y
> /boot/config-3.5.0-2.fc17.x86_64:CONFIG_DYNAMIC_DEBUG=y
> /boot/config-3.5.1-1.fc17.x86_64:CONFIG_DYNAMIC_FTRACE=y
> /boot/config-3.5.1-1.fc17.x86_64:CONFIG_DYNAMIC_DEBUG=y
>
> Now I wonder why I didn't have those usb_urb_complete messages before? The last time I played with mediatree was with 3.4.4-5.fc17.x86_64, and with the mediatree2/dvb_core branch - and I did not have these then.

Yeah, you are correct. There is something wrong now. I see also those 
ratelimited debugs even didn't ordered...

I think dev_dbg_ratelimited() is very new, there is no other users... I 
have to find out whats wrong.

Now I am finalizing DVB USB reset_resume(). Very cool. Looks like I can 
now continue watching television even USB controller gets reseted during 
suspend (reset resume). Every DVB USB device I have here seems to 
survive both normal resume and reset resume =)

regards
Antti


-- 
http://palosaari.fi/
