Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63673 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934353Ab2DLPZp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Apr 2012 11:25:45 -0400
Received: by bkcik5 with SMTP id ik5so1619632bkc.19
        for <linux-media@vger.kernel.org>; Thu, 12 Apr 2012 08:25:44 -0700 (PDT)
Message-ID: <4F86F3A6.9040305@gmail.com>
Date: Thu, 12 Apr 2012 17:24:22 +0200
From: Florian Fainelli <f.fainelli@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org, marbugge@cisco.com, hverkuil@cisco.com
Subject: Re: [RFC] HDMI-CEC proposal
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans, Martin,

Sorry to jump in so late in the HDMI-CEC discussion, here are some 
comments from my perspective on your proposal:

- the HDMI-CEC implementation deserves its own bus and class of devices 
because by definition it is a physical bus, which is even electrically 
independant from the rest of the HDMI bus (A/V path)

- I don't think it is a good idea to tight it so closely to v4l, because 
one can perfectly have CEC-capable hardware without video, or at least 
not use v4l and have HDMI-CEC hardware

- it was suggested to use sockets at some point, I think it is 
over-engineered and should only lead

- processing messages in user-space is definitively the way to go, even 
input can be either re-injected using an uinput driver, or be handled in 
user-space entirely, eventually we might want to install "filters" based 
on opcodes to divert some opcodes to a kernel consumer, and the others 
to an user-space one

Right now, I have a very simple implementation that I developed for the 
company I work for which can be found here: 
https://github.com/ffainelli/linux-hdmi-cec

It is designed like this:

1) A core module, which registers a cec bus, and provides an abstraction 
for a CEC adapter (both device & driver):
- basic CEC adapter operations: logical address setting, queueing management
- counters, rx filtering
- host attaching/detaching in case the hardware is capable of 
self-processing CEC messages (for wakeup in particular)

2) A character device module, which exposes a character device per CEC 
adapter and only allows one consumer at a time and exposes the following 
ioctl's:

- SET_LOGICAL_ADDRESS
- RESET_DEVICE
- GET_COUNTERS
- SET_RX_MODE (my adapter can be set in a promiscuous mode)

the character device supports read/write/poll, which are the prefered 
ways for transfering/receiving data

3) A CEC adapter implementation which registers and calls into the core 
module when receiving a CEC message, and which the core module calls in 
response to the IOCTLs described below.

At first I thought about defining a generic netlink family in order to 
allow multiple user-space listeners receive CEC messages, but in the end 
having only one consumer per adapter device is fine by me and a more 
traditionnal approach for programmers.

I am relying on external components for knowing my HDMI physical address.

Hope this is not too late to (re)start the discussion on HDMI-CEC.

Thank you very much.
--
Florian
