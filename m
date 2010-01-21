Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:52923 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946Ab0AUJzv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jan 2010 04:55:51 -0500
Received: by ewy19 with SMTP id 19so2171760ewy.1
        for <linux-media@vger.kernel.org>; Thu, 21 Jan 2010 01:55:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <829197381001201000x58aadea5wab0948691d9a4c4f@mail.gmail.com>
References: <135ab3ff1001200926j9917d69x51eede94512fa664@mail.gmail.com>
	 <829197381001201000x58aadea5wab0948691d9a4c4f@mail.gmail.com>
Date: Thu, 21 Jan 2010 10:55:49 +0100
Message-ID: <135ab3ff1001210155qad2c794rf6781c4ac28159c7@mail.gmail.com>
Subject: Re: Drivers for Eyetv hybrid
From: Morten Friesgaard <friesgaard@gmail.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

To bad. I bought this tuner because of the cross platform compability :-/

Well, it looks awfully alot like the TerraTec H5, would there be a
driver this one?
http://www.terratec.net/en/products/TerraTec_H5_83188.html

How hard is it to create a driver myself? I'm an engineer, have some
knowlege with building the linux kernel, patching firmware etc.

/Morten


On Wed, Jan 20, 2010 at 7:00 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Wed, Jan 20, 2010 at 12:26 PM, Morten Friesgaard
> <friesgaard@gmail.com> wrote:
>> Hello.
>> I installed mythbuntu 9.10 this week on some old hardware, I had a
>> Hauppauge 500MCE PVR in and made it work fairly easy. I'm used to
>> gentoo
>>
>> However, I want to record HD signal, so I plugged in a Eyetv hybrid
>> and followed this guide
>> http://ubuntuforums.org/showthread.php?t=1015387
>>
>> I extracted the driver, put it in into /lib/firmware, modprobed
>> em28xx, rebooted. When I plug in the device, it is not recognised. I
>> tried both usb ports. The ID is "0fd9:0018", which is somewhat
>> different from similar hardware e.g. Hauppauge wintv-hvr-950 (ID
>> 2040:6513 http://www.linuxtv.org/wiki/index.ph..._WinTV-HVR-950 )
>
> It's a totally different hardware design, nothing like the older
> version of the EyeTV Hybrid (which was just a clone of the HVR-950).
>
> It is unsupported currently (and nobody is working on it to my knowledge).
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
>
