Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:41791 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932804AbaDIWo1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Apr 2014 18:44:27 -0400
Message-id: <5345CD32.8010305@samsung.com>
Date: Wed, 09 Apr 2014 16:44:02 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
MIME-version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
Cc: m.chehab@samsung.com, tj@kernel.org, rafael.j.wysocki@intel.com,
	linux@roeck-us.net, toshi.kani@hp.com,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	shuahkhan@gmail.com, Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [RFC PATCH 0/2] managed token devres interfaces
References: <cover.1397050852.git.shuah.kh@samsung.com>
 <20140409191740.GA10748@kroah.com>
In-reply-to: <20140409191740.GA10748@kroah.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/09/2014 01:17 PM, Greg KH wrote:
> On Wed, Apr 09, 2014 at 09:21:06AM -0600, Shuah Khan wrote:

>>
>> Test Cases for token devres interfaces: (passed)
>>   - Create, lock, unlock, and destroy sequence.
>>   - Try lock while it is locked. Returns -EBUSY as expected.
>>   - Try lock after destroy. Returns -ENODEV as expected.
>>   - Unlock while it is unlocked. Returns 0 as expected. This is a no-op.
>>   - Try unlock after destroy. Returns -ENODEV as expected.
>
> Any chance you can add these "test cases" as part of the kernel code so
> it lives here for any future changes?

Yes. I am planning to add these test cases to the kernel to serve as 
regression tests when these interfaces change. I have to add these in a 
driver framework, i.e I might need to create dummy driver perhaps. I 
haven't given it much thought on how, but I do plan to add tests.

>
>> Special notes for Mauro Chehab:
>>   - Please evaluate if these token devres interfaces cover all media driver
>>     use-cases. If not what is needed to cover them.
>>   - For use-case testing, I generated a string from em28xx device, as this
>>     is common for all em28xx extensions: (hope this holds true when em28xx
>>     uses snd-usb-audio
>>   - Construct string with (dev is struct em28xx *dev)
>> 		format: "tuner:%s-%s-%d"
>> 		with the following:
>>     	            dev_name(&dev->udev->dev)
>>                  dev->udev->bus->bus_name
>>                  dev->tuner_addr
>>   - I added test code to em28xx_card_setup() to test the interfaces:
>>     example token from this test code generated with the format above:
>
> What would the driver changes look like to take advantage of these new
> functions?
>

I am working on changes to em28xx driver to create and lock/unlock tuner 
token when it starts analog/digital video streaming. I should have a 
patch ready in a day or two.

thanks,
-- Shuah


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
