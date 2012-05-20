Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50243 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745Ab2ETKOF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 May 2012 06:14:05 -0400
Message-ID: <4FB8C3E9.6020206@iki.fi>
Date: Sun, 20 May 2012 13:14:01 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Thomas Mair <thomas.mair86@googlemail.com>
CC: linux-media@vger.kernel.org, pomidorabelisima@gmail.com
Subject: Re: [PATCH v5 0/5] support for rtl2832
References: <1> <1337366864-1256-1-git-send-email-thomas.mair86@googlemail.com> <4FB6B55D.4060500@iki.fi> <4FB8BFC9.2080704@googlemail.com>
In-Reply-To: <4FB8BFC9.2080704@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 20.05.2012 12:56, Thomas Mair wrote:
> On 18.05.2012 22:47, Antti Palosaari wrote:
>> Good evening!
>>
>> On 18.05.2012 21:47, Thomas Mair wrote:
>>> Good Evening!
>>>
>>> This is the corrected version of the patch series to support the
>>> RTL2832 demodulator. There where no major changes. The majority of
>>> the changes consist in fixing style issues and adhering to proper
>>> naming conventions.
>>
>> Review done and seems to be OK for my eyes.
>
> Thanks Antti! You have been a big help for developing the driver.
> What are the next steps? I think the fc0012 and fc0013 driver
> need to be reviewed before the patch may be included in
> staging. Is that the way it works?

Yes those should be reviewed. At least Mauro will review those when 
merging drivers to master but it is always better if there is some other 
reviewers before that as he has million patches to review.

>>> The next question for me is how to proceed when including new
>>> devices. Poma already sent an extensive list a little while
>>> ago (http://patchwork.linuxtv.org/patch/10982/). Should they
>>> all be included at once, or should I wait until somone confirms
>>> they are working correctly and include them one by one?
>>
>> It has been rule that device is added after known to work.
>>
>
> That sounds good to me. In the meantime I will try to set up a
> page for the driver on the linuxtv.org wiki to keep information
> about the driver and the devices in one place.
>
>> Unfortunately DVB USB do not support dynamic USB ID. In order to workaround that I have done some small hackish solution for the dvb_usb_rtl28xxu driver. Currently it works for RTL2831U based devices, but I see it could be easily extended for RTL2832U too by adding module parameter.
>>
>
> If I understand it right, the problem is that the tuner/demod
> combination is also hard coded in the dvb_usb_rtl28xxu driver?

Device USB IDs are hard coded to (static struct 
dvb_usb_device_properties) and that structure is passed to the DVB USB 
framework by calling dvb_usb_device_init(). DVB USB framework just 
refuses to register device if USB ID is not found. So I added that 
hackish solution to replace one USB ID by USB ID got as a dynamic USB 
ID. Dynamic ID is USB core features. It will load and call some USB 
driver even given USB ID is not advertised by the driver.

regards
Antti
-- 
http://palosaari.fi/
