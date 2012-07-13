Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:32821 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758224Ab2GMBNl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jul 2012 21:13:41 -0400
Message-ID: <4FFF763B.1060705@iki.fi>
Date: Fri, 13 Jul 2012 04:13:31 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Steven Toth <stoth@kernellabs.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: GPIO interface between DVB sub-drivers (bridge, demod, tuner)
References: <4FFF327A.9080300@iki.fi> <CALzAhNVwN3TJhn-3i9SDhKfk=tvZZ49RTKkUzWC8RZ_m=v=A+w@mail.gmail.com> <CALzAhNUmdcd7cE-fcMHJsNk1rTcKXoZR9Oyu+5XciNZQ57EBGQ@mail.gmail.com>
In-Reply-To: <CALzAhNUmdcd7cE-fcMHJsNk1rTcKXoZR9Oyu+5XciNZQ57EBGQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/13/2012 12:07 AM, Steven Toth wrote:
> Resend in plaintext, it got bounced from vger.
>
> On Thu, Jul 12, 2012 at 4:49 PM, Steven Toth <stoth@kernellabs.com> wrote:
>>>
>>> Is there anyone who could say straight now what is best approach and
>>> where to look example?
>>>
>>
>> I don't have an answer but the topic does interest me. :)
>>
>> Nobody understands the relationship between the bridge and the
>> sub-component as well as the bridge driver. The current interfaces are
>> limiting in many ways. We solve that today with rather ugly 'attach'
>> structures that are inflexible, for example to set gpios to a default state.
>> Then, once that interface is attached, the bridge effectively loses most of
>> the control to the tuner and/or demod. The result is a large disconnect
>> between the bridge and subcomponents.

I agree that mostly. For example that GPIO. It fits very poorly for 
interfaces that are highly given hardware design dependent like GPIOs. 
You can code logic like GPIO0 is LED, GPIO0 is tuner reset, GPIO0 is LNA 
and then set that logic in attach(). Due to that I am looking for better 
alternative.

>> Why limit any interface extension to GPIOs? Why not make something a
>> little more flexible so we can pass custom messages around?
>>
>> get(int parm, *value) and set(int parm, value)
>>
>> Bridges and demods can define whatever parmid's they like in their attach
>> headers. (Like we do for callbacks currently).
>>
>> For example, some tuners have temperature sensors, I have no ability to
>> read that today from the bridge, other than via I2C - then I'm pulling i2c
>> device specific logic into the bridge. :(

Yes! indeed, it is only possibly just like you said. Fortunately this 
kind of properties are not very common. Temperature is offered by many 
tuners, but there is no much need for that info in bridge. Maybe force 
sleep or switch powers totally off by using GPIO to prevent overheat.

>> It would be nice to be able to demod/tunerptr->get(XC5000_PARAM_TEMP,
>> &value), for example.
>>
>> Get/Set I/F is a bit of a classic, between tuners and video decoders. This
>> (at least a while ago) was poorly handled, or not at all. Only the bridge
>> really knows how to deal with odd component configurations like this, yet it
>> has little or no control.

IF information is now set tuner on attach() and then tuner delivers that 
info to demodulator via .get_if_frequency() which is member of tuner 
ops. Technically that solution works. If hardware design based IFs are 
not given as parameter on tuner attach() tuner should use tuner default 
IFs which are likely quite correct.

>> I'd want to see a list of 4 or 5 good get/set use cases though, with some
>> unusual parms, before I'd really believe a generic get/set is more
>> appropriate than a strongly typed set of additional function pointers.

Generally speaking for that set/get, I sent mail about ~same issue 
yesterday.
http://www.spinics.net/lists/linux-media/msg50202.html

There is set_property() and get_property() callbacks defined for FE 
already. But those are not used. My opinion is that those callbacks 
should be changed to deliver data for demodulator and for tuner too 
instead of current method - which is common huge properties cache 
structure shared between all sub-drivers. I don't like it all as it is 
stupid to add stuff that common structure for every standard we has. 
Lets take example device that supports DVB-C and other device supports 
ISDB-T. How many common parameters we has? I think only one - frequency. 
All the others are just waste.

What I think I am going to make new RFC which changes that so every 
parameter from userspace is passed to the demodulator driver (using 
set_property() - change it current functionality) and not cached to the 
common cache at all. Shortly: change current common cache based 
parameter transmission to happen set parameter to demodulator one by one.

>> What did you ever decide about the enable/disable of the LNA? And, how
>> would the bridge do that in your proposed solution? Via the proposed GPIO
>> interface?

I sent PATCH RFC for DVB API to add LNA support yesterday. It is new API 
parameter. User could select ON/OFF/AUTO and on AUTO mode driver should 
make decision, likely taking signal measurements etc.
New callback is added for frontend. If bridge likes to handle LNA it 
sets that callback in order to get user requests. When bridge gets that 
set_lna() callback it examines what user request and likely sets GPIOs.

regards
Antti



-- 
http://palosaari.fi/


