Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f42.google.com ([209.85.210.42]:52291 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab1HQHgX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2011 03:36:23 -0400
Received: by pzk37 with SMTP id 37so619067pzk.1
        for <linux-media@vger.kernel.org>; Wed, 17 Aug 2011 00:36:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201108170123.09647.jareguero@telefonica.net>
References: <CAL9G6WUpso9FFUzC3WWiBZDqQDr-+HQFouCO_2V-zVHVyiyKeg@mail.gmail.com>
	<201108162227.00963.jareguero@telefonica.net>
	<4E4AD9B4.2040908@iki.fi>
	<201108170123.09647.jareguero@telefonica.net>
Date: Wed, 17 Aug 2011 09:36:23 +0200
Message-ID: <CAL9G6WW3Atz9Vj7xoWqrYQKKAsLL1Q9Hj+v6FYxYE5dqdPRjFQ@mail.gmail.com>
Subject: Re: Afatech AF9013
From: Josu Lazkano <josu.lazkano@gmail.com>
To: Jose Alberto Reguero <jareguero@telefonica.net>
Cc: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2011/8/17 Jose Alberto Reguero <jareguero@telefonica.net>:
> On Martes, 16 de Agosto de 2011 22:57:24 Antti Palosaari escribió:
>> On 08/16/2011 11:27 PM, Jose Alberto Reguero wrote:
>> >> options dvb-usb force_pid_filter_usage=1
>> >>
>> >> I change the signal timeout and tuning timeout and now it works perfect!
>> >>
>> >> I can watch two HD channels, thanks for your help.
>> >>
>> >> I really don't understand what force_pid_filter_usage do on the
>> >> module, is there any documentation?
>> >>
>> >> Thanks and best regards.
>> >
>> > For usb devices with usb 2.0 when tunned to a channel there is enought
>> > usb bandwith to deliver the whole transponder. With pid filters they
>> > only deliver the pids needed for the channel. The only limit is that the
>> > pid filters is limited normaly to 32 pids.
>>
>> May I ask how wide DVB-T streams you have? Here in Finland it is about
>> 22 Mbit/sec and I think two such streams should be too much for one USB
>> bus. I suspect there is some other bug in back of this.
>>
>> regards
>> Antti
>
> Here the transport stream is like yours. About 4 Mbit/sec by channel, and
> about 5 channels by transport stream. The problem I have is that when I have
> the two tuners working I have a few packets lost, and I have some TS
> discontinuitys. With pid filters the stream is perfect. Perhaps Josu have
> another problem.
>
> Jose Alberto
>

Thanks both!

I don't know how wide is the stream, but it could be a USB wide
limitation. My board is a little ION based and I have some USB
devices:

$ lsusb
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 006: ID 0a12:0001 Cambridge Silicon Radio, Ltd
Bluetooth Dongle (HCI mode)
Bus 002 Device 005: ID 04fc:05d8 Sunplus Technology Co., Ltd Wireless
keyboard/mouse
Bus 002 Device 004: ID 0471:0815 Philips (or NXP) eHome Infrared Receiver
Bus 002 Device 003: ID 9022:d660 TeVii Technology Ltd. DVB-S2 S660
Bus 002 Device 002: ID 05e3:0606 Genesys Logic, Inc. USB 2.0 Hub /
D-Link DUB-H4 USB 2.0 Hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 002: ID 1b80:e399 Afatech
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

The problematic twin device is the "Afatech" one, there is an DVB-S2
USB tuner, a bluetooth dongle, a IR receiver and a wireless
mouse/keybord receiver.

Now I am at work, I will try to disconnect all devices and try with
just the DVB-T device.

I use to try with MythTV if it works or not. Is there any other tool
to test and debug more deep about USB or DVB wide?

I apreciate your help. Thanks and best regards.

-- 
Josu Lazkano
