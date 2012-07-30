Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50801 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314Ab2G3Hjv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Jul 2012 03:39:51 -0400
Message-ID: <50163A3B.6080807@iki.fi>
Date: Mon, 30 Jul 2012 10:39:39 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: poma <pomidorabelisima@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: GPIO interface between DVB sub-drivers (bridge, demod, tuner)
References: <4FFF327A.9080300@iki.fi> <CALzAhNVwN3TJhn-3i9SDhKfk=tvZZ49RTKkUzWC8RZ_m=v=A+w@mail.gmail.com> <CALzAhNUmdcd7cE-fcMHJsNk1rTcKXoZR9Oyu+5XciNZQ57EBGQ@mail.gmail.com> <5008B7B0.1020602@iki.fi> <5015A947.4040005@gmail.com>
In-Reply-To: <5015A947.4040005@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/30/2012 12:21 AM, poma wrote:
> On 07/20/2012 03:43 AM, Antti Palosaari wrote:
>> On 07/13/2012 12:07 AM, Steven Toth wrote:
>>> On Thu, Jul 12, 2012 at 4:49 PM, Steven Toth <stoth@kernellabs.com>
>>> wrote:
>>>> Nobody understands the relationship between the bridge and the
>>>> sub-component as well as the bridge driver. The current interfaces are
>>>> limiting in many ways. We solve that today with rather ugly 'attach'
>>>> structures that are inflexible, for example to set gpios to a default
>>>> state.
>>>> Then, once that interface is attached, the bridge effectively loses
>>>> most of
>>>> the control to the tuner and/or demod. The result is a large disconnect
>>>> between the bridge and subcomponents.
>>>>
>>>> Why limit any interface extension to GPIOs? Why not make something a
>>>> little more flexible so we can pass custom messages around?
>>
>>>> What did you ever decide about the enable/disable of the LNA? And, how
>>>> would the bridge do that in your proposed solution? Via the proposed
>>>> GPIO
>>>> interface?
>>
>> GPIO / LNA is ready, see following patches:
>> add LNA support for DVB API
>> cxd2820r: use Kernel GPIO for GPIO access
>> em28xx: implement FE set_lna() callback
>>
>> from:
>> http://git.linuxtv.org/anttip/media_tree.git/shortlog/refs/heads/dvb_core
>>
>> Kernel GPIOs were quite easy to implement and use - when needed
>> knowledge was gathered after all the testing and study. I wonder why
>> none was done that earlier for DVB...
>>
>> It also offer nice debug/devel feature as you can mount those GPIOs via
>> sysfs and use directly.
>>
>
> Above mentioned GPIO functionality must be implemented in driver itself
> to use /sys/class/gpio/… sysfs interface, right?
> It is not enough to build kernel with CONFIG_GENERIC_GPIO=y,
> CONFIG_GPIOLIB=y, CONFIG_GPIO_SYSFS, right?

You will need to implement callbacks for gpiolib. sysfs interface is 
then get for free.

regards
Antti

-- 
http://palosaari.fi/
