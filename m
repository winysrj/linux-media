Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45099 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745Ab1ASNih (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 19 Jan 2011 08:38:37 -0500
Received: by fxm20 with SMTP id 20so886132fxm.19
        for <linux-media@vger.kernel.org>; Wed, 19 Jan 2011 05:38:35 -0800 (PST)
Message-ID: <4D36E955.4040203@pelagicore.com>
Date: Wed, 19 Jan 2011 14:38:29 +0100
From: =?UTF-8?B?UmljaGFyZCBSw7ZqZm9ycw==?=
	<richard.rojfors@pelagicore.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 0/1] radio-timb: Add tuner and DSP to the I2C bus
References: <1290765070.18798.7.camel@debian> <201011261103.23998.hverkuil@xs4all.nl>
In-Reply-To: <201011261103.23998.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 11/26/2010 11:03 AM, Hans Verkuil wrote:
> On Friday, November 26, 2010 10:51:10 Richard Röjfors wrote:
>> To follow is a patch to add the tuner and DSP passed in the platform data
>> to the I2C bus.
>>
>> This patch is to be applied after Hans' patch to remove usage of the
>> blocking ioctl.
> 
> Is this something you need to have fixed for 2.6.37, or is 2.6.38 good enough?

It seems like this didn't make it to 2.6.38-rc1, is it possible to get it in before
the final 2.6.38? This is a bug fix...

--Richard
