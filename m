Return-path: <mchehab@pedra>
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:28855 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753561Ab1A0BHb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 26 Jan 2011 20:07:31 -0500
Message-ID: <4D40C551.4020907@teksavvy.com>
Date: Wed, 26 Jan 2011 20:07:29 -0500
From: Mark Lord <kernel@teksavvy.com>
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils
 ?
References: <4D3E59CA.6070107@teksavvy.com> <4D3E5A91.30207@teksavvy.com> <20110125053117.GD7850@core.coreip.homeip.net> <4D3EB734.5090100@redhat.com> <20110125164803.GA19701@core.coreip.homeip.net> <AANLkTi=1Mh0JrYk5itvef7O7e7pR+YKos-w56W5q4B8B@mail.gmail.com> <20110125205453.GA19896@core.coreip.homeip.net> <4D3F4804.6070508@redhat.com> <4D3F4D11.9040302@teksavvy.com> <20110125232914.GA20130@core.coreip.homeip.net> <20110126020003.GA23085@core.coreip.homeip.net> <4D403855.4050706@teksavvy.com> <4D40C3D7.90608@teksavvy.com>
In-Reply-To: <4D40C3D7.90608@teksavvy.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 11-01-26 08:01 PM, Mark Lord wrote:
> On 11-01-26 10:05 AM, Mark Lord wrote:
>> On 11-01-25 09:00 PM, Dmitry Torokhov wrote:
> ..
>>> I wonder if the patch below is all that is needed...
>>
>> Nope. Does not work here:
>>
>> $ lsinput
>> protocol version mismatch (expected 65536, got 65537)
>>
> 
> Heh.. I just noticed something *new* in the bootlogs on my system:
> 
> kernel: Registered IR keymap rc-rc5-tv
> udevd-event[6438]: run_program: '/usr/bin/ir-keytable' abnormal exit
> kernel: input: i2c IR (Hauppauge) as /devices/virtual/rc/rc0/input7
> kernel: ir-keytable[6439]: segfault at 8 ip 00000000004012d2 sp 00007fff6d43ca60
> error 4 in ir-keytable[400000+7000]
> kernel: rc0: i2c IR (Hauppauge) as /devices/virtual/rc/rc0
> kernel: ir-kbd-i2c: i2c IR (Hauppauge) detected at i2c-0/0-0018/ir0 [ivtv i2c
> driver #0]
> 
> That's udev invoking ir-keyboard when the ir-kbd-i2c kernel module is loaded,
> and that is also ir-keyboard (userspace) segfaulting when run.

Note: I tried to capture an strace of ir-keyboard segfaulting during boot
(as above), but doing so kills the system (hangs on boot).

The command from udev was: /usr/bin/ir-keytable -a /etc/rc_maps.cfg -s rc0
