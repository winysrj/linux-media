Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:37768 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbcGEGFY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jul 2016 02:05:24 -0400
Subject: Re: IR remote stopped working in kernels 4.5 and 4.6
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
	linux-media@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <1467664616.2288.12.camel@HansenPartnership.com>
 <43cc65d3-7d9f-2ead-8a21-fcc6ee0d147e@gmail.com>
 <1467667090.2288.18.camel@HansenPartnership.com>
From: Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <e6293126-2474-33b7-12c5-d32b55e43df6@gmail.com>
Date: Tue, 5 Jul 2016 07:57:32 +0200
MIME-Version: 1.0
In-Reply-To: <1467667090.2288.18.camel@HansenPartnership.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 04.07.2016 um 23:18 schrieb James Bottomley:
> On Mon, 2016-07-04 at 23:08 +0200, Heiner Kallweit wrote:
>> Am 04.07.2016 um 22:36 schrieb James Bottomley:
>>> This looks to be a problem with the rc subsystem.  The IR 
>>> controller in question is part of a cx8800 atsc card. In the 4.4 
>>> kernel, where it works, this is what ir-keytable says:
>>>
>>> Found /sys/class/rc/rc0/ (/dev/input/event12) with:
>>> 	Driver cx88xx, table rc-hauppauge
>>> 	Supported protocols: other lirc rc-5 jvc sony nec sanyo mce-kbd
>>> rc-6 sharp xmp 
>>> 	Enabled protocols: lirc nec 
>>> 	Name: cx88 IR (pcHDTV HD3000 HDTV)
>>> 	bus: 1, vendor/product: 7063:3000, version: 0x0001
>>> 	Repeat delay = 500 ms, repeat period = 125 ms
>>>
>>> And in 4.6, where it doesn't work:
>>>
>>> Found /sys/class/rc/rc0/ (/dev/input/event12) with:
>>> 	Driver cx88xx, table rc-hauppauge
>>> 	Supported protocols: lirc 
After having had a look at the cx88 driver the issue seems to be there.
For the HD3000 allowed_protocols is initialized to RC_BIT_OTHER only.
This prevents autoloading of the NEC module.

If the device is not restricted to a particular protocol (some devices
supported by cx88 seem to be restricted to the NEC protocol) then
allowed_protocols should be set to RC_BIT_ALL.

Can you test with this change?

If HD3000 is restricted to NEC then the initialization should be
similar to e.g. PROLINK PLAYTVPVR

>>> 	Enabled protocols: lirc 
>>> 	Name: cx88 IR (pcHDTV HD3000 HDTV)
>>> 	bus: 1, vendor/product: 7063:3000, version: 0x0001
>>> 	Repeat delay = 500 ms, repeat period = 125 ms
>>>
>>> The particular remote in question seems to require the nec protocol 
>>> to work and the failure in 4.5 and 4.6 is having any supported
>>> protocols at all.  I can get the remote to start working again by 
>>> adding the nec protocol:
>>>
>>> echo nec > /sys/class/rc/rc0/protocols
>>>
>>> But it would be nice to have this happen by default rather than 
>>> having to add yet another work around init script.
>>>
>> Meanwhile decoder modules are loaded on demand only. This can be done
>> automatically w/o the need for additional init scripts.
>>
>> If /etc/rc_maps.cfg includes a keymap with type NEC then the nec 
>> decoder module is loaded automatically.
>>
>> My rc_maps.cfg looks like this (and causes the SONY decoder module to 
>> be loaded automatically):
>>
>> #driver table                    file
>> *       *        sony-rm-sx800
>>
>> And the keymap:
>>
>> # table sony-rm-sx800, type SONY
>> 0x110030        KEY_PREVIOUS
>> 0x110031        KEY_NEXT
>> 0x110033        KEY_BACK
>> ..
>> ..
> 
> 
> Well, to work in the 4.4 kernel, the rc_maps.cfg names a table with the
> nec controller, so it seems that whatever is supposed to trigger
> autoloading isn't.
> 
> Is ir-keytable supposed to do this?  The current debian testing one is
> 
> Package: ir-keytable
> Source: v4l-utils
> Version: 1.10.1-1
> 
> Which seems to be the most current one.
> 
> James
> 
> 

