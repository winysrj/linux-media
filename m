Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:42630 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760229Ab3JPKVQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Oct 2013 06:21:16 -0400
Message-ID: <525E689A.9000006@iki.fi>
Date: Wed, 16 Oct 2013 13:21:14 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Matthias Schwarzott <zzam@gentoo.org>
CC: linux-media@vger.kernel.org, Ulf <mopp@gmx.net>
Subject: Re: Hauppauge HVR-900 HD and HVR 930C-HD with si2165
References: <trinity-fe3d0cd8-edad-4308-9911-95e49b1e82ea-1376739034050@3capp-gmx-bs54> <52426BB0.60809@gentoo.org> <52444AA3.8020205@iki.fi> <524A5EDF.8070904@gentoo.org> <524AE01E.9040300@iki.fi> <52530BC1.9010200@gentoo.org> <525316A6.3010608@iki.fi> <525E1B30.9040801@gentoo.org>
In-Reply-To: <525E1B30.9040801@gentoo.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 16.10.2013 07:50, Matthias Schwarzott wrote:
> On 07.10.2013 22:16, Antti Palosaari wrote:
>> On 07.10.2013 22:30, Matthias Schwarzott wrote:
>>> my real problem currently is, that I cannot get a good usb dump:
>>> 1. In virtual machine (win xp under kvm) it finds one transponder when
>>> scanning DVB-T, but does not get a picture.
>>
>> I think demod locks (== means signal is OK and demod streams data),
>> but stream got lost somewhere on kvm. I have had similar experiences
>> many years back when I tested some virtual machines.
> Hi Antti,
>
> You were absolutely right here. Using the USB sniffs from the virtual
> machine, I got a picture. So only the stream seems to get lost.
> I did this by using these steps:
>
> * Record data: tcpdump -i usbmon1 -w win-tune.tcpdump
> * Start virtual machine and tune
>
> * Convert to usbsniff format: parse_tcpdump_log.pl win-tune.tcpdump
> * Run parse_cx231xx.pl on it (so i2c transfers can be seen)
> * Format it by my own parse-si2165.py
>
> With this I get code of 4700 i2c sends/receives.
> When adding a msleep(1) into my si2165_read function, I get a picture
> most of the tries.
> This is for DVB-T with fixed set of parameters.

Nice! Thats very good starting point =) Now start implementing things 
correctly.

* proper I2C routines / register write / read
* firmware download
* demod lock flags (that could be found easily by looking sniffs, it is 
reg(s) that is read very often and almost never written)

In a case of demod most registers has just hard coded values. Only case 
where you will likely see different register values is bandwidth 
settings. Unfortunately it is hard to find without modulator where you 
could test easily all 6/7/8 MHz, sniff and diff. Fortunately though, 8 
MHz is used almost everywhere in the world...

regards
Antti

-- 
http://palosaari.fi/
