Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay.bearnet.nu ([80.252.223.222]:2734 "EHLO relay.bearnet.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754459Ab0A0QFB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2010 11:05:01 -0500
Message-ID: <4B606421.1060905@pelagicore.com>
Date: Wed, 27 Jan 2010 17:04:49 +0100
From: =?ISO-8859-1?Q?Richard_R=F6jfors?= <richard.rojfors@pelagicore.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Douglas Schilling Landgraf <dougsland@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] radio: Add radio-timb
References: <4B599C44.4030801@pelagicore.com> <201001221726.16522.hverkuil@xs4all.nl> <4B59FE40.3020004@pelagicore.com> <201001271241.46912.hverkuil@xs4all.nl>
In-Reply-To: <201001271241.46912.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
>> The first time we run we could definitely do a 4l2_i2c_new_subdev*, but what if I rmmod the driver
>> and insmod it again? When we do the do an open, then v4l2_i2c_new_subdev* would fail because the
>> device is only on the bus and probed. So I would have to look for it anyway. Or am I wrong? I found
>> this like the only generic way(?)
> 
> Not sure I understand you. When you call v4l2_device_unregister any registered
> i2c devices will be automatically unloaded from the i2c bus. So when you do a
> new modprobe, then it is as if you did it for the first time.
> 
> This should work. If not, then let me know and we can look at it.

Thanks for the explanation! It should work, I will update accordingly.

> 
>>> Is there a reason why you want to load them only on first use? It is customary
>>> to load them when this driver is loaded. Exceptions to that may be if the i2c
>>> device needs to load a firmware: this can be slow over i2c and so should be
>>> postponed until the i2c driver is needed for the first time.
>> The main reason is actually that this is a platform device which might come available before the I2C
>> bus in the system. So we postpone the use of the bus until needed, because we know for sure it's
>> available at that point.
> 
> The i2c busses are always initialized first. That's a change that went in a few
> kernel releases ago.

Ok, in this case the I2C bus sits on top of a MFD device which might be installed late to reduce
bootup time.

Bootup time is actually also a reason to keep this code in open rather than in probe.


--Richard

