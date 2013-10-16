Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:48142 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758Ab3JPEvH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Oct 2013 00:51:07 -0400
Message-ID: <525E1B30.9040801@gentoo.org>
Date: Wed, 16 Oct 2013 06:50:56 +0200
From: Matthias Schwarzott <zzam@gentoo.org>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media@vger.kernel.org, Ulf <mopp@gmx.net>
Subject: Re: Hauppauge HVR-900 HD and HVR 930C-HD with si2165
References: <trinity-fe3d0cd8-edad-4308-9911-95e49b1e82ea-1376739034050@3capp-gmx-bs54> <52426BB0.60809@gentoo.org> <52444AA3.8020205@iki.fi> <524A5EDF.8070904@gentoo.org> <524AE01E.9040300@iki.fi> <52530BC1.9010200@gentoo.org> <525316A6.3010608@iki.fi>
In-Reply-To: <525316A6.3010608@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07.10.2013 22:16, Antti Palosaari wrote:
> On 07.10.2013 22:30, Matthias Schwarzott wrote:
>> my real problem currently is, that I cannot get a good usb dump:
>> 1. In virtual machine (win xp under kvm) it finds one transponder when
>> scanning DVB-T, but does not get a picture.
>
> I think demod locks (== means signal is OK and demod streams data), 
> but stream got lost somewhere on kvm. I have had similar experiences 
> many years back when I tested some virtual machines.
Hi Antti,

You were absolutely right here. Using the USB sniffs from the virtual 
machine, I got a picture. So only the stream seems to get lost.
I did this by using these steps:

* Record data: tcpdump -i usbmon1 -w win-tune.tcpdump
* Start virtual machine and tune

* Convert to usbsniff format: parse_tcpdump_log.pl win-tune.tcpdump
* Run parse_cx231xx.pl on it (so i2c transfers can be seen)
* Format it by my own parse-si2165.py

With this I get code of 4700 i2c sends/receives.
When adding a msleep(1) into my si2165_read function, I get a picture 
most of the tries.
This is for DVB-T with fixed set of parameters.

Regards
Matthias

