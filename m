Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:60387 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab0CFVlR (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Mar 2010 16:41:17 -0500
Received: by fxm19 with SMTP id 19so5251515fxm.21
        for <linux-media@vger.kernel.org>; Sat, 06 Mar 2010 13:41:16 -0800 (PST)
Message-ID: <4B92CBF9.4070104@gmail.com>
Date: Sat, 06 Mar 2010 22:41:13 +0100
From: thomas schorpp <thomas.schorpp@googlemail.com>
Reply-To: thomas.schorpp@gmail.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: Help with RTL2832U DVB-T dongle (LeadTek WinFast DTV Dongle Mini)
References: <6934ea941003052353n4258600cs78dba8487d203564@mail.gmail.com>
In-Reply-To: <6934ea941003052353n4258600cs78dba8487d203564@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jan Slaninka wrote:
> Hi,
> 
> I'd like to ask for a support with getting LeadTek WindFast DTV Dongle
> mini running on Linux. So far I was able to fetch latest v4l-dvb from
> HG, and successfully compiled module dvb_usb_rtl2832u found in

> 090730_RTL2832U_LINUX_Ver1.1.rar

>From Ubuntu etc Webforums? 

Not linuxtv.org or OSS code, missing license, so considered *Realtek proprietary* as default license by (c) law.

Ask the maintainers to ask Realtek if they like to have it GPL'd so we can add, improve and maintain it.

Do not distribute patches for it over this list or forums until license status is cleared.

> but with no luck.
> The box says the dongle's TV Tuner is Infineon 396

No such Infineon Tuner 
http://www.infineon.com/cms/en/product/channel.html?channel=ff80808112ab681d0112ab6b9bb708b9
must be other device You've seen, possibly EEPROM/Regulator.

> and Demodulator is
> RTL2832U. Is there any chance with this one? Any hints appreciated.
> 
> Thanks,
> Jan
> 

> Bus 002 Device 009: ID 0413:6a03 Leadtek Research, Inc.

Add this USB-ID to the driver and try your luck.

If the frontend tuner is not detected automatically, assign it manually in the source code.

y
tom
