Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:46384 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753144Ab1HSOr7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Aug 2011 10:47:59 -0400
Received: by pzk37 with SMTP id 37so4949232pzk.1
        for <linux-media@vger.kernel.org>; Fri, 19 Aug 2011 07:47:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E4C2631.6010405@iki.fi>
References: <CAL9G6WUpso9FFUzC3WWiBZDqQDr-+HQFouCO_2V-zVHVyiyKeg@mail.gmail.com>
	<201108162227.00963.jareguero@telefonica.net>
	<4E4AD9B4.2040908@iki.fi>
	<201108170123.09647.jareguero@telefonica.net>
	<CAL9G6WW3Atz9Vj7xoWqrYQKKAsLL1Q9Hj+v6FYxYE5dqdPRjFQ@mail.gmail.com>
	<4E4C2631.6010405@iki.fi>
Date: Fri, 19 Aug 2011 16:47:57 +0200
Message-ID: <CAL9G6WXwRJ5MgK-KL8Ni+O3jZbofPcKafv+=XTMOMM_YqgNJHw@mail.gmail.com>
Subject: Re: Afatech AF9013
From: Josu Lazkano <josu.lazkano@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Jose Alberto Reguero <jareguero@telefonica.net>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2011/8/17 Antti Palosaari <crope@iki.fi>:
> On 08/17/2011 10:36 AM, Josu Lazkano wrote:
>> I don't know how wide is the stream, but it could be a USB wide
>> limitation. My board is a little ION based and I have some USB
>> devices:
>> $ lsusb
>> Bus 001 Device 002: ID 1b80:e399 Afatech
>> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
>
> I don't think so. Total under 50Mbit/sec stream should not be too much
> for one USB2.0 root hub.
>
> Which is chipset used ION (it is southbridge which contains usually USB
> ports)?
>
>> The problematic twin device is the "Afatech" one, there is an DVB-S2
>> USB tuner, a bluetooth dongle, a IR receiver and a wireless
>> mouse/keybord receiver.
>>
>> Now I am at work, I will try to disconnect all devices and try with
>> just the DVB-T device.
>>
>> I use to try with MythTV if it works or not. Is there any other tool
>> to test and debug more deep about USB or DVB wide?
>
> You can look stream sizes using dvbtraffic tool. It is last line of
> output which shows total stream size.
>
> tzap can be used to tune channel. But it you can use some other app like
> MythTV and then run dvbtraffic same time.
>
>> I apreciate your help. Thanks and best regards.
>
> regards
> Antti
>
> --
> http://palosaari.fi/
>

Thanks Antti, I don't know the chipset model, my board is this one:
ZOTAC ION ITX-G Synergy Edition:
http://www.zotac.com/pdbrochures/mb/ION-ITX-G-E-Synergy-Edition_v1.3.pdf

On the BIOS there is something about southbridge, but now I am
connected remotely so I can not access to the BIOS, I must change
something on the BIOS?

I make this steps to record a TV channel:

1. Scan with w_scan with both adapters:
w_scan -a 2 -ft -c ES >> canales1_TDT.conf
w_scan -a 3 -ft -c ES >> canales2_TDT.conf

Here is the output and the channel files:
http://dl.dropbox.com/u/1541853/w_scan1
http://dl.dropbox.com/u/1541853/canales1_TDT.conf

http://dl.dropbox.com/u/1541853/w_scan2
http://dl.dropbox.com/u/1541853/canales2_TDT.conf

I think there is something wrong, because there must be more channels
as TVE 1, La 2...

How can I tune the correct channel?

I try this:

$ tzap -a 2 -c canales1_TDT.conf -r "TELECINCO"
using '/dev/dvb/adapter2/frontend0' and '/dev/dvb/adapter2/demux0'
reading channels from file 'canales1_TDT.conf'
ERROR: could not find channel 'TELECINCO' in channel list

I want to try to tune the channel and record it with gnutv and see if
there is any problem. Thanks for the dvbtraffic tool.

Thanks for all your help, best regards.

-- 
Josu Lazkano
