Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.lysator.liu.se ([130.236.254.3]:38536 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbcCXS7s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Mar 2016 14:59:48 -0400
Message-ID: <56F43919.1020501@lysator.liu.se>
Date: Thu, 24 Mar 2016 19:59:37 +0100
From: Peter Rosin <peda@lysator.liu.se>
MIME-Version: 1.0
To: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
CC: Wolfram Sang <wsa@the-dreams.de>, Peter Rosin <peda@axentia.se>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Peter Korsgaard <peter.korsgaard@barco.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Jonathan Cameron <jic23@kernel.org>,
	Hartmut Knaack <knaack.h@gmx.de>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Peter Meerwald <pmeerw@pmeerw.net>,
	Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Frank Rowand <frowand.list@gmail.com>,
	Grant Likely <grant.likely@linaro.org>,
	Adriana Reus <adriana.reus@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Nicholas Mc Guire <hofrat@osadl.org>,
	Olli Salonen <olli.salonen@iki.fi>, linux-i2c@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-iio@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 1/8] i2c-mux: add common core data for every mux instance
References: <1452009438-27347-1-git-send-email-peda@lysator.liu.se> <1452009438-27347-2-git-send-email-peda@lysator.liu.se> <56F3B86E.4050002@mentor.com> <56F3CA0E.60906@lysator.liu.se> <56F3F89F.8000805@mentor.com>
In-Reply-To: <56F3F89F.8000805@mentor.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Vladimir,

On 2016-03-24 15:24, Vladimir Zapolskiy wrote:
> On 24.03.2016 13:05, Peter Rosin wrote:
>> On 2016-03-24 10:50, Vladimir Zapolskiy wrote:
>>> On 05.01.2016 17:57, Peter Rosin wrote:
>>>> @@ -196,21 +195,21 @@ static int i2c_arbitrator_probe(struct platform_device *pdev)
>>>>  		dev_err(dev, "Cannot parse i2c-parent\n");
>>>>  		return -EINVAL;
>>>>  	}
>>>> -	arb->parent = of_get_i2c_adapter_by_node(parent_np);
>>>> +	muxc->parent = of_find_i2c_adapter_by_node(parent_np);
>>>
>>> why do you prefer here to use "unlocked" version of API?
>>>
>>> Foe example would it be safe/possible to unload an I2C bus device driver
>>> module or unbind I2C device itself in runtime?
>>
>> I think you ask why I change from of_get_i2c_... to of_find_i2c_..., and that
>> change was not intentional. It was the result of a bad merge during an early
>> rebase.
>>
>> Does that cover it?
>>
> 
> Yep, thank you for clarification, please account this in v3.

Oh , v3 is old news, v4 was sent out some weeks ago, and there is a v5
on a github branch. This bad rebase was fixed in v4.

> I'll try to find some time to review the whole changeset carefully,
> in fact I briefly reviewed it two months ago, but I didn't find
> anything obviously wrong that time.

Please put that on hold until I have rebased ontop of v4.6-rc1 and
changed a couple of other things. I'd hate for you to waste your
time on outdated patches.

Cheers,
Peter
