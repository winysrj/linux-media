Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:49734 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755547AbZFQRYS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 13:24:18 -0400
Message-ID: <4A392719.8070102@redhat.com>
Date: Wed, 17 Jun 2009 19:25:45 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Convert cpia driver to v4l2,      drop parallel port version
 support?
References: <13104.62.70.2.252.1245224630.squirrel@webmail.xs4all.nl>	<20090617065621.23515ab7@pedra.chehab.org>	<4A38CCAF.5060202@redhat.com>	<20090617112802.152a6d64@pedra.chehab.org>	<4A390093.5090003@redhat.com> <20090617122352.261e1a16@pedra.chehab.org>
In-Reply-To: <20090617122352.261e1a16@pedra.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 06/17/2009 05:23 PM, Mauro Carvalho Chehab wrote:
> Em Wed, 17 Jun 2009 16:41:23 +0200
> Hans de Goede<hdegoede@redhat.com>  escreveu:
>
>> Hi all,
>>
>> On 06/17/2009 04:28 PM, Mauro Carvalho Chehab wrote:
>>> Em Wed, 17 Jun 2009 12:59:59 +0200
>>> Hans de Goede<hdegoede@redhat.com>   escreveu:
>>>
>> <snip>
>>
>>>> As for usbvideo that supports (amongst others) the st6422 (from the out of tree
>>>> qc-usb-messenger driver), but only one usb-id ??. I'm currently finishing up adding
>>>> st6422 support to gspca (with all known usb-id's), I have 2 different cams to test this with.
>>> I have here one Logitech quickcam. There are several variants, and the in-tree
>>> and out-tree drivers support different models. I can test it here and give you
>>> a feedback. However, I don't have the original driver for it.
>>>
>> Ok, what is its usb id (they tend to be unique for Logitech cams) ?
>
> The one I have is this one:
>
> Bus 005 Device 003: ID 046d:08f6 Logitech, Inc. QuickCam Messenger Plus
>
> This is supported by one quickcam driver.
>

Ah, that is one of the 2 models I have access to, so I can promise you that one will work fine
with the new st6422 support I'm doing.

>>>> zc0301
>>>> only supports one usb-id which has not yet been tested with gspca, used to claim a lot more
>>>> usb-id's but didn't actually work with those as it only supported the bridge, not the sensor
>>>> ->   remove it now ?
>>> I have one zc0301 cam that works with this driver. The last time I checked, it
>>> didn't work with gspca. I'll double check.
>>>
>> Ok, let me know how it goes.
>
> The zc0301 camera is this one:
>
> Bus 005 Device 002: ID 046d:08ae Logitech, Inc. QuickCam for Notebooks
>
> zc0301 driver says this:
>
> [98174.672464] zc0301: V4L2 driver for ZC0301[P] Image Processor and Control Chip v1:1.10
> [98174.672517] usb 5-2: ZC0301[P] Image Processor and Control Chip detected (vid/pid 0x046D:0x08AE)
> [98174.713717] usb 5-2: PAS202BCB image sensor detected
>
> The cam works as expected.
>

Hmm, bummer I don't have any zc3xx test cams with a pas202b sensor, guess I need to find one :)

>
> I probably won't go to LPC this year, since I'm programming to be at Japan Linux
> Symposium in October, and it seems too much jet leg for me to be in Portland in
> Sept and in Japan in Oct ;)
>

Ah too bad, but understandable.

Regards,

Hans
