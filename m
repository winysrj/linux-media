Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:34890 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbbECLRN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 May 2015 07:17:13 -0400
Received: by wgyo15 with SMTP id o15so126130134wgy.2
        for <linux-media@vger.kernel.org>; Sun, 03 May 2015 04:17:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAG_g8w6MOdqJLQYLDyqt+SBXhiCqQTHHMJxN7NB_VboFEZX0Rg@mail.gmail.com>
References: <CAL9G6WU9g25Ybr6wo+-OBOfMu2xsR_DpywxqKmbUfqmf8a9pog@mail.gmail.com>
	<CAG_g8w6MOdqJLQYLDyqt+SBXhiCqQTHHMJxN7NB_VboFEZX0Rg@mail.gmail.com>
Date: Sun, 3 May 2015 13:17:11 +0200
Message-ID: <CAL9G6WVS_oX7_y+3hEJvyRWP_xxcrgz54FtmeOdVhT0dbfQDLg@mail.gmail.com>
Subject: Re: Kernel crash with dvb devices
From: Josu Lazkano <josu.lazkano@gmail.com>
To: crow <crow@linux.org.ba>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks for the reply,

I am not sure if it is related to the TeVii.

Someone could say which device is crashing? I see [dib7000p] in the
call trace, maybe it could be "Hauppauge Nova-TD Stick (52009)"
device, it use "dvb_usb_dib0700" module.

Regards.

2015-05-03 13:03 GMT+02:00 crow <crow@linux.org.ba>:
> Hi,
> I don’t have S660 but the S650 and I have hat also kernel crash see on
> the link [1]. For this i am using an workaround inside grub (I am on
> Archlinux x86_64):
> /etc/default/grub:
> GRUB_CMDLINE_LINUX_DEFAULT="irqpoll ipv6.disable=1"
>
> With the irqpoll I don’t have crashes. Of course it would be great to
> fix this. Maybe it can help you to.
>
> [1] https://www.mail-archive.com/linux-media@vger.kernel.org/msg79486.html
>
> Regards,
>
> On Sat, May 2, 2015 at 11:55 AM, Josu Lazkano <josu.lazkano@gmail.com> wrote:
>> Hello list,
>>
>> I have some DVB devices in a MythTV backend:
>>
>> TeVii S660 USB
>> Hauppauge Nova-TD Stick (52009)
>> Avermedia Super 007
>>
>> The problems is that sometimes I got a kernel crash and I need to
>> reboot the machine. Here is a log: http://paste.debian.net/170723/
>>
>> Is this kernel/module/firmware problem?
>>
>> I am using Debian Jessie with 3.16.0-4-amd64 kernel.
>>
>> Thanks for your help.
>>
>> Best regards.
>>
>> --
>> Josu Lazkano
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Josu Lazkano
