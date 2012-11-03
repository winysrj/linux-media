Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:34107 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab2KCEPC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 3 Nov 2012 00:15:02 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so5937502iea.19
        for <linux-media@vger.kernel.org>; Fri, 02 Nov 2012 21:15:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <502AE483.6000001@iki.fi>
References: <1344987576.21425.YahooMailClassic@web29406.mail.ird.yahoo.com>
	<502AE483.6000001@iki.fi>
Date: Fri, 2 Nov 2012 21:14:59 -0700
Message-ID: <CAA7C2qj=MqjffDMG3Ekb2RLiwnj0dvOzEvhm_RDM=HLED3YvfA@mail.gmail.com>
Subject: Re: small regression in mediatree/for_v3.7-3 - media_build
From: VDR User <user.vdr@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: htl10@users.sourceforge.net, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 14, 2012 at 4:51 PM, Antti Palosaari <crope@iki.fi> wrote:
>> There seems to be a small regression on mediatree/for_v3.7-3
>> - dmesg/klog get flooded with these:
>>
>> [201145.140260] dvb_frontend_poll: 15 callbacks suppressed
>> [201145.586405] usb_urb_complete: 88 callbacks suppressed
>> [201150.587308] usb_urb_complete: 3456 callbacks suppressed
>>
>> [201468.630197] usb_urb_complete: 3315 callbacks suppressed
>> [201473.632978] usb_urb_complete: 3529 callbacks suppressed
>> [201478.635400] usb_urb_complete: 3574 callbacks suppressed
>>
>> It seems to be every 5 seconds, but I think that's just klog skipping
>> repeats and collapsing duplicate entries. This does not happen the last time
>> I tried playing with the TV stick :-).
>
> That's because you has dynamic debugs enabled!
> modprobe dvb_core; echo -n 'module dvb_core +p' >
> /sys/kernel/debug/dynamic_debug/control
> modprobe dvb_usbv2; echo -n 'module dvb_usbv2 +p' >
> /sys/kernel/debug/dynamic_debug/control
>
> If you don't add dvb_core and dvb_usbv2 modules to
> /sys/kernel/debug/dynamic_debug/control you will not see those.

I'm getting massive amounts of "dvb_frontend_poll: 20 callbacks
suppressed" messages in dmesg also and I definitely did not put
dvb_core or anything else in /sys/kernel/debug/dynamic_debug/control.
For that matter I don't even have a
/sys/kernel/debug/dynamic_debug/control file.

> I have added ratelimited version for those few debugs that are flooded
> normally. This suppressed is coming from ratelimit - it does not print all
> those similar debugs.

I'm using kernel 3.6.3 with media_build from Oct. 21, 2012. How I can
disable those messages? I'd rather not see hundreds, possibly
thousands or millions of those messages. :)
