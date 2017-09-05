Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp82.ord1c.emailsrvr.com ([108.166.43.82]:36141 "EHLO
        smtp82.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750881AbdIEI6r (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 5 Sep 2017 04:58:47 -0400
From: Edgar Thier <edgar.thier@theimagingsource.com>
Subject: Re: UVC property auto update
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <c3f8b20a-65f9-ead3-9ffd-041641254af7@theimagingsource.com>
 <Pine.LNX.4.64.1709031714570.29016@axis700.grange>
 <4ce389e0-f63e-049e-b200-14ada55bb630@theimagingsource.com>
 <alpine.DEB.2.20.1709040801550.13291@axis700.grange>
 <c36606bf-a412-894b-82bc-37fb88b50121@theimagingsource.com>
 <alpine.DEB.2.20.1709041208520.13291@axis700.grange>
Message-ID: <cb50a0e7-7f0f-bf98-df59-4fc95d7add2b@theimagingsource.com>
Date: Tue, 5 Sep 2017 10:58:45 +0200
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.20.1709041208520.13291@axis700.grange>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> 
> Ok, looking more at the spec, the driver and your patch, here's what I 
> come up with:
> 
> 1. UVC defines which standard controls should have which flags. Among 
> those flags it specifies, which controls should specify the Autoupdate 
> flag. E.g. see the first of them as it appears in my copy of the spec 
> "4.2.2.4.8 Average Bit Rate Control"
> 2. The driver could read out flags from descriptors, but it hard-codes 
> them instead. So, (arguably), there's no need to actually read them at 
> probe time. XUs on the other hand aren't standard, therefore their flags 
> have to be read out.
> 3. In your patch you provide gain as an example. Do you mean the 
> PU_GAIN_CONTROL? The spec doesn't specify, that it should have Autoupdate 
> set. Now, whether that means, that using that flag with PU_GAIN_CONTROL is 
> a violation of the spec - I'm not sure about.
> 
> So, I think, the question really is - are hard-coded flags a proper and 
> sufficient approach or should flags be read from descriptors?
> 

That is the questioned I cannot answer. The current approach (with my patch) enables both.
The cameras I work with either assume no AUTO_UPDATE or try to define the FLAG themselves.
As to what the standard expects, I do not know as IMO it is not clearly enough defined if this flag
is optional or somehow expected. But I think that it makes more sense to ask the device
for its capabilities than the other way around. E.g. I have yet to encounter a camera that has hue
with AUTO_UPDATE yet the driver expects it.

> 
>> I will also ask the firmware developer if only value changes are available or flag changes are also
>> a possibility.
> 
> Well, flags aren't likely to change, perhaps. I think min and max values 
> are more likely to be updated.
> 

I just talked to him. There are no plans to use the auto update functionality for anything besides
GET_CUR. Flags could get messy since auto update itself could be toggled once other properties are
changed. These cross dependencies are not handled in the standard as far as I am aware.

> Well, flags aren't likely to change, perhaps. I think min and max values 
> are more likely to be updated.

That depends. When activating an auto feature, say auto-exposure. it could be interesting to set
exposure to read-only. For boundary changes I would say the question is how many users would
anticipate such a behavior.

>>>
>>> As you can see, it only handles the VALUE_CHANGE (GET_CUR) case. I would 
>>> suggest implementing a patch on top of it to add support for INFO_CHANGE 
>>> and you'd be the best person to test it then!
>>
>> I will try it out. I should be able to give you feedback tomorrow.
> 
> Thanks.
> 

Your patch works in combination with mine. I could not detect any problems.
