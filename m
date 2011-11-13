Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49441 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745Ab1KMMeO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Nov 2011 07:34:14 -0500
Message-ID: <4EBFB942.1030900@iki.fi>
Date: Sun, 13 Nov 2011 14:34:10 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/7] af9015 Remove call to get config from probe.
References: <4ebe96dc.d467e30a.389b.ffff8e28@mx.google.com>	 <4EBE9C3C.4070201@iki.fi> <4ebeb95d.e813b40a.37be.5102@mx.google.com>	 <4EBECAA4.1050400@iki.fi> <4ebfb241.8366b40a.1a27.7902@mx.google.com>
In-Reply-To: <4ebfb241.8366b40a.1a27.7902@mx.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/13/2011 02:04 PM, Malcolm Priestley wrote:
> On Sat, 2011-11-12 at 21:36 +0200, Antti Palosaari wrote:
>> On 11/12/2011 08:22 PM, Malcolm Priestley wrote:
>>> On Sat, 2011-11-12 at 18:18 +0200, Antti Palosaari wrote:
>>>> On 11/12/2011 05:55 PM, Malcolm Priestley wrote:
>>>>> Remove get config from probe and move to identify_state.
>>>>>
>>>>> intf->cur_altsetting->desc.bInterfaceNumber is always expected to be zero, so there
>>>>> no point in checking for it.
>>>>
>>>> Are you sure? IIRC there is HID remote on interface 1 or 2 or so (some
>>>> other than 0). Please double check.
>>>>
>>>>> Calling from probe seems to cause a race condition with some USB controllers.
>>>>
>>>> Why?
>>>>
>>> Is some other module going to claim the device?
>>>
>>> Would it not be better use usb_set_interface to set it back to 0?
>>>
>
> I spoke too soon, there is someone else about.
>
> On boot input claims interface 1
>
> Nov 13 11:43:36 tvbox kernel: [    1.830276] input: Afatech DVB-T 2 as /devices/pci0000:00/0000:00:06.1/usb2/2-4/2-4:1.1/input/input2
> Nov 13 11:43:36 tvbox kernel: [    1.830367] generic-usb 0003:1B80:E399.0001: input,hidraw0: USB HID v1.01 Keyboard [Afatech DVB-T 2] on usb-0000:00:06.1-4/input1
> ...
> Nov 13 11:43:38 tvbox kernel: [   19.151700] dvb-usb: found a 'KWorld PlusTV Dual DVB-T Stick (DVB-T 399U)' in cold state, will try to load a firmware
> ...
> Nov 13 11:43:39 tvbox kernel: [   20.313483] input: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:06.1/usb2/2-4/rc/rc0/input8
> Nov 13 11:43:39 tvbox kernel: [   20.313528] rc0: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:06.1/usb2/2-4/rc/rc0
> Nov 13 11:43:39 tvbox kernel: [   20.313530] dvb-usb: schedule remote query interval to 500 msecs.
> Nov 13 11:43:39 tvbox kernel: [   20.313534] dvb-usb: KWorld PlusTV Dual DVB-T Stick (DVB-T 399U) successfully initialized and connected.
>
> So, a usb_set_interface is needed to make sure we on interface 0 and remain there.

Sorry, didn't still understand what you mean.

What I would like to say check for interface was set for HID remote and 
since we just want to leave HID without any driver help we will just 
skip it.

Do you try to say it should be always set usb_set_interface 0 just for sure?

Antti
-- 
http://palosaari.fi/
