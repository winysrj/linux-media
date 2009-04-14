Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.hauppauge.com ([167.206.143.4]:4556 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbZDNFsA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Apr 2009 01:48:00 -0400
Message-ID: <49E4238C.6000500@linuxtv.org>
Date: Tue, 14 Apr 2009 01:47:56 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: tuner-core i2c address range check: time to remove them?
References: <200903292253.01684.hverkuil@xs4all.nl> <200904131310.18758.hverkuil@xs4all.nl>
In-Reply-To: <200904131310.18758.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> On Sunday 29 March 2009 22:53:01 Hans Verkuil wrote:
>> Hi all,
>>
>> The tuner-core.c source contains this warning since 2.6.24:
>>
>> tuner_warn("Support for tuners in i2c address range 0x64 thru 0x6f\n");
>> tuner_warn("will soon be dropped. This message indicates that your\n");
>> tuner_warn("hardware has a %s tuner at i2c address 0x%02x.\n",
>>                    t->name, t->i2c->addr);
>> tuner_warn("To ensure continued support for your device, please\n");
>> tuner_warn("send a copy of this message, along with full dmesg\n");
>> tuner_warn("output to v4l-dvb-maintainer@linuxtv.org\n");
>> tuner_warn("Please use subject line: \"obsolete tuner i2c address.\"\n");
>> tuner_warn("driver: %s, addr: 0x%02x, type: %d (%s)\n",
>>                    t->i2c->adapter->name, t->i2c->addr, t->type,
>> t->name);
>>
>> Isn't it time to remove these i2c addresses? I don't believe we ever had
>> a real tuner at such an address.
>>
>> With the ongoing v4l2_subdev conversion I need to do a bit of cleanup in
>> tuner-core.c as well, so it would be a good time for me to combine it
>> (and it gets rid of an ugly cx88 hack in tuner-core.c as well).
>>
>> Regards,
>>
>> 	Hans
> 
> Mike, please let me know if I can remove this!

Hans,

The warning message can be removed now, but please note that i2c address 
0x64 *is* a valid i2c address for a tuner.

I believe that 0x65 thru 0x6f can be removed.

Regards,

Mike
