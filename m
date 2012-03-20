Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43999 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952Ab2CTQtz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Mar 2012 12:49:55 -0400
Received: by eaaq12 with SMTP id q12so111626eaa.19
        for <linux-media@vger.kernel.org>; Tue, 20 Mar 2012 09:49:53 -0700 (PDT)
Message-ID: <4F68B52F.4040405@gmail.com>
Date: Tue, 20 Mar 2012 17:49:51 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <m@bues.ch>
CC: Hans-Frieder Vogt <hfvogt@gmx.net>, linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] Basic AF9035/AF9033 driver
References: <201202222321.43972.hfvogt@gmx.net>	<4F67CF24.8050601@redhat.com>	<20120320140411.58b5808b@milhouse>	<4F68B001.1050809@gmail.com> <20120320173724.4d3f2f0f@milhouse>
In-Reply-To: <20120320173724.4d3f2f0f@milhouse>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 20/03/2012 17:37, Michael Büsch ha scritto:
> On Tue, 20 Mar 2012 17:27:45 +0100
> Gianluca Gennari <gennarone@gmail.com> wrote:
> 
>> Hi Michael,
>>
>> Il 20/03/2012 14:04, Michael Büsch ha scritto:
>>> Thank you for working on a af903x driver.
>>>
>>> I tried to test the driver on a debian 3.2 kernel, after applying a small fix:
>>> It should be CONFIG_DVB_USB_AF903X here.
>>
>> this issue is fixed in version "1.02" of the driver, posted by Hans a
>> few days ago.
> 
> I can only find the post from Feb 22th, which includes this glitch.
> Can you point me to the newer post in the list archives?

Here it is:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg44169.html

>>> So I'm wondering how big the differences between the fc0011 and fc0012 are.
>>> Can the 0011 be implemented in the 0012 driver, or does it require a separate driver?
>>> Please give me a few hints, to I can work on implementing support for that tuner.
>>
>> I have no idea about the real differences between the two tuner models,
>> but here you can find an old "leaked" af9035 driver with support for
>> several tuners, including fc0011 and fc0012:
>>
>> https://bitbucket.org/voltagex/af9035/src
>>
>> (look under the "api" subdir for the tuners).
> 
> Yeah I know about that "thing". It makes my eyes bleed, though.
> 
> But the author of this document pointed me to this:
> http://linuxtv.org/wiki/index.php/Fitipower
> That seems pretty useful, in addition to the existing crap driver.
> 
>> The driver is not working with recent kernels, but probably you can
>> extract the information needed to implement a proper kernel driver for
>> fc0011, using the fc0012 driver written by Hans as a reference.
> 
> Yeah after looking at things it seems best to have a separate module.
> I already started to put the boilerplate code together and I'm currently
> putting the various device specific bits in place.
> 

Nice!

Regards,
Gianluca
