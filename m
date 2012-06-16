Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55875 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758903Ab2FPAzG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jun 2012 20:55:06 -0400
Message-ID: <4FDBD966.2030505@iki.fi>
Date: Sat, 16 Jun 2012 03:55:02 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: dvb_usb_v2: use pointers to properties[REGRESSION]
References: <1339798273.12274.21.camel@Route3278> <4FDBBD36.9020302@iki.fi> <1339806912.13364.35.camel@Route3278>
In-Reply-To: <1339806912.13364.35.camel@Route3278>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/16/2012 03:35 AM, Malcolm Priestley wrote:
> On Sat, 2012-06-16 at 01:54 +0300, Antti Palosaari wrote:
>> Hello Malcolm,
>>
>> On 06/16/2012 01:11 AM, Malcolm Priestley wrote:
>>> Hi Antti
>>>
>>> You can't have dvb_usb_device_properties as constant structure pointer.
>>>
>>> At run time it needs to be copied to a private area.
>>
>> Having constant structure for properties was one of main idea of whole
>> change. Earlier it causes some problems when driver changes those values
>> - for example remote configuration based info from the eeprom.
>>
>>> Two or more devices of the same type on the system will be pointing to
>>> the same structure.
>>
>> Yes and no. You can define struct dvb_usb_device_properties for each USB ID.
>>
>>> Any changes they make to the structure will be common to all.
>>
>> For those devices having same USB ID only.
>> Changing dvb_usb_device_properties is *not* allowed. It is constant and
>> should be. That was how I designed it. Due to that I introduced those
>> new callbacks to resolve needed values dynamically.
> Yes, but it does make run-time tweaks difficult.
>
>> If there is still something that is needed to resolve at runtime I am
>> happy to add new callback. For example PID filter configuration is
>> static currently as per adapter and if it is needed to to reconfigure at
>> runtime new callback is needed.
> I will look at the PID filter later, it defaulted to off.
>
> However, in my builds for ARM devices it is defaulted on. I will be
> testing this later. I can't see any problems.
>
>>
>> Could you say what is your problem I can likely say how to resolve it.
>>
>
> Well, the problem is, I now need two separate structures for LME2510 and
> LME2510C as in the existing driver, the hope was to merge them as one.
> The only difference being the stream endpoint number.

Then you should use .get_usb_stream_config() instead of static stream 
configuration. That is now supported.

I have found one logical error in my current implementation. 
get_usb_stream_config gets frontend as a parameter, but it is called 
frontend == NULL when attaching adapters and after that frontend is real 
value when called (just before streaming is started). Now what happens 
if we has multiple adapters? We cannot know which adapter is requested 
during attach since FE is NULL :)
But that is problem case only if you have multiple adapters. I will find 
out better solution next few days. It is ugly now.
You can just skip fe checking or something. See AF9015 for example.

> Currently, it is implemented in identify_state on dvb_usb_v2.
>
> The get_usb_stream_config has no access to device to to allow a run-time
> change there.

Hmmm, what you try to say? As FE is given as a pointer, you have also 
adapter and device. Those are nested, device is root, then adapter is 
under that and finally frontend are under the adapter.


.
└── device
     ├── adapter0
     │   ├── frontend0
     │   ├── frontend1
     │   └── frontend2
     └── adapter1
         ├── frontend0
         ├── frontend1
         └── frontend2


regards
Antti
-- 
http://palosaari.fi/


