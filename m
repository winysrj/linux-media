Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52590 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758026Ab2DMJ3O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Apr 2012 05:29:14 -0400
Received: by bkcik5 with SMTP id ik5so2127802bkc.19
        for <linux-media@vger.kernel.org>; Fri, 13 Apr 2012 02:29:12 -0700 (PDT)
Message-ID: <4F87F195.5080504@gmail.com>
Date: Fri, 13 Apr 2012 11:27:49 +0200
From: Florian Fainelli <f.fainelli@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Oliver Schinagl <oliver+list@schinagl.nl>,
	linux-media@vger.kernel.org, marbugge@cisco.com
Subject: Re: [RFC] HDMI-CEC proposal
References: <4F86F3A6.9040305@gmail.com> <4F873CE7.4040401@schinagl.nl> <201204130703.19005.hverkuil@xs4all.nl>
In-Reply-To: <201204130703.19005.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Le 04/13/12 07:03, Hans Verkuil a écrit :
> You both hit the main problem of the CEC support: how to implement the API.

Well, the API that I propose here [1] is quite simple:

- a kernel-side API for defining CEC adapters drivers
- a character device with an ioctl() control path and read/write/poll 
data-path

[1]: https://github.com/ffainelli/linux-hdmi-cec

>
> Cisco's work on CEC has been stalled as we first want to get HDMI support in
> V4L. Hopefully that will happen in the next few months. After that we will
> resume working on the CEC API.

Well, I don't think that tighting HDMI into V4L is such a good idea 
either. HDMI is also a separate bus and deserves its own subsystem and 
even subsystems (audio, video, HDCP, CEC). For instance, the STB I am 
working with does not use the V4L API at all, however, I would like to 
be able to integrate within the Linux HDMI stack once there, think about 
nvidia's driver too.

I can understand that you want to hold on your efforts on CEC while you 
want to get HDMI in, but don't make it entirely driven by Cisco and 
accept the community feedback.

>
> Regards,
>
> 	Hans
>
> On Thursday, April 12, 2012 22:36:55 Oliver Schinagl wrote:
>> Since a lot of video cards dont' support CEC at all (not even
>> connected), don't have hdmi, but work perfectly fine with dvi->hdmi
>> adapters, CEC can be implemented in many other ways (think media centers)
>>
>> One such exammple is using USB/Arduino
>>
>> http://code.google.com/p/cec-arduino/wiki/ElectricalInterface
>>
>> Having an AVR with v-usb code and cec code doesn't look all that hard
>> nor impossible, so one could simply have a USB plug on one end, and an
>> HDMI plug on the other end, utilizing only the CEC pins.
>>
>> This would make it more something like LIRC if anything.
>>
>> On 04/12/12 17:24, Florian Fainelli wrote:
>>> Hi Hans, Martin,
>>>
>>> Sorry to jump in so late in the HDMI-CEC discussion, here are some
>>> comments from my perspective on your proposal:
>>>
>>> - the HDMI-CEC implementation deserves its own bus and class of devices
>>> because by definition it is a physical bus, which is even electrically
>>> independant from the rest of the HDMI bus (A/V path)
>>>
>>> - I don't think it is a good idea to tight it so closely to v4l, because
>>> one can perfectly have CEC-capable hardware without video, or at least
>>> not use v4l and have HDMI-CEC hardware
>>>
>>> - it was suggested to use sockets at some point, I think it is
>>> over-engineered and should only lead
>>>
>>> - processing messages in user-space is definitively the way to go, even
>>> input can be either re-injected using an uinput driver, or be handled in
>>> user-space entirely, eventually we might want to install "filters" based
>>> on opcodes to divert some opcodes to a kernel consumer, and the others
>>> to an user-space one
>>>
>>> Right now, I have a very simple implementation that I developed for the
>>> company I work for which can be found here:
>>> https://github.com/ffainelli/linux-hdmi-cec
>>>
>>> It is designed like this:
>>>
>>> 1) A core module, which registers a cec bus, and provides an abstraction
>>> for a CEC adapter (both device&  driver):
>>> - basic CEC adapter operations: logical address setting, queueing
>>> management
>>> - counters, rx filtering
>>> - host attaching/detaching in case the hardware is capable of
>>> self-processing CEC messages (for wakeup in particular)
>>>
>>> 2) A character device module, which exposes a character device per CEC
>>> adapter and only allows one consumer at a time and exposes the following
>>> ioctl's:
>>>
>>> - SET_LOGICAL_ADDRESS
>>> - RESET_DEVICE
>>> - GET_COUNTERS
>>> - SET_RX_MODE (my adapter can be set in a promiscuous mode)
>>>
>>> the character device supports read/write/poll, which are the prefered
>>> ways for transfering/receiving data
>>>
>>> 3) A CEC adapter implementation which registers and calls into the core
>>> module when receiving a CEC message, and which the core module calls in
>>> response to the IOCTLs described below.
>>>
>>> At first I thought about defining a generic netlink family in order to
>>> allow multiple user-space listeners receive CEC messages, but in the end
>>> having only one consumer per adapter device is fine by me and a more
>>> traditionnal approach for programmers.
>>>
>>> I am relying on external components for knowing my HDMI physical address.
>>>
>>> Hope this is not too late to (re)start the discussion on HDMI-CEC.
>>>
>>> Thank you very much.
>>> --
>>> Florian
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
