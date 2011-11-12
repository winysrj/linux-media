Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39597 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281Ab1KLTgH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Nov 2011 14:36:07 -0500
Message-ID: <4EBECAA4.1050400@iki.fi>
Date: Sat, 12 Nov 2011 21:36:04 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/7] af9015 Remove call to get config from probe.
References: <4ebe96dc.d467e30a.389b.ffff8e28@mx.google.com>	 <4EBE9C3C.4070201@iki.fi> <4ebeb95d.e813b40a.37be.5102@mx.google.com>
In-Reply-To: <4ebeb95d.e813b40a.37be.5102@mx.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/12/2011 08:22 PM, Malcolm Priestley wrote:
> On Sat, 2011-11-12 at 18:18 +0200, Antti Palosaari wrote:
>> On 11/12/2011 05:55 PM, Malcolm Priestley wrote:
>>> Remove get config from probe and move to identify_state.
>>>
>>> intf->cur_altsetting->desc.bInterfaceNumber is always expected to be zero, so there
>>> no point in checking for it.
>>
>> Are you sure? IIRC there is HID remote on interface 1 or 2 or so (some
>> other than 0). Please double check.
>>
>>> Calling from probe seems to cause a race condition with some USB controllers.
>>
>> Why?
>>
> Is some other module going to claim the device?
>
> Would it not be better use usb_set_interface to set it back to 0?
>
> Rather than failing it back to the user.

Maybe I don't understand what you mean.

But here is the copy&paste from code:
/* interface 0 is used by DVB-T receiver and
    interface 1 is for remote controller (HID) */
if (intf->cur_altsetting->desc.bInterfaceNumber == 0) {

As it says (comment in the code), interface 1 is for remote controller. 
I added that to prevent call all that attach stuff twice. I have done 
such check for some other drivers too where is multiple interfaces.

IIRC .probe() is called once per each interface device has. So it will 
call that two times (if there is HID remote activated), resulting same 
device appears two times in bad luck.

Just returning 0 for those probes we don't need sounds good approach for me.


Antti
-- 
http://palosaari.fi/
